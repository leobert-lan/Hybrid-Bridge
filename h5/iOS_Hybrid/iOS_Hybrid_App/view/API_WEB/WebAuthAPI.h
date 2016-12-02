//
//  WebAuthAPI.h
//  HybridApp
//
//  Created by Qingyang on 16/12/1.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAuthAPI : NSObject
//+ (void)AuthListener:(WKWebViewJavascriptBridge *)bridge handler:(void (^)(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback))handler;
+ (void)AuthInfoListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
@end
