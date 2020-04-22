//
//  StorageModel.h
//  WanchangLawFirms
//
//  Created by lh on 2019/2/11.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StorageModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, assign) long long fileLength;
@property (nonatomic, assign) BOOL isDir;
@end

NS_ASSUME_NONNULL_END
