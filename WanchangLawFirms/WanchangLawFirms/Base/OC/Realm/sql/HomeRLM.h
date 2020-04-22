//
//  HomeRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/11.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 首页数据表
@interface HomeRLM : RLMObject
@property (nonatomic, copy) NSString *c_id;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *pv;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *sub_title;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *oss_url;
@end

NS_ASSUME_NONNULL_END
