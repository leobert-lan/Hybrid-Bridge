//
//  WebAuthAPI.h
//  HybridApp
//
//  Created by Qingyang on 16/12/1.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAuthAPI : NSObject
//这里是两种写法，如果data有具体model，这里可以注明，便于使用
//+ (void)AuthListener:(WKWebViewJavascriptBridge *)bridge handler:(void (^)(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback))handler;
+ (void)AuthInfoListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
@end
