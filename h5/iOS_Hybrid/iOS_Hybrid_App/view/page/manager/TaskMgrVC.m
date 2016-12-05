//
//  TaskHomeVC.m
//  cyy_task
//
//  Created by Qingyang on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskMgrVC.h"
#import "TaskMgrHistoryDataSource.h"
#import "TaskMgrFavoDataSource.h"
#import "TaskDetailsVC.h"
static CGFloat kMargin = 6;
@interface TaskMgrVC (){
    UIView *vBlue;
    CGFloat menuW;
    TaskMgrHistoryDataSource *dsTask;
    TaskMgrFavoDataSource *dsFavo;
}

@end
@implementation TaskMgrVC
- (void)viewDidLoad{
    [super viewDidLoad];
    
    taskType=TaskUndertakeTypeAll;
    
    [self tableDataSourceInit];
//    [self showTaskHistory];

    
    [self setupMJHeader];
    [self setupMJFooter];
//    [self showLoading];
    
    if ([QGLOBAL hadAuthToken])
        [self showTaskHistory];
//    [self checkMenuBadges];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [QGLOBAL.menu hideTabBar:NO];
    
    
    
    //判断导航栏效果
    if (seg != nil) {
        if (seg.selectedSegmentIndex==0) {
            //已接需求
            [self.view addSubview:vTask];
            [self.view bringSubviewToFront:vTask];
            
            [self navForHistory];
            
            //刷新已接需求数据
//            if (QGLOBAL.auth)
//                [self refreshDataTask];
        }
        else {
            //我的收藏
            [self.view addSubview:vFavo];
            [self.view bringSubviewToFront:vFavo];
            
            if (isEditing==false) {
                [self navForFavo];
//                [self checkEditStatus];
                //刷新我的收藏数据
//                if (QGLOBAL.auth)
//                    [self refreshDataFavo];
            }
        }
    }
    
    [self checkAuth];
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //页面初始化
    [self pageUI];
 
}


- (void)checkAuth{
    if (![QGLOBAL hadAuthToken]) {
        DLog(@"未登录");
        vBGNoAuth.frame=self.view.bounds;
        vBGNoAuth.backgroundColor=self.view.backgroundColor;
        [self.view addSubview:vBGNoAuth];
        [self.view bringSubviewToFront:vBGNoAuth];
        
        [self showInfoViewLogin:@"您还未登录," image:@"goLogin"];
    }
    else {
        DLog(@"已登录");
        [vBGNoAuth removeFromSuperview];
        [self removeInfoLoginView];
    }
}
#pragma mark - UI
- (void)UIGlobal{
    [super UIGlobal];
    
//    CGRect frm=[UIScreen mainScreen].bounds;
//    self.view.frame=frm;
    
    //导航栏初始化
    [self navForHistory];
    [self addSegToNavbar];

    //颜色
    vBottomBar.backgroundColor=RGBHex(kColorMain001);
    vTableHeader.backgroundColor=RGBHex(kColorGray207);
    lblTblMsg.textColor = RGBHex(kColorGray203);
    tblFavo.backgroundColor=[UIColor clearColor];
    tblTask.backgroundColor=[UIColor clearColor];
    vFavo.backgroundColor=RGBHex(kColorGray207);
    vTask.backgroundColor=RGBHex(kColorGray207);
}


