//
//  FileRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/15.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 文件详情表
@interface FileRLM : RLMObject
@property (nonatomic, copy) NSString *remotePath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *deleted;
@property (nonatomic, copy) NSString *ext;
@end

NS_ASSUME_NONNULL_END
