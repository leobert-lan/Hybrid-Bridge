//
//  FileManager.m
//  resource
//
//  Created by Yan Qingyang on 15/11/3.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "FileManager.h"
#import <CommonCrypto/CommonCrypto.h>

static NSInteger HASH_DATA_SIZE = 1024*64;  // Read 64K of data to be hashed

@implementation FileManager
#pragma mark - 获取资源路径
+ (NSString *)getFilePath:(NSString*)name ofType:(nullable NSString *)ext{
    return [[NSBundle mainBundle] pathForResource:name ofType:ext];
}
#pragma mark - 获取系统目录
//获取程序的Home目录路径
+(NSString *)getHomeDirectoryPath
{
    return NSHomeDirectory();
}

//获取document目录路径
+(NSString *)getDocumentPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

//获取Cache目录路径
+(NSString *)getCachePath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

//获取Library目录路径
+(NSString *)getLibraryPath
{
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

//获取Tmp目录路径
+(NSString *)getTmpPath
{
    return NSTemporaryDirectory();
}

#pragma mark 获取文件夹，没有就创建
//返回Documents下的指定文件路径(加创建)
+ (NSString *)getDocumentsDirectory:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self getDocumentPath] stringByAppendingPathComponent:dir];
    if ([FileManager isExist:path]) {
        return path;
    }
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        DLog(@"create dir error: %@",error.debugDescription);
    }
    return path;
}

//返回Caches下的指定文件路径(加创建)
+ (NSString *)getCachesDirectory:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self getCachePath] stringByAppendingPathComponent:dir];
    if ([FileManager isExist:path]) {
        return path;
    }
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        DLog(@"create dir error: %@",error.debugDescription);
    }
    
    [self addSkipBackupAttributeToItemAtURL:path];//cache一定要设置不备份
    
    return path;
}

////返回tmp下的指定文件路径(加创建)
+ (NSString *)getTmpDirectory:(NSString *)dir
{
    NSError* error;
    NSString* path = [[self getTmpPath] stringByAppendingPathComponent:dir];
    if ([FileManager isExist:path]) {
        return path;
    }
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        DLog(@"create dir error: %@",error.debugDescription);
    }
    
    [self addSkipBackupAttributeToItemAtURL:path];//cache一定要设置不备份
    
    return path;
}
#pragma mark - creat
+ (BOOL)createDirectory:(NSString*)path{
    NSError* error;
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        DLog(@"create dir error: %@",error.debugDescription);
        return NO;
    }
    return YES;
}
#pragma mark - show
+ (NSArray*)showSubsAtPath:(NSString*)dir{
    NSFileManager *fileManage=[NSFileManager defaultManager];
    NSArray *arr=[fileManage subpathsAtPath:dir];
    return arr;
}

+ (NSArray*)showContentsAtPath:(NSString*)dir{
    NSFileManager *fileManage=[NSFileManager defaultManager];
    NSArray *arr=[fileManage contentsOfDirectoryAtPath:dir error:nil];
    return arr;
}
#pragma mark - check文件夹/文件
+ (BOOL)isExist:(NSString*)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//check文件夹
+ (BOOL)isExistDirectory:(NSString*)path{
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        return YES;
    }
    return NO;
}

#pragma mark- 文件的数据
+ (NSData *)getDataFromPath:(NSString *)path
{
    return [[NSFileManager defaultManager] contentsAtPath:path];
}

+ (BOOL)saveData:(NSData*)data withPath:(NSString *)path cover:(BOOL)cover{
    NSFileManager * fm;
    fm = [NSFileManager defaultManager];
    
    if ([self isExist:path] ) {
        if (cover)
            [self deletePath:path];
        else return NO;
    }
    
    
    BOOL ifsucess;
    ifsucess = NO;
    //获取上面fileData对象中通过NSFileManager对象获取的文件中的内容，然后再创建一个新的路径，并存储
    ifsucess = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];

    if(ifsucess)
    {
//        DLog(@"create file sucess");
    }
    else
    {
//        DLog(@"create file failed");
    }
    return ifsucess;
}

#pragma mark - del
+ (BOOL)deletePath:(NSString *)aPath
{
    if([[NSFileManager defaultManager]fileExistsAtPath:aPath])
    {
        return [[NSFileManager defaultManager] removeItemAtPath:aPath error:nil];
    }
    return YES;
}

+ (BOOL)deleteDocumentsDirectory:(NSString *)dir
{
    NSString* aPath = [[self getDocumentPath] stringByAppendingPathComponent:dir];
    return [self deletePath:aPath];
    
}

//清理文件夹
+ (void)cleanDirectory:(NSString *)dir{
    //不要用[[NSFileManager defaultManager] subpathsAtPath:dir]，会打印出子文件夹内的所有文件
    NSArray* tempArray = [self showContentsAtPath:dir];
    for (NSString* fileName in tempArray) {
        NSString* fullPath = [dir stringByAppendingPathComponent:fileName];
        [self deletePath:fullPath];
    }
}
#pragma mark - move
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if(![[NSFileManager defaultManager]fileExistsAtPath:srcPath]) return NO;
    
    NSError *error=nil;
    if ([[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:&error]) {
        return YES;
    }
    DLog(@"*** Unable to move file: %@", [error localizedDescription]);
    DLog(@"*** %@: %@", srcPath,dstPath);
    return NO;
}


