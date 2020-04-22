//
//  LHBackgroundView.m
//  LHNavigationController
//
//  Created by lh on 2019/1/30.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "LHBackgroundView.h"

@interface LHBackgroundView ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation LHBackgroundView
@synthesize backgroundImage = _backgroundImage;
@synthesize imgAlpha = _imgAlpha;

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (UIImage *)backgroundImage {
    return _backgroundImage;
}

- (void)setImgAlpha:(CGFloat)imgAlpha {
    _imgAlpha = imgAlpha;
    _backgroundImageView.alpha = imgAlpha;
}

- (CGFloat)imgAlpha {
    return _imgAlpha;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundImageView];
//        [self addSubview:self.effectView];
    }
    return self;
}



- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundImageView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _effectView.frame = self.bounds;
    }
    return _effectView;
}

@end
