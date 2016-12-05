//
//  TaskHomeVC.h
//  cyy_task
//
//  Created by Qingyang on 16/7/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "SubscripNewVC.h"
#import "loginVC.h"
#import "HybridAppVC.h"
@interface TaskHomeVC : BaseViewController
{
    IBOutlet UIView *vHeader,*vBanners,*vChannel,*vMsg,*vTitle;
    IBOutlet UIButton *btnSubscription,*btnTaskHot,*btnTaskRich,*btnTasks;
    
    NSMutableArray *arrData;
    NSMutableArray *arrBannes;
    
    MJRefreshNormalHeader *headerMJ;
    MJRefreshAutoNormalFooter *footerMJ;
    NSInteger page;
}
@end
