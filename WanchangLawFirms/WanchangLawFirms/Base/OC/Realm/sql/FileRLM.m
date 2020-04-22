//
//  FileRLM.m
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "FileRLM.h"

@implementation FileRLM
+ (NSString *)primaryKey {
    return @"remotePath";
}

+ (NSDictionary *)defaultPropertyValues {
    return @{@"deleted": @"0"};
}

@end
