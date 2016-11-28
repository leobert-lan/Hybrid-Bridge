//
//  ThirdpartyLoginAPI.m
//  H5
//
//  Created by zhchen on 16/3/1.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "ThirdpartyLoginAPI.h"

@implementation ThirdpartyLoginAPI
+ (void)thirdPartyLoginListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler
{
    __weak id weakSelf=bridge;
    [bridge registerHandler:NATIVE_FUNCTION_THIRDPARTYLOGIN handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}
+ (void)thirdPartyLoginListenerSina:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler
{
    __weak id weakSelf=bridge;
    [bridge registerHandler:NATIVE_FUNCTION_THIRDPARTYLOGINSINA handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}
+ (void)thirdPartyLoginListenerWeixin:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler
{
    __weak id weakSelf=bridge;
    [bridge registerHandler:NATIVE_FUNCTION_THIRDPARTYLOGINWEIXIN handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}

+ (void)thirdPartyShareListenerQQ:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler
{
    __weak id weakSelf=bridge;
    [bridge registerHandler:NATIVE_FUNCTION_THIRDPARTYShareQQ handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}

+ (void)thirdPartyShareListenerSina:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler
{
    __weak id weakSelf=bridge;
    [bridge registerHandler:NATIVE_FUNCTION_THIRDPARTYShareSina handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}
+ (void)thirdPartyShareListenerWeixin:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler
{
    __weak id weakSelf=bridge;
    [bridge registerHandler:NATIVE_FUNCTION_THIRDPARTYShareWeixin handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}
@end
