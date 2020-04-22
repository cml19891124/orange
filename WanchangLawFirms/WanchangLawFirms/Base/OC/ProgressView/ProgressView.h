//
//  ProgressView.h
//  具有进度条的按钮
//
//  Created by Love on 13-10-21.
//  Copyright (c) 2013年 Love. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressLayer.h"
@interface ProgressView : UIView
@property (nonatomic, assign) float progress;


@property (nonatomic, assign) float startAngle;
@property (nonatomic, retain) UIColor *tintColor;
- (void) setProgress:(float)progress animated:(BOOL)animated;


@end
