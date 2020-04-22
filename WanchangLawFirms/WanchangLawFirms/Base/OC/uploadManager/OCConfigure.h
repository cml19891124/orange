//
//  OCConfigure.h
//  zhirong
//
//  Created by lh on 2018/5/3.
//  Copyright © 2018年 szcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCConfigure : NSObject
+ (instancetype)share;
@property (nonatomic, copy, readonly) NSString *STSServer;
@property (nonatomic, copy, readonly) NSString *end_point;
@property (nonatomic, copy, readonly) NSString *bucket_name;
@end
