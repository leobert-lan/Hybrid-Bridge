//
//  TaskMgrHistoryDataSource.h
//  cyy_task
//
//  Created by Qingyang on 16/7/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDataSource.h"
#import "TaskMgrCell.h"
@interface TaskMgrHistoryDataSource : TaskDataSource
@property (nonatomic,assign) BOOL myTaskEnabled;//区分是否是用户的需求
@property (assign) BOOL hidesPopNav;//隐藏上一页导航栏
@end
