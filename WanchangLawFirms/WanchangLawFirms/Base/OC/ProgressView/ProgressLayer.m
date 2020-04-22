//
//  ProgressLayer.m
//  具有进度条的按钮
//
//  Created by Love on 13-10-21.
//  Copyright (c) 2013年 Love. All rights reserved.
//

#import "ProgressLayer.h"

@interface ProgressLayer()
@property (nonatomic, assign) CGFloat radius;
@end

@implementation ProgressLayer
@synthesize progress;
@synthesize startAngle;
@synthesize tintColor;
- (id) initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if(self)
    {
        if([layer isKindOfClass:[ProgressLayer class]])
        {
            ProgressLayer *otherLayer = layer;
            self.progress = otherLayer.progress;
            self.startAngle = otherLayer.startAngle;
            self.tintColor = otherLayer.tintColor;
            self.shouldRasterize = YES;
            CGFloat w = self.bounds.size.width;
            CGFloat h = self.bounds.size.height;
            self.radius = sqrt(w * w / 4 + h * h / 4);
        }
    }
    
    return self;
}


+ (BOOL) needsDisplayForKey:(NSString *)key
{
    if([key isEqualToString:@"progress"])
        return YES;
    else
        return [super needsDisplayForKey:key];
}

- (void) drawInContext:(CGContextRef)context
{
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGPoint center = {self.bounds.size.width/2.0, self.bounds.size.height/2.0};
    
    // Elapsed arc
    CGContextAddArc(context, center.x, center.y, self.radius, startAngle + progress * 2.0 * M_PI, startAngle + M_PI * 2.0 , 0);
    CGContextAddLineToPoint(context, center.x, center.y);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, tintColor.CGColor);
    CGContextFillPath(context);
}

@end
