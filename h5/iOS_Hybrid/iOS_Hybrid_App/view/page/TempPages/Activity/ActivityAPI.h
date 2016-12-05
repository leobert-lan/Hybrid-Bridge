//
//  ActivityAPI.h
//  cyy_task
//
//  Created by Qingyang on 16/11/14.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityCmtModel.h"

#pragma mark - 1020 临时活动
#define API_ActivityCreatComment            @"activity/app-req-comment/create"
#define API_ActivityCommentList             @"activity/app-req-comment/list-ranking"
#define API_ActivityZanComment              @"activity/app-req-comment/zan"
#define API_ActivityAlreadyComment          @"activity/app-req-comment/is-already-signed"
#define API_ActivityTime                    @"activity/app-req-comment/time"

@interface ActivityAPI : NSObject
#pragma mark - 发表评论
+ (void)ActivityCreatCommentContent:(NSString *)content Success:(void (^)(id model))success failure:(void (^)(NetError* err))failure;

+ (void)ActivityCmtListWithOffset:(NSInteger)offset success:(void (^)(NSMutableArray* list))success failure:(void (^)(NetError* err))failure;

+ (void)ActivityCmtByUser:(NSString*)username success:(void (^)(ActivityCmtModel* model))success failure:(void (^)(NetError* err))failure;

+ (void)ActivityZanCmtID:(NSString*)oid success:(void (^)(BOOL success))success failure:(void (^)(NetError* err))failure;
+ (void)ActivityTimeWithSuccess:(void (^)(NSString* start,NSString* end))success failure:(void (^)(NetError* err))failure;
@end
