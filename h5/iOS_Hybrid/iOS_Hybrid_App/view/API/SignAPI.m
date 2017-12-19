//
//  SignAPI.m
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SignAPI.h"

@implementation SignAPI
+ (void)login:(NSString*)username password:(NSString*)password success:(void(^)(AuthModel*  model))success failure:(void(^)(NetError* err))failure{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"name"] = StrFromObj(username);
    dd[@"password"] = StrFromObj(password);

//    NSString *ttt=@"https://api.vsochina.com/user/login/index";//API_Login
    [HTTPConnecting post:API_Login params:dd success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        
        NSDictionary *json=responseObj;
        NSError* err = nil;
        AuthModel* mm = [[AuthModel alloc] initWithDictionary:json error:&err];
        
        [MobClick profileSignInWithPUID:mm.username];
//        mm.access_token = mm.vso_token;
//        mm.loginID = username;
//        QGLOBAL.auth = mm;
        
        if (success) {
            success (mm);
        }
        /*
        avatar = "http://static.vsochina.com/data/avatar/000/00/98/55_avatar_middle.jpg";
        email = "<null>";
        id = 9855;
        isnewpwd = 1;
        logined = 1;
        mobile = "";
        nickname = zhou88;
        password = 9d737aaaec3d78dfa295ead57328e86d;
        status = 1;
        uid = 9855;
        username = zhou88;
        "vso_token" = 36828176ef5c7052da5e023c80a125ba;
        */
//        NSError* err = nil;
//        AuthModel* mm = [[AuthModel alloc] initWithDictionary:responseObj error:&err];
//
//        if (success) {
//            success (mm);
//        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
    
    
//    [HTTPConnecting.httpManager POST:path parameters:dd success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObj) {
//        //                        DLog(@"JSON: %@", responseObject);
//        NSDictionary *json=responseObj;
//        DLog(@"%@",json);
//   
//        if (json[@"ret"] && [json[@"ret"] intValue]==200) {
//            NSError* err = nil;
//            AuthModel* mm = [[AuthModel alloc] initWithDictionary:json error:&err];
//            
//            if (success) {
//                success (mm);
//            }
//        }
//        else if(failure){
//            NetError *err = [[NetError alloc]initWithDomain:@"" code:0 userInfo:nil];
//            if (json[@"message"])
//                err.errMessage=json[@"message"];
//            if (json[@"ret"])
//                err.errStatusCode=[json[@"ret"] intValue];
//            
//            failure(err);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull aError) {
//        NetError *err=nil;
//        if (aError) {
//            err=[[NetError alloc]initWithDomain:aError.domain code:aError.code userInfo:aError.userInfo];
//            
//            NSDictionary *userInfo = [aError userInfo];
//            
//            NSHTTPURLResponse *resp=userInfo[@"com.alamofire.serialization.response.error.response"];
//            err.errMessage=aError.localizedDescription;
//            
//            if (resp) {
//                err.errStatusCode=resp.statusCode;
//            }
//            else {
//                NSError *ee=[userInfo objectForKey:NSUnderlyingErrorKey] ;
//                NSDictionary *uu=[ee userInfo];
//                resp=uu[@"com.alamofire.serialization.response.error.response"];
//                if (resp) {
//                    err.errStatusCode=resp.statusCode;
//                }
//                else
//                    err.errStatusCode=aError.code;
//            }
//        }
//
//        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
//        if (response.statusCode==200) {
//            if (success) {
//                success(nil);
//            }
//        }
//        else {
//            if (failure) {
//                err.errMessage=[err.errDescriptions objectForKey:StrFromInt(err.errStatusCode)];
//                failure(err);
//            }
//        }
//    }];
}

