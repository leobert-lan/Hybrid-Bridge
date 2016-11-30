//
//  SubscriptionCollVC.h
//  cyy_task
//
//  Created by Qingyang on 16/8/25.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "SubscriptionListVC.h"


@interface SubscriptionCollVC : SubscriptionListVC
{
    NSMutableArray *arrSel;
}
@property (nonatomic,retain) NSString *indusId;
@end
