//
//  WebTaskAPI.h
//  HybridApp
//
//  Created by Qingyang on 16/12/6.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebTaskAPI : NSObject

#pragma mark - 调取web
+ (void)TaskSearchCall:(WKWebViewJavascriptBridge *)bridge
               keyword:(NSString*)keyword
              indus_id:(NSString*)indus_id
                 model:(int)model
            hosted_fee:(int)hosted_fee
                 order:(TaskListSearchOrder)order
                  page:(NSInteger)page pageSize:(int)pageSize
              callback:(void (^)(id bridge, id data, NetError *err))callback;
@end
