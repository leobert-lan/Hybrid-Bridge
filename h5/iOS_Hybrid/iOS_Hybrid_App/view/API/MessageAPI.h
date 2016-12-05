//
//  MessageAPI.h
//  cyy_task
//
//  Created by zhchen on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageAPI : NSObject
+ (void)SystemMessageListType:(NSString *)type offset:(NSInteger)offset success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)NewMessageType:(NSString *)type success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)MessageDeleteId:(NSString *)msgId success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)MessageReadId:(NSString *)msgId success:(void (^)(id))success failure:(void (^)(id))failure;
@end
