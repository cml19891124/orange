//
//  LHBackgroundView.h
//  LHNavigationController
//
//  Created by lh on 2019/1/30.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 自定义导航栏背景视图
@interface LHBackgroundView : UIView
- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat imgAlpha;

@end

NS_ASSUME_NONNULL_END
