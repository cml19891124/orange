//
//  OCBase.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/7.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef DEBUG
#define DebugLog(message, ...) NSLog(@"%s: " message, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define DebugLog(message, ...)
#endif

NS_ASSUME_NONNULL_BEGIN

@interface OCBase : NSObject

@end

NS_ASSUME_NONNULL_END
