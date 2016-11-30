//
//  SignAPI.h
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignAPI : NSObject
+ (void)login:(NSString*)username password:(NSString*)password success:(void(^)(AuthModel*  model))success failure:(void(^)(NetError* err))failure;
+ (void)logout:(NSString *)uid session:(NSString *)session token:(NSString *)token success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)authUsername:(NSString *)username userToken:(NSString *)userToken success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)getUserInfoUsername:(NSString *)username success:(void (^)(id))success failure:(void (^)(id))failure;
// 获取验证码
+ (void)registerGetValidCodeMobile:(NSString *)mobile action:(NSString *)action success:(void (^)(id))success failure:(void (^)(id))failure;
// 手机号是否可用
+ (void)registerIsMobile:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(id))failure;
// 验证验证码
+ (void)registerValidCode:(NSString *)validCode mobile:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(id))failure;
// 注册用户
+ (void)registerUserMobile:(NSString *)mobile password:(NSString *)password success:(void (^)(id))success failure:(void (^)(id))failure;
// 三方信息是否存在
+ (void)thirdIsExist:(NSString *)via openid:(NSString *)openid success:(void(^)(id model))success failure:(void(^)(id err))failure;
// 第三方登录
+ (void)thirdLoginVia:(NSString *)via openid:(NSString *)openid success:(void(^)(id model))success failure:(void(^)(id err))failure;
// 三方登录修改密码
+ (void)thirdLoginChangePwdUserName:(NSString *)username pwd:(NSString *)pwd success:(void(^)(id model))success failure:(void(^)(id err))failure;
+ (void)ForgotPwdUserName:(NSString *)username pwd:(NSString *)pwd success:(void(^)(id model))success failure:(void(^)(id err))failure;
// 修改密码
+ (void)changePwd:(NSString *)username oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd success:(void(^)(id model))success failure:(void(^)(id err))failure;
@end
