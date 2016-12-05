//
//  WebAuthAPI.m
//  HybridApp
//
//  Created by Qingyang on 16/12/1.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "WebAuthAPI.h"

@implementation WebAuthAPI
#pragma mark - 监听web
+ (void)AuthInfoListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler{
    __weak id weakSelf=bridge;
    [bridge registerHandler:APP_N_PUBLIC_SIGN_AUTHINFO handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, nil, nil, responseCallback);
        }
    }];
}

#pragma mark - 调取web
+ (void)AuthInfoCall:(WKWebViewJavascriptBridge *)bridge data:(id)data callback:(H5Callback)callback {
    __weak id weakSelf=bridge;
//    [bridge callHandler:JS_FUNCTION_DEMO data:data responseCallback:^(id response) {
//        if (callback) {
//            callback(weakSelf,[H5DataCheck checkData:response],nil);
//        }
//    }];
}
@end