- (void)addSegToNavbar{
    CGRect frm=CGRectMake(0, 0, AutoValue(200), 30);
    seg=[[UISegmentedControl alloc]initWithItems:@[@"已接需求", @"我的收藏"]];

    seg.frame = frm;
    seg.selectedSegmentIndex = 2;
    seg.selectedSegmentIndex = 0; //设置默认选中项
    seg.tintColor = RGBHex(kColorW); //设置选中部分的颜色
    [seg addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    [self naviTitleView:seg];
    
    //显示我的需求列表
    [self.view addSubview:vTask];
    [self.view bringSubviewToFront:vTask];
}

- (void)pageUI{

    CGRect frm=self.view.bounds;
    
    vTask.frame=frm;
    vFavo.frame=frm;
    
    tblFavo.frame=frm;
    
    frm.size.height=45;
    vTaskMenu.frame=frm;
    
    frm.size.height=self.view.height-vTaskMenu.height;
    frm.origin.y=vTaskMenu.height;
    tblTask.frame=frm;
    
    frm.size.height=50;
    frm.origin.y=tblFavo.height-frm.size.height;
    vBottomBar.frame=frm;
    
    vTableHeader.width=self.view.width;
    
    //菜单初始化
    [self taskMenuInit];
    
    [tblTask setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [tblFavo setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];

}


#pragma mark - 投标筛选
- (void)taskMenuInit{
    CGRect frm;
    if (arrMenuBadges==nil) {
        int num=5;
        menuW=vTaskMenu.width/num;
        
        vTaskMenu.backgroundColor=RGBHex(kColorW);
        frm=vTaskMenu.bounds;
        frm.size.height=0.5;
        frm.origin.y=vTaskMenu.height-0.5;
        UIView *sep=[[UIView alloc]initWithFrame:frm];
        sep.backgroundColor=RGBHex(kColorGray206);
        [vTaskMenu addSubview:sep];
        
        
        arrMenuBadges=[[NSMutableArray alloc]initWithCapacity:num];
        
        //菜单
        int i =0;
        while (i<num) {
            
            frm=CGRectMake(0, 0, menuW, vTaskMenu.height);
            frm.origin.x=i*frm.size.width;
            
            UIButton *btn=[[UIButton alloc]initWithFrame:frm];
            btn.titleLabel.font=fontSystem(kFontS28);
            [btn setTitleColor:RGBHex(kColorGray202) forState:UIControlStateNormal];
            [btn setTitleColor:RGBHex(kColorGray211) forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(menuSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn.tag=i;
            switch (i) {
                case 0:
                    [btn setTitle:@"全部" forState:UIControlStateNormal];
                    btn.tag=TaskUndertakeTypeAll;
                    break;
                case 1:
                    [btn setTitle:@"已投标" forState:UIControlStateNormal];
                    btn.tag=TaskUndertakeTypeBidding;
                    break;
                case 2:
                    [btn setTitle:@"已中标" forState:UIControlStateNormal];
                    btn.tag=TaskUndertakeTypeSelected;
                    break;
                case 3:
                    [btn setTitle:@"交付中" forState:UIControlStateNormal];
                    btn.tag=TaskUndertakeTypeDelive;
                    break;
                case 4:
                    [btn setTitle:@"待评价" forState:UIControlStateNormal];
                    btn.tag=TaskUndertakeTypeTo_evaluate;
                    break;
                default:
                    break;
            }
            [vTaskMenu addSubview:btn];
            
            //分割线
            if (i+1 != num) {
                frm=CGRectMake((i+1)*menuW, (vTaskMenu.height-22)/2, 0.5, 22);
                UIView *fg=[[UIView alloc]initWithFrame:frm];
                fg.backgroundColor=RGBHex(kColorGray206);
                [vTaskMenu addSubview:fg];
            }
            
            //角标
            frm=CGRectMake(0, 8, 18, 14);//2位数 18
            frm.origin.x=btn.x+menuW/3*2;
            UILabel *lbl=[[UILabel alloc]initWithFrame:frm];
            lbl.tag=i;
            lbl.layer.cornerRadius=lbl.height/2;
            lbl.layer.borderColor=RGBHex(kColorAuxiliary102).CGColor;//kColorAuxiliary102
            lbl.layer.borderWidth=0.5;
            lbl.textColor=RGBHex(kColorW);
            lbl.backgroundColor=RGBHex(kColorAuxiliary102);
            lbl.text=@"···";
            lbl.font=fontSystem(kFontS20);
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.clipsToBounds=YES;
            lbl.userInteractionEnabled=NO;
            lbl.hidden=YES;
            [vTaskMenu addSubview:lbl];
            [arrMenuBadges addObject:lbl];
            i++;
        }
        
        frm=CGRectMake(kMargin, sep.y-1, menuW-kMargin*2, 1);
        vBlue=[[UIView alloc]initWithFrame:frm];
        vBlue.backgroundColor=RGBHex(kColorMain001);
        [vTaskMenu addSubview:vBlue];
    }
}


- (void)navForHistory{
    [QGLOBAL.menu hideTabBar:NO];
    
    if (QGLOBAL.navAvatar==nil) {
        //如果没登录
        [self naviLeftButtonImage:[UIImage imageNamed:@"Default_avatar"] highlighted:[UIImage imageNamed:@"Default_avatar"] action:@selector(navLeftAction:)];
        
    }
    else {
        //如果登录，这里要换头像图片
        [self naviLeftButtonImage:QGLOBAL.navAvatar highlighted:QGLOBAL.navAvatar action:@selector(navLeftAction:)];
    }

    [self naviRightButton:@"" action:nil];
    
    
}

- (void)navForFavo{
    if (QGLOBAL.navAvatar==nil) {
        //如果没登录
        [self naviLeftButtonImage:[UIImage imageNamed:@"Default_avatar"] highlighted:[UIImage imageNamed:@"Default_avatar"] action:@selector(navLeftAction:)];
        
    }
    else {
        //如果登录，这里要换头像图片
        [self naviLeftButtonImage:QGLOBAL.navAvatar highlighted:QGLOBAL.navAvatar action:@selector(navLeftAction:)];
    }
    
    if (arrDataFavo.count)
        [self naviRightButton:@"编辑" action:@selector(navEditAction:)];
    else
        [self naviRightButton:@"" action:nil];
    
    vBottomBar.hidden=YES;
    
    [QGLOBAL.menu hideTabBar:NO];
    
    isEditing=false;
    [self checkEditStatus];
}

- (void)navForAllSelection{
    [self naviLeftButton:@"全选" action:@selector(navAllAction:)];
    [self naviRightButton:@"取消" action:@selector(navCancelAction:)];
    
    vBottomBar.hidden=NO;
    
    CGRect frm;
    frm=vFavo.bounds;
    frm.size.height=50;
    frm.origin.y=tblFavo.height-frm.size.height;
    vBottomBar.frame=frm;
}


#pragma mark - table
- (void)tableDataSourceInit{
    dsTask=[[TaskMgrHistoryDataSource alloc]init];
    dsFavo=[[TaskMgrFavoDataSource alloc]init];
    
    dsTask.delegate=self;
    dsFavo.delegate=self;
    
    dsTask.delegateNav=[QGLOBAL.mainFrame navigationController];
    dsTask.hidesPopNav=YES;
    
    arrSelected=[NSMutableArray new];
    dsFavo.arrSelected=arrSelected;
    
    tblTask.delegate=dsTask;
    tblTask.dataSource=dsTask;
    
    tblFavo.delegate=dsFavo;
    tblFavo.dataSource=dsFavo;
}
#pragma mark - 上下拉刷新
- (void)setupMJHeader {
    headerMJTask = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshListTask)];
    [headerMJTask setTitle:@"松开即可刷新" forState:MJRefreshStateIdle];
    tblTask.header = headerMJTask;
    headerMJTask.stateLabel.textColor = RGBHex(kColorGray201);
    headerMJTask.stateLabel.font = fontSystem(kFontS26);
    headerMJTask.lastUpdatedTimeLabel.textColor = RGBHex(kColorGray203);
    headerMJTask.lastUpdatedTimeLabel.font = fontSystem(kFontS20);
    
    headerMJFavo = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshListFavo)];
    [headerMJFavo setTitle:@"松开即可刷新" forState:MJRefreshStateIdle];
    tblFavo.header = headerMJFavo;
    headerMJFavo.stateLabel.textColor = RGBHex(kColorGray201);
    headerMJFavo.stateLabel.font = fontSystem(kFontS26);
    headerMJFavo.lastUpdatedTimeLabel.textColor = RGBHex(kColorGray203);
    headerMJFavo.lastUpdatedTimeLabel.font = fontSystem(kFontS20);
}

