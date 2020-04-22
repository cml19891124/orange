//
//  MessageRLM.h
//  WanchangLawFirms
//
//  Created by lh on 2018/12/7.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

/// 消息表
@interface MessageRLM : RLMObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *msg_id;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *trade_sn;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *net_id;


@property (nonatomic, copy) NSString *attribute;

@property (nonatomic, copy) NSString *j_status;
@property (nonatomic, copy) NSString *j_path;
@property (nonatomic, assign) BOOL j_isRead;
@property (nonatomic, assign) BOOL j_isWithdrew;
@property (nonatomic, assign) BOOL j_isReadAck;

@property (nonatomic, copy) NSString *j_oss_snap_url;
@property (nonatomic, copy) NSString *j_oss_full_url;

@end

NS_ASSUME_NONNULL_END