/*
+ (void)login:(NSString*)username password:(NSString*)password success:(void(^)(AuthModel*  model))success failure:(void(^)(NetError* err))failure{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"name"] = StrFromObj(username);
    dd[@"password"] = StrFromObj(password);
    //    dd[@"appkey"] = @"YPMB";
    NSString *path=[NSString stringWithFormat:@"%@",API_Login];
    
    [HTTPConnecting.httpManager POST:path parameters:dd success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObj) {
        //                        DLog(@"JSON: %@", responseObject);
        NSDictionary *json=responseObj;
        DLog(@"%@",json);
        
        if (json[@"ret"] && [json[@"ret"] intValue]==200) {
            NSError* err = nil;
            AuthModel* mm = [[AuthModel alloc] initWithDictionary:json error:&err];
            
            if (success) {
                success (mm);
            }
        }
        else if(failure){
            NetError *err = [[NetError alloc]initWithDomain:@"" code:0 userInfo:nil];
            if (json[@"message"])
                err.errMessage=json[@"message"];
            if (json[@"ret"])
                err.errStatusCode=[json[@"ret"] intValue];
            
            failure(err);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull aError) {
        NetError *err=nil;
        if (aError) {
            err=[[NetError alloc]initWithDomain:aError.domain code:aError.code userInfo:aError.userInfo];
            
            NSDictionary *userInfo = [aError userInfo];
            
            NSHTTPURLResponse *resp=userInfo[@"com.alamofire.serialization.response.error.response"];
            err.errMessage=aError.localizedDescription;
            
            if (resp) {
                err.errStatusCode=resp.statusCode;
            }
            else {
                NSError *ee=[userInfo objectForKey:NSUnderlyingErrorKey] ;
                NSDictionary *uu=[ee userInfo];
                resp=uu[@"com.alamofire.serialization.response.error.response"];
                if (resp) {
                    err.errStatusCode=resp.statusCode;
                }
                else
                    err.errStatusCode=aError.code;
            }
        }
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
        if (response.statusCode==200) {
            if (success) {
                success(nil);
            }
        }
        else {
            if (failure) {
                err.errMessage=[err.errDescriptions objectForKey:StrFromInt(err.errStatusCode)];
                failure(err);
            }
        }
    }];
}
*/
+ (void)logout:(NSString *)uid session:(NSString *)session token:(NSString *)token success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"vso_uid"] = StrFromObj(uid);
    dd[@"vso_sess"] = StrFromObj(session);
    dd[@"vso_token"] = StrFromObj(token);
    [HTTPConnecting post:API_Logout params:dd success:^(id responseObj) {
        //友盟统计用户退出
        [MobClick profileSignOff];
        
        if (success) {
            success (responseObj);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
    }];
}
+ (void)authUsername:(NSString *)username userToken:(NSString *)userToken success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(username);
    dd[@"vso_token"] = StrFromObj(userToken);
    [HTTPConnecting post:API_LoginStatus params:dd success:^(id responseObj) {
        [MobClick profileSignInWithPUID:dd[@"username"]];
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
+ (void)getUserInfoUsername:(NSString *)username success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(username);
    [HTTPConnecting get:API_UserInfo params:dd success:^(id responseObj) {
        NSDictionary *dict = responseObj;
         NSError* err = nil;
        UserModel *mm = [[UserModel alloc] initWithDictionary:dict error:&err];
        DLog(@">>> API_UserInfo:%@",mm);
        if (success) {
            success (mm);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
        
    }];
}

#pragma mark - New
// 获取验证码
+ (void)registerGetValidCodeMobile:(NSString *)mobile action:(NSString *)action success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    NSString *urlType;
    if (StrIsEmpty(QGLOBAL.usermodel.mobile)) {
        urlType = API_Register;
    }else{
        urlType = API_SendValidUsername;
        dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    }
    dd[@"mobile"] = StrFromObj(mobile);
    dd[@"action"] = StrFromObj(action);
    [HTTPConnecting post:urlType params:dd success:^(id responseObj) {
        
        if (success) {
            success (responseObj);
        }
        
        
    } failure:^(NetError *e) {
        if (failure) {
            failure(e);
        }
    }];
}
// 手机号是否可用
+ (void)registerIsMobile:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"mobile"] = StrFromObj(mobile);
    [HTTPConnecting get:API_RegisterIsMobile params:dd success:^(id responseObj) {
        
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
// 验证验证码
+ (void)registerValidCode:(NSString *)validCode mobile:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    NSString *urlType;
    if (StrIsEmpty(QGLOBAL.usermodel.mobile)) {
        urlType = API_RegisterValid_code;
        dd[@"mobile"] = StrFromObj(mobile);
    }else{
        urlType = API_CheckValidUsername;
        dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    }
    
    dd[@"valid_code"] = StrFromObj(validCode);
    [HTTPConnecting post:urlType params:dd success:^(id responseObj) {
        
            if (success) {
                success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
// 注册用户
+ (void)registerUserMobile:(NSString *)mobile password:(NSString *)password success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"mobile"] = StrFromObj(mobile);
    dd[@"password"] = StrFromObj(password);
    [HTTPConnecting post:API_RegisterUser params:dd success:^(id responseObj) {
        
        if (success) {
            success (responseObj);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
// 第三方是否存在
+ (void)thirdIsExist:(NSString *)via openid:(NSString *)openid success :(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"via"] = StrFromObj(via);
    dd[@"openid"] = StrFromObj(openid);
    [HTTPConnecting get:API_ThirdIsExist params:dd success:^(id responseObj) {
        NSDictionary *dd=responseObj;
        DLog(@"%@",dd);
        if (success) {
            success(dd);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
    
}
// 第三方登录
+ (void)thirdLoginVia:(NSString *)via openid:(NSString *)openid success:(void(^)(id model))success failure:(void(^)(id err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"via"] = StrFromObj(via);
    dd[@"openid"] = StrFromObj(openid);
//    dd[@"appkey"] = @"YPMB";
    [HTTPConnecting post:API_ThirdLogin params:dd success:^(id responseObj) {
        NSDictionary *dd=responseObj;
        
        NSError* err = nil;
        AuthModel* mm = [[AuthModel alloc] initWithDictionary:dd error:&err];
//        mm.access_token = mm.vso_token;
        DLog(@"%@",dd);
        if (success) {
            success (mm);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
// 三方登录修改密码
+ (void)thirdLoginChangePwdUserName:(NSString *)username pwd:(NSString *)pwd success:(void(^)(id model))success failure:(void(^)(id err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(username);
    dd[@"password"] = StrFromObj(pwd);
    [HTTPConnecting post:API_ThirdLoginChangePwd params:dd success:^(id responseObj) {
       
        if (success) {
            success(responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
// 忘记密码
+ (void)ForgotPwdUserName:(NSString *)username pwd:(NSString *)pwd success:(void(^)(id model))success failure:(void(^)(id err))failure
{
    DLog(@"%@",StrFromObj(username));
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"name"] = StrFromObj(username);
    dd[@"password"] = StrFromObj(pwd);
    [HTTPConnecting post:API_ForgotPwd params:dd success:^(id responseObj) {
        
        if (success) {
            success(responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
// 修改密码
+ (void)changePwd:(NSString *)username oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd success:(void(^)(id model))success failure:(void(^)(id err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(username);
    dd[@"old_password"] = StrFromObj(oldPwd);
    dd[@"new_password"] = StrFromObj(newPwd);
    [HTTPConnecting post:API_ChangePwd params:dd success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
@end