- (void)refreshDataTask{
//    [self tableTaskFrame];
    
    [headerMJTask beginRefreshing];
}

- (void)refreshDataFavo{
    [headerMJFavo beginRefreshing];
}

- (void)setupMJFooter
{
    footerMJTask = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getListNextTask)];
    
    [footerMJTask endRefreshingWithNoMoreData];
    [footerMJTask setTitle:@"" forState:MJRefreshStateIdle];
    
    tblTask.footer = footerMJTask;
    
    footerMJFavo = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getListNextFavo)];
    
    [footerMJFavo endRefreshingWithNoMoreData];
    [footerMJFavo setTitle:@"" forState:MJRefreshStateIdle];
    
    tblFavo.footer = footerMJFavo;
}
#pragma mark - 获取数据
- (void)refreshListTask{
    pageTask = 0;
    [TaskAPI TakeTaskList:nil type:taskType offset:pageTask success:^(NSMutableArray *arr) {
        if (arr.count) {
            [tblTask setTableHeaderView:nil];
            DLog(@"%@",arr.firstObject);
        }
        arrDataTask=[arr mutableCopy];
        dsTask.arrData=arrDataTask;
        dsTask.myTaskEnabled=YES;
        [tblTask reloadData];
        
        [self didLoad];
        [tblTask.header endRefreshing];
    } failure:^(NetError *err) {
        if (err.errStatusCode==13862) {
            DLog(@">>> 无数据 TakeTaskList");
            [self noTaskHistory];
            return ;
        }
        [self didLoad];
        [tblTask.header endRefreshing];
        
        [self showText:err.errMessage];
    }];
    
}

