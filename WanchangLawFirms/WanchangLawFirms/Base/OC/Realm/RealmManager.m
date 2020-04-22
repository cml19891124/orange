//
//  RealmManager.m
//  OLegal
//
//  Created by lh on 2018/11/26.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import "RealmManager.h"
#import <Realm.h>
#import "WanchangLawFirms-Swift.h"

#import "MyDataRLM.h"
#import "MessageRLM.h"
#import "PendingMsgRLM.h"
#import "ConversationRLM.h"
#import "HomeRLM.h"
#import "FileRLM.h"
#import "SystemRLM.h"
#import "DownloadRLM.h"
#import "LawyerOneRLM.h"
#import "MyBusinessRLM.h"
#import "ArticleRLM.h"
#import "TIFRLM.h"

static RealmManager *_realmManager = nil;

@implementation RealmManager
+ (instancetype)shareManager {
    if (_realmManager == nil) {
        _realmManager = [RealmManager new];
        [_realmManager initDataBase];
    }
    return _realmManager;
}

- (void)initDataBase {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"OLegal.realm"];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [NSURL URLWithString:filePath];
    config.readOnly = NO;
    config.schemaVersion = 1.0;
    config.objectClasses = @[
                             MyDataRLM.class,
                             MessageRLM.class,
                             PendingMsgRLM.class,
                             ConversationRLM.class,
                             HomeRLM.class,
                             FileRLM.class,
                             SystemRLM.class,
                             DownloadRLM.class,
                             LawyerOneRLM.class,
                             MyBusinessRLM.class,
                             ArticleRLM.class,
                             ];
    config.migrationBlock = ^(RLMMigration * _Nonnull migration, uint64_t oldSchemaVersion) {
        
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
}
    
- (void)updateMyData:(NSString *)json_string uid:(nonnull NSString *)uid {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    MyDataRLM *rlm = [MyDataRLM new];
    rlm.account = uid;
    rlm.ext = json_string;
    [realm addOrUpdateObject:rlm];
    [realm commitWriteTransaction];
}
    
- (UserModel *)getMyModel:(NSString *)uid {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MyDataRLM *> *result = [MyDataRLM objectsWhere:[NSString stringWithFormat:@"account = '%@'", uid]];
    UserModel *model = [UserModel new];
    if (result.count == 1) {
        MyDataRLM *rlm = result[0];
        NSData *data = [rlm.ext dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        model = [UserModel mj_objectWithKeyValues:dict];
    }
    [realm commitWriteTransaction];
    return model;
}

- (void)updateMyBusiness:(NSString *)json_string uid:(NSString *)uid {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    MyBusinessRLM *rlm = [MyBusinessRLM new];
    rlm.account = uid;
    rlm.ext = json_string;
    [realm addOrUpdateObject:rlm];
    [realm commitWriteTransaction];
}

- (MineBusinessModel *)getMyBusiness:(NSString *)uid {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MyBusinessRLM *> *result = [MyBusinessRLM objectsWhere:[NSString stringWithFormat:@"account = '%@'", uid]];
    MineBusinessModel *model = [MineBusinessModel new];
    if (result.count == 1) {
        MyBusinessRLM *rlm = result[0];
        NSData *data = [rlm.ext dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        model = [MineBusinessModel mj_objectWithKeyValues:dict];
    }
    [realm commitWriteTransaction];
    return model;
}

- (void)addMsgModel:(JSocketModel *)model {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"msg_id = '%@'", model.id]];
    if (results.count == 1) {
        model.j_already_exist = YES;
    }
    MessageRLM *rlm = [self socketModelToRlm:model];
    [realm addOrUpdateObject:rlm];
    if ([model.j_status isEqualToString:@"0"]) {
        PendingMsgRLM *penRLM = [PendingMsgRLM new];
        penRLM.msg_id = rlm.msg_id;
        penRLM.account = rlm.account;
        [realm addOrUpdateObject:penRLM];
    }
    [realm commitWriteTransaction];
}

