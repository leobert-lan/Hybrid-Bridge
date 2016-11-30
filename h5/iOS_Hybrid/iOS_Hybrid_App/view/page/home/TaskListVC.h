//
//  TaskListVC.h
//  cyy_task
//
//  Created by Qingyang on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "TaskDataSource.h"

@interface TaskListVC : BaseViewController
{
    TaskDataSource *dsTask;
    MJRefreshNormalHeader *headerMJ;
}
@property (assign) TaskListStyle taskStyle;
@end
