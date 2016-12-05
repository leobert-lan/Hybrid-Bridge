//
//  TaskMgrFavoDataSource.h
//  cyy_task
//
//  Created by Qingyang on 16/7/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDataSource.h"
@interface TaskMgrFavoDataSource : TaskDataSource
@property (nonatomic,assign) BOOL selectionEnabled;
@property (nonatomic, weak) NSMutableArray *arrSelected;
@end
