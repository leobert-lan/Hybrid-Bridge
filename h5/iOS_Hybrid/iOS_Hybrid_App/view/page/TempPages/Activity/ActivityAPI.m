//
//  ActivityAPI.m
//  cyy_task
//
//  Created by Qingyang on 16/11/14.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ActivityAPI.h"

@implementation ActivityAPI
#pragma mark - 发表评论
+ (void)ActivityCreatCommentContent:(NSString *)content Success:(void (^)(id model))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"content"] = StrFromObj(content);
    dd[@"lang"] = @"zh-CN";
    [HTTPConnecting post:API_ActivityCreatComment params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError* err) {
        if (failure) {
            failure(err);
        }
    }];
}

+ (void)ActivityCmtListWithOffset:(NSInteger)offset success:(void (^)(NSMutableArray* list))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (!StrIsEmpty(QGLOBAL.auth.username))
        dd[@"username"] = StrFromObj(QGLOBAL.auth.username);

    //可选，每页返回多少条数据
    if (offset>0) {
        dd[@"offset"]=StrFromInt(offset*kPageSize);
    }
    else {
        dd[@"offset"]=@"0";
    }
    dd[@"limit"]=StrFromInt(kPageSize);
    [HTTPConnecting get:API_ActivityCommentList params:dd success:^(id responseObj) {
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            
            NSMutableArray *arr=[ActivityCmtModel arrayOfModelsFromDictionaries:responseObj error:&err];
            
            if (err==nil) {
                if (success) {
                    success (arr);
                }
            }
            else if(failure){
                failure(nil);
            }
            
        }

    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}


+ (void)ActivityCmtByUser:(NSString*)username success:(void (^)(ActivityCmtModel* model))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (!StrIsEmpty(username))
        dd[@"username"] = StrFromObj(username);
    else if(failure){
        failure(nil);
        return;
    }
   
    [HTTPConnecting get:API_ActivityAlreadyComment params:dd success:^(id responseObj) {
        NSDictionary *dict = responseObj;
        //        DLog(@"%@",dict);
        NSError* err = nil;
        ActivityCmtModel *mm = [[ActivityCmtModel alloc] initWithDictionary:dict error:&err];
        if (err==nil) {
            if (success) {
                success (mm);
            }
        }
        else if(failure){
            failure(nil);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

+ (void)ActivityZanCmtID:(NSString*)oid success:(void (^)(BOOL success))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (StrIsEmpty(QGLOBAL.auth.username) || StrIsEmpty(oid))
    {
        if(failure){
            failure(nil);
            return;
        }
    }
    
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"id"] = StrFromObj(oid);
    
    [HTTPConnecting post:API_ActivityZanComment params:dd success:^(id responseObj) {
        if (success) {
            success (YES);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}


+ (void)ActivityTimeWithSuccess:(void (^)(NSString* start,NSString* end))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=nil;
    
    [HTTPConnecting get:API_ActivityTime params:dd success:^(id responseObj) {
        NSDictionary *dict = responseObj;
        if (StrIsEmpty(dict[@"start"])||StrIsEmpty(dict[@"end"])) {
            if (failure) {
                failure(nil);
            }
            return ;
        }
        NSString *st=dict[@"start"];
        NSString *et=dict[@"end"];
        
        st = [st stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        et = [et stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        if (success) {
            success (st,et);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

@end
