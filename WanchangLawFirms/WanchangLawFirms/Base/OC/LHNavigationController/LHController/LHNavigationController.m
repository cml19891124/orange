//
//  LHNavigationController.m
//  LHNavigationController
//
//  Created by lh on 2019/1/30.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "LHNavigationController.h"
#import "UIViewController+LH.h"
#import "UINavigationController+LH.h"
#import "LHBackgroundView.h"


@interface LHNavigationController () <UIGestureRecognizerDelegate, UINavigationBarDelegate, LHNavigationDelegate>
@property (nonatomic, strong) LHBackgroundView *backgroundView;
@end

@implementation LHNavigationController
@synthesize popGestureDisabled = _popGestureDisabled;
@synthesize backgroundImage = _backgroundImage;

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backgroundView.backgroundImage = backgroundImage;
}

- (UIImage *)backgroundImage {
    return _backgroundImage;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.lh_delegate = self;
    }
    return self;
}

- (void)lh_interactivePercent:(CGFloat)percentComplete {
    UIViewController *topVC = self.topViewController;
    id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
    UIViewController *fromVC = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
    if (fromVC.currentNavigationBarAlpha != toVC.currentNavigationBarAlpha) {
        [self setNavAlpha:toVC.currentNavigationBarAlpha + (1 - percentComplete) * (fromVC.currentNavigationBarAlpha - toVC.currentNavigationBarAlpha)];
    }
}

- (void)lh_interactiveContext:(id<UIViewControllerTransitionCoordinatorContext>)context {
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    if (fromVC.currentNavigationBarAlpha == toVC.currentNavigationBarAlpha) {
        return;
    }
    CGFloat progress = [context percentComplete];
    NSTimeInterval totalDuration = [context transitionDuration];
    CGFloat fromAlpha = toVC.currentNavigationBarAlpha + (1 - progress) * (fromVC.currentNavigationBarAlpha - toVC.currentNavigationBarAlpha);
    CGFloat toAlpha = 0;
    CGFloat duration = 0;
    BOOL cancelled = [context isCancelled];
    if (cancelled) {
        duration = totalDuration * progress;
        toAlpha = fromVC.currentNavigationBarAlpha;
    } else {
        duration = totalDuration * (1 - progress);
        toAlpha = toVC.currentNavigationBarAlpha;
    }
    [self navAlphaChange:fromAlpha to:toAlpha duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    
    [self addBackGesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.backgroundView.superview) {
        for (UIView *v1 in self.navigationBar.subviews) {
            if ([v1 isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                [v1 addSubview:self.backgroundView];
            }
        }
    }
    
//    [self.navigationBar insertSubview:self.backgroundView atIndex:1];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        UIViewController *fromVC = self.topViewController;
        UIViewController *toVC = viewController;
        [self navAlphaChange:fromVC.currentNavigationBarAlpha to:toVC.currentNavigationBarAlpha duration:0.25];
    } else {
        [self setNavAlpha:viewController.currentNavigationBarAlpha];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *fromVC = self.topViewController;
    UIViewController *toVC = self.viewControllers[self.viewControllers.count - 2];
    [self navAlphaChange:fromVC.currentNavigationBarAlpha to:toVC.currentNavigationBarAlpha duration:0.25];
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *firstVC = self.viewControllers.firstObject;
    [self setNavAlpha:firstVC.currentNavigationBarAlpha];
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL result = self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
    return result;
}

#pragma mark - UINavigationBarDelegate
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    if (self.viewControllers.count >= navigationBar.items.count) {// 点击返回按钮
        UIViewController *vc = self.viewControllers[self.viewControllers.count - 1];
        [self setNavAlpha:vc.currentNavigationBarAlpha];
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    UIViewController *vc = self.topViewController;
    [self setNavAlpha:vc.currentNavigationBarAlpha];
}

#pragma mark - 公开方法
- (void)addBackGesture {
    [self.view addGestureRecognizer:self.edgeBackGesture];
}

- (void)removeBackGesture {
    [self.view removeGestureRecognizer:self.edgeBackGesture];
}

#pragma mark - 私有方法
- (void)navAlphaChange:(CGFloat)from to:(CGFloat)to duration:(NSTimeInterval)duration {
    [self setNavAlpha:from];
    [UIView animateWithDuration:duration animations:^{
        [self setNavAlpha:to];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setNavAlpha:(CGFloat)alpha {
    self.backgroundView.imgAlpha = alpha;
}

#pragma mark - 懒加载
- (void)setPopGestureDisabled:(BOOL)popGestureDisabled {
    _popGestureDisabled = popGestureDisabled;
    if (popGestureDisabled) {
        [self removeBackGesture];
    } else {
        [self addBackGesture];
    }
}

- (BOOL)popGestureDisabled {
    return _popGestureDisabled;
}

- (UIScreenEdgePanGestureRecognizer *)edgeBackGesture {
    if (!_edgeBackGesture) {
        _edgeBackGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
        _edgeBackGesture.edges = UIRectEdgeLeft;
        _edgeBackGesture.delegate = self;
    }
    return _edgeBackGesture;
}

- (LHBackgroundView *)backgroundView {
    if (!_backgroundView) {
//        _backgroundView = [[LHBackgroundView alloc] initWithFrame:CGRectMake(0, -UIApplication.sharedApplication.statusBarFrame.size.height, UIScreen.mainScreen.bounds.size.width, UIApplication.sharedApplication.statusBarFrame.size.height + 44)];
        _backgroundView = [[LHBackgroundView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIApplication.sharedApplication.statusBarFrame.size.height + 44)];
        _backgroundView.clipsToBounds = YES;
//        [self.navigationBar addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)gesture{
    //调用系统手势绑定的方法
    [self.interactivePopGestureRecognizer.delegate performSelector:@selector(handleNavigationTransition:) withObject:gesture];
    CGPoint point = [gesture locationInView:self.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.ges_delegate != nil &&[self.ges_delegate respondsToSelector:@selector(lhNavigationControllerHandGestureBeganAt:)]) {
                [self.ges_delegate lhNavigationControllerHandGestureBeganAt:point];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.ges_delegate != nil &&[self.ges_delegate respondsToSelector:@selector(lhNavigationControllerHandGestureMoveAt:)]) {
                [self.ges_delegate lhNavigationControllerHandGestureMoveAt:point];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (self.ges_delegate != nil && [self.ges_delegate respondsToSelector:@selector(lhNavigationControllerHandGestureEndAt:)]) {
                [self.ges_delegate lhNavigationControllerHandGestureEndAt:point];
            }
        }
            break;
        default:
            break;
    }
}

@end
