//
//  TaskMgrCell.h
//  cyy_task
//
//  Created by Qingyang on 16/7/20.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskCell.h"
#import "EvaluateVC.h"
#import "ProtocolVC.h"
#import "SubmissionVC.h"
@interface TaskMgrCell : TaskCell
{
    TaskModel *taskMd;
}
@property (nonatomic,assign) BOOL myTaskEnabled;
@property (assign) BOOL hidesPopNav;//隐藏上一页导航栏
@end
