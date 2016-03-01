//
//  GPSH5API.h
//  H5
//
//  Created by Qingyang on 16/2/25.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSH5API : NSObject
+ (void)OpenGpsListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
@end
