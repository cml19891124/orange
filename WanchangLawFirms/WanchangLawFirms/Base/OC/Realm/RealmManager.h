//
//  RealmManager.h
//  OLegal
//
//  Created by lh on 2018/11/26.
//  Copyright © 2018 gaming17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UserModel;
@class JSocketModel;
@class MessageModel;
@class HomeModel;
@class JFileModel;
@class LawyerModel;
@class MineBusinessModel;
@class TIFModel;

NS_ASSUME_NONNULL_BEGIN

@interface RealmManager : NSObject
+ (instancetype)shareManager;

/// 更新用户信息
- (void)updateMyData:(NSString *)json_string uid:(NSString *)uid;
/// 获取用户信息
- (UserModel *)getMyModel:(NSString *)uid;
/// 更新企业信息
- (void)updateMyBusiness:(NSString *)json_string uid:(NSString *)uid;
/// 获取企业信息
- (MineBusinessModel *)getMyBusiness:(NSString *)uid;

/// 添加单个聊天消息
- (void)addMsgModel:(JSocketModel *)model;
/// 添加多个聊天消息
- (void)addMsgModelArr:(NSArray<JSocketModel *> *)mulArr;
/// 添加离线消息
- (void)addOfflineMsgModelArr:(NSArray<JSocketModel *> *)mulArr;
/// 添加历史消息
- (void)addHistoryMsgModelArr:(NSArray<JSocketModel *> *)mulArr;
/// 获取指定区间消息
- (NSArray<JSocketModel *> *)getSocketModelFromMessageId:(NSString *)messageId trade_sn:(NSString *)trade_sn;
- (NSArray<JSocketModel *> *)getChatFiles:(NSString *)trade_sn;
- (NSArray<JSocketModel *> *)getChatAllMsgs:(NSString *)trade_sn;
/// 消息关键字搜索
- (NSArray<JSocketModel *> *)getMsgModelByKeyWord:(NSString *)keyword sn:(NSString *)sn;
/// 获取指定消息以后的所有聊天消息记录
- (NSArray<JSocketModel *> *)getSocketModelAfterMessageId:(NSString *)messageId trade_sn:(NSString *)trade_sn;
/// 更新消息状态
- (void)updateMsgStatus:(NSString *)status msg_id:(NSString *)msg_id;
/// 得到网络端消息id时更新
- (void)updateMsgId:(NSString *)msg_id net_id:(NSString *)net_id;
/// 更新图片消息的缩略图以及下载的原图，此时只保存路径
- (void)updateImgMsgOssUrl:(NSString *)msg_id is_snap:(BOOL)is_snap oss_url:(NSString *)oss_url;
/// 更新未发送成功的消息为失败状态
- (void)updateUnsendMsgFailed;
/// 更新撤回消息
- (void)updateWithdrew:(NSString *)msg_id;
/// 更新消息已读和已读回执
- (void)updateRead:(NSString *)sn isReadAck:(BOOL)isReadAck;

/// 获取本地会话列表
- (NSArray<MessageModel *> *)getConversationList:(NSString *)status;
/// 添加本地会话列表
- (void)addConversation:(NSArray<MessageModel *> *)arr status:(NSString *)status;
/// 更新正在处理的会话列表
- (void)updateConversationOnGoing:(NSArray<MessageModel *> *)arr;
/// 更新已完成的会话列表
- (void)updateConversationFinished:(NSArray<MessageModel *> *)arr;
/// 更新订单为已完成
- (void)updateConversationFinish:(NSString *)trade_sn;
/// 会话编辑好未发送的消息
- (void)updateConversationInputText:(NSString *)text trade_sn:(NSString *)trade_sn;

/// 首页轮播
- (void)addHomeLatest:(NSArray<HomeModel *> *)arr;
/// 获取首页轮播缓存
- (NSArray<HomeModel *> *)getHomeLatest;

/// 添加文件
- (void)addFile:(JFileModel *)model;
/// 得到本地文件
- (NSArray<JFileModel *> *)getAllFiles:(BOOL)isAll;
/// 根据服务端路径得到本地已下载的文件模型
- (JFileModel *)getOneFile:(NSString *)remotePath;
/// 删除文件
- (void)deleteFile:(JFileModel *)model;

/// 添加系统消息
- (void)addSystemArr:(NSArray<JSocketModel *> *)arr;
/// 获取所有本地系统消息
- (NSArray<JSocketModel *> *)getAllSystemModelArr;

/// 添加已下载好路径
- (void)addDownload:(NSString *)remotePath;
/// 判断是否已下载
- (BOOL)judgeDownload:(NSString *)remotePath;

/// 添加律师信息
- (void)addLawyerArr:(NSArray<LawyerModel *> *)arr;
/// 得到所有本地缓存的律师信息
- (NSArray<LawyerModel *> *)getAllLawyer;

/// 更新文章偏移量
- (void)updateArticle:(NSString *)aid offsetY:(CGFloat)offsetY;
/// 得到文章上次浏览的位置
- (CGFloat)getArticleOffsetY:(NSString *)aid;

- (void)saveTIFModel:(TIFModel *)model;
- (void)deleteTIFModel:(NSString *)ID;
- (TIFModel *)getTIFModel:(NSString *)ID;
@end

NS_ASSUME_NONNULL_END
