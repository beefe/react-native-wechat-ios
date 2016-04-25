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
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"
#import "WXMediaMessage+messageConstruct.h"


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

    // 发送信息
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;

        NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", messageResp.errCode], @"errCode", nil];

        [instance.bridge.eventDispatcher sendAppEventWithName:@"didRecvMessageResponse"
                                                         body:body];
    // 授权
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;

        NSDictionary *body = [[NSDictionary alloc] initWithObjectsAndKeys:
                              authResp.code, @"code",
                              authResp.state, @"state",
                              [NSString stringWithFormat:@"%d", authResp.errCode], @"errCode", nil];

        [instance.bridge.eventDispatcher sendAppEventWithName:@"didRecvAuthResponse"
                                                        body:body];
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        NSString *errCode = @"";
        NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     strMsg,@"strMsg",
                                     errCode,@"errCode",nil];
        switch (resp.errCode) {
            case WXSuccess:
                errCode = [NSString stringWithFormat:@"%d",resp.errCode];
                strMsg = @"支付结果：成功！";
                body[@"strMsg"] = strMsg;
                body[@"errCode"] = errCode;
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                errCode = [NSString stringWithFormat:@"%d",resp.errCode];
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                body[@"strMsg"] = strMsg;
                body[@"errCode"] = errCode;
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        [instance.bridge.eventDispatcher sendAppEventWithName:@"finishedPay"
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

//
RCT_EXPORT_METHOD(sendLinkURL:(NSString *)link
                  :(NSString *)tagName
                  :(NSString *)title
                  :(NSString *)desc
                  :(NSString *)thumbImage
                  :(int)_scene
                  :(RCTResponseSenderBlock)callback) {

    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbImage]]];

    enum WXScene scene = _scene;

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = link;

    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:desc
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:image
                                                      MediaTag:tagName];

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    BOOL res = [WXApi sendReq:req];
    callback(@[@(res)]);
}

RCT_EXPORT_METHOD(sendImage:(NSString *)path
                  :(NSString *)tagName
                  :(NSString *)title
                  :(NSString *)desc
                  :(int)_scene
                  :(RCTResponseSenderBlock)callback) {

    enum WXScene scene = _scene;
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;


    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:desc
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:nil
                                                      MediaTag:tagName];

    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    BOOL res = [WXApi sendReq:req];
    callback(@[@(res)]);
}

RCT_EXPORT_METHOD(wechatPay:(NSDictionary *)dict
                  :(RCTResponseSenderBlock)callback) {
    NSMutableString *stamp  = [dict objectForKey:@"timeStamp"];
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = [dict objectForKey:@"partnerId"];
    req.prepayId = [dict objectForKey:@"prepayId"];
    req.nonceStr = [dict objectForKey:@"nonceStr"];
    req.timeStamp = stamp.intValue;
    req.package = [dict objectForKey:@"packageValue"];
    req.sign = [dict objectForKey:@"sign"];
    //日志输出
        NSLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    BOOL res = [WXApi sendReq:req];
    callback(@[@(res)]);
}

@end
