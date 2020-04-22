//
//  DownloadRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/19.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 下载表
@interface DownloadRLM : RLMObject
@property (nonatomic, copy) NSString *remotePath;
@property (nonatomic, copy) NSString *ext;
@end

NS_ASSUME_NONNULL_END
