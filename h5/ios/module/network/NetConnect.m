//
//  NetConnect.m
//  resource
//
//  Created by Yan Qingyang on 15/10/23.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "NetConnect.h"
#import "FileManager.h"

@interface NetConnect(){
    //    NSProgress *progress;
}

//@property (nonatomic, strong) AFURLSessionManager  *urlManager;
@end

@implementation NetConnect
+ (instancetype)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)dealloc{
    self.httpManager=nil;
}

- (id)init
{
    if (self == [super init]) {
        //        self.progressEnabled=YES;
        //        _touchCancle = YES;
        //        [QWLoading instanceWithDelegate:self];
        //        _baseUrl=[[NSString alloc] init];
        [self AFManagerInit];
        return self;
    }
    return nil;
}

- (id)initWithDelegate:(id)delegate
{
    if (self == [self init]) {
        
        self.delegate=delegate;
        return self;
    }
    return nil;
}

- (id)initWithBaseUrl:(NSString *)baseUrl delegate:(id)delegate
{
    if (self == [self initWithDelegate:delegate]) {
        self.baseUrl=baseUrl;
        return self;
    }
    return nil;
}

- (void)setBaseUrl:(NSString *)baseUrl
{
    _baseUrl = baseUrl;
    
    //    [self AFManagerInit];
}

- (void)AFManagerInit{
    if (_httpManager) {
        _httpManager=nil;
    }
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
    _httpManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];//设置相应内容类型
    //    _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];//请求json格式
    _httpManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[ @"GET"]];
    _httpManager.requestSerializer.timeoutInterval = 10;
    
    [self HTTPInit];
}

- (AFHTTPSessionManager *)creatHttpManager{
    
    AFHTTPSessionManager *http;
    
    if (_httpManager) {
        http = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:_httpManager.session.configuration];
        http.responseSerializer=_httpManager.responseSerializer;
        http.requestSerializer=_httpManager.requestSerializer;
        
    }
    else {
        //        http.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
        
    }
    
    
    return http;
}

- (void)HTTPInit{
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    _httpManager.session.configuration=configuration;
}

- (NSString*)urlEncode:(id<NSObject>)value
{
    //make sure param is a string
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [(NSNumber*)value stringValue];
    }
    
    NSAssert([value isKindOfClass:[NSString class]], @"request parameters can be only of NSString or NSNumber classes. '%@' is of class %@.", value, [value class]);
    
    return (__bridge_transfer  NSString *)(CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (__bridge CFStringRef) value,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8));
}

