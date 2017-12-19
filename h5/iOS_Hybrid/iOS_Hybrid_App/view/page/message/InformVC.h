//
//  InformVC.h
//  cyy_task
//
//  Created by zhchen on 16/8/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^InformBlock)();
@interface InformVC : BaseViewController
@property (nonatomic,strong) NSMutableArray *arrClick;
@property (nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footerMJ;
@property (nonatomic,copy)InformBlock InformBlock;
@end
