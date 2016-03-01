//
//  QRCodeH5API.h
//  H5
//
//  Created by zhchen on 16/2/25.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeH5API : NSObject
+ (void)openCameraListener:(WKWebViewJavascriptBridge *)bridge handler:(H5Listener)handler;
@end
