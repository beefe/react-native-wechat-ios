//
//  RCTWeChat.m
//  RCTWeChat
//
//  Created by xiaoyan on 15/12/10.
//  Copyright © 2015年 ziyan. All rights reserved.
//

#import "RCTWeChat.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "WXApi.h"
#import "WXApiObject.h"

static RCTWeChat * instance = nil;

@implementation RCTWeChat

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

+ (instancetype)shareInstance {
    @synchronized(self) {
        if (!instance) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+ (instancetype)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (!instance) {
            instance = [super allocWithZone:zone];
        }
    }
    return instance;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

// 处理微信通过URL启动App时传递的数据
- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:instance];
}

// 发送一个sendReq后，收到微信的回应
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        
        NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:
                              authResp.code, @"code",
                              authResp.state, @"state",
                              [NSString stringWithFormat:@"%d", authResp.errCode], @"errCode", nil];

        [self.bridge.eventDispatcher sendAppEventWithName:@"didRecvAuthResponse"
                                                        body:body];
    }
}

// 收到一个来自微信的请求，
// 第三方应用程序处理完后调用sendResp向微信发送结果
- (void)onReq:(BaseReq *)req {
}


// 向微信终端程序注册第三方应用
RCT_EXPORT_METHOD(registerApp:(NSString *)appid
                  :(RCTResponseSenderBlock)callback)
{
    BOOL res = [WXApi registerApp:appid];
    callback(@[@(res)]);
}

// 向微信终端程序注册第三方应用，带描述
RCT_EXPORT_METHOD(registerAppWithDesc:(NSString *)appid
                  :(NSString *)appdesc
                  :(RCTResponseSenderBlock)callback) {
    BOOL res = [WXApi registerApp:appid withDescription:appdesc];
    callback(@[@(res)]);
}

// 判断当前微信的版本是否支持OpenApi
RCT_EXPORT_METHOD(isWXAppSupportApi:(RCTResponseSenderBlock)callback) {
    BOOL res = [WXApi isWXAppSupportApi];
    callback(@[@(res)]);
}

// 检测是否已安装微信
RCT_EXPORT_METHOD(isWXAppInstalled:(RCTResponseSenderBlock)callback)
{
    BOOL res = [WXApi isWXAppInstalled];
    callback(@[@(res)]);
}

// 获取当前微信SDK的版本号
RCT_EXPORT_METHOD(getApiVersion:(RCTResponseSenderBlock)callback) {
    NSString* res = [WXApi getApiVersion];
    callback(@[res]);
}

// 获取微信的itunes安装地址
RCT_EXPORT_METHOD(getWXAppInstallUrl:(RCTResponseSenderBlock)callback) {
    NSString* res = [WXApi getWXAppInstallUrl];
    callback(@[res]);
}

// 打开微信
RCT_EXPORT_METHOD(openWXApp:(RCTResponseSenderBlock)callback) {
    BOOL res = [WXApi openWXApp];
    callback(@[@(res)]);
}

// 发起认证请求
RCT_EXPORT_METHOD(sendAuthReq:(NSString *)scope
                  :(NSString *)state
                  :(RCTResponseSenderBlock)callback) {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope;
    req.state = state;
    BOOL res = [WXApi sendReq:req];
    callback(@[@(res)]);
}

@end