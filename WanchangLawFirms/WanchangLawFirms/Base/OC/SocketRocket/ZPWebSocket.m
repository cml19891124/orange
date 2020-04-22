//
//  ZPWebSocket.m
//  GoShoping
//
//  Created by QYBM on 2017/3/9.
//  Copyright © 2017年 QYBM. All rights reserved.
//

#import "ZPWebSocket.h"
#import <SRWebSocket.h>
#import "OCBase.h"
#import "WanchangLawFirms-Swift.h"

@interface ZPWebSocket()<SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, retain) NSTimer *pingTimer;
@property (nonatomic, assign) int pingSecond;
@end

@implementation ZPWebSocket
+ (instancetype)initSocket {
    static id ZPSocket;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ZPSocket = [ZPWebSocket new];
    });
    return ZPSocket;
}
    
- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.pingBlock = ^{
            weakSelf.pingSecond = 0;
            [weakSelf.pingTimer setFireDate:[NSDate distantFuture]];
        };
    }
    return self;
}
    
- (NSTimer *)pingTimer {
    if (!_pingTimer) {
        _pingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DDCheckPing) userInfo:nil repeats:YES];
    }
    return _pingTimer;
}
    
- (NSTimer *)heartTimer {
    if (!_heartTimer) {
        _heartTimer = [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(DDCheckLongConnectByServe) userInfo:nil repeats:YES];
    }
    return _heartTimer;
}

- (void)connectWebSocket {
    if (_webSocket) {
        [_webSocket close];
        _webSocket.delegate = nil;
        _webSocket = nil;
    }
    NSString *urlStr = @"wss://im.wanchangorange.com/ws";
    if (UserInfo.share.isTestServer) {
        urlStr = @"ws://47.106.38.135:8901";
    }
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    _webSocket.delegate = self;
    [_webSocket open];
}


#pragma mark - SRWebSocketDelegate
//连接成功回调
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    self.status = ZPWebSocketStatusConnecting;
    DebugLog(@"socket链接");
    if ([self.delegate respondsToSelector:@selector(reconnectionSocket)]) {
        [self.delegate reconnectionSocket];
    }
    [self.heartTimer fire];
    _pingSecond = 0;
    [self.pingTimer setFireDate:[NSDate distantFuture]];
}

//收到消息回调
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    [self messageStatus:message];
}

- (void)messageStatus:(NSString *)str {
    if ([self.delegate respondsToSelector:@selector(webSocketDataStr:)]) {
        [self.delegate webSocketDataStr:str];
    }
    if ([self.delegate respondsToSelector:@selector(webSocketReceiveDataStr:)]) {
        [self.delegate webSocketReceiveDataStr:str];
    }
}
//断开链接
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    self.status = ZPWebSocketStatusDown;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self connectWebSocket];
    });
}

//关闭回调
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket.readyState == SR_CLOSED && code != SRStatusCodeGoingAway) {
        [self connectWebSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    DebugLog(@"socketSOCKET 心跳%@",pongPayload);
}

#pragma mark - 方法
- (void)send:(NSString *)string {
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:string];
    }
}

- (void)close {
    self.status = ZPWebSocketStatusDown;
    [_webSocket close];
    _webSocket.delegate = nil;
    _webSocket = nil;
    [self.heartTimer invalidate];
    _heartTimer = nil;
    DebugLog(@"socket已关闭");
}

- (void)DDCheckLongConnectByServe {
    NSString *string = @"{\"event\":\"ping\"}";
    _pingSecond = 0;
    [self.pingTimer setFireDate:[NSDate distantPast]];
//    [self send:string];
    NSString *resultStr = [AES encryptAES:string key:UserInfo.share.aes_key iv:UserInfo.share.aes_iv];
    [self send:resultStr];
}
    
- (void)DDCheckPing {
    _pingSecond += 1;
    if (_pingSecond > 5) {
        [self connectWebSocket];
    }
}
@end































