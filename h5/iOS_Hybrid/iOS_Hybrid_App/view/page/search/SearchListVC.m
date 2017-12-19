//
//  SearchListVC.m
//  cyy_task
//
//  Created by Qingyang on 16/7/21.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchListVC.h"

@interface SearchListVC ()<UITextFieldDelegate>
{
    NSInteger page;
    NSMutableArray *arrData;
    UITextField *txtSearch;
}
@end

@implementation SearchListVC

#pragma mark - web 全局界面UI

- (void)WebUIInit{
    [super WebUIInit];
    
    if (self.webViewMain == nil) {
        
        
    }
    
    if (self.webView2 == nil) {
        
        self.webView2 = [[WKWebView alloc]init];
        self.webView2.frame=self.view.bounds;
        self.webView2.navigationDelegate = self;
        self.webView2.UIDelegate = self;
        [self.view addSubview:self.webView2];
        [self.view sendSubviewToBack:self.webView2];
    }
    
    //添加监听
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge2 = [WKWebViewJavascriptBridge bridgeForWebView:self.webView2];
//    [self listener2:self.bridge2];
    //    [self.bridgeMain callHandler:@"toH5" data:@{ @"auth":@"USER_ID_AND_TOKEN" }];
    
    [self loadHybridWeb:self.webView2];
    
    self.tableMain.hidden=YES;
}

- (void)loadHybridWeb:(WKWebView*)webView {
    NSURL *url=[NSURL URLWithString:@"http://m.vsochina.com:8080/bridge/test/"];
    
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)searchInWeb{
    //保留上次搜索内容
    if (_keyword) {
        oldKeyword=[_keyword copy];
    }
    else {
        oldKeyword=nil;
    }
    
    page = 0;
    [WebTaskAPI TaskSearchCall:_bridge2 keyword:_keyword indus_id:tpSubscrip2Sel.oid model:tpFilterType.oid.intValue hosted_fee:tpFilterTrust.oid.intValue order:tpOrder.oid.intValue page:page pageSize:kPageSize callback:^(id bridge, id data, NetError *err) {
        DLog(@"TaskSearchCall:%@",data);
    }];
    /*
    [TaskAPI SearchTaskList:_keyword indus_id:tpSubscrip2Sel.oid model:tpFilterType.oid.intValue hosted_fee:tpFilterTrust.oid.intValue order:tpOrder.oid.intValue page:page pageSize:kPageSize success:^(NSMutableArray *arr) {
        arrData=[arr mutableCopy];
        dsTask.arrData=arrData;
        [self.tableMain reloadData];
        
        [self didLoad];
        [self.tableMain.header endRefreshing];
        
        //        vMenu.hidden=NO;
        [self removeInfoView];
        
    } failure:^(NetError *err) {
        [self didLoad];
        [self.tableMain.header endRefreshing];
        
        if (err.errStatusCode==13862) {
            DLog(@">>> 无数据 ");
            //显示找不到页面
            
            [self noDataSearched];
            return ;
        }
        
        [self showText:err.errMessage];
    }];
    */
}
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self conditionInit];
    [self filterViewInit];
    
    [self listDataSourceInit];
    [self searchConditionDataSourceInit];
    
    [self setupMJHeader];
    [self setupMJFooter];
    [self showLoading];
    [self refreshList];
    
    if (!StrIsEmpty(_keyword)) {
        txtSearch.text=_keyword;
    }
}

- (void)UIGlobal{
    [super UIGlobal ];
//    DLog(@"%@",self.navigationController.viewControllers);
    if (self.popRootEnabled) {
        [self naviRightButtonImage:[UIImage imageNamed:@"close"] highlighted:[UIImage imageNamed:@"close"] action:@selector(navPopRootAction:)];
        [self naviSearchTextfield:100];
        
    }
    else {
        [self naviSearchTextfield:70];
    }
    
    
    vCond.backgroundColor=RGBHex(kColorGray207);
    vMenu.backgroundColor=RGBHex(kColorW);
    
    colType.backgroundColor=RGBAHex(kColorW,0);
    
    //否则妨碍statusbar触发返回顶部
    tblType.scrollsToTop=NO;
    tblTypeII.scrollsToTop=NO;
    colType.scrollsToTop=NO;
}


