//
//  UINavigationController+LH.h
//  WanchangLawFirms
//
//  Created by lh on 2019/2/1.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHNavigationDelegate <NSObject>

/// 手势返回百分比
- (void)lh_interactivePercent:(CGFloat)percentComplete;
/// 手势返回转场
- (void)lh_interactiveContext:(id<UIViewControllerTransitionCoordinatorContext>)context;

@end

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (LH)
@property (nonatomic, weak) id<LHNavigationDelegate> lh_delegate;
@end

NS_ASSUME_NONNULL_END
