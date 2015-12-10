//
//  RCTWeChat.h
//  RCTWeChat
//
//  Created by xiaoyan on 15/12/10.
//  Copyright © 2015年 ziyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "WXApi.h"

@interface RCTWeChat : NSObject <RCTBridgeModule, WXApiDelegate>

+ (instancetype) shareInstance;

- (BOOL) handleOpenURL:(NSURL *)url;

@end