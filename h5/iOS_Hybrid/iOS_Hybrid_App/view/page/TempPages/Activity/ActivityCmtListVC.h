//
//  ActivityCmtListVC.h
//  cyy_task
//
//  Created by Qingyang on 16/11/14.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "ActivityAPI.h"
#import "ActivityConfig.h"
@interface ActivityCmtListVC : BaseViewController
{
    IBOutlet UIView *vHeader,*vFooter,*vMyCmt;;
    IBOutlet UIButton *btnJoinCmt,*btnHuodong;
    IBOutlet UILabel *lblTime,*lblContent,*lblUser,*lblStatus;
    IBOutlet UIImageView *imgAvatar;
    IBOutlet UIImageView *iconStatus;
    
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *vRules,*vRulesMain,*vRulesText;
    IBOutlet UIImageView *bgHuodong;
    
    IBOutlet UILabel *lblBannerTime,*lblRuleTime;
    IBOutlet UILabel *lblR1,*lblR2,*lblR3,*lblR4;
    IBOutlet UIImageView *iconNo1,*iconNo2,*iconNo3,*iconNo4;
    UILabel *sp1,*sp2,*sp3;
//    NSString *ssStarts,*ssEnd;
    
    NSMutableArray *arrData;
    
    
    MJRefreshNormalHeader *headerMJ;
    MJRefreshAutoNormalFooter *footerMJ;
    NSInteger page;
    
    ActivityCmtModel *mmMyCmt;
}
@end
