//
//  UIViewController+JNoPresent.m
//  WanchangLawFirms
//
//  Created by lh on 2018/12/21.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "UIViewController+JNoPresent.h"
#import <objc/runtime.h>

@implementation UIViewController (JNoPresent)
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(lq_presentViewController:animated:completion:));
        
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

- (void)lq_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {
            return;
        }
    }
    [self lq_presentViewController:viewControllerToPresent animated:flag completion:completion];
}
@end
