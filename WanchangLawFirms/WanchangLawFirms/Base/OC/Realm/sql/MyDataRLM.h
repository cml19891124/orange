//
//  MyDataRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/3.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 个人信息表
@interface MyDataRLM : RLMObject
    
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *ext;

@end

NS_ASSUME_NONNULL_END