- (void)filterViewInit{
    [btnReset setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
    [btnOK setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
    
    btnReset.backgroundColor=RGBHex(kColorW);
    btnOK.backgroundColor=RGBHex(kColorMain001);
    
    btnReset.clipsToBounds=YES;
    btnReset.layer.cornerRadius=3;
    btnReset.layer.borderWidth=0.5;
    btnReset.layer.borderColor=RGBHex(kColorGray203).CGColor;
    
    btnOK.clipsToBounds=YES;
    btnOK.layer.cornerRadius=3;

    CGFloat ww=(APP_W-15*3)/2;
    
    btnReset.frame=CGRectMake(15, 10, ww, 40);
    btnOK.frame=CGRectMake(ww+30, 10, ww, 40);
    
    CGRect frm;
    frm=CGRectMake(0, 0, APP_W, 0.5);
    UIView *sp3=[[UIView alloc]initWithFrame:frm];
    sp3.backgroundColor=RGBHex(kColorGray206);
    [vFilter addSubview:sp3];
}
- (void)conditionInit{
    btnType.tag=TaskSearchConditionType;
    btnFilter.tag=TaskSearchConditionFilter;
    btnOrder.tag=TaskSearchConditionOrder;
    
    [btnType setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
    [btnFilter setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
    [btnOrder setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
    
    [btnType addTarget:self action:@selector(conditionAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnFilter addTarget:self action:@selector(conditionAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnOrder addTarget:self action:@selector(conditionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGPoint cc = vMenu.center;
    cc.x = APP_W/2;
    btnFilter.center = cc;
    
    cc.x = APP_W/6;
    btnType.center = cc;
    
    cc.x *= 5;
    btnOrder.center = cc;
    
    CGRect frm=CGRectMake(APP_W/3, (vMenu.height-20)/2, 0.5, 20);
    UIView *sp1=[[UIView alloc]initWithFrame:frm];
    sp1.backgroundColor=RGBHex(kColorGray206);
    [vMenu addSubview:sp1];
    
    UIView *sp2=[[UIView alloc]initWithFrame:frm];
    sp2.backgroundColor=RGBHex(kColorGray206);
    sp2.x *= 2;
    [vMenu addSubview:sp2];
    
    frm=CGRectMake(0, vMenu.height-0.5, APP_W, 0.5);
    UIView *sp3=[[UIView alloc]initWithFrame:frm];
    sp3.backgroundColor=RGBHex(kColorGray206);
    [vMenu addSubview:sp3];
    
    
    
    btnShadow.hidden=YES;
    btnShadow.alpha=0;
    [btnShadow addTarget:self action:@selector(menuCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    vCond.y=0-vCond.height;
    
    frm=CGRectMake(0, 0, 0.5, 0);
    vTypeSepaLine=[[UIView alloc]initWithFrame:frm];
    vTypeSepaLine.backgroundColor=RGBAHex(kColorGray206,0);//当前版本取消分割线
    [vCond addSubview:vTypeSepaLine];
    
    tblTypeII.backgroundColor=[UIColor clearColor];
}

#pragma mark - 导航栏文字按钮

- (id)naviSearchTextfield:(CGFloat)margin{
    UIView* aView=[[UIView alloc]init];
    float ww=APP_W-margin;
    CGRect frm=CGRectMake(0, 0, ww, 44);//self.navigationController.navigationBar.bounds;
    aView.frame=frm;
    aView.backgroundColor=[UIColor clearColor];
    
//    frm.size.width-=15;
    frm.size.height=30;
//    frm.origin.y=(aView.height-frm.size.height)/2;
    txtSearch=[[UITextField alloc]initWithFrame:frm];
    txtSearch.center=aView.center;
    txtSearch.backgroundColor=RGBHex(kColorW);
    txtSearch.layer.cornerRadius=txtSearch.height/2;
    txtSearch.clipsToBounds=YES;
    txtSearch.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    txtSearch.returnKeyType=UIReturnKeySearch;
    txtSearch.delegate=self;
    txtSearch.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtSearch.tintColor = RGBHex(kColorMain001);
    [aView addSubview:txtSearch];
    
    frm=CGRectMake(0, 0, 36, 34);
    UIImageView *img=[[UIImageView alloc]initWithFrame:frm];
    img.image=[UIImage imageNamed:@"search"];
    img.contentMode=UIViewContentModeCenter;
    txtSearch.leftView=img;
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    
    [self.navigationItem setTitleView:aView];
    
    return aView;
}
#pragma mark - 上下拉刷新
- (void)setupMJHeader {
    headerMJ = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshList)];
    [headerMJ setTitle:@"松开即可刷新" forState:MJRefreshStateIdle];
    self.tableMain.header = headerMJ;
    headerMJ.stateLabel.textColor = RGBHex(kColorGray201);
    headerMJ.stateLabel.font = fontSystem(kFontS26);
    headerMJ.lastUpdatedTimeLabel.textColor = RGBHex(kColorGray203);
    headerMJ.lastUpdatedTimeLabel.font = fontSystem(kFontS20);
    
}

- (void)refreshData{
    [headerMJ beginRefreshing];
}

- (void)setupMJFooter
{
    footerMJ = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getListNext)];
    
    [footerMJ endRefreshingWithNoMoreData];
    [footerMJ setTitle:@"" forState:MJRefreshStateIdle];
 
    self.tableMain.footer = footerMJ;
}
#pragma mark - 获取数据
- (void)refreshList{
    //保留上次搜索内容
    if (_keyword) {
        oldKeyword=[_keyword copy];
    }
    else {
        oldKeyword=nil;
    }
    
    page = 0;
    [TaskAPI SearchTaskList:_keyword indus_id:tpSubscrip2Sel.oid model:tpFilterType.oid.intValue hosted_fee:tpFilterTrust.oid.intValue order:tpOrder.oid.intValue page:page pageSize:kPageSize success:^(NSMutableArray *arr) {
        arrData=[arr mutableCopy];
        dsTask.arrData=arrData;
        [self.tableMain reloadData];
        
        [self didLoad];
        [self.tableMain.header endRefreshing];
        
//        vMenu.hidden=NO;
        [self removeInfoView];
        
    } failure:^(NetError *err) {
        [self didLoad];
        [self.tableMain.header endRefreshing];
        
        if (err.errStatusCode==13862) {
            DLog(@">>> 无数据 ");
            //显示找不到页面
            
            [self noDataSearched];
            return ;
        }
        
        [self showText:err.errMessage];
    }];
    
}

- (void)getListNext
{
    page ++;
    [TaskAPI SearchTaskList:_keyword indus_id:tpSubscrip2Sel.oid model:tpFilterType.oid.intValue hosted_fee:tpFilterTrust.oid.intValue order:tpOrder.oid.intValue page:page pageSize:kPageSize success:^(NSMutableArray *arr) {
//        arrData=[arr mutableCopy];
       
        [arrData addObjectsFromArray:arr];
        
        [self didLoad];
        [self.tableMain.footer endRefreshing];
        
        footerMJ.automaticallyHidden = YES;
        if (arr.count == 0) {
            [footerMJ endRefreshingWithNoMoreData];
        }
        
        dsTask.arrData=arrData;
        [self.tableMain reloadData];
        
    } failure:^(NetError *err) {
        [self.tableMain.footer endRefreshing];
        if (err.errStatusCode==13862) {
            DLog(@">>> 无数据 ");
            footerMJ.automaticallyHidden = YES;
            [footerMJ endRefreshingWithNoMoreData];
            return ;
        }
        [footerMJ setTitle:@"" forState:MJRefreshStateIdle];
        [self showText:err.errMessage];
        

    }];

}

- (void)noDataSearched{
    [arrData removeAllObjects];
    dsTask.arrData=arrData;
    [self.tableMain reloadData];
    
//    vMenu.hidden=YES;
    
    [self showInfoView:@"暂无搜索结果，换个词试试？" image:@"pic_search"];
    
    //确认层级
    [self.view bringSubviewToFront:btnShadow];
    [self.view bringSubviewToFront:vCond];
    [self.view bringSubviewToFront:vMenu];
}
#pragma mark - action
- (IBAction)navPopRootAction:(id)sender{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)conditionAction:(id)sender{
    UIButton *btn=sender;
    
    if (btn.selected) {
        //收回菜单
        btn.selected=false;
    }
    else {
        //打开菜单
        btnType.selected=false;
        btnFilter.selected=false;
        btnOrder.selected=false;
        
        btn.selected=true;
        
//        [self.view endEditing:YES];
        [txtSearch resignFirstResponder];
    }
    
    [self checkMenu:btn];
}

- (IBAction)menuCloseAction:(id)sender{
    btnType.selected=false;
    btnFilter.selected=false;
    btnOrder.selected=false;
    
    [UIView animateWithDuration:.25 animations:^{
        btnShadow.alpha=0;
        
        vCond.y=0-vCond.height;
    } completion:^(BOOL finished) {
        btnShadow.hidden=YES;
    }];
}

- (IBAction)filterOKAction:(id)sender{
    tpFilterType.selected=NO;
    tpFilterTrust.selected=NO;
    tpFilterAuth.selected=NO;
    tpFilterType=tpFilterTypeSel;
    tpFilterTrust=tpFilterTrustSel;
    tpFilterAuth=tpFilterAuthSel;
    tpFilterType.selected=YES;
    tpFilterTrust.selected=YES;
    tpFilterAuth.selected=YES;
    [self research];
}
- (IBAction)filterResetAction:(id)sender{
    [self DSFilerReset];
    [colType reloadData];
    [self research];
}
#pragma mark - menu
- (void)checkMenu:(UIButton*)choose{
    if (choose.selected) {
        if (btnShadow.hidden!=NO) {
            btnShadow.alpha=0;
            btnShadow.hidden=NO;
        }
        //show菜单
        vFilter.hidden=YES;
        tblType.hidden=YES;
        tblTypeII.hidden=YES;
        colType.hidden=NO;
        vTypeSepaLine.hidden=YES;
        switch (choose.tag) {
            case TaskSearchConditionType:
            {
                vCond.height=self.tableMain.height;
                tblType.hidden=NO;
                tblTypeII.hidden=NO;
                colType.hidden=YES;
                
                tblType.frame=vCond.bounds;
                tblType.width=140;
                
                tblTypeII.frame=vCond.bounds;
                tblTypeII.width-=140;
                tblTypeII.x=140;
                
                tpSubscripI.selected=NO;
                tpSubscripISel.selected=YES;;
                tpSubscripI=tpSubscripISel;
                arrTypeII=tpSubscripI.list;
                
                dsType.arrData=arrTypeI;
                dsTypeII.arrData=arrTypeII;
//                dsChoose.width=colType.width;
//                dsTypeII.tag=choose.tag;
//                [dsChoose setWidth:colType.width margin:kSearchColleMargin sectionHeaderDisabled:NO];
                
                [tblType reloadData];
                [tblTypeII reloadData];
                
                vTypeSepaLine.height=vCond.height;
                vTypeSepaLine.x=tblType.width;
                vTypeSepaLine.hidden=NO;
                [vCond bringSubviewToFront:vTypeSepaLine];
            }
                break;
            case TaskSearchConditionFilter:
            {
                //打开筛选时，先重置选择状态到用户选择，临时选择状态去掉
                tpFilterTypeSel.selected=NO;
                tpFilterTrustSel.selected=NO;
                tpFilterAuthSel.selected=NO;
                tpFilterType.selected=YES;
                tpFilterTrust.selected=YES;
                tpFilterAuth.selected=YES;
                
                //修改显示高度，根据内容
                vFilter.hidden=NO;
   
                dsChoose.arrData=arrFilter;
                dsChoose.width=vCond.width;
                dsChoose.tag=choose.tag;
                vCond.height=[dsChoose getSizeWithCollectionView:colType].height+vFilter.height;
                colType.frame=vCond.bounds;
                colType.height-=vFilter.height;
                
                [colType reloadData];
            }
                break;
            case TaskSearchConditionOrder:
            {
//                vCond.height=120;
                dsChoose.arrData=arrOrder;
                dsChoose.width=vCond.width;
                dsChoose.tag=choose.tag;
                
                vCond.height=[dsChoose getSizeWithCollectionView:colType].height;
                colType.frame=vCond.bounds;
                
                [colType reloadData];
            }
                break;
            default:
                break;
        }
        
        //确认层级
        [self.view insertSubview:vCond belowSubview:vMenu];
        [self.view insertSubview:btnShadow belowSubview:vCond];
        
        vCond.y=0-vCond.height;
        
        [UIView animateWithDuration:.25 animations:^{
            btnShadow.alpha=1;
            vCond.y=CGRectGetMaxY(vMenu.frame);
        } completion:^(BOOL finished) {
            //
        }];
    }
    else {
        //close menu
        
        [self menuCloseAction:nil];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//
    
    [self search:textField.text];
    [txtSearch resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self menuCloseAction:nil];
}
#pragma mark - search
- (void)search:(NSString*)key{
    if (StrIsEmpty(key)) {
        _keyword=nil;
    }
    else {
        //搜索内容不为空时，保留成历史搜索数据,为公共数据
        _keyword=key;
        SearchHistoryModel *mm = [[SearchHistoryModel alloc] init];
        mm.keyword = key;
        mm.datetime=[QGLOBAL dateToTimeInterval:[NSDate date]];
        [SearchHistoryModel updateModelToDB:mm key:nil];
    }
    
    //如果搜索内容变动，所有筛选重置
    if ((_keyword != oldKeyword) && ![_keyword isEqualToString:oldKeyword]) {
        [self DSAllReset];
    }
    
    [self refreshData];
    
    //test
    [self searchInWeb];
}
#pragma mark - TableView代理方法 数据初始化

- (void)listDataSourceInit{
    dsTask=[[TaskDataSource alloc]init];
    dsTask.delegate=self;
    
    self.tableMain.delegate=dsTask;
    self.tableMain.dataSource=dsTask;
    
  
    
}

#pragma mark - 筛选条件 数据初始化
- (void)searchConditionDataSourceInit{
    dsType=[[SearchTableDataSource alloc]init];
    dsType.delegate=self;
    dsType.typeI=YES;
    
    tblType.delegate=dsType;
    tblType.dataSource=dsType;
    
    
    dsTypeII=[[SearchTableDataSource alloc]init];
    dsTypeII.delegate=self;
    dsTypeII.typeI=NO;
    
    tblTypeII.delegate=dsTypeII;
    tblTypeII.dataSource=dsTypeII;
    
    
    dsChoose=[[SearchColleDataSource alloc]init];
    dsChoose.delegate=self;
    
    [dsChoose setColWidth:colType.width margin:kSearchColleMargin sectionHeaderDisabled:NO];
    
    [colType setContentInset:UIEdgeInsetsMake(0, kSearchColleMargin, kSearchColleMargin, kSearchColleMargin)];
    
    colType.delegate=dsChoose;
    colType.dataSource=dsChoose;
    
    [self DSTypeInit];
    [self DSFilterInit];
    [self DSOrderInit];
    
    
    
}

- (void)DSTypeInit{
//    arrTypeI=[[NSMutableArray alloc]init];
//    arrTypeII=[[NSMutableArray alloc]init];

    [OtherAPI getIndustryList:NO success:^(NSMutableArray *arr) {
//        DLog(@"}}} %@",arr);
        arrTypeI=[OtherAPI collItemsFromSubIndustryList:arr canAll:YES];
        
        if (arrTypeI==nil) arrTypeI=[[NSMutableArray alloc]init];
//        DLog(@"}}} %@",arrTypeI);
        CollectionItemTypeModel *m0=[CollectionItemTypeModel new];
        m0.title=@"全部";
        m0.oid=@"0";
        m0.selected=YES;
     
        [arrTypeI insertObject:m0 atIndex:0];
        
        tpSubscripI=m0;
        tpSubscripISel=tpSubscripI;
        tpSubscrip2Sel=tpSubscripI;
    } failure:^(NetError *err) {
        //
    }];
    
    

}

- (void)DSFilterInit{
    arrFilter=[[NSMutableArray alloc]init];
    
    //假数据
    CollectionItemTypeModel *m1=[CollectionItemTypeModel new];
    m1.title=@"需求类型";
    m1.oid=@"1";

    CollectionItemTypeModel *m11=[CollectionItemTypeModel new];
    m11.title=@"全部";
    m11.oid=@"0";
    m11.tag=m1.oid;
    m11.selected=YES;
    CollectionItemTypeModel *m12=[CollectionItemTypeModel new];
    m12.title=@"单人悬赏";
    m12.oid=@"1";
    m12.tag=m1.oid;
    CollectionItemTypeModel *m13=[CollectionItemTypeModel new];
    m13.title=@"项目招标";
    m13.oid=@"2";
    m13.tag=m1.oid;

    NSMutableArray *aa1=[NSMutableArray arrayWithObjects:m11,m12,m13, nil];
    m1.list=aa1;
    
    //可选，是否已托管（0=>未托管，1=>已托管，无默认值，不传该参数则查询所有数据）
    CollectionItemTypeModel *m2=[CollectionItemTypeModel new];
    m2.title=@"资金托管";
    m2.oid=@"2";
    
    CollectionItemTypeModel *m21=[CollectionItemTypeModel new];
    m21.title=@"全部";
    m21.oid=@"999";
    m21.tag=m2.oid;
    m21.selected=YES;
    CollectionItemTypeModel *m22=[CollectionItemTypeModel new];
    m22.title=@"已托管";
    m22.oid=@"1";
    m22.tag=m2.oid;
    
    NSMutableArray *aa2=[NSMutableArray arrayWithObjects:m21,m22, nil];
    m2.list=aa2;
    
    /*
    CollectionItemTypeModel *m3=[CollectionItemTypeModel new];
    m3.title=@"身份认证";
    m3.oid=@"3";
    
    CollectionItemTypeModel *m31=[CollectionItemTypeModel new];
    m31.title=@"全部";
    m31.oid=@"0";
    m31.tag=m3.oid;
    m31.selected=YES;
    CollectionItemTypeModel *m32=[CollectionItemTypeModel new];
    m32.title=@"个人认证";
    m32.oid=@"1";
    m32.tag=m3.oid;
    CollectionItemTypeModel *m33=[CollectionItemTypeModel new];
    m33.title=@"企业认证";
    m33.oid=@"2";
    m33.tag=m3.oid;
    
    NSMutableArray *aa3=[NSMutableArray arrayWithObjects:m31,m32,m33, nil];
    m3.list=aa3;
    */
    
    [arrFilter addObject:m1];
    [arrFilter addObject:m2];
//    [arrFilter addObject:m3];
    
    tpFilterType=m11;
    tpFilterTrust=m21;
//    tpFilterAuth=m31;
    tpFilterTypeSel=tpFilterType;
    tpFilterTrustSel=tpFilterTrust;
    tpFilterAuthSel=tpFilterAuth;
}

- (void)DSOrderInit{
    arrOrder=[[NSMutableArray alloc]init];
    
    //假数据
    CollectionItemTypeModel *m1=[CollectionItemTypeModel new];
    m1.title=@"排序";
    m1.oid=@"0";
//    CollectionItemTypeModel *m11=[CollectionItemTypeModel new];
//    m11.title=@"全部";
//    m11.oid=StrFromInt(TaskListSearchOrderNone);
//    m11.selected=YES;
    CollectionItemTypeModel *m12=[CollectionItemTypeModel new];
    m12.title=@"临近截稿";
    m12.selected=YES;
    m12.oid=StrFromInt(TaskListSearchOrderEndTime);
    CollectionItemTypeModel *m13=[CollectionItemTypeModel new];
    m13.title=@"价格最高";
    m13.oid=StrFromInt(TaskListSearchOrderMaxCash);
    CollectionItemTypeModel *m14=[CollectionItemTypeModel new];
    m14.title=@"投稿最多";
    m14.oid=StrFromInt(TaskListSearchOrderTotalBids);
    CollectionItemTypeModel *m15=[CollectionItemTypeModel new];
    m15.title=@"最新发布";
    m15.oid=StrFromInt(TaskListSearchOrderCreateTime);
    
    NSMutableArray *aa1=[NSMutableArray arrayWithObjects:m12,m13,m14,m15 ,nil];
    m1.list=aa1;
    
    
    
    [arrOrder addObject:m1];
    
    tpOrder=m12;

}
//重置为初始值
- (void)DSAllReset{
    if (arrTypeI.count) {
        
        tpSubscripI.selected=NO;
        tpSubscripI=arrTypeI.firstObject;;
        tpSubscripI.selected=YES;
        
        arrTypeII=tpSubscripI.list;
        
        tpSubscripII.selected=NO;
        tpSubscripII=nil;
        tpSubscripISel=tpSubscripI;
    }
    
    [self DSFilerReset];
    
    CollectionItemTypeModel *om=arrOrder.firstObject;
    if (om && om.list.count) {
        tpOrder.selected=NO;
        tpOrder=om.list.firstObject;
        tpOrder.selected=YES;
    }
    
}

- (void)DSFilerReset{
    tpFilterTypeSel.selected=NO;
    tpFilterTrustSel.selected=NO;
    tpFilterAuthSel.selected=NO;
    
    if (arrFilter.count>=1) {
        CollectionItemTypeModel *mm=arrFilter[0];
        if (mm && mm.list.count) {
            tpFilterType.selected=NO;
            tpFilterType=mm.list.firstObject;
            tpFilterType.selected=YES;
        }
    }
    if (arrFilter.count>=2) {
        CollectionItemTypeModel *mm=arrFilter[1];
        if (mm && mm.list.count) {
            tpFilterTrust.selected=NO;
            tpFilterTrust=mm.list.firstObject;
            tpFilterTrust.selected=YES;
        }
    }
    if (arrFilter.count>=3) {
        CollectionItemTypeModel *mm=arrFilter[2];
        if (mm && mm.list.count) {
            tpFilterAuth.selected=NO;
            tpFilterAuth=mm.list.firstObject;
            tpFilterAuth.selected=YES;
        }
    }
    
    tpFilterTypeSel=tpFilterType;
    tpFilterTrustSel=tpFilterTrust;
    tpFilterAuthSel=tpFilterAuth;
}
#pragma mark - 选择条件
- (void)research{
    [self menuCloseAction:nil];
    [self refreshData];
}

#pragma mark - BaseTableDataSourceDelegate
- (void)BaseTableDataSourceDelegate:(id)delegate didSelectCellModel:(id)model{
    if (delegate==dsTask) {
        TaskModel *mm=model;
        DLog(@">>> %@",mm.toDictionary);
        
        TaskDetailsVC *vc = [[TaskDetailsVC alloc] initWithNibName:@"TaskDetailsVC" bundle:nil];
        vc.taskBn = mm.task_bn;
        vc.delegatePopVC=self.delegatePopVC;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (delegate == dsType){
        if (tpSubscripI==model) {
            return;
        }
        
        tpSubscripI.selected=NO;
        tpSubscripI=model;
        tpSubscripI.selected=YES;
        
        arrTypeII=tpSubscripI.list;
        dsTypeII.arrData=arrTypeII;
        tblTypeII.dataSource=dsTypeII;
        [tblType reloadData];
        [tblTypeII reloadData];
        
        NSInteger ii=[arrTypeI indexOfObject:tpSubscripI];
        if (NSNotFound != ii && ii == 0) {
            //全部
            tpSubscripII.selected=NO;
            tpSubscripII=nil;
            tpSubscripISel=tpSubscripI;
            tpSubscrip2Sel=tpSubscripI;
            [self research];
        }
//        DLog(@"*** %@ %@",tpSubscripISel,tpSubscripI);
    }
    else if (delegate == dsTypeII){
        if (tpSubscripII==model) {
            return;
        }
        tpSubscripII.selected=NO;
        tpSubscripII=model;
        tpSubscripII.selected=YES;
        tpSubscripISel=tpSubscripI;
        tpSubscrip2Sel=tpSubscripII;
        DLog(@">>> 选择分类: %@",tpSubscripII.toDictionary);
        
        [tblTypeII reloadData];
        
        [self research];
    }

}

- (void)BaseTableDataSourceDelegate:(id)delegate tableViewDidScroll:(UIScrollView *)tableView{
    [txtSearch resignFirstResponder];
}
#pragma mark - BaseCollectionDataSourceDelegate
- (void)BaseCollectionDataSourceDelegate:(SearchColleDataSource*)delegate didSelectItemModel:(CollectionItemTypeModel*)model{
    DLog(@">>> %li %@",[delegate tag],model.toDictionary);
    if (TaskSearchConditionOrder==[delegate tag]) {
        tpOrder.selected=NO;
        tpOrder=model;
        tpOrder.selected=YES;
        [self research];
    }
    if (TaskSearchConditionFilter==[delegate tag]) {
        //把当前条件选择状态去掉，临时显示状态选上
        if ([model.tag isEqualToString:tpFilterType.tag]) {
            tpFilterType.selected=NO;
            tpFilterTypeSel.selected=NO;
            tpFilterTypeSel=model;
            tpFilterTypeSel.selected=YES;
        }
        if ([model.tag isEqualToString:tpFilterTrust.tag]) {
            tpFilterTrust.selected=NO;
            tpFilterTrustSel.selected=NO;
            tpFilterTrustSel=model;
            tpFilterTrustSel.selected=YES;
        }
        if ([model.tag isEqualToString:tpFilterAuth.tag]) {
            tpFilterAuth.selected=NO;
            tpFilterAuthSel.selected=NO;
            tpFilterAuthSel=model;
            tpFilterAuthSel.selected=YES;
        }
        
        [colType reloadData];
    }
}
@end
