//
//  sysMessagesVC.h
//  cyy_task
//
//  Created by zhchen on 16/8/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^sysMessagesBlock)();
@interface sysMessagesVC : BaseViewController
@property (nonatomic,strong) NSMutableArray *arrClick;
@property (nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footerMJ;
@property (nonatomic,copy)sysMessagesBlock sysMessagesBlock;
@end
