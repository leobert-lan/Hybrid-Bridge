//
//  SearchListVC.h
//  cyy_task
//
//  Created by Qingyang on 16/7/21.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "TaskDataSource.h"
#import "SearchTableDataSource.h"
#import "SearchColleDataSource.h"
#import "TaskDetailsVC.h"

//test
#import "BaseWKWebViewVC.h"
#import "WebTaskAPI.h"
typedef NS_ENUM(NSInteger, TaskSearchConditionStyle){
    TaskSearchConditionType = 1,
    TaskSearchConditionFilter,
    TaskSearchConditionOrder
};

@interface SearchListVC : BaseWKWebViewVC
{
    IBOutlet UIButton *btnType,*btnFilter,*btnOrder;
    IBOutlet UIButton *btnShadow,*btnReset,*btnOK;
    IBOutlet UIView *vMenu,*vCond,*vFilter;
    UIView *vTypeSepaLine;
    
    IBOutlet UITableView *tblType,*tblTypeII;
    IBOutlet UICollectionView *colType;
    
    TaskDataSource *dsTask;
    SearchTableDataSource *dsType,*dsTypeII;
    SearchColleDataSource *dsChoose;
    
    NSMutableArray *arrTypeI,*arrTypeII,*arrFilter,*arrOrder;
    
    MJRefreshNormalHeader *headerMJ;
    MJRefreshAutoNormalFooter *footerMJ;
    
    CollectionItemTypeModel *tpSubscripI,*tpSubscripII;
    CollectionItemTypeModel *tpSubscripISel,*tpSubscrip2Sel;//分类选择
    CollectionItemTypeModel *tpOrder;//排序选择
    //筛选
    CollectionItemTypeModel *tpFilterType,*tpFilterTrust,*tpFilterAuth;
    CollectionItemTypeModel *tpFilterTypeSel,*tpFilterTrustSel,*tpFilterAuthSel;//选择
    
    NSString *oldKeyword;
}

@property (assign) BOOL popRootEnabled;
@property (nonatomic,strong) NSString* keyword;

//测试
@property (nonatomic, strong) WKWebView* webView2;
@property (nonatomic,strong) WKWebViewJavascriptBridge* bridge2;
@end
