//
//  TaskHomeVC.h
//  cyy_task
//
//  Created by Qingyang on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"

@interface TaskMgrVC : BaseViewController
{
    IBOutlet UITableView *tblTask,*tblFavo;
    IBOutlet UIView *vTask,*vFavo,*vTaskMenu,*vBottomBar,*vTableHeader,*vBGNoAuth;
    IBOutlet UILabel *lblTblMsg;
    UISegmentedControl *seg;
    NSMutableArray *arrMenuBadges;
    BOOL isEditing;
    
    MJRefreshNormalHeader *headerMJTask,*headerMJFavo;
    MJRefreshAutoNormalFooter *footerMJTask,*footerMJFavo;
    int pageTask,pageFavo;
    NSMutableArray *arrDataTask,*arrDataFavo,*arrPrefer;
    NSMutableArray *arrSelected;
    TaskUndertakeType taskType;
}
@end