#pragma mark - 错误处理
- (NetError*)checkError:(NSError*)aError{
    NetError *err=nil;
    if (aError) {
        err=[[NetError alloc]initWithDomain:aError.domain code:aError.code userInfo:aError.userInfo];
//        [err errDescriptionsInit];
        
        NSDictionary *userInfo = [aError userInfo];
        
        NSHTTPURLResponse *resp=userInfo[@"com.alamofire.serialization.response.error.response"];
        err.errMessage=aError.localizedDescription;
        //    DLog(@"%@\n\nee:%ld",resp,resp.statusCode);
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
    else {
        
    }
    
    return err;
}
#pragma mark - request

- (void)requestWithPath:(NSString *)path params:(NSDictionary *)params method:(NSString *)method progressEnabled:(BOOL)pEnabled success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure{
    if (_timeoutInterval>=5) {
        _httpManager.requestSerializer.timeoutInterval=_timeoutInterval;
    }
    
    //    DLog(@"HTTPRequestHeaders:%@",_httpManager.requestSerializer.HTTPRequestHeaders);
    DLog(@"\n---:%@\n+++:%@",path,params);
    //    if (pEnabled) {
    //
    //    }
    if([method isEqualToString:@"GET"]){
        [_httpManager GET:path parameters:params success:^(NSURLSessionTask *task, id responseObject) {
            //            DLog(@"JSON-%@: %@", [responseObject class],responseObject);
            if (success) {
                success(responseObject);
            }
            
            
        } failure:^(NSURLSessionTask *task, NSError *error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            if (response.statusCode==200) {
                //                DLog(@"成功");
                if (success) {
                    success(nil);
                }
            }
            else {
                NetError *ne=[self checkError:error];
                if (failure) {
                    failure(ne);
                }
            }
        }];
    }
    else if([method isEqualToString:@"POST"]){
        [_httpManager POST:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //                        DLog(@"JSON: %@", responseObject);
            if (success) {
                success(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //                        DLog(@"Error: %@", error);
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            if (response.statusCode==200) {
                //                DLog(@"成功");
                if (success) {
                    success(nil);
                }
            }
            else {
                NetError *ne=[self checkError:error];
                if (failure) {
                    failure(ne);
                }
            }
        }];
    }
    else if([method isEqualToString:@"PUT"]){
        [_httpManager POST:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (success) {
                success(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //                        DLog(@"Error: %@", error);
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            if (response.statusCode==200) {
                //                DLog(@"成功");
                if (success) {
                    success(nil);
                }
            }
            else {
                NetError *ne=[self checkError:error];
                if (failure) {
                    failure(ne);
                }
            }
        }];
    }
    else if([method isEqualToString:@"DELETE"]){
        [_httpManager DELETE:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (success) {
                success(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //                        DLog(@"Error: %@", error);
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            if (response.statusCode==200) {
                //                DLog(@"成功");
                if (success) {
                    success(nil);
                }
            }
            else {
                NetError *ne=[self checkError:error];
                if (failure) {
                    failure(ne);
                }
            }
        }];
    }
}

- (void)postWithPath:(NSString *)path params:(NSDictionary *)params filePath:(NSString*)filePath fileName:(NSString *)fileName success:(void(^)(id responseObj))success failure:(void(^)(id))failure{
    //    DLog(@"\n---:%@\n+++:%@",path,params);
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    [_httpManager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:fileURL name:fileName error:nil];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //        DLog(@"JSON: %@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"Error: %@", error);
        if (failure) {
            failure([self checkError:error]);
        }
    }];
}

- (NSDictionary *)checkParams:(NSDictionary *)dict{
    return dict;
}

#pragma mark upload
- (void)uploadWithPath:(NSString *)path params:(NSDictionary *)params method:(NSString *)method progressEnabled:(BOOL)pEnabled
               success:(void(^)(id responseObj))success failure:(void(^)(id))failure{
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"myimage.jpg"], 1.0);
    
    [_httpManager POST:@"http://myurl.com" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"attachment" fileName:@"myimage.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        //        DLog(@"Success %@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Failure %@, %@", error, [task.response description]);
        if (failure) {
            failure([self checkError:error]);
        }
    }];
}

#pragma mark - URL schema
- (NSString *)getUrlWithPath:(NSString *)path
{
    //    if ([_requestType isEqualToString:@"https"]) {
    //        if ([self.baseUrl hasPrefix:@"http://"]) {
    //            self.baseUrl =  [self.baseUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    //        }
    //
    //    }
    NSString * urlString = nil;
    if (StrIsEmpty(self.baseUrl)) {
        urlString=path;
    }
    else
        [NSString stringWithFormat:@"%@%@", self.baseUrl, path];
    
    return urlString;
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure
{
    params = [self checkParams:params];
    [self requestWithPath:[self getUrlWithPath:url] params:params method:@"GET" progressEnabled:NO  success:^(id responseObj) {
        success (responseObj);
    } failure:^(NetError* err) {
        failure(err);
    }];
    //    self.progressEnabled=YES;
    //    [self get:url params:params progressEnabled:YES success:success failure:failure];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure
{
    //    DLog(@"%@",[self urlWithPath:url]);
    params = [self checkParams:params];
    
    [self requestWithPath:[self getUrlWithPath:url] params:params method:@"POST" progressEnabled:NO  success:^(id responseObj) {
        success (responseObj);
    } failure:^(NetError* err) {
        failure(err);
    }];
    
}

- (void)delete:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure
{
    
    params = [self checkParams:params];
    
    [self requestWithPath:[self getUrlWithPath:url] params:params method:@"DELETE" progressEnabled:NO  success:^(id responseObj) {
        success (responseObj);
    } failure:^(NetError* err) {
        failure(err);
    }];
    
}

- (void)getWithLoading:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure
{
    params = [self checkParams:params];
    [self requestWithPath:[self getUrlWithPath:url] params:params method:@"GET" progressEnabled:YES  success:^(id responseObj) {
        success (responseObj);
    } failure:^(NetError* err) {
        failure(err);
    }];
}

- (void)postWithProgress:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NetError* err))failure
{
    params = [self checkParams:params];
    
    [self requestWithPath:[self getUrlWithPath:url] params:params method:@"POST" progressEnabled:YES  success:^(id responseObj) {
        success (responseObj);
    } failure:^(NetError* err) {
        failure(err);
    }];
    
}