- (void)refreshListFavo{
    pageFavo = 0;
    [TaskAPI FavoTaskList:nil offset:pageFavo success:^(NSMutableArray *arr) {
        if (arr.count) {
            [tblFavo setTableHeaderView:nil];
            
        }
        arrDataFavo=[arr mutableCopy];
        dsFavo.arrData=arrDataFavo;
        [tblFavo reloadData];
        
        [self didLoad];
        [tblFavo.header endRefreshing];
        
        [self navForFavo];
    } failure:^(NetError *err) {
        if (err.errStatusCode==13862) {
            DLog(@">>> 无数据 noFavoList");
            [arrDataFavo removeAllObjects];
            [self noFavoList];
            return ;
        }
        [self didLoad];
        [tblFavo.header endRefreshing];
        
        [self showText:err.errMessage];
    }];
    
}

- (void)getListNextTask
{
    pageTask ++;
    [TaskAPI TakeTaskList:nil type:taskType offset:pageTask success:^(NSMutableArray *arr) {
        [arrDataTask addObjectsFromArray:arr];
        
        [self didLoad];
        [tblTask.footer endRefreshing];
        
        footerMJTask.automaticallyHidden = YES;
        if (arr.count == 0) {
            [footerMJTask endRefreshingWithNoMoreData];
        }
        
        dsTask.arrData=arrDataTask;
        [tblTask reloadData];
        
    } failure:^(NetError *err) {
        [tblTask.footer endRefreshing];
        if (err.errStatusCode==13862) {
            DLog(@">>> 无数据 ");
            tblTask.footer.automaticallyHidden = YES;
            [tblTask.footer endRefreshingWithNoMoreData];
            return ;
        }
        [footerMJTask setTitle:@"" forState:MJRefreshStateIdle];
        [self showText:err.errMessage];
        
//        [footerMJTask setTitle:@"" forState:MJRefreshStateIdle];
//        [tblTask.footer endRefreshing];
//        [self showText:err.errMessage];
    }];

}