- (void)addMsgModelArr:(NSArray<JSocketModel *> *)mulArr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (JSocketModel *model in mulArr) {
        MessageRLM *rlm = [self socketModelToRlm:model];
        [realm addOrUpdateObject:rlm];
        if ([model.j_status isEqualToString:@"0"]) {
            PendingMsgRLM *penRLM = [PendingMsgRLM new];
            penRLM.msg_id = rlm.msg_id;
            penRLM.account = rlm.account;
            [realm addOrUpdateObject:penRLM];
        }
    }
    [realm commitWriteTransaction];
}

- (void)addOfflineMsgModelArr:(NSArray<JSocketModel *> *)mulArr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
//    NSArray *resultArr = [mulArr sortedArrayUsingComparator:^NSComparisonResult(JSocketModel *obj1, JSocketModel *obj2) {
//        return obj1.time > obj2.time;
//    }];
    NSMutableArray *withdrewArr = [NSMutableArray new];
    for (JSocketModel *model in mulArr) {
        RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"net_id = '%@'", model.id]];
        if (results.count == 0) {
            if ((model.type > 0 && model.type < 5) || model.type == 7) {
                MessageRLM *rlm = [self socketModelToRlm:model];
                [realm addOrUpdateObject:rlm];
            } else if (model.type == 5) {
                [self updateRead:model.sn realm:realm];
            } else if (model.type == 6) {
                [withdrewArr addObject:model.content];
            }
        } else {
            model.j_already_exist = YES;
        }
    }
    for (NSString *net_id in withdrewArr) {
        RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"net_id = '%@'", net_id]];
        if (results.count == 1) {
            MessageRLM *rlm = results[0];
            rlm.j_isWithdrew = YES;
            [realm addOrUpdateObject:rlm];
        }
    }
    [realm commitWriteTransaction];
}

- (void)addHistoryMsgModelArr:(NSArray<JSocketModel *> *)mulArr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
//    NSArray *resultArr = [mulArr sortedArrayUsingComparator:^NSComparisonResult(JSocketModel *obj1, JSocketModel *obj2) {
//        return obj1.time > obj2.time;
//    }];
    NSMutableArray *withdrewArr = [NSMutableArray new];
    for (JSocketModel *model in mulArr) {
        RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"net_id = '%@'", model.id]];
        if (results.count == 0) {
            if ((model.type > 0 && model.type < 5) || model.type == 7) {
                model.j_isRead = YES;
                model.j_isReadAck = YES;
                MessageRLM *rlm = [self socketHistoryModelToRlm:model];
                [realm addOrUpdateObject:rlm];
            } else if (model.type == 5) {

            } else if (model.type == 6) {
                [withdrewArr addObject:model.content];
            }
        }
    }
    for (NSString *net_id in withdrewArr) {
        RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"net_id = '%@'", net_id]];
        if (results.count == 1) {
            MessageRLM *rlm = results[0];
            rlm.j_isWithdrew = YES;
            [realm addOrUpdateObject:rlm];
        }
    }
    [realm commitWriteTransaction];
}

