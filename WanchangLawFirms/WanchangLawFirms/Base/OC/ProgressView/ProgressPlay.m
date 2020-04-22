//
//  ProgressPlay.m
//  具有进度条的按钮
//
//  Created by Love on 13-10-21.
//  Copyright (c) 2013年 Love. All rights reserved.
//

#import "ProgressPlay.h"

@implementation ProgressPlay
@synthesize position;

@synthesize delegate;
- (void) play
{
    if(timer)
        return;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:PERIOD target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}
- (void) pause
{
    [timer invalidate];
    timer = nil;
}

- (void) timerDidFire:(NSTimer *)theTimer
{
    if(self.position >= 1.0)
    {
        self.position = 0.0;
        [timer invalidate];
        timer = nil;
        [self.delegate playerDidStop:self];
    }
    else
    {
        self.position += PERIOD/DURATION;
        [self.delegate player:self didReachPosition:self.position];
    }
}

@end
