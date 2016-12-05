//
//  SubscripNewVC.h
//  cyy_task
//
//  Created by Qingyang on 16/9/18.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchColleDataSource.h"
@interface SubscripNewVC : BaseViewController
{
    IBOutlet UIView *vHeader,*vFooter;
    IBOutlet UICollectionView *colType;
    IBOutlet UIButton *btnOK;
    IBOutlet UILabel *lblTTL;
    SearchColleDataSource *dsChoose;
    
    NSMutableArray *arrSel;
}

@property (assign) BOOL canJump;
@property (nonatomic,strong) NSMutableArray *arrData;
@end
