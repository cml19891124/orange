//
//  StorageManager.h
//  WanchangLawFirms
//
//  Created by lh on 2019/2/11.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StorageModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 存储空间、使用时进行修改
@interface StorageManager : NSObject
+ (instancetype)initWithShare;
- (NSArray<StorageModel *> *)getFileListInFolderWithPath:(NSString *)path;
- (float)cachesSize;
- (void)clearCaches;
@end

NS_ASSUME_NONNULL_END
