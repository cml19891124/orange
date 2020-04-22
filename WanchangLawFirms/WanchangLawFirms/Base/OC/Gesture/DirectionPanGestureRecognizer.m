//
//  DirectionPanGestureRecognizer.m
//  chat
//
//  Created by lh on 2017/11/22.
//  Copyright © 2017年 gaming17. All rights reserved.
//

#import "DirectionPanGestureRecognizer.h"
int const static kDirectionPanThreshold = 5;

@implementation DirectionPanGestureRecognizer
@synthesize direction = _direction;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) {
        if (abs(_moveX) > kDirectionPanThreshold) {
            switch (_direction) {
                case DirectionPangestureRecognizerVertical:
                {
                    self.state = UIGestureRecognizerStateFailed;
                }
                    break;
                case DirectionPanGestureRecognizerHorizontal:
                {
                    _drag = YES;
                }
                    break;
                case DirectionPanGestureRecognizerRight:
                {
                    if (-_moveX > kDirectionPanThreshold) {
                        _drag = YES;
                    } else {
                        self.state = UIGestureRecognizerStateFailed;
                    }
                }
                    break;
                case DirectionPanGestureRecognizerDrag:
                {
                    self.state = UIGestureRecognizerStateFailed;
                }
                    break;
                case DirectionPanGestureRecognizerUpSwipe:
                {
                    self.state = UIGestureRecognizerStateFailed;
                }
                    break;
                default:
                    break;
            }
        } else if (abs(_moveY) > kDirectionPanThreshold) {
            switch (_direction) {
                case DirectionPangestureRecognizerVertical:
                {
                    _drag = YES;
                }
                    break;
                case DirectionPanGestureRecognizerHorizontal:
                {
                    self.state = UIGestureRecognizerStateFailed;
                }
                    break;
                case DirectionPanGestureRecognizerRight:
                {
                    self.state = UIGestureRecognizerStateFailed;
                }
                    break;
                case DirectionPanGestureRecognizerDrag:
                {
                    if (-_moveY > kDirectionPanThreshold) {
                        _drag = YES;
                    } else {
                        self.state = UIGestureRecognizerStateFailed;
                    }
                }
                    break;
                case DirectionPanGestureRecognizerUpSwipe:
                {
                    if (_moveY > kDirectionPanThreshold) {
                        _drag = YES;
                    } else {
                        self.state = UIGestureRecognizerStateFailed;
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}

@end
