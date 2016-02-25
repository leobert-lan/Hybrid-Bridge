//
//  DemoH5API.m
//  H5
//
//  Created by Qingyang on 16/2/25.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "DemoH5API.h"

@implementation DemoH5API
#pragma mark - 监听
+ (void)demoListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler{
    __weak id weakSelf=bridge;
    [bridge registerHandler:NATIVE_FUNCTION_DEMO handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}

#pragma mark - 调取H5
+ (void)demoCall:(WKWebViewJavascriptBridge *)bridge data:(id)data callback:(H5Callback)callback {
    __weak id weakSelf=bridge;
    [bridge callHandler:JS_FUNCTION_DEMO data:data responseCallback:^(id response) {
        if (callback) {
            callback(weakSelf,[H5DataCheck checkData:response],nil);
        }
    }];
}
@end
