//
//  MessageAPI.m
//  cyy_task
//
//  Created by zhchen on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "MessageAPI.h"

@implementation MessageAPI
+ (void)SystemMessageListType:(NSString *)type offset:(NSInteger)offset success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
//    dd[@"limit"] = StrFromInt(limit);
    //可选，每页返回多少条数据
    if (offset>0) {
        dd[@"offset"]=StrFromInt(offset*kPageSize);
    }
    else {
        dd[@"offset"]=@"0";
    }
    dd[@"msg_type"] = StrFromObj(type);
    dd[@"limit"]=StrFromInt(kPageSize);
    [HTTPConnecting post:API_SysMessageList params:dd success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        NSError* err = nil;
        NSMutableArray *arr = [SysMessagesModel arrayOfModelsFromDictionaries:responseObj error:&err];
        if (success) {
            success (arr);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
+ (void)NewMessageType:(NSString *)type success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    [HTTPConnecting get:API_NemMessage params:dd success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        NSDictionary *dd = responseObj;
        NSError* err = nil;
        NSDictionary *ListDic = [NSDictionary dictionary];
        if ([type isEqualToString:@"system"]) {
            ListDic = dd[@"system"];
            MessageSysModel* mm = [[MessageSysModel alloc] initWithDictionary:ListDic error:&err];
            if (success) {
                success (mm);
            }
        }else if ([type isEqualToString:@"appmsg"]){
            ListDic = dd[@"appmsg"];
            MessageInformModel* mm = [[MessageInformModel alloc] initWithDictionary:ListDic error:&err];
            if (success) {
                success (mm);
            }
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

+ (void)MessageDeleteId:(NSString *)msgId success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"id"] = StrFromObj(msgId);
    [HTTPConnecting get:API_MessageDelete params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
+ (void)MessageReadId:(NSString *)msgId success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"id"] = StrFromObj(msgId);
    [HTTPConnecting get:API_MessageRead params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
@end
