//
//  ConversationRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/10.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 会话表
@interface ConversationRLM : RLMObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *trade_sn;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *product_title;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *msg_id;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *input_text;

@end

NS_ASSUME_NONNULL_END
