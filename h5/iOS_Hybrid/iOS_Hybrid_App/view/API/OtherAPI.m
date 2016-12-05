//
//  OtherAPI.m
//  cyy_task
//
//  Created by Qingyang on 16/8/26.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "OtherAPI.h"
static CGFloat kTimeOut = 90;

@implementation OtherAPI
#pragma mark - 搜索类别
+ (NSMutableArray *)collItemsFromSubIndustryList:(NSMutableArray*)list canAll:(BOOL)canAll{
    NSMutableArray *tmp= [[NSMutableArray alloc]initWithCapacity:list.count];
    
    for (IndustryModel *mm in list) {
        CollectionItemTypeModel *m1=[CollectionItemTypeModel new];
        m1.title=mm.name;
        m1.oid=mm.oid;
        m1.list=[self collItemsFromSubIndustryList:mm.list canAll:canAll];
        
//        DLog(@"%@",m1.oid);
        //2级行业加“全部”按钮
        if (canAll && mm.lvl.intValue==0) {
            CollectionItemTypeModel *mall=[CollectionItemTypeModel new];
            mall.title=@"全部";
            mall.oid=mm.oid;
            [m1.list insertObject:mall atIndex:0];
        }
        
        
        [tmp addObject:m1];
    }
    return tmp;
}

+ (NSMutableArray *)subIndustryList:(IndustryModel*)mm {
    NSString *where=nil;
    
    if (mm==nil) {
        where=@"lvl = 0";
    }
    else {
        if (mm.lft.integerValue+1>=mm.rgt.integerValue) {
            return nil;
        }
        int lvl=mm.lvl.intValue+1;
        where=[NSString stringWithFormat:@"root = %@ AND lvl = %i AND CAST(lft AS int) >= %@ AND CAST(rgt AS int) <= %@",mm.root,lvl,mm.lft,mm.rgt];
//        where=[NSString stringWithFormat:@"root = %@ AND lvl = %i",mm.root,lvl];
    }
    
    NSMutableArray *tree= [NSMutableArray arrayWithArray:[IndustryModel getModelListFromDBWithWhere:where]];
//    if (mm.lvl.intValue+1==1) {
//        DLog(@">>> %@\n%lu",where,(unsigned long)tree.count);
//    }
//    DLog(@">>> \nwhere %@\n%lu",where,(unsigned long)tree.count);
    for (IndustryModel* mm in tree) {
        mm.list=[self subIndustryList:mm ];
//        DLog(@">>> %@",mm);
    }
    return tree;
}

