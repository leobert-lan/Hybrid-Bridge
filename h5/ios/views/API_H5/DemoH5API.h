//
//  DemoH5API.h
//  H5
//
//  Created by Qingyang on 16/2/25.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoH5API : NSObject
+ (void)demoListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
+ (void)demoCall:(WKWebViewJavascriptBridge *)bridge data:(id)data callback:(H5Callback)callback;
@end
