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

+ (void)LoginListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler{
    __weak id weakSelf=bridge;
    [bridge registerHandler:APP_N_PUBLIC_SIGN_LOGIN handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, nil, nil, responseCallback);
        }
    }];
}

#pragma mark - 调取web
@end
