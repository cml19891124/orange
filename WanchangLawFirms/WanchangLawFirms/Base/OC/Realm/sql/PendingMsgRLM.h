//
//  PendingMsgRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/10.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 正在发送中的消息表
@interface PendingMsgRLM : RLMObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *msg_id;
@end

NS_ASSUME_NONNULL_END