- (NSArray<JSocketModel *> *)getSocketModelFromMessageId:(NSString *)messageId trade_sn:(NSString *)trade_sn {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MessageRLM *> *results;
    if (trade_sn.length > 0) {
        results = [[MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", trade_sn]] sortedResultsUsingKeyPath:@"time" ascending:true];
    } else {
        results = [[MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@' and account = '%@'", trade_sn, UserInfo.share.uid]] sortedResultsUsingKeyPath:@"time" ascending:true];
    }
    NSMutableArray *mulArr = [NSMutableArray new];
    int count = 0;
    BOOL add = NO;
    if (![messageId isEqualToString:@""]) {
        for (NSUInteger i = results.count; i > 0; i--) {
            MessageRLM *rlm = results[i - 1];
            if (add) {
                if (count < 20) {
                    count += 1;
                    JSocketModel *model = [self messageRlmToModel:rlm];
                    [mulArr addObject:model];
                } else {
                    break;
                }
            }
            if ([rlm.msg_id isEqualToString:messageId] || [rlm.net_id isEqualToString:messageId]) {
                add = YES;
            }
        }
    } else {
        for (NSUInteger i = results.count; i > 0; i--) {
            MessageRLM *rlm = results[i - 1];
            if (count < 20) {
                JSocketModel *model = [self messageRlmToModel:rlm];
                [mulArr addObject:model];
                count += 1;
            } else {
                break;
            }
        }
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (NSArray<JSocketModel *> *)getChatFiles:(NSString *)trade_sn {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSMutableArray *mulArr = [NSMutableArray new];
    RLMResults <MessageRLM *> *results = [[MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@' and type = '4'",trade_sn]] sortedResultsUsingKeyPath:@"time" ascending:true];
    for (MessageRLM *rlm in results) {
        JSocketModel *model = [self messageRlmToModel:rlm];
        [mulArr addObject:model];
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (NSArray<JSocketModel *> *)getChatAllMsgs:(NSString *)trade_sn {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSMutableArray *mulArr = [NSMutableArray new];
    RLMResults <MessageRLM *> *results = [[MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'",trade_sn]] sortedResultsUsingKeyPath:@"time" ascending:true];
    for (MessageRLM *rlm in results) {
        JSocketModel *model = [self messageRlmToModel:rlm];
        [mulArr addObject:model];
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (NSArray<JSocketModel *> *)getMsgModelByKeyWord:(NSString *)keyword sn:(NSString *)sn {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSMutableArray *mulArr = [NSMutableArray new];
    RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"content contains '%@' and trade_sn = '%@' and type = '1'",keyword,sn]];
    for (MessageRLM *rlm in results) {
        JSocketModel *model = [self messageRlmToModel:rlm];
        [mulArr addObject:model];
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (NSArray<JSocketModel *> *)getSocketModelAfterMessageId:(NSString *)messageId trade_sn:(NSString *)trade_sn {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MessageRLM *> *results;
    if (trade_sn.length > 0) {
        results = [[MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", trade_sn]] sortedResultsUsingKeyPath:@"time" ascending:true];
    } else {
        results = [[MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@' and account = '%@'", trade_sn, UserInfo.share.uid]] sortedResultsUsingKeyPath:@"time" ascending:true];
    }
    NSMutableArray *mulArr = [NSMutableArray new];
    int count = 0;
    for (NSUInteger i = results.count; i > 0; i--) {
        MessageRLM *rlm = results[i - 1];
        count += 1;
        JSocketModel *model = [self messageRlmToModel:rlm];
        [mulArr addObject:model];
        if ([rlm.msg_id isEqualToString:messageId] || [rlm.net_id isEqualToString:messageId]) {
            break;
        }
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (void)updateMsgStatus:(NSString *)status msg_id:(NSString *)msg_id {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"msg_id = '%@' or net_id = '%@'",msg_id,msg_id]];
    if (results.count == 1) {
        MessageRLM *rlm = results[0];
        rlm.j_status = status;
        if ([status isEqualToString:@"0"]) {
            [realm deleteObject:rlm];
        } else {
            [realm addOrUpdateObject:rlm];
        }
        RLMResults <PendingMsgRLM *> *penResults = [PendingMsgRLM objectsWhere:[NSString stringWithFormat:@"msg_id = '%@'", msg_id]];
        [realm deleteObjects:penResults];
    }
    [realm commitWriteTransaction];
}

- (void)updateMsgId:(NSString *)msg_id net_id:(NSString *)net_id {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"msg_id = '%@'", msg_id]];
    if (results.count == 1) {
        MessageRLM *rlm = results[0];
        rlm.net_id = net_id;
        [realm addOrUpdateObject:rlm];
    }
    [realm commitWriteTransaction];
}

- (void)updateImgMsgOssUrl:(NSString *)msg_id is_snap:(BOOL)is_snap oss_url:(NSString *)oss_url {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"msg_id = '%@' or net_id = '%@'", msg_id, msg_id]];
    if (results.count == 1) {
        MessageRLM *rlm = results[0];
        if (is_snap) {
            rlm.j_oss_snap_url = oss_url;
        } else {
            rlm.j_oss_full_url = oss_url;
        }
        [realm addOrUpdateObject:rlm];
    }
    [realm commitWriteTransaction];
}

- (void)updateUnsendMsgFailed {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <PendingMsgRLM *> *penResults = [PendingMsgRLM objectsWhere:[NSString stringWithFormat:@"account = '%@'", UserInfo.share.uid]];
    for (PendingMsgRLM *pen in penResults) {
        RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"msg_id = '%@'", pen.msg_id]];
        if (results.count == 1) {
            MessageRLM *rlm = results[0];
            rlm.j_status = @"2";
            [realm addOrUpdateObject:rlm];
        }
    }
    [realm deleteObjects:penResults];
    [realm commitWriteTransaction];
}

- (void)updateWithdrew:(NSString *)msg_id {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"net_id = '%@' or msg_id = '%@'", msg_id, msg_id]];
    if (results.count == 1) {
        MessageRLM *rlm = results[0];
        rlm.j_isWithdrew = YES;
        [realm addOrUpdateObject:rlm];
    }
    [realm commitWriteTransaction];
}

- (void)updateRead:(NSString *)sn isReadAck:(BOOL)isReadAck {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", sn]];
    if (results.count > 0) {
        for (int i = (int)results.count - 1; i >= 0; i--) {
            MessageRLM *rlm = results[i];
            if (isReadAck) {
                if ([rlm.from isEqualToString:UserInfo.share.uid]) {
                    break;
                }
                if (rlm.j_isReadAck == YES) {
                    break;
                }
                rlm.j_isReadAck = YES;
                [realm addOrUpdateObject:rlm];
            } else {
                if ([rlm.from isEqualToString:UserInfo.share.uid]) {
                    if (rlm.j_isRead) {
                        break;
                    }
                    rlm.j_isRead = YES;
                    [realm addOrUpdateObject:rlm];
                }
            }
        }
    }
    [realm commitWriteTransaction];
}

- (NSArray<MessageModel *> *)getConversationList:(NSString *)status {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <ConversationRLM *> *results = [ConversationRLM objectsWhere:[NSString stringWithFormat:@"account = '%@' and status = '%@'", UserInfo.share.uid, status]];
    NSMutableArray *mulArr = [NSMutableArray new];
    for (ConversationRLM *rlm in results) {
        MessageModel *model = [self conversationRlmToModel:rlm];
        if ([rlm.status isEqualToString:@"1"]) {
            RLMResults <MessageRLM *> *msgResults = [[MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", rlm.trade_sn]] sortedResultsUsingKeyPath:@"time" ascending:NO];
            NSInteger count = 0;
            if (msgResults.count > 0) {
                MessageRLM *first = msgResults[0];
                if (![first.from isEqualToString:UserInfo.share.uid]) {
                    for (MessageRLM *msg in msgResults) {
                        if (![msg.from isEqualToString:UserInfo.share.uid]) {
                            if (msg.j_isReadAck) {
                                break;
                            } else {
                                count += 1;
                            }
                        }
                    }
                }
                if (first.time.length >= 10) {
                    NSString *time = [first.time substringToIndex:10];
                    model.j_time = [time longLongValue];
                    model.lastMsgModel = [self messageRlmToModel:first];
                }
            } else {
                model.j_time = [rlm.created_at longLongValue];
            }
            model.j_unread_count = count;
        }
        [mulArr addObject:model];
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (void)addConversation:(NSArray<MessageModel *> *)arr status:(nonnull NSString *)status {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (MessageModel *model in arr) {
        RLMResults <ConversationRLM *> *results = [ConversationRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", model.order_sn]];
        if (results.count == 1) {
            ConversationRLM *rlm = results[0];
            rlm.status = status;
            [realm addOrUpdateObject:rlm];
        } else {
            ConversationRLM *rlm = [self messageModelToRLM:model];
            rlm.status = status;
            [realm addOrUpdateObject:rlm];
        }
    }
    [realm commitWriteTransaction];
}

- (void)updateConversationOnGoing:(NSArray<MessageModel *> *)arr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <ConversationRLM *> *results = [ConversationRLM objectsWhere:[NSString stringWithFormat:@"account = '%@' and status = '%@'", UserInfo.share.uid, @"1"]];
    NSMutableArray *mulArr = [NSMutableArray new];
    for (ConversationRLM *rlm in results) {
        [mulArr addObject:rlm];
    }
    for (MessageModel *model in arr) {
        BOOL find = NO;
        for (ConversationRLM *rlm in mulArr) {
            if ([rlm.trade_sn isEqualToString:model.order_sn]) {
                find = YES;
                rlm.uid = model.id;
                rlm.avatar = model.avatar;
                rlm.name = model.name;
                [realm addOrUpdateObject:rlm];
                [mulArr removeObject:rlm];
                break;
            }
        }
        if (!find) {
            ConversationRLM *rlm = [self messageModelToRLM:model];
            rlm.status = @"1";
            [realm addOrUpdateObject:rlm];
        }
    }
    [realm deleteObjects:mulArr];
    [realm commitWriteTransaction];
}

- (void)updateConversationFinished:(NSArray<MessageModel *> *)arr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (MessageModel *model in arr) {
        RLMResults <ConversationRLM *> *results = [ConversationRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", model.order_sn]];
        if (results.count == 1) {
            ConversationRLM *rlm = results[0];
            rlm.status = @"2";
            rlm.uid = model.id;
            rlm.avatar = model.avatar;
            rlm.name = model.name;
            [realm addOrUpdateObject:rlm];
        } else {
            ConversationRLM *rlm = [self messageModelToRLM:model];
            rlm.status = @"2";
            [realm addOrUpdateObject:rlm];
        }
    }
    [realm commitWriteTransaction];
}

- (void)updateConversationInputText:(NSString *)text trade_sn:(NSString *)trade_sn {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <ConversationRLM *> *results = [ConversationRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", trade_sn]];
    if (results.count == 1) {
        ConversationRLM *rlm = results[0];
        rlm.input_text = text;
        [realm addOrUpdateObject:rlm];
    }
    [realm commitWriteTransaction];
}

- (void)updateConversationFinish:(NSString *)trade_sn {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <ConversationRLM *> *results = [ConversationRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", trade_sn]];
    if (results.count == 1) {
        ConversationRLM *rlm = results[0];
        rlm.status = @"2";
        [realm addOrUpdateObject:rlm];
    }
    [realm commitWriteTransaction];
}

- (void)addHomeLatest:(NSArray<HomeModel *> *)arr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <HomeRLM *> *results = [HomeRLM allObjects];
    [realm deleteObjects:results];
    for (HomeModel *m in arr) {
        HomeRLM *rlm = [self homeModelToRlm:m];
        [realm addOrUpdateObject:rlm];
    }
    [realm commitWriteTransaction];
}

- (NSArray<HomeModel *> *)getHomeLatest {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <HomeRLM *> *results = [HomeRLM allObjects];
    NSMutableArray *mulArr = [NSMutableArray new];
    for (HomeRLM *rlm in results) {
        HomeModel *model = [self homeRlmToModel:rlm];
        [mulArr addObject:model];
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (void)addFile:(JFileModel *)model {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    FileRLM *rlm = [self fileModelToRlm:model];
    [realm addOrUpdateObject:rlm];
    [realm commitWriteTransaction];
}

- (NSArray<JFileModel *> *)getAllFiles:(BOOL)isAll {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <FileRLM *> *results;
    if (isAll) {
        results = [FileRLM allObjects];
    } else {
        results = [FileRLM objectsWhere:@"deleted = '0'"];
    }
    NSMutableArray *mulArr = [NSMutableArray new];
    for (FileRLM *rlm in results) {
        JFileModel *model = [self fileRlmToModel:rlm];
        [mulArr addObject:model];
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (JFileModel *)getOneFile:(NSString *)remotePath {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <FileRLM *> *results = [FileRLM objectsWhere:[NSString stringWithFormat:@"remotePath = '%@'", remotePath]];
    JFileModel *model = [[JFileModel alloc] initWithRemotePath:@"" name:@"" fileSize: @""];
    if (results.count == 1) {
        FileRLM *rlm = results[0];
        model = [self fileRlmToModel:rlm];
    }
    [realm commitWriteTransaction];
    return model;
}

- (void)deleteFile:(JFileModel *)model {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <FileRLM *> *results = [FileRLM objectsWhere:[NSString stringWithFormat:@"remotePath = '%@'", model.remotePath]];
    if (results.count == 1) {
        FileRLM *rlm = results[0];
        rlm.deleted = @"1";
        [realm addOrUpdateObject:rlm];
    }
    [realm commitWriteTransaction];
}

- (void)addSystemArr:(NSArray<JSocketModel *> *)arr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (JSocketModel *model in arr) {
        RLMResults <SystemRLM *> *results = [SystemRLM objectsWhere:[NSString stringWithFormat:@"id = '%@'", model.id]];
        if (results.count == 1) {
            model.j_already_exist = YES;
        } else {
            SystemRLM *rlm = [self systemModelToRlm:model];
            [realm addOrUpdateObject:rlm];
        }
    }
    [realm commitWriteTransaction];
}

- (NSArray<JSocketModel *> *)getAllSystemModelArr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <SystemRLM *> *results = [SystemRLM objectsWhere:[NSString stringWithFormat:@"account = '%@'", UserInfo.share.uid]];
    NSMutableArray *mulArr = [NSMutableArray new];
    for (SystemRLM *rlm in results) {
        JSocketModel *model = [self systemRlmToModel:rlm];
        [mulArr addObject:model];
        if (mulArr.count >= 100) {
            break;
        }
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (void)addDownload:(NSString *)remotePath {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    DownloadRLM *rlm = [DownloadRLM new];
    rlm.remotePath = remotePath;
    [realm addOrUpdateObject:rlm];
    [realm commitWriteTransaction];
}

- (BOOL)judgeDownload:(NSString *)remotePath {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <DownloadRLM *> *results = [DownloadRLM objectsWhere:[NSString stringWithFormat:@"remotePath = '%@'", remotePath]];
    BOOL find = NO;
    if (results.count == 1) {
        find = YES;
    }
    [realm commitWriteTransaction];
    return find;
}

- (void)addLawyerArr:(NSArray<LawyerModel *> *)arr {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (LawyerModel *model in arr) {
        LawyerOneRLM *rlm = [self lawyerModelToRlm:model];
        [realm addOrUpdateObject:rlm];
    }
    [realm commitWriteTransaction];
}

- (NSArray<LawyerModel *> *)getAllLawyer {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSMutableArray *mulArr = [NSMutableArray new];
    RLMResults <LawyerOneRLM *> *results = [LawyerOneRLM allObjects];
    for (LawyerOneRLM *rlm in results) {
        LawyerModel *model = [self LawyerOneRLMToModel:rlm];
        [mulArr addObject:model];
    }
    [realm commitWriteTransaction];
    return mulArr;
}

- (void)updateArticle:(NSString *)aid offsetY:(CGFloat)offsetY {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    ArticleRLM *rlm = [ArticleRLM new];
    rlm.article_id = aid;
    rlm.article_offset_y = [NSString stringWithFormat:@"%.0f", offsetY];
    [realm addOrUpdateObject:rlm];
    [realm commitWriteTransaction];
}

- (CGFloat)getArticleOffsetY:(NSString *)aid {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    CGFloat y = 0;
    RLMResults <ArticleRLM *> *results = [ArticleRLM objectsWhere:[NSString stringWithFormat:@"article_id = '%@'", aid]];
    if (results.count == 1) {
        ArticleRLM *rlm = results[0];
        y = [rlm.article_offset_y floatValue];
    }
    [realm commitWriteTransaction];
    return y;
}

- (void)saveTIFModel:(TIFModel *)model {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    TIFRLM *rlm = [self tifModelToRlm:model];
    [realm addOrUpdateObject:rlm];
    [realm commitWriteTransaction];
}

- (void)deleteTIFModel:(NSString *)ID {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <TIFRLM *> *results = [TIFRLM objectsWhere:[NSString stringWithFormat:@"ID = '%@'", ID]];
    [realm deleteObjects:results];
    [realm commitWriteTransaction];
}

- (TIFModel *)getTIFModel:(NSString *)ID {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    RLMResults <TIFRLM *> *results = [TIFRLM objectsWhere:[NSString stringWithFormat:@"ID = '%@'", ID]];
    TIFModel *model = [TIFModel new];
    if (results.count == 1) {
        model = [self tifRlmToModel:results[0]];
    }
    [realm commitWriteTransaction];
    return model;
}

#pragma mark - 内部方法
- (TIFModel *)tifRlmToModel:(TIFRLM *)rlm {
    TIFModel *model = [TIFModel new];
    model.id = rlm.ID;
    model.content = rlm.content;
    model.images = rlm.images;
    model.files = rlm.files;
    return model;
}

- (TIFRLM *)tifModelToRlm:(TIFModel *)model {
    TIFRLM *rlm = [TIFRLM new];
    rlm.ID = model.id;
    rlm.content = model.content;
    rlm.images = model.images;
    rlm.files = model.files;
    return rlm;
}

- (LawyerOneRLM *)lawyerModelToRlm:(LawyerModel *)model {
    LawyerOneRLM *rlm = [LawyerOneRLM new];
    rlm.uid = model.id;
    rlm.name = model.name;
    rlm.avatar = model.avatar;
    rlm.desc = model.desc;
    rlm.work_year = model.work_year;
    return rlm;
}

- (LawyerModel *)LawyerOneRLMToModel:(LawyerOneRLM *)rlm {
    LawyerModel *model = [LawyerModel new];
    model.id = rlm.uid;
    model.name = rlm.name;
    model.avatar = rlm.avatar;
    model.desc = rlm.desc;
    model.work_year = rlm.work_year;
    return model;
}

- (SystemRLM *)systemModelToRlm:(JSocketModel *)model {
    SystemRLM *rlm = [SystemRLM new];
    rlm.account = UserInfo.share.uid;
    rlm.content = model.content;
    rlm.id = model.id;
    rlm.push_type = model.push_type;
    rlm.push_title = model.push_title;
    NSString *timeStr = [NSString stringWithFormat:@"%lld", model.time];
    if (timeStr.length >= 13) {
        rlm.time = [timeStr substringToIndex:13];
    } else {
        rlm.time = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970] * 1000];
    }
    rlm.attribute = model.attribute;
    return rlm;
}

- (JSocketModel *)systemRlmToModel:(SystemRLM *)rlm {
    JSocketModel *model = [JSocketModel new];
    model.content = rlm.content;
    model.time = [rlm.time longLongValue];
    model.push_type = rlm.push_type;
    model.push_title = rlm.push_title;
    model.id = rlm.id;
    model.attribute = rlm.attribute;
    return model;
}

- (FileRLM *)fileModelToRlm:(JFileModel *)model {
    FileRLM *rlm = [FileRLM new];
    rlm.remotePath = model.remotePath;
    rlm.name = model.name;
    rlm.fileSize = model.fileSize;
    rlm.localPath = model.localPath;
    return rlm;
}

- (JFileModel *)fileRlmToModel:(FileRLM *)rlm {
    JFileModel *model = [[JFileModel alloc] initWithRemotePath:rlm.remotePath name:rlm.name fileSize: rlm.fileSize];
    model.localPath = rlm.localPath;
    return model;
}

- (void)updateRead:(NSString *)sn realm:(RLMRealm *)realm {
    RLMResults <MessageRLM *> *results = [MessageRLM objectsWhere:[NSString stringWithFormat:@"trade_sn = '%@'", sn]];
    if (results.count > 0) {
        for (int i = (int)results.count - 1; i >= 0; i--) {
            MessageRLM *rlm = results[i];
            if ([rlm.from isEqualToString:UserInfo.share.uid]) {
                if (rlm.j_isRead) {
                    break;
                }
                rlm.j_isRead = YES;
                [realm addOrUpdateObject:rlm];
            }
        }
    }
}

- (HomeRLM *)homeModelToRlm:(HomeModel *)model {
    HomeRLM *rlm = [HomeRLM new];
    rlm.c_id = model.id;
    rlm.cover = model.cover;
    rlm.pv = model.pv;
    rlm.source = model.source;
    rlm.sub_title = model.sub_title;
    rlm.symbol = model.symbol;
    rlm.thumb = model.thumb;
    rlm.title = model.title;
    return rlm;
}

- (HomeModel *)homeRlmToModel:(HomeRLM *)rlm {
    HomeModel *model = [HomeModel new];
    model.id = rlm.c_id;
    model.cover = rlm.cover;
    model.pv = rlm.pv;
    model.source = rlm.source;
    model.sub_title = rlm.sub_title;
    model.symbol = rlm.symbol;
    model.thumb = rlm.thumb;
    model.title = rlm.title;
    return model;
}

- (ConversationRLM *)messageModelToRLM:(MessageModel *)model {
    ConversationRLM *rlm = [ConversationRLM new];
    rlm.trade_sn = model.order_sn;
    rlm.amount = model.amount;
    rlm.created_at = model.created_at;
    rlm.desc = model.desc;
    rlm.product_title = model.product_title;
    rlm.uid = model.id;
    rlm.avatar = model.avatar;
    rlm.name = model.name;
    rlm.account = UserInfo.share.uid;
    return rlm;
}

- (MessageModel *)conversationRlmToModel:(ConversationRLM *)rlm {
    MessageModel *model = [MessageModel new];
    model.order_sn = rlm.trade_sn;
    model.amount = rlm.amount;
    model.created_at = rlm.created_at;
    model.desc = rlm.desc;
    model.product_title = rlm.product_title;
    model.id = rlm.uid;
    model.avatar = rlm.avatar;
    model.name = rlm.name;
    model.j_time = [rlm.time intValue];
    model.input_text = rlm.input_text;
    return model;
}

- (JSocketModel *)messageRlmToModel:(MessageRLM *)rlm {
    JSocketModel *model = [JSocketModel new];
    model.id = rlm.msg_id;
    model.from = rlm.from;
    model.to = rlm.to;
    model.content = rlm.content;
    model.sn = rlm.trade_sn;
    model.time = [rlm.time longLongValue];
    model.j_status = rlm.j_status;
    model.type = [rlm.type intValue];
    model.attribute = rlm.attribute;
    model.j_path = rlm.j_path;
    model.j_isRead = rlm.j_isRead;
    model.j_isReadAck = rlm.j_isReadAck;
    model.j_isWithdrew = rlm.j_isWithdrew;
    model.j_oss_snap_url = rlm.j_oss_snap_url;
    model.j_oss_full_url = rlm.j_oss_full_url;
    model.net_id = rlm.net_id;
    return model;
}

- (MessageRLM *)socketModelToRlm:(JSocketModel *)model {
    MessageRLM *rlm = [MessageRLM new];
    rlm.account = UserInfo.share.uid;
    rlm.msg_id = model.id;
    rlm.net_id = model.net_id;
    rlm.from = model.from;
    rlm.to = model.to;
    rlm.content = model.content;
    rlm.trade_sn = model.sn;
    NSString *timeStr = [NSString stringWithFormat:@"%lld", model.time];
    if (timeStr.length >= 13) {
        rlm.time = [timeStr substringToIndex:13];
    } else {
        rlm.time = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970] * 1000];
    }
    rlm.j_status = model.j_status;
    rlm.type = [NSString stringWithFormat:@"%ld", (long)model.type];
    rlm.attribute = model.attribute;
    rlm.j_path = model.j_path;
    rlm.j_isWithdrew = model.j_isWithdrew;
    rlm.j_isReadAck = model.j_isReadAck;
    rlm.j_isRead = model.j_isRead;
    rlm.j_oss_snap_url = model.j_oss_snap_url;
    rlm.j_oss_full_url = model.j_oss_full_url;
    return rlm;
}

- (MessageRLM *)socketHistoryModelToRlm:(JSocketModel *)model {
    MessageRLM *rlm = [MessageRLM new];
    rlm.account = UserInfo.share.uid;
    rlm.msg_id = model.id;
    rlm.net_id = model.id;
    rlm.from = model.from_id;
    rlm.to = model.to_id;
    rlm.content = model.content;
    rlm.trade_sn = model.sn;
    NSString *timeStr = [NSString stringWithFormat:@"%lld", model.time];
    if (timeStr.length >= 13) {
        rlm.time = [timeStr substringToIndex:13];
    } else {
        rlm.time = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970] * 1000];
    }
    rlm.j_status = model.j_status;
    rlm.type = [NSString stringWithFormat:@"%ld", (long)model.type];
    rlm.attribute = model.attribute;
    rlm.j_path = model.j_path;
    rlm.j_isWithdrew = model.j_isWithdrew;
    rlm.j_isReadAck = model.j_isReadAck;
    rlm.j_isRead = model.j_isRead;
    rlm.j_oss_snap_url = model.j_oss_snap_url;
    rlm.j_oss_full_url = model.j_oss_full_url;
    return rlm;
}

@end
