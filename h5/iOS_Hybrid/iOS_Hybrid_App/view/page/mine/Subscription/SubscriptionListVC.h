//
//  SubscriptionListVC.h
//  cyy_task
//
//  Created by Qingyang on 16/8/25.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "SubScriptionCell.h"
//#import "SubscriptionCollVC.h"
@protocol SubscriptionDelegate <NSObject>
@optional
- (void)SubscriptionDelegate:(id)delegate type:(NSString*)type tags:(NSArray*)tags;

@end

@interface SubscriptionListVC : BaseViewController
{
    IBOutlet UIView *vHeader,*vFooter;
    IBOutlet UILabel *lblTTL;
    IBOutlet UIButton *btnClose,*btnOK;
  
    UIView *spLine;
    
}

@property (assign) BOOL canJump;
@property (nonatomic,strong) NSMutableArray *arrData;
@end
