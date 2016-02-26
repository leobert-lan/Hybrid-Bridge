//
//  GPSH5API.m
//  H5
//
//  Created by Qingyang on 16/2/25.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "GPSH5API.h"

@implementation GPSH5API
#pragma mark - 监听
+ (void)OpenGpsListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler
{
    __weak id weakSelf=bridge;
    [bridge registerHandler:NATIVE_FUNCTION_OPENGPS handler:^(id data, WVJBResponseCallback responseCallback) {
        if (handler) {
            handler(weakSelf, [H5DataCheck checkData:data], nil, responseCallback);
        }
    }];
}
@end
