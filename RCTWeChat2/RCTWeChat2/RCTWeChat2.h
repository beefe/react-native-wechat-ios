//
//  RCTWeChat2.h
//  RCTWeChat2
//
//  Created by xiaoyan on 15/12/9.
//  Copyright © 2015年 ziyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "WXApi.h"

@interface RCTWeChat2 : NSObject <RCTBridgeModule, WXApiDelegate>

+ (instancetype) shareInstance;

- (BOOL) handleOpenURL:(NSURL *)url;

@end
