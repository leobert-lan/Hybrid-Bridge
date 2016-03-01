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
    [bridge registerHandler:NATIVE_FUNCTION_OPENCAMERA_SCAN handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}
@end
