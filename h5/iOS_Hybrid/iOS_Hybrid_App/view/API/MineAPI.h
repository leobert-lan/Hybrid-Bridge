//
//  MineAPI.h
//  cyy_task
//
//  Created by zhchen on 16/7/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineAPI : NSObject
+ (void)myConcernListOffset:(NSInteger)offset success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)myConcernCancelObjName:(NSString *)objName success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)mineChangeInfoInfoLab:(NSString *)infoLab info:(NSString *)info success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)FeedbackContent:(NSString *)content mobile:(NSString *)mobile file:(NSString *)file success:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)IndusGetListsuccess:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)RealNAmeQuerysuccess:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)CompanyAuthQuerysuccess:(void (^)(id))success failure:(void (^)(id))failure;
+ (void)concernAddObjName:(NSString *)objName success:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 绑定手机号
+ (void)PhoneBoundMobile:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 地区
+ (void)CityListsuccess:(void (^)(id))success failure:(void (^)(id))failure;
#pragma mark - 实名认证
+ (void)AuthRealname:(NSString *)realname idCard:(NSString *)idCard idPicPro:(NSString *)idPicPro idPicCon:(NSString *)idPicCon idPicPer:(NSString *)idPicPer validitySTime:(NSString *)validitySTime validityETime:(NSString *)validityETime authArea:(NSString *)authArea type:(int)type success:(void (^)(id model))success failure:(void (^)(NetError* err))failure;
#pragma mark - 企业认证
+ (void)AuthCompanyCreateCompany:(NSString *)company licenNum:(NSString *)licenNum licenpic:(NSString *)licenpic legal:(NSString *)legal turnover:(NSString *)turnover startTime:(NSString *)startTime endTime:(NSString *)endTime areaprov:(NSString *)areaprov areacity:(NSString *)areacity areadist:(NSString *)areadist address:(NSString *)address autharea:(NSString *)autharea type:(int)type success:(void (^)(id model))success failure:(void (^)(NetError* err))failure;
#pragma mark - 身份证校验
+ (void)IDcardCheckId:(NSString *)idCard success:(void (^)(id model))success failure:(void (^)(NetError* err))failure;
#pragma mark － 订阅
+ (void)SubscripIndusIds:(NSString *)indusIds success:(void (^)(id model))success failure:(void (^)(NetError *err))failure;
+ (void)MySubscripListWithSuccess:(void (^)(NSString *indus_id,NSString*indus_name))success failure:(void (^)(NetError *err))failure;
@end
