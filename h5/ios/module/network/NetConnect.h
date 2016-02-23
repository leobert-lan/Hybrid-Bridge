//
//  NetConnect.h
//  resource
//
//  Created by Yan Qingyang on 15/10/23.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NetError.h"
//#define  NetConnecting [NetConnect sharedInstance]

//@protocol NetConnectDelegate;
//
//@protocol NetConnectDelegate <NSObject>
//@optional
//- (void)NetConnectDelegate:(id)obj fractionCompleted:(double)fractionCompleted;
//@end
typedef void (^NCSendDataBlock)(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
typedef void (^NCDownloadDataBlock)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
//typedef void (^NetConnectBlock)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes);
//
//typedef void (^NCCompletion)(NSURLResponse *response, id responseObject, NSError *error);

@interface NetConnect : NSObject
//单例
+ (instancetype)sharedInstance;

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, readwrite) NSString * baseUrl;

//@property (nonatomic, strong) NSData *resumeData;
//@property (nonatomic, strong) NSURLSessionDownloadTask *taskDownload;

- (id)initWithDelegate:(id)delegate;
- (id)initWithBaseUrl:(NSString *)baseUrl delegate:(id)delegate;

//head cookie设置
- (void)HTTPInit;
//重写参数方法，可以添加固定参数如 access token这种
- (NSDictionary *)checkParams:(NSDictionary *)dict;
#pragma mark - URL schema
- (NSString *)getUrlWithPath:(NSString *)path;

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure;
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure;
- (void)delete:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure;

//request
- (void)requestWithPath:(NSString *)path params:(NSDictionary *)params method:(NSString *)method progressEnabled:(BOOL)pEnabled success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure;
#pragma mark - 错误处理
- (NetError*)checkError:(NSError*)error;
#pragma mark - NSURLSessionTask
- (void)taskStop:(id)task;
#pragma mark - 上传/下载 不要用单例模式
- (NSURLSessionDownloadTask*)downloadFile:(NSString*)fileUrl docFolder:(NSString*)docFolder reload:(BOOL)reload completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock;
- (NSURLSessionDownloadTask *)downloadFile:(NSString*)fileUrl docFolder:(NSString*)docFolder saveName:(NSString*)saveName reload:(BOOL)reload completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock;
- (NSURLSessionDownloadTask *)downloadFile:(NSString*)fileUrl diskPath:(NSString*)diskPath reload:(BOOL)reload completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock;
//*  暂停
- (NSURLSessionDownloadTask *)downloadFilePause:(NSURLSessionDownloadTask *)task completion:(void (^)(NSURLSessionDownloadTask *downloadTask, NSData *resumeData))completion;
// *  恢复（继续）
- (NSURLSessionDownloadTask*)downloadFileResumeData:(NSData *)resumeData toPath:(NSString *)dstPath completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock;
//*  停
- (NSURLSessionDownloadTask *)downloadFileCancel:(NSURLSessionDownloadTask *)task;

//上传数据
- (NSURLSessionUploadTask*)upload:(NSString*)url file:(NSData*)file parameters:(id)parameters completion:(void (^)(NSURLResponse *response, id responseObject, NetError* err))completion sendDataBlock:(NCSendDataBlock)sendDataBlock;
@end