- (void)getListNextFavo
{
    pageFavo ++;
    [TaskAPI FavoTaskList:nil offset:pageFavo success:^(NSMutableArray *arr) {
        [arrDataFavo addObjectsFromArray:arr];
        
        [self didLoad];
        [tblFavo.footer endRefreshing];
        
        footerMJFavo.automaticallyHidden = YES;
        if (arr.count == 0) {
            [footerMJFavo endRefreshingWithNoMoreData];
        }
        
        dsFavo.arrData=arrDataFavo;
        [tblFavo reloadData];
        
    } failure:^(NetError *err) {
        [tblFavo.footer endRefreshing];
        if (err.errStatusCode==13862) {
            DLog(@">>> 无数据 ");
            tblFavo.footer.automaticallyHidden = YES;
            [tblFavo.footer endRefreshingWithNoMoreData];
            return ;
        }
        [footerMJFavo setTitle:@"" forState:MJRefreshStateIdle];
        [self showText:err.errMessage];
        
//        [footerMJFavo setTitle:@"" forState:MJRefreshStateIdle];
//        [tblFavo.footer endRefreshing];
//        [self showText:err.errMessage];
    }];
    
}
#pragma mark - 状态
- (void)noLogin{
    
}
- (void)noTaskHistory{
    [tblFavo setTableHeaderView:nil];
    [tblTask setTableHeaderView:vTableHeader];
    lblTblMsg.text=Msg_NoTaskHistory;
    
    [TaskAPI PreferTaskList:nil offset:0 success:^(NSMutableArray *arr) {
        
        
        arrPrefer=[arr mutableCopy];
        dsTask.arrData=arrPrefer;
        dsTask.myTaskEnabled=NO;
        [tblTask reloadData];
        
        [self didLoad];
        [tblTask.header endRefreshing];
        
        footerMJTask.automaticallyHidden = YES;
        [footerMJTask endRefreshingWithNoMoreData];
    } failure:^(NetError *err) {
        [self didLoad];
        [tblTask.header endRefreshing];
        
//        [self showText:err.errMessage];
    }];
}

- (void)noFavoList{
    [self navForFavo];
    
    [tblTask setTableHeaderView:nil];
    [tblFavo setTableHeaderView:vTableHeader];
    lblTblMsg.text=Msg_NoFavoHistory;
    
    [TaskAPI PreferTaskList:nil offset:0 success:^(NSMutableArray *arr) {
        
        
        arrPrefer=[arr mutableCopy];
        dsFavo.arrData=arrPrefer;
        [tblFavo reloadData];
        
        [self didLoad];
        [tblFavo.header endRefreshing];
        
        footerMJFavo.automaticallyHidden = YES;
        [footerMJFavo endRefreshingWithNoMoreData];
    } failure:^(NetError *err) {
        [self didLoad];
        [tblFavo.header endRefreshing];
        
        //        [self showText:err.errMessage];
    }];
}

- (void)showTaskHistory{
 
    
    //检查是否有数据，没有拉推荐数据
    if (arrDataTask.count==0) {
        [self showLoading];
        [self refreshListTask];
//        [self refreshDataTask];
    }
    
    //如果数据，加载数据
//    if (1) {
//        [self noTaskHistory];
//    }
    
    //刷新数据
//    [tblTask reloadData];
}

- (void)showFavoList{
    
    
    if (arrDataFavo.count==0) {
        [self showLoading];
        [self refreshListFavo];
    }
    
//    [tblFavo reloadData];
//    if (1) {
//        [self noFavoList];
//    }
}

- (void)checkMenuBadges{
    for (UILabel *lbl in arrMenuBadges) {
        lbl.hidden=YES;
    }
}
#pragma mark - action
- (IBAction)navLeftAction:(id)sender{
//    DLog(@">>>menu list");
    [QGLOBAL.mainFrame showLeftView];
}

- (IBAction)navEditAction:(id)sender{
    isEditing=true;
    [QGLOBAL.menu hideTabBar:YES];
    [self navForAllSelection];
    [self checkEditStatus];
}

- (IBAction)navAllAction:(id)sender{
    [arrSelected removeAllObjects];
    for (TaskModel* mm in arrDataFavo) {
        mm.selected=YES;
        [arrSelected addObject:mm];
    }
    
    [tblFavo reloadData];
}

