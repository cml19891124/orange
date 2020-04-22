//
//  DirectionPanGestureRecognizer.h
//  chat
//
//  Created by lh on 2017/11/22.
//  Copyright © 2017年 gaming17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    DirectionPangestureRecognizerVertical,
    DirectionPanGestureRecognizerHorizontal,
    DirectionPanGestureRecognizerRight,
    DirectionPanGestureRecognizerDrag,
    DirectionPanGestureRecognizerUpSwipe
} DirectionPangestureRecognizerDirection;


@interface DirectionPanGestureRecognizer : UIPanGestureRecognizer{
    BOOL _drag;
    int _moveX;
    int _moveY;
    DirectionPangestureRecognizerDirection _direction;
}

@property (nonatomic, assign) DirectionPangestureRecognizerDirection direction;


@end
