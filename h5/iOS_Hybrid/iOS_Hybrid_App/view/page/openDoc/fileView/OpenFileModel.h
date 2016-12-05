//
//  OpenFileModel.h
//  cyy_task
//
//  Created by zhchen on 16/11/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseModel.h"

@interface OpenFileModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *fileExt; // 文件后缀
@property (nonatomic,retain) NSString<Optional> *fileName; //文件名
@property (nonatomic,retain) NSString<Optional> *filePath;  // 文件路径
@property (nonatomic,retain) NSString<Optional> *fileSize; // 文件大小
@property (nonatomic,retain) NSString<Optional> *fileSizeAlias; // 文件大小别名
@property (nonatomic,retain) NSString<Optional> *mime; // 文件类型
@property (nonatomic,retain) NSString<Optional> *urlDownload; // 文件下载地址
@end