#pragma mark - stop
- (void)taskStop:(id)task{
    if (task && [task isKindOfClass:[NSURLSessionTask class]]) {
        NSURLSessionTask* tt=task;
        [tt cancel];
    }
}
#pragma mark - 下载
- (NSURLSessionDownloadTask *)downloadFile:(NSString*)fileUrl diskPath:(NSString*)diskPath reload:(BOOL)reload completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock{
    //不用单例模式，要释放内存
    __block AFHTTPSessionManager *http = [self creatHttpManager];
    if (_timeoutInterval>=5) {
        http.requestSerializer.timeoutInterval=_timeoutInterval;
    }
    
    __block NSString *_filePath = diskPath;
    if (StrIsEmpty(diskPath)) {
        //文件夹名不为空放docm，否则放cache
        NSString *docPath = [FileManager getCachePath];
        NSString *fName = [fileUrl fileNameOfURL];
        if (fName==nil) {
            fName=[fileUrl MD5];
        }
        _filePath=[NSString stringWithFormat:@"%@/%@", docPath, fName];;
    }
    
    //检查附件是否存在
    if (reload == NO && [FileManager isExist:_filePath]) {
        if (completion)
            completion(nil,_filePath,nil);
        http=nil;
        return nil;
    }
    
    NSURL *URL = [NSURL URLWithString:fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *task = [http downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response){
        //        DLog(@"%@\n\n%@",targetPath,response    );
        //删掉原文件，否则新下载不覆盖
        [FileManager deletePath:_filePath];
        NSURL *fp = [NSURL fileURLWithPath:_filePath];
        return fp;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completion) {
            Dispatch_Main_Sync(completion(response,_filePath,[self checkError:error]));
        }
        http=nil;
    }];
    
    [task resume];
    
    //跟踪下载数据
    [http setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        //        DLog(@"%lli %lli %lli",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        //        NSLog(@"%f / %f", (double)totalBytesWritten, (double)totalBytesExpectedToWrite);
        if (writeDataBlock) {
            Dispatch_Main_Sync(writeDataBlock(session,downloadTask,bytesWritten,totalBytesWritten,totalBytesExpectedToWrite));
        }
    }];
    
    return task;
}
//下载文件到docm
- (NSURLSessionDownloadTask *)downloadFile:(NSString*)fileUrl docFolder:(NSString*)docFolder saveName:(NSString*)saveName reload:(BOOL)reload completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock
{
    //如果save名字不为空，文件名字为save名字，否则从url里获取对应名字
    NSString *name;
    if (!StrIsEmpty(saveName)) {
        name=saveName;
    }
    else {
        //获取url上的文件名字，如果‘/’结尾的的就把url地址md5化
        NSString *fName = [fileUrl fileNameOfURL];
        if (fName==nil) {
            fName=[fileUrl MD5];
        }
        name=fName;
    }
    
    //文件夹名不为空放docm，否则放cache
    NSString *docPath = [FileManager getCachePath];
    if (!StrIsEmpty(docFolder)) {
        docPath=[FileManager getDocumentsDirectory:docFolder];
    }
    
    __block NSString *_filePath = [NSString stringWithFormat:@"%@/%@", docPath, name];
    
    return [self downloadFile:fileUrl diskPath:_filePath reload:reload completion:completion writeDataBlock:writeDataBlock];
    
}

- (NSURLSessionDownloadTask*)downloadFile:(NSString*)fileUrl docFolder:(NSString*)docFolder reload:(BOOL)reload completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock{
    return [self downloadFile:fileUrl docFolder:docFolder saveName:nil reload:reload completion:completion writeDataBlock:writeDataBlock];
}

