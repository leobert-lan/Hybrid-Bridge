//
//  HttpConnect.m
//  resource
//
//  Created by Yan Qingyang on 15/11/9.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "HttpConnect.h"
//#import "NetConnect.h"

@implementation HttpConnect
+ (id)sharedInstance
{
    InstanceByBlock(^{
        return [[self alloc] init];
    });
}

+ (instancetype)aInstance{
    return [[self alloc] init];
}
//需要设置head或者cookie的，需要重写
- (void)HTTPInit{
    [super HTTPInit];
    
    NSString *userAgent=[NSString stringWithFormat:@"VSO-Task-iOS/%@ (iOS %@)",VERSION,OS_VERSION];
    [self.httpManager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
}

- (NSDictionary *)checkParams:(NSDictionary *)dict{
    NSMutableDictionary *dd=[[NSMutableDictionary alloc]initWithDictionary:dict copyItems:YES];
//    if (!StrIsEmpty(QGLOBAL.auth.access_token))
//        dd[@"access_token"]=StrFromObj(QGLOBAL.auth.access_token);
//    if (!StrIsEmpty(QGLOBAL.auth.access_id))
//        dd[@"access_id"]=StrFromObj(QGLOBAL.auth.access_id);
    
    //临时app id
//    dd[@"token"]=StrFromObj(QGLOBAL.auth.access_token);
//    dd[@"appid"]=StrFromObj(QGLOBAL.auth.access_id);
    
    return dd;
}

- (NetError*)checkError:(id)error{
    NetError* err=[super checkError:error];
    

    switch (err.errStatusCode) {
        case 9004:
        case 9005:
        case 9008:
        case 9009:
        case 9014:    
        case 401:
        {
            //登录失效
            if (QGLOBAL.auth!=nil) {
                UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"您的登录已过期!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alt show];
            }
            
            
            [QGLOBAL logout];
        }
            break;
        case 0:
        case -1:
        case -1000:
        case -1001:
        case -1009:
        case -1002:
        case -1003:
        case -1004:
        case -1005:
        case -1006:
        case -1007:
        case -1008:
        case -1010:
        case -1011:
        case -1012:
        case -1013:
        case -1014:
        case -1015:
        case -1016:
        case -1017:
        case -1018:
        case -1019:
        case -1020:
        case -1021:
        case -1100:
        case -1101:
        case -1102:
        case -1200:
        case -1201:
        case -1202:
        case -1203:
        case -1204:
        case -1205:
        case -1206:
        case -2000:
        case -3000:
        case -3001:
        case -3002:
        case -3003:
        case -3004:
        case -3005:
        case -3006:
        case -3007:{
            err.errMessage=[err.errDescriptions objectForKey:StrFromInt(err.errStatusCode)];
        }
            break;
        default:
            break;
    }
    
    return err;
}

/*
- (void)checkResponse:(id)responseObj success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure{
    if ([QGLOBAL object:responseObj isClass:[NSDictionary class]]) {
        NSDictionary *dd=responseObj;
        if (dd[@"ret"] != nil) {
            if ([dd[@"ret"] intValue]==0) {
                if (success) {
                    success(responseObj);
                }
            }
            else {
                if (failure) {
                    NetError *err=[[NetError alloc]initWithDomain:@"" code:0 userInfo:nil];
                    if (dd[@"message"])
                        err.errMessage=dd[@"message"];
                    if (dd[@"ret"])
                        err.errStatusCode=[dd[@"ret"] intValue];
                    
                    failure(err);
                }
            }
            
        }
        else  {
            //老接口无ret返回
            if (success)
                success(responseObj);
        }
    }
    else {
        //老接口无数据返回
        if (success)
            success(responseObj);
    }
}
*/

- (void)checkResponse:(id)responseObj success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure{
    if (kResponsePrintEnabled) {
        DLog(@"\n**** responseObj ****\n%@\n************",responseObj);
    }
    
    if ([QGLOBAL object:responseObj isClass:[NSDictionary class]]) {
        NSDictionary *dd=responseObj;
        if (dd[@"status"] != nil) {
            if ([dd[@"status"] intValue]==1) {
                if (success) {
                    if (dd[@"data"] != nil) {
                        success(dd[@"data"]);
                    }
                    else {
                        success(responseObj);
                    }
                }
                
                
            }
            else {
                if (failure) {
                    NetError *err=[[NetError alloc]initWithDomain:@"" code:0 userInfo:nil];
                    if (dd[@"message"])
                        err.errMessage=dd[@"message"];
                    if (dd[@"ret"])
                        err.errStatusCode=[dd[@"ret"] integerValue];
                    
                    failure([self checkError:err]);
                }
            }
            
        }
        else  {
            //老接口无ret返回
            if (success)
                success(responseObj);
        }
    }
    else {
        //老接口无数据返回
        if (success)
            success(responseObj);
    }
}

//- (NSString *)getUrlWithPath:(NSString *)path{
//    NSString *url=[super getUrlWithPath:path];
//    if (QGLOBAL.auth.access_token && QGLOBAL.auth.access_id)
//        url=[NSString stringWithFormat:@"%@?access_token=%@&access_id=%@",url,StrFromObj(QGLOBAL.auth.access_token),QGLOBAL.auth.access_id];
//    return url;
//}

#pragma mark - 针对CURL封装
- (NSDictionary *)checkParams:(NSDictionary *)dict url:(NSString *)url{
    NSMutableDictionary *dd=[[NSMutableDictionary alloc]initWithDictionary:dict copyItems:YES];
    if (!StrIsEmpty(QGLOBAL.auth.vso_token))
        dd[@"auth_token"]=StrFromObj(QGLOBAL.auth.vso_token);
    if (!StrIsEmpty(QGLOBAL.auth.username))
        dd[@"auth_username"]=StrFromObj(QGLOBAL.auth.username);
    if (!StrIsEmpty(url))
        dd[@"url"]=StrFromObj(url);
   
    //临时添加
//    dd[@"from"]=@"iOS";//[NSString stringWithFormat:@"VSO-Task-iOS/%@ (iOS %@)",VERSION,OS_VERSION];
    
    return dd;
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure
{
    params = [self checkParams:params url:url];
    [self requestWithPath:[self getUrlWithPath:BASE_URL_INNER] params:params method:@"GET" progressEnabled:NO  success:^(id responseObj) {
        success (responseObj);
    } failure:^(NetError* err) {
        failure(err);
    }];
    //    self.progressEnabled=YES;
    //    [self get:url params:params progressEnabled:YES success:success failure:failure];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure
{
    params = [self checkParams:params url:url];
//    [self getUrlWithPath:BASE_URL_INNER]
    [self requestWithPath:[self getUrlWithPath:BASE_URL_INNER] params:params method:@"POST" progressEnabled:NO success:^(id responseObj) {
        success (responseObj);
    } failure:^(NetError* err) {
        failure(err);
    }];
    
}
@end
