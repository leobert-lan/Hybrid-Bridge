//
//  TaskListVC.m
//  cyy_task
//
//  Created by Qingyang on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskListVC.h"
#import "TaskDetailsVC.h"
@interface TaskListVC ()
{
    NSMutableArray *arrData;
}
@end

@implementation TaskListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self listDataSourceInit];
    
    [self checkTitle];
    
    [self setupMJHeader];
    [self showLoading];
    [self refreshList];
}

#pragma mark - 获取数据
- (void)refreshList{
//    page = 1;
    [TaskAPI TaskListStyle:_taskStyle success:^(NSMutableArray *arr) {
        //                DLog(@">>>%@",arr);
        arrData=[arr mutableCopy];
        dsTask.arrData=arrData;
        [self.tableMain reloadData];
        
        [self didLoad];
        [self.tableMain.header endRefreshing];
    } failure:^(id err) {
        
        [self didLoad];
        [self.tableMain.header endRefreshing];
    }];
}
#pragma mark - 上下拉刷新
- (void)setupMJHeader {
    headerMJ = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshList)];
    [headerMJ setTitle:@"松开即可刷新" forState:MJRefreshStateIdle];
    self.tableMain.header = headerMJ;
    headerMJ.stateLabel.textColor = RGBHex(kColorGray201);
    headerMJ.stateLabel.font = fontSystem(kFontS26);
    headerMJ.lastUpdatedTimeLabel.textColor = RGBHex(kColorGray203);
    headerMJ.lastUpdatedTimeLabel.font = fontSystem(kFontS20);
    
}

- (void)refreshData{
    [headerMJ beginRefreshing];
}


#pragma mark - TableView代理方法

- (void)listDataSourceInit{
    dsTask=[[TaskDataSource alloc]init];
    dsTask.delegate=self;
    
    self.tableMain.delegate=dsTask;
    self.tableMain.dataSource=dsTask;
}

- (void)checkTitle{
    switch (_taskStyle) {
        case TaskListStyleHot:
        {
            [self naviTitle:@"最火任务"];
            
            
        }
            break;
        case TaskListStyleRich:
        {
            [self naviTitle:@"最壕任务"];
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark - BaseTableDataSourceDelegate
- (void)BaseTableDataSourceDelegate:(id)delegate didSelectCellModel:(TaskModel*)model{
    
    DLog(@">>> %@",model.toDictionary);
    TaskDetailsVC *vc = [[TaskDetailsVC alloc] initWithNibName:@"TaskDetailsVC" bundle:nil];
    vc.taskBn = model.task_bn;
    vc.delegatePopVC=self.delegatePopVC;
    [self.navigationController pushViewController:vc animated:YES];

}
@end
