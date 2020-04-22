//
//  OCConfigure.m
//  zhirong
//
//  Created by lh on 2018/5/3.
//  Copyright © 2018年 szcy. All rights reserved.
//

#import "OCConfigure.h"
#import "WanchangLawFirms-Swift.h"

static OCConfigure *_configure = nil;
@implementation OCConfigure

+ (instancetype)share {
    if (_configure == nil) {
        _configure = [OCConfigure new];
    }
    return _configure;
}

- (NSString *)STSServer {
    if (UserInfo.share.isTestServer) {
        return @"http://47.106.38.135:8900/pub/oss/token";
    }
    return @"https://api.wanchangorange.com/pub/oss/token";
}

- (NSString *)end_point {
    return @"http://oss-cn-shenzhen.aliyuncs.com";
}

- (NSString *)bucket_name {
    if (UserInfo.share.isTestServer) {
        return @"szcy-orange";
    }
    return @"sz-orange";
}

//- (NSString *)base_img_url {
//    return @"http://szcy-orange.oss-cn-shenzhen.aliyuncs.com/";
////    return @"http://sz-orange.oss-cn-shenzhen.aliyuncs.com/";
//}

@end
