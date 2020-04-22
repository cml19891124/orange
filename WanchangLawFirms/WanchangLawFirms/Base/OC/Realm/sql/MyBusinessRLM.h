//
//  MyBusinessRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2019/1/11.
//  Copyright © 2019 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 企业信息表
@interface MyBusinessRLM : RLMObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *ext;

@end

NS_ASSUME_NONNULL_END