// *  恢复（继续）
- (NSURLSessionDownloadTask*)downloadFileResumeData:(NSData *)resumeData toPath:(NSString *)dstPath completion:(void (^)(NSURLResponse *response, NSString *filePath, NetError* err))completion writeDataBlock:(NCDownloadDataBlock)writeDataBlock
{
    if (resumeData==nil) {
        return nil;
    }
    
    __block AFHTTPSessionManager *http = [self creatHttpManager];
    if (_timeoutInterval>=5) {
        http.requestSerializer.timeoutInterval=_timeoutInterval;
    }
    
    // 传入上次暂停下载返回的数据，就可以恢复下载
    NSURLSessionDownloadTask *task = [http downloadTaskWithResumeData:resumeData progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //获取下载后的临时数据文件
        NSString *tmpFile = [NSString stringWithFormat:@"%@%@", [FileManager getTmpPath], targetPath.absoluteString.lastPathComponent];
        //删除老文件
        [FileManager deletePath:dstPath];
        //把下载完成的文件拷贝到目标文件夹
        [FileManager moveItemAtPath:tmpFile toPath:dstPath];
        return [NSURL URLWithString:dstPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completion) {
            completion(response,filePath.absoluteString,[self checkError:error]);
        }
        
        http=nil;
    }];
    
    
    // 开始任务
    [task resume];
    
    //跟踪下载数据
    [http setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if (writeDataBlock) {
            writeDataBlock(session,downloadTask,bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
    
    // 清空
    resumeData = nil;
    //    _taskDownload=task;
    return task;
}

//*  暂停
- (NSURLSessionDownloadTask *)downloadFilePause:(NSURLSessionDownloadTask *)task completion:(void (^)(NSURLSessionDownloadTask *downloadTask, NSData *resumeData))completion
{
    if (task == nil) return nil;
    
    [task cancelByProducingResumeData:^(NSData *resumeData) {
        //  resumeData : 包含了继续下载的开始位置\下载的url
        if (completion) {
            completion(task,resumeData);
        }
    }];
    return nil;
}

//*  停
- (NSURLSessionDownloadTask *)downloadFileCancel:(NSURLSessionDownloadTask *)task
{
    if (task == nil) return nil;
    
    [task cancel];
    return nil;
}

#pragma mark -
- (NSURLSessionDataTask*)stream{
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *task = [_httpManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            DLog(@"Error: %@", error);
        } else {
            DLog(@"%@ %@", response, responseObject);
        }
    }];
    [task resume];
    return task;
}

- (NSURLSessionUploadTask*)upload:(NSString*)url filePath:(NSString*)filePath{
    
    NSURL *URL = [NSURL URLWithString:url];//@"http://example.com/upload"
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *path = [NSURL fileURLWithPath:filePath];//@"file://path/to/image.png"
    NSURLSessionUploadTask *task = [_httpManager uploadTaskWithRequest:request fromFile:path progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            DLog(@"Error: %@", error);
        } else {
            DLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [task resume];
    return task;
}

//上传数据
- (NSURLSessionUploadTask*)upload:(NSString*)url file:(NSData*)file parameters:(NSDictionary*)parameters completion:(void (^)(NSURLResponse *response, id responseObject, NetError* err))completion sendDataBlock:(NCSendDataBlock)sendDataBlock{
    __block AFHTTPSessionManager *http = [self creatHttpManager];
    if (_timeoutInterval>=5) {
        http.requestSerializer.timeoutInterval=_timeoutInterval;
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [http.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //注意这里的name和fileName 要和服务器匹配
        [formData appendPartWithFileData:file name:@"file" fileName:@"data" mimeType:@"multipart/form-data"];
        
    } error:&serializationError];
    
    if (serializationError) {
        if (completion) {
            dispatch_async( dispatch_get_main_queue(), ^{
                completion(nil,nil,[self checkError:serializationError]);
            });
            
        }
        
        http=nil;
        return nil;
    }
    
    __block NSURLSessionUploadTask *task = [http uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        
        http=nil;
        
        if (completion) {
            Dispatch_Main_Sync(completion(response,responseObject,[self checkError:error]));
        }
    }];
    
    [task resume];
    
    
    
    //跟踪load数据
    [http setTaskDidSendBodyDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (sendDataBlock) {
            Dispatch_Main_Sync(sendDataBlock(session,task,bytesSent,totalBytesSent,totalBytesExpectedToSend));
        }
    }];
    
    return task;
}


#pragma mark - fct


#pragma mark - kvo
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
//        NSProgress *progress = (NSProgress *)object;
//        DLog(@"%@",progress.userInfo);
//        DLog(@"----> Progress fractionCompleted is %f", progress.fractionCompleted);
//        if (self.delegate && [self.delegate respondsToSelector:@selector(NetConnectDelegate:fractionCompleted:)]) {
//            [self.delegate NetConnectDelegate:self fractionCompleted:progress.fractionCompleted];
//        }
//    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
@end
