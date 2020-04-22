//
//  UIViewController+LH.m
//  WanchangLawFirms
//
//  Created by lh on 2019/2/1.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "UIViewController+LH.h"
#import "LHNavigationController.h"
#import <objc/runtime.h>

static char *CloudoxKey = "CloudoxKey";

@implementation UIViewController (LH)
- (void)setCurrentNavigationBarAlpha:(CGFloat)currentNavigationBarAlpha {
    CGFloat alpha = currentNavigationBarAlpha;
    if (alpha > 1) {
        alpha = 1;
    }
    objc_setAssociatedObject(self, CloudoxKey, [NSString stringWithFormat:@"%f", alpha], OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.navigationController isKindOfClass:[LHNavigationController class]]) {
        LHNavigationController *lhnav = (LHNavigationController *)self.navigationController;
        [lhnav setNavAlpha:alpha];
    }
}

- (CGFloat)currentNavigationBarAlpha {
    NSString *temp = objc_getAssociatedObject(self, CloudoxKey) ? : @"1";
    return [temp floatValue];
}
@end
