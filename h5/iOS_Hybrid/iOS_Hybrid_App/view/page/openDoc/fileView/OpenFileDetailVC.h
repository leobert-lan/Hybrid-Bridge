//
//  OpenFileDetailVC.h
//  CloudBox
//
//  Created by zhchen on 16/3/15.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import "BaseViewController.h"
#import "OpenFileModel.h"
@interface OpenFileDetailVC : BaseViewController
/**
 *  文件的路径
 */
@property (nonatomic,copy) NSURL *filePath;
@property (nonatomic,copy) OpenFileModel *fileModel;
@property (nonatomic,copy) NSString *FileTitle;
@property (nonatomic,copy) NSString *contentType;
@property (nonatomic,copy)NSString *taskBn;
@end
