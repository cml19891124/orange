//
//  SystemRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/17.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 系统消息表
@interface SystemRLM : RLMObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *push_type;
@property (nonatomic, copy) NSString *push_title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *attribute;
@end

NS_ASSUME_NONNULL_END
