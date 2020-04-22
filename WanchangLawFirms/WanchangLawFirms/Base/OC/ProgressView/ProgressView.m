//
//  ProgressView.m
//  具有进度条的按钮
//
//  Created by Love on 13-10-21.
//  Copyright (c) 2013年 Love. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

+ (Class) layerClass
{
    return [ProgressLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initIVars];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _initIVars];
    }
    return self;
}

- (void) _initIVars
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.tintColor = [UIColor colorWithWhite:0 alpha:0.25];
    self.startAngle = -M_PI_2;
    self.clipsToBounds = YES;
}


- (float) progress
{
    ProgressLayer *layer = (ProgressLayer *)self.layer;
    return layer.progress;
}

- (void) setProgress:(float)progress
{
    BOOL growing = progress > self.progress;
    [self setProgress:progress animated:growing];
}

- (void) setProgress:(float)progress animated:(BOOL)animated
{
    
    
    // Coerce the value
    if(progress < 0.0f)
        progress = 0.0f;
    else if(progress > 1.0f)
        progress = 1.0f;
    
    // Apply to the layer
    ProgressLayer *layer = (ProgressLayer *)self.layer;
    if(animated)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = 0.1;
        animation.fromValue = [NSNumber numberWithFloat:layer.progress];
        animation.toValue = [NSNumber numberWithFloat:progress];
        [layer addAnimation:animation forKey:@"progressAnimation"];
        
        layer.progress = progress;
    }
    
    else {
        layer.progress = progress;
        [layer setNeedsDisplay];
    }
}

- (UIColor *)tintColor
{
    ProgressLayer *layer = (ProgressLayer *)self.layer;
    return layer.tintColor;
}
- (void) setTintColor:(UIColor *)tintColor
{
    ProgressLayer *layer = (ProgressLayer *)self.layer;
    layer.tintColor = tintColor;
    [layer setNeedsDisplay];
}


- (float) startAngle
{
    ProgressLayer *layer = (ProgressLayer *)self.layer;
    return layer.startAngle;
}

- (void) setStartAngle:(float)startAngle
{
    ProgressLayer *layer = (ProgressLayer *)self.layer;
    layer.startAngle = startAngle;
    [layer setNeedsDisplay];
}



@end
