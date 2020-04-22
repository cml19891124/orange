//
//  ProgressPlay.h
//  具有进度条的按钮
//
//  Created by Love on 13-10-21.
//  Copyright (c) 2013年 Love. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DURATION  20.0
#define PERIOD    0.5

@class ProgressPlay;

@protocol ProgressPlayDelegate <NSObject>

- (void) player:(ProgressPlay *)player didReachPosition:(float)position;
- (void) playerDidStop:(ProgressPlay *)player;

@end

@interface ProgressPlay : NSObject{
    NSTimer *timer;
}
- (void) play;
- (void) pause;
@property (assign) float position;  // 0..1
@property (retain) id <ProgressPlayDelegate> delegate;

@end
