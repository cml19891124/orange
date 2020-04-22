//
//  UINavigationController+LH.m
//  WanchangLawFirms
//
//  Created by lh on 2019/2/1.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "UINavigationController+LH.h"
#import "UIViewController+LH.h"
#import <objc/runtime.h>

@implementation UINavigationController (LH)
- (void)setLh_delegate:(id<LHNavigationDelegate>)lh_delegate {
    objc_setAssociatedObject(self, @selector(lh_delegate), lh_delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<LHNavigationDelegate>)lh_delegate {
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)initialize {
    if (self == [UINavigationController self]) {
        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
        SEL swizzledSelector = NSSelectorFromString(@"et__updateInteractiveTransition:");
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        
        SEL popOriginalSEL =  @selector(popViewControllerAnimated:);
        SEL popSwizzledSEL =  NSSelectorFromString(@"xa_popViewControllerAnimated:");
        Method popOriginalMethod = class_getInstanceMethod([self class],  popOriginalSEL);
        Method popSwizzledMethod = class_getInstanceMethod([self class],  popSwizzledSEL);
        BOOL popSuccess = class_addMethod([self class], popOriginalSEL, method_getImplementation(popSwizzledMethod), method_getTypeEncoding(popSwizzledMethod));
        if(popSuccess){
            class_replaceMethod([self class], popSwizzledSEL, method_getImplementation(popOriginalMethod),  method_getTypeEncoding(popOriginalMethod));
        }else{
            method_exchangeImplementations(popOriginalMethod, popSwizzledMethod);
        }
        
    }
}

//滑动手势
- (void)et__updateInteractiveTransition:(CGFloat)percentComplete {
    [self et__updateInteractiveTransition:(percentComplete)];
    if (self.lh_delegate != nil && [self.lh_delegate respondsToSelector:@selector(lh_interactivePercent:)]) {
        [self.lh_delegate lh_interactivePercent:percentComplete];
    }
}

//剩余的进度
- (UIViewController *)xa_popViewControllerAnimated:(BOOL)animated {
    UIViewController *popVC = [self xa_popViewControllerAnimated:animated];
    UIViewController *vc = self.topViewController;
    if (vc != nil) {
        id<UIViewControllerTransitionCoordinator> coordinator = vc.transitionCoordinator;
        if (coordinator != nil) {
            if (@available(iOS 10.0, *)) {
                [coordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                    if (self.lh_delegate != nil && [self.lh_delegate respondsToSelector:@selector(lh_interactiveContext:)]) {
                        [self.lh_delegate lh_interactiveContext:context];
                    }
                }];
            } else {
                [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    if (self.lh_delegate != nil && [self.lh_delegate respondsToSelector:@selector(lh_interactiveContext:)]) {
                        [self.lh_delegate lh_interactiveContext:context];
                    }
                }];
            }
        }
    }
    return popVC;
}

@end
