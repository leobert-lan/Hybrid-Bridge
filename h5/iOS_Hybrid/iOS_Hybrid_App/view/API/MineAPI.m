//
//  MineAPI.m
//  cyy_task
//
//  Created by zhchen on 16/7/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "MineAPI.h"

@implementation MineAPI
+ (void)myConcernListOffset:(NSInteger)offset success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    if (offset>0) {
        dd[@"offset"]=StrFromInt(offset*kPageSize);
    }
    else {
        dd[@"offset"]=@"0";
    }
    dd[@"limit"]=StrFromInt(kPageSize);
    [HTTPConnecting post:API_MyConcernList params:dd success:^(id responseObj) {
        NSError* err = nil;
        NSMutableArray *arr = [MyConcernModel arrayOfModelsFromDictionaries:responseObj error:&err];
//        DLog(@"%@",responseObj);
        if (success) {
            success (arr);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

+ (void)concernAddObjName:(NSString *)objName success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"obj_name"] = StrFromObj(objName);
    [HTTPConnecting post:Api_MyConcernAdd params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

+ (void)myConcernCancelObjName:(NSString *)objName success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"obj_name"] = StrFromObj(objName);
    [HTTPConnecting post:Api_MyConcernCancel params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark － 修改用户信息
+ (void)mineChangeInfoInfoLab:(NSString *)infoLab info:(NSString *)info success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    [dd setValue:info forKey:infoLab];
    [HTTPConnecting post:API_ChangeInfo params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

+ (void)FeedbackContent:(NSString *)content mobile:(NSString *)mobile file:(NSString *)file success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"content"] = StrFromObj(content);
    dd[@"mobile"] = StrFromObj(mobile);
    dd[@"file"] = StrFromObj(file);
    [HTTPConnecting post:API_Feedback params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
+ (void)IndusGetListsuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    [HTTPConnecting get:API_IndusList params:nil success:^(id responseObj) {
        NSArray *dd = responseObj;
        NSMutableArray *indusArr = [NSMutableArray array];
        for (NSDictionary *dict in dd) {
            NSError* err = nil;
            IndusModel *mm = [[IndusModel alloc] initWithDictionary:dict error:&err];
            if (mm == nil) {
                return ;
            }
            [indusArr addObject:mm];
        }
        if (success) {
            success (indusArr);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];

}

+ (void)RealNAmeQuerysuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"lang"] = @"zh-CN";
    [HTTPConnecting get:API_RealnameQuery params:dd success:^(id responseObj) {
        NSDictionary *dd = responseObj;
        NSError* err = nil;
        RealNameModel *mm = [[RealNameModel  alloc] initWithDictionary:dd error:&err];
        if (success) {
            success (mm);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
+ (void)CompanyAuthQuerysuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"lang"] = @"zh-CN";
    [HTTPConnecting get:API_CompanyAuthQuery params:dd success:^(id responseObj) {
        NSDictionary *dd = responseObj;
        NSError* err = nil;
        CompanyAuthModel *mm = [[CompanyAuthModel  alloc] initWithDictionary:dd error:&err];
        if (success) {
            success (mm);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}


#pragma mark - 绑定手机号
+ (void)PhoneBoundMobile:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(id))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"mobile"] = StrFromObj(mobile);
    NSString *urlType;
    if (StrIsEmpty(QGLOBAL.usermodel.mobile)) {
        urlType = API_PhoneBoundCreat;
    }else{
        urlType = API_PhoneBound;
    }
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

#pragma mark - 地区
+ (void)CityListsuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    [HTTPConnecting get:API_CityList params:nil success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[AuthAreaListModel arrayOfModelsFromDictionaries:responseObj error:&err];
            
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
#pragma mark - 实名认证
+ (void)AuthRealname:(NSString *)realname idCard:(NSString *)idCard idPicPro:(NSString *)idPicPro idPicCon:(NSString *)idPicCon idPicPer:(NSString *)idPicPer validitySTime:(NSString *)validitySTime validityETime:(NSString *)validityETime authArea:(NSString *)authArea type:(int)type success:(void (^)(id model))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"realname"] = StrFromObj(realname);
    dd[@"id_card"] = StrFromObj(idCard);
    dd[@"id_pic"] = StrFromObj(idPicPro);
    dd[@"id_pic_2"] = StrFromObj(idPicCon);
    dd[@"id_pic_3"] = StrFromObj(idPicPer);
    dd[@"auth_area"] = StrFromObj(authArea);
    dd[@"lang"] = @"zh-CN";
    if (type == 1) { // 大陆
        dd[@"validity_s_time"] = StrFromObj(validitySTime);
        dd[@"validity_e_time"] = StrFromObj(validityETime);
    }else if (type == 2){ // 港澳
        dd[@"validity_s_time"] = StrFromObj(validitySTime);
        dd[@"validity_e_time"] = StrFromObj(validityETime);
//        dd[@"auth_area"] = StrFromObj(authArea);
    }else if (type == 3){
        
    }
    [HTTPConnecting post:API_RealnameCreat params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 企业认证
+ (void)AuthCompanyCreateCompany:(NSString *)company licenNum:(NSString *)licenNum licenpic:(NSString *)licenpic legal:(NSString *)legal turnover:(NSString *)turnover startTime:(NSString *)startTime endTime:(NSString *)endTime areaprov:(NSString *)areaprov areacity:(NSString *)areacity areadist:(NSString *)areadist address:(NSString *)address autharea:(NSString *)autharea type:(int)type success:(void (^)(id model))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"company"] = StrFromObj(company);
    dd[@"licen_num"] = StrFromObj(licenNum);
    dd[@"licen_pic"] = StrFromObj(licenpic);
    dd[@"turnover"] = StrFromObj(turnover);
    dd[@"lang"] = @"zh-CN";
    dd[@"auth_area"] = StrFromObj(autharea);
    if (type == 1) {
        
        dd[@"area_prov"] = StrFromObj(areaprov);
        dd[@"area_city"] = StrFromObj(areacity);
        dd[@"area_dist"] = StrFromObj(areadist);
        dd[@"ent_start_time"] = StrFromObj(startTime);
        dd[@"ent_end_time"] = StrFromObj(endTime);
        dd[@"legal"] = StrFromObj(legal);
        dd[@"licen_address"] = StrFromObj(address);
    }else if (type == 2){
        dd[@"area_prov"] = StrFromObj(areaprov);
        dd[@"area_city"] = StrFromObj(areacity);
        dd[@"area_dist"] = StrFromObj(areadist);
        dd[@"legal"] = StrFromObj(legal);
        dd[@"licen_address"] = StrFromObj(address);
    }else if (type == 3){
    }
    [HTTPConnecting post:API_CompanyCreat params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
    
}

#pragma mark - 身份证校验
+ (void)IDcardCheckId:(NSString *)idCard success:(void (^)(id model))success failure:(void (^)(NetError* err))failure
{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"id"] = StrFromObj(idCard);
    dd[@"lang"] = @"zh-CN";
    [HTTPConnecting get:API_IDcardCheck params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
#pragma mark － 订阅
+ (void)SubscripIndusIds:(NSString *)indusIds success:(void (^)(id model))success failure:(void (^)(NetError *err))failure
{
    
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);
    dd[@"indus_id"] = StrFromObj(indusIds);
    [HTTPConnecting post:API_SubscriptionUpdate params:dd success:^(id responseObj) {
        if (success) {
            success (responseObj);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

+ (void)MySubscripListWithSuccess:(void (^)(NSString *indus_id,NSString*indus_name))success failure:(void (^)(NetError *err))failure
{
    
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"username"] = StrFromObj(QGLOBAL.auth.username);

    [HTTPConnecting get:API_SubscriptionList params:dd success:^(id responseObj) {
        if (success) {
            NSString * indus_id;
            NSString * indus_name;
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dd = responseObj;
                indus_id=dd[@"indus_id"];
                indus_name=dd[@"indus_name"];
            }
            success ( indus_id,indus_name);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
@end
