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
@end
