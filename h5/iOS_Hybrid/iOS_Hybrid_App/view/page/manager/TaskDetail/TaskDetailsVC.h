//
//  TaskDetailsVC.h
//  cyy_task
//
//  Created by zhchen on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(int, CloudFileContentType) {
    CloudFileContentTypeNone = 0,
    CloudFileContentTypeImage,
    CloudFileContentTypeVideo ,
    CloudFileContentTypeAudio ,
    CloudFileContentTypeDocument ,
    CloudFileContentTypeApplication,
    CloudFileContentTypeVirtual,
    CloudFileContentTypeUnknow,
};
@interface TaskDetailsVC : BaseViewController
@property (nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic,copy)NSString *taskBn;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footerMJ;
@end
