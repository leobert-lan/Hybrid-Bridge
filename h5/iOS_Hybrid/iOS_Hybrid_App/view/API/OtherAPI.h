//
//  OtherAPI.h
//  cyy_task
//
//  Created by Qingyang on 16/8/26.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OtherModel.h"

/*
 'task' => '任务/需求'
 'service' => '服务'
 'work' => '作品/稿件'
 'user_cert' => '用户认证'
 'space' => '用户资料'
 'agreement' => '合同'
 'resource' => '资源'
 'rc' => '人才库'
 'maker' => '创客空间'
 'copyright' => '版权'
 'default' => '其它'
 */
typedef NS_ENUM(NSInteger, UploadFileType){
    UploadFileTypeDefault = 0,
    UploadFileTypeTask ,
    UploadFileTypeService,
    UploadFileTypeWork,
    UploadFileTypeUserCert,
    UploadFileTypeSpace,
    UploadFileTypeAgreement,
    UploadFileTypeResource,
    UploadFileTypeRC,
    UploadFileTypeMaker,
    UploadFileTypeCopyright,
};

@interface OtherAPI : NSObject
#pragma mark - 搜索类别
/*
可选，跟分类编号
对应com_vsochina_maker数据库tb_industry的root值
indus_pid默认为0，查询所有分类
indus_pid不为空，则查询该分类下的数据
*/
+ (void)getIndustryList:(BOOL)refresh success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;

//数据转换
+ (NSMutableArray *)collItemsFromSubIndustryList:(NSMutableArray*)list canAll:(BOOL)canAll;

+ (void)getIndustryListNew:(BOOL)refresh success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;
#pragma mark - 上传
//上传名字是必须的
+ (void)UploadFile:(id)file name:(NSString*)name success:(void (^)(NSString* path))success failure:(void (^)(NetError *err))failure sendDataBlock:(NCSendDataBlock)sendDataBlock;
//认证专用 文件名必须带常用后缀
+ (void)UploadForAuth:(id)file name:(NSString*)name objtype:(UploadFileType)objtype size:(CGSize)size success:(void (^)(id obj))success failure:(void (^)(NetError *err))failure sendDataBlock:(NCSendDataBlock)sendDataBlock;

#pragma mark - 下载
+ (NSURLSessionDownloadTask *)downloadFileForAuth:(NSString*)fileUrl diskPath:(NSString*)diskPath completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock;
#pragma mark - 跑马灯
+ (void)RollingWithOffset:(int)offset success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;
#pragma mark - 广告
+ (void)BannersWithLimit:(int)limit success:(void (^)(NSMutableArray *arr))success failure:(void (^)(NetError* err))failure;
@end
