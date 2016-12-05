//
//  SearchHistoryVC.h
//  cyy_task
//
//  Created by Qingyang on 16/7/21.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchListVC.h"
#import "SearchHistoryCell.h"
#import "SearchHistoryCleanCell.h"
#import "SearchColleDataSource.h"
@interface SearchHistoryVC : BaseViewController
{
    IBOutlet UICollectionView *colHotSearch;
    IBOutlet UILabel *lblHistoryTTL;
    SearchColleDataSource *dsHotSerarch;
}
@end