- (IBAction)navCancelAction:(id)sender{
//    isEditing=false;
    [self navForFavo];
//    [self checkEditStatus];
}

- (IBAction)segAction:(id)sender{
    if (![QGLOBAL hadAuthToken]) return;

    
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl * segment = sender;
        if (segment.selectedSegmentIndex == 0) {
            [tblTask.header endRefreshing];
            [self navForHistory];
            

            [self.view addSubview:vTask];
            [self.view bringSubviewToFront:vTask];
            
            [self showTaskHistory];
            
            //statusbar触发返回顶部
            tblTask.scrollsToTop=YES;
            tblFavo.scrollsToTop=NO;
            
        }
        else if (segment.selectedSegmentIndex == 1) {
            [tblFavo.header endRefreshing];
            [self navForFavo];


            [self.view addSubview:vFavo];
            [self.view bringSubviewToFront:vFavo];
            
            [self showFavoList];
            
            //statusbar触发返回顶部
            tblTask.scrollsToTop=NO;
            tblFavo.scrollsToTop=YES;
        }
    }
}

- (IBAction)menuSelectedAction:(id)sender{
    UIButton *btn=sender;
    taskType = btn.tag;

    [MobClick event:UMMgrTaskMenu attributes:@{@"type":StrFromInt(taskType)}];
    
    [UIView animateWithDuration:0.05*(taskType+1) animations:^{
        vBlue.x=taskType*menuW+kMargin;
    } completion:^(BOOL finished) {
        arrDataTask=nil;
        [tblTask reloadData];
        
        [self refreshDataTask];
    }];
}
- (IBAction)delAction:(id)sender{
    DLog(@">>> del:%@",arrSelected);
    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:arrSelected.count];
    for (TaskModel* mm in arrSelected) {
        [tmp addObject:StrFromObj(mm.task_bn)];
    }
    
    [self showLoading];
    [TaskAPI FavorDeleteTaskBn:tmp success:^(id model) {
//        Taskmodel.favored.task = [NSNumber numberWithInt:0];
        [arrDataFavo removeObjectsInArray:arrSelected];
        [arrSelected removeAllObjects];
       
        [self didLoad];
        [self navForFavo];
        [self refreshDataFavo];
    } failure:^(NetError* err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
        [self showText:err.errMessage];
    }];
}
#pragma mark - history

#pragma mark - favo
- (void)checkEditStatus{
    if (isEditing==false) {
        for (TaskModel* mm in arrSelected) {
            mm.selected=NO;
        }
        [arrSelected removeAllObjects];
    }
    dsFavo.selectionEnabled=isEditing;
    [tblFavo reloadData];
}
#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    [super getNotifType:type data:data target:obj];
    if (type == NotifLoginSuccess){
        //login
        [self viewWillAppear:NO];
        
        //判断导航栏效果
        if (seg != nil) {
            if (seg.selectedSegmentIndex==0) {
                //已接需求
                [self showTaskHistory];
            }
            else {
                //我的收藏
                [self showFavoList];
            }
        }
        
//        if ([QGLOBAL object:data isClass:[UIImage class]]) {
//            
//        }
        
    }
    if (type == NotifQuitOut){
        //logout
        [self viewWillAppear:NO];
    }
}

- (IBAction)btnTest:(id)sender {
    TaskDetailsVC *vc = [[TaskDetailsVC alloc] initWithNibName:@"TaskDetailsVC" bundle:nil];
    vc.delegatePopVC=self.delegatePopVC;
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
}

#pragma mark - BaseTableDataSourceDelegate
- (void)BaseTableDataSourceDelegate:(id)delegate didSelectCellModel:(TaskModel*)model{
    
    DLog(@">>> %@",model.toDictionary);
    TaskDetailsVC *vc = [[TaskDetailsVC alloc] initWithNibName:@"TaskDetailsVC" bundle:nil];
    vc.taskBn = model.task_bn;
    vc.hidesPopNav=YES;
    vc.delegatePopVC=self.delegatePopVC;
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
//    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