+ (void)getIndustryList:(BOOL)refresh success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure{
//    DLog(@">>> %li",[IndustryModel getCountFromDBWithWhere:nil]);
    if (!refresh && [IndustryModel getCountFromDBWithWhere:nil]>0) {
        NSMutableArray *tmp=[self subIndustryList:nil];
        if (success) {
            success(tmp);
        }
        else if(failure){
            failure(nil);
        }
        return;
    }
    
    
    [HTTPConnecting get:API_IndustryListII params:nil success:^(id responseObj) {
//                DLog(@">>IndustryListII> %@",responseObj);
        NSError* err = nil;
        if ([responseObj isKindOfClass:[NSArray class]]){
            NSMutableArray *arr=[IndustryModel arrayOfModelsFromDictionaries:responseObj error:&err];
            if (err==nil) {
                [IndustryModel deleteModelFromDB];
                [IndustryModel insertModelListToDB:arr filter:^(id model, BOOL inseted, BOOL *rollback) {
                    
                }];
                DLog(@">>IndustryListII> %@",arr.lastObject);
                NSMutableArray *tmp=[self subIndustryList:nil];
                if (success) {
                    success(tmp);
                }
                else if(failure){
                    failure(nil);
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

+ (void)getIndustryListNew:(BOOL)refresh success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure{

//    if (!refresh && [IndustryModel getCountFromDBWithWhere:nil]>0) {
//        NSMutableArray *tmp=[self subIndustryList:nil];
//        if (success) {
//            success(tmp);
//        }
//        else if(failure){
//            failure(nil);
//        }
//        return;
//    }
    
    
    [HTTPConnecting post:API_IndustryList params:nil success:^(id responseObj) {
                        DLog(@"%@",responseObj);
//        NSError* err = nil;
//        if ([responseObj isKindOfClass:[NSArray class]]){
//            NSMutableArray *arr=[IndustryModel arrayOfModelsFromDictionaries:responseObj error:&err];
//            if (err==nil) {
//                [IndustryModel deleteModelFromDB];
//                [IndustryModel insertModelListToDB:arr filter:^(id model, BOOL inseted, BOOL *rollback) {
//                    NSMutableArray *tmp=[self subIndustryList:nil];
//                    if (success) {
//                        success(tmp);
//                    }
//                    else if(failure){
//                        failure(nil);
//                    }
//                }];
//                
//            }
//            else if(failure){
//                failure(nil);
//            }
//        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 上传
//文件必须有名字，且必须带常用后缀
+ (void)UploadFile:(id)file name:(NSString*)name success:(void (^)(NSString* path))success failure:(void (^)(NetError *err))failure sendDataBlock:(NCSendDataBlock)sendDataBlock{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    dd[@"folder"] = @"/file_tmp/";
    if (StrIsEmpty(name)) {
        NSString *str=[QGLOBAL dateToTimeInterval:[NSDate date]];
        dd[@"name"] = [str MD5];
    }
    else {
        dd[@"name"] = [name MD5];
    }
    
    HttpConnect *conn=HTTPUpload;
    [conn uploadWithPath:API_Upload file:file name:name params:dd success:^(id responseObj) {
//        DLog(@"%@",responseObj);
        if ([QGLOBAL object:responseObj isClass:[NSDictionary class]]) {
            NSDictionary *dd=responseObj;
            if (success) {
                success(dd[@"path"]);
            }
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    } sendDataBlock:sendDataBlock];
}

+ (void)UploadForAuth:(id)file name:(NSString*)name objtype:(UploadFileType)objtype size:(CGSize)size success:(void (^)(id obj))success failure:(void (^)(NetError *err))failure sendDataBlock:(NCSendDataBlock)sendDataBlock{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];

    /*
     可选，语言，默认zh-CN
     zh-CN => 简体中文
     zh-TW => 繁体中文
     en => 英文
     */
    dd[@"username"]=StrFromObj(QGLOBAL.auth.username);
    dd[@"lang"] = @"zh-CN";
  
    switch (objtype) {
        case UploadFileTypeTask:
            dd[@"objtype"] = @"task";
            break;
        case UploadFileTypeService:
            dd[@"objtype"] = @"service";
            break;
        case UploadFileTypeWork:
            dd[@"objtype"] = @"work";
            break;
        case UploadFileTypeUserCert:
            dd[@"objtype"] = @"user_cert";
            break;
        case UploadFileTypeSpace:
            dd[@"objtype"] = @"space";
            break;
        case UploadFileTypeAgreement:
            dd[@"objtype"] = @"agreement";
            break;
        case UploadFileTypeResource:
            dd[@"objtype"] = @"resource";
            break;
        case UploadFileTypeRC:
            dd[@"objtype"] = @"rc";
            break;
        case UploadFileTypeMaker:
            dd[@"objtype"] = @"maker";
            break;
        case UploadFileTypeCopyright:
            dd[@"objtype"] = @"copyright";
            break;
        default:
            dd[@"objtype"] = @"default";
            break;
    }

//    dd[@"access_token"]=StrFromObj(QGLOBAL.auth.access_token);
//    dd[@"access_id"]=StrFromObj(QGLOBAL.auth.access_id);
    dd[@"url"]=StrFromObj(API_UploadForAuth);
    
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        if (size.width && size.height) {
            dd[@"size"]=[NSArray arrayWithObjects:StrFromDouble(size.width),StrFromDouble(size.height), nil];
        }
    }
    HttpConnect *conn=HTTPUpload;
    [conn uploadWithPath:[conn getUrlWithPath:BASE_URL_INNER] file:file name:name params:dd success:^(id responseObj) {
        DLog(@"+++ %@",responseObj);
        NSDictionary *dd=responseObj;
        NSError* err = nil;
        UploadModel *mm = [[UploadModel alloc]  initWithDictionary:dd error:&err];
        if (err==nil && success) {
            success(mm);
        }
        else if (failure) {
            failure(nil);
        }
        
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    } sendDataBlock:sendDataBlock];
}

#pragma mark - 下载
//diskPath 完整路径
+ (NSURLSessionDownloadTask *)downloadFileForAuth:(NSString*)fileUrl diskPath:(NSString*)diskPath completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock{
    HttpConnect *conn=HTTPDownload;
    conn.timeoutInterval = kTimeOut;

    return [conn downloadFile:fileUrl diskPath:diskPath reload:NO completion:completion writeDataBlock:writeDataBlock];
}

//
+ (NSURLSessionDownloadTask *)downloadFileForAuth:(NSString*)fileUrl docFolder:(NSString*)diskPath completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock{
    HttpConnect *conn=HTTPDownload;
    conn.timeoutInterval = kTimeOut;
    return [conn downloadFile:fileUrl docFolder:diskPath reload:NO completion:completion writeDataBlock:writeDataBlock];
}
#pragma mark - 跑马灯
+ (void)RollingWithOffset:(int)offset success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (offset>0) {
        dd[@"offset"]=StrFromInt(offset*kPageSize);
    }
    else {
        dd[@"offset"]=@"0";
    }
    dd[@"limit"]=StrFromInt(kPageSize);
    
    dd[@"lang"] = @"zh-CN";
    [HTTPConnecting get:API_Rolling params:dd success:^(id responseObj) {
        //        DLog(@"%@",responseObj);
        NSError* err = nil;

        NSMutableArray *arr=[TaskSimpleModel arrayOfModelsFromDictionaries:responseObj error:&err];
        if (err==nil) {
            if (success) {
                success(arr);
            }
        }
        else if (failure) {
            failure(nil);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}

#pragma mark - 广告
+ (void)BannersWithLimit:(int)limit success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure{
    NSMutableDictionary *dd=[NSMutableDictionary dictionary];
    if (limit>0) {
        dd[@"limit"]=StrFromInt(limit);
    }
    else {
        dd[@"limit"]=@"3";
    }

    [HTTPConnecting get:API_Banners params:dd success:^(id responseObj) {
//                DLog(@"%@",responseObj);
        NSError* err = nil;
        
        NSMutableArray *arr=[BannerModel arrayOfModelsFromDictionaries:responseObj error:&err];
        if (err==nil) {
            if (success) {
                success(arr);
            }
        }
        else if (failure) {
            failure(nil);
        }
    } failure:^(NetError *err) {
        if (failure) {
            failure(err);
        }
    }];
}
@end
