//
//  ProgressLayer.h
//  具有进度条的按钮
//
//  Created by Love on 13-10-21.
//  Copyright (c) 2013年 Love. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ProgressLayer : CALayer
@property (nonatomic, assign) float progress;

@property (nonatomic, assign) float startAngle;
@property (nonatomic, retain) UIColor *tintColor;

@end