#pragma mark - 不进行iCloud备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString*)path
{
    NSURL* URL = [NSURL fileURLWithPath:path];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey
                                   error: &error];
    if(!success){
        DLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark - dispatch_async
+ (void)invokeAsyncBlock:(id (^)())block
              completion:(void (^)(id obj))completion
{
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^(void) {
        id retVal = nil;
        if (block) {
            retVal = block();
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (completion) {
                                   completion(retVal);
                               }
                           });
        }
    });
}

#pragma mark - 文件MD5 
+ (void)fileMD5ByAssetURL:(NSString *)assetURL resultBlock:(void (^)(NSString* md5, NSNumber* totalFileSize, NSError *error))resultBlock{
    
    if (StrIsEmpty(assetURL)) {
        if (resultBlock) {
            NSError *error=[[NSError alloc]init];
            resultBlock(nil,nil,error);
        }
        return;
    }
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^(void) {
        [assetLibrary assetForURL:[NSURL URLWithString:assetURL] resultBlock:^(ALAsset *asset) {
            if (asset==nil ){
                DLog(@">>>文件被删了:%@",assetURL);
                NSError *error=[[NSError alloc]init];
                resultBlock(nil,nil,error);
                return ;
            }
            
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            long long totalSize=rep.size;
            
            const long int bufferSize = HASH_DATA_SIZE;
//
            // 初始化一个 hash object
            CC_MD5_CTX hashObject;
            CC_MD5_Init(&hashObject);
//
            // 初始化一个buffer
            Byte *buffer = (Byte*)malloc(bufferSize);
            NSUInteger read = 0, offset = 0;
            NSError* err = nil;
            if (rep.size != 0)
            {
                do {
                    //返回读取字节数,返回0代表结束
                    read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                    if (read>0) {
                        //读到数据
                        
                    }
                    CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)read);
                    //游标
                    offset += read;
                } while (read != 0 && !err);//没到结尾，没出错，ok继续
            }

            // 释放缓冲区，关闭文件
            free(buffer);
            buffer = NULL;
            
            if (err) {
                if (resultBlock) {
                    resultBlock(nil,nil,err);
                }
            }

            // 计算 hash digest
            unsigned char digest[CC_MD5_DIGEST_LENGTH];
            CC_MD5_Final(digest, &hashObject);
            
            // 计算 string result
            char hash[2 * sizeof(digest) + 1];
            for (size_t i = 0; i < sizeof(digest); ++i) {
                snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
            }

            CFStringRef result = NULL;
            result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
            NSString *md5 = (__bridge_transfer NSString *)result;
            
//            if (resultBlock) {
//                resultBlock(md5);
//            }
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (resultBlock) {
                                   resultBlock(md5,[NSNumber numberWithLongLong:totalSize],nil);
                               }
                           });
            
        } failureBlock:^(NSError *error) {
            if (resultBlock) {
                resultBlock(nil,nil,error);
            }
        }];
    });
}



#pragma mark 文件片段
+ (void)fileChunkByAssetURL:(NSString *)assetURL offset:(NSInteger)offset chunkSize:(NSUInteger)chunkSize resultBlock:(void (^)(NSData* data, NSNumber* offset, NSNumber* chunkSize, NSNumber* totalFileSize, NSError *error))resultBlock{
    
    if (StrIsEmpty(assetURL)) {
        if (resultBlock){
            NSError *error=[NSError new];
            resultBlock(nil,nil,nil,nil,error);
        }
        return;
    }
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^(void) {
        [assetLibrary assetForURL:[NSURL URLWithString:assetURL] resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            long long totalSize=rep.size;
            
            const long int bufferSize = chunkSize>0?chunkSize:HASH_DATA_SIZE;
            
            // 初始化一个buffer
            Byte *buffer = (Byte*)malloc(bufferSize);
            
            NSUInteger os=(offset>=0)?offset:0;
            NSUInteger read = 0;
            NSUInteger fromOffset = os*chunkSize;
            NSError* err = nil;
            if (rep.size != 0 )
            {
                if (fromOffset<=rep.size) {
                    read = [rep getBytes:buffer fromOffset:fromOffset length:bufferSize error:&err];
                }
                
//                do {
//                    //返回读取字节数,返回0代表结束
//                    read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
//                    if (read>0) {
//                        //读到数据
//                        
//                    }
//                    
//                    //游标
//                    offset += read;
//                } while (read != 0 && !err);//没到结尾，没出错，ok继续
            }
            
            NSData *dt = [NSData dataWithBytes:buffer length:read];
            
            // 释放缓冲区，关闭文件
            free(buffer);
            buffer = NULL;
            
            if (err) {
                if (resultBlock) {
                    resultBlock(nil,nil,nil,[NSNumber numberWithLongLong:totalSize],err);
                }
            }
        
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if (resultBlock) {
                                   resultBlock(dt,[NSNumber numberWithInteger:offset],[NSNumber numberWithInteger:read],[NSNumber numberWithLongLong:totalSize],nil);
                               }
                           });
            
        } failureBlock:^(NSError *error) {
            if (resultBlock) {
                resultBlock(nil,nil,nil,nil,error);
            }
        }];
    });
}
@end
