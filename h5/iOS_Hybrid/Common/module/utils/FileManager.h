//
//  FileManager.h
//  resource
//
//  Created by Yan Qingyang on 15/11/3.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManager : NSObject
#pragma mark - creat
+ (BOOL)createDirectory:(NSString*)path;
#pragma mark - 获取系统目录
//获取document目录路径
+(NSString *)getDocumentPath;
//获取Cache目录路径
+(NSString *)getCachePath;
//获取Tmp目录路径
+(NSString *)getTmpPath;
#pragma mark - check文件夹/文件
+ (BOOL)isExist:(NSString*)path;
//check文件夹
+ (BOOL)isExistDirectory:(NSString*)path;
#pragma mark 获取文件夹，没有就创建
+(NSString *)getDocumentsDirectory:(NSString *)dir;
+(NSString *)getCachesDirectory:(NSString *)dir;
+ (NSString *)getTmpDirectory:(NSString *)dir;
#pragma mark- 文件的数据
+ (NSData *)getDataFromPath:(NSString *)path;
+ (BOOL)saveData:(NSData*)data withPath:(NSString *)path cover:(BOOL)cover;
#pragma mark - del
+ (BOOL)deletePath:(NSString *)aPath;
+ (BOOL)deleteDocumentsDirectory:(NSString *)dir;
//清理文件夹
+ (void)cleanDirectory:(NSString *)dir;
#pragma mark - move
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;
#pragma mark - show
//所有文件，包括子文件夹内文件
+ (NSArray*)showSubsAtPath:(NSString*)dir;
//只显示一级目录内文件
+ (NSArray*)showContentsAtPath:(NSString*)dir;

#pragma mark - 获取资源路径
+ (NSString *)getFilePath:(NSString*)name ofType:(NSString *)ext;

#pragma mark - 文件MD5
//算MD5
+ (void)fileMD5ByAssetURL:(NSString *)assetURL resultBlock:(void (^)(NSString* md5, NSNumber* totalFileSize,NSError *error))resultBlock;
+ (void)fileChunkByAssetURL:(NSString *)assetURL offset:(NSInteger)offset chunkSize:(NSUInteger)chunkSize resultBlock:(void (^)(NSData* data, NSNumber* offset, NSNumber* chunkSize, NSNumber* totalFileSize, NSError *error))resultBlock;
@end
