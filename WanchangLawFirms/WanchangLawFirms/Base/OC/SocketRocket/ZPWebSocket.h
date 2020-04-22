//
//  ZPWebSocket.h
//  GoShoping
//
//  Created by QYBM on 2017/3/9.
//  Copyright © 2017年 QYBM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZPWebSocketStatus) {
    ZPWebSocketStatusConnecting = 1,//链接中
    ZPWebSocketStatusDown,//关闭
};
@class ZPWebSocket;
@protocol ZPWebSocketDelegate <NSObject>

@optional
//socket成功连接回调
- (void)reconnectionSocket;
//收到数据
- (void)webSocketReceiveDataStr:(NSString *_Nullable)str;
//socket 数据返回回调
- (void)webSocketDataStr:(NSString *_Nullable)str;

@end

NS_ASSUME_NONNULL_BEGIN
@interface ZPWebSocket : NSObject
@property (nonatomic, assign) ZPWebSocketStatus status;
@property (nonatomic, retain) NSTimer *heartTimer;
@property (nonatomic, weak) id<ZPWebSocketDelegate> delegate;
@property (nonatomic, copy) void (^pingBlock)(void);
+ (instancetype)initSocket;
- (void)connectWebSocket;
- (void)send:(NSString *)string;
- (void)close;
@end
NS_ASSUME_NONNULL_END
