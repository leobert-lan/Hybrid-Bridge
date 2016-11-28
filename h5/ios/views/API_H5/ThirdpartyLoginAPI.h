//
//  ThirdpartyLoginAPI.h
//  H5
//
//  Created by zhchen on 16/3/1.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdpartyLoginAPI : NSObject
+ (void)thirdPartyLoginListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;

+ (void)thirdPartyLoginListenerSina:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;

+ (void)thirdPartyLoginListenerWeixin:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
+ (void)thirdPartyShareListenerWeixin:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
+ (void)thirdPartyShareListenerQQ:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
+ (void)thirdPartyShareListenerSina:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
@end
