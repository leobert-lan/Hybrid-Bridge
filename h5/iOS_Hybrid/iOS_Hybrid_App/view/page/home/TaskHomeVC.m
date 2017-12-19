//
//  TaskHomeVC.m
//  cyy_task
//
//  Created by Qingyang on 16/7/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskHomeVC.h"
#import "SearchHistoryVC.h"
#import "TaskListVC.h"
#import "BannersVC.h"
#import "SDCycleScrollView.h"
#import "QYRollingLbl.h"
#import "ActivityCmtListVC.h"
//#import "CNIDCheck.h"
@interface TaskHomeVC ()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *banners;
    QYRollingLbl *msgRolling;
}
@end

@implementation TaskHomeVC
//- (void)insatance:(id)aInstance sel:(SEL)aSelector{
//    //需要启动aInstance中的方法aSelector
//    if (aInstance && aSelector) {
//        IMP imp = [aInstance methodForSelector:aSelector];
////        imp();
//        void (*func)(id, SEL) = (void *)imp;
//        func(aInstance, aSelector);
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DLog(@"^^^^ %@ %@",[QGLOBAL dateToTimeInterval:[NSDate date]],[QGLOBAL dateFromTimeInterval:@"843899201"]);
//    NSString *ss=@"-`=[]{};',./~!@#$%^&*()_+|:\"<>?";
//    DLog(@"00000 %@:%i %i %i",ss,[QGLOBAL isContainsEmoji:ss],[QGLOBAL isContainsEmoji:@"1234567890"],[QGLOBAL isContainsEmoji:@"中文密码😄😄"]);
    [self rollingStart];
    
    [self setupMJHeader];
    [self setupMJFooter];
//    [self showLoading];
    [self refreshList];
    
//    [CNIDCheck isChineseIdNo:@"1"];
}

- (void)UIGlobal{
    [super UIGlobal];
    
    
    //导航栏搜索框
//    [self naviRightZero];
    [self naviSearchView];
    
//    CGRect frm;
//    vHeader.height=APP_W;//AutoValue(310);
    vBanners.height=APP_W/2;//长宽比 2:1;
    
    vChannel.height=AutoValue((170/2));
    vChannel.y=CGRectGetMaxY(vBanners.frame);
    
    vMsg.height=AutoValue((50/2));
    vMsg.y=CGRectGetMaxY(vChannel.frame);
    
    vTitle.height=45;//vHeader.height-1-CGRectGetMaxY(vMsg.frame);
    vTitle.y=CGRectGetMaxY(vMsg.frame);
    vHeader.height=vBanners.height+vChannel.height+vMsg.height+vTitle.height+1;
    
    vBanners.backgroundColor=RGBHex(kColorGray205);
    vMsg.backgroundColor=RGBHex(kColorGray207);
    vHeader.backgroundColor=RGBHex(kColorGray206);
    vTitle.backgroundColor=RGBHex(kColorW);
    
    btnSubscription.y=(vTitle.height-btnSubscription.height)/2;
    btnSubscription.layer.cornerRadius=2;
    btnSubscription.layer.borderWidth=0.5;
    btnSubscription.layer.borderColor=RGBHex(kColorMain001).CGColor;
    [btnSubscription setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    [btnSubscription setTitleColor:RGBHex(kColorAuxiliary103) forState:UIControlStateHighlighted];
    
    [self channelInit];
    [self bannerInit];
    [self rollingMessageInit];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [QGLOBAL.menu hideTabBar:NO];
    
    //订阅
    btnSubscription.hidden=NO;

    
    if (QGLOBAL.navAvatar==nil) {
        //如果没登录
        [self naviLeftButtonImage:[UIImage imageNamed:@"Default_avatar"] highlighted:[UIImage imageNamed:@"Default_avatar"] action:@selector(navLeftAction:)];
        
    }
    else {
        //如果登录，这里要换头像图片
//        DLog(@"*** home头像 %@",NSStringFromCGSize(QGLOBAL.navAvatar.size));
        [self naviLeftButtonImage:QGLOBAL.navAvatar highlighted:QGLOBAL.navAvatar action:@selector(navLeftAction:)];
    }
    
    
}

//频道菜单
- (void)channelInit{
    btnTaskHot.y=0;
    btnTaskRich.y=btnTaskHot.y;
    btnTasks.y=btnTaskHot.y;
    
    btnTaskHot.height=vChannel.height;
    btnTaskRich.height=vChannel.height;
    btnTasks.height=vChannel.height;
    
    btnTaskHot.width=60;
    btnTaskRich.width=btnTaskHot.width;
    btnTasks.width=btnTaskHot.width;
    
    CGFloat ww=APP_W/3;
    CGFloat mg=(ww-btnTaskHot.width)/2;
    
    btnTaskHot.x=mg;
    btnTaskRich.x=ww+mg;
    btnTasks.x=ww*2+mg;
    
    UIEdgeInsets egImg=UIEdgeInsetsMake(AutoValue(-18), 10, 0, 0);
    UIEdgeInsets egTtl=UIEdgeInsetsMake(AutoValue(48), -40, 0, 0);
    
    [btnTaskHot setImageEdgeInsets:egImg];
    [btnTaskHot setTitleEdgeInsets:egTtl];
    
    [btnTaskRich setImageEdgeInsets:egImg];
    [btnTaskRich setTitleEdgeInsets:egTtl];
    
    [btnTasks setImageEdgeInsets:egImg];
    [btnTasks setTitleEdgeInsets:egTtl];
    
    
    btnTaskHot.backgroundColor=[UIColor clearColor];
    btnTaskRich.backgroundColor=[UIColor clearColor];
    btnTasks.backgroundColor=[UIColor clearColor];
    
    [btnTaskHot addTarget:self action:@selector(hotTaskAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnTaskRich addTarget:self action:@selector(richTaskAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnTasks addTarget:self action:@selector(tasksAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    CGRect frm=CGRectMake(APP_W/3, 10, 0.5, vChannel.height-20);
    UIView *sp1=[[UIView alloc]initWithFrame:frm];
    sp1.backgroundColor=RGBHex(kColorGray206);
    [vChannel addSubview:sp1];
    
    UIView *sp2=[[UIView alloc]initWithFrame:frm];
    sp2.backgroundColor=RGBHex(kColorGray206);
    sp2.x *= 2;
    [vChannel addSubview:sp2];
}

//广告
- (void)bannerInit{
    if (banners) {
        return;
    }
    
    banners = [SDCycleScrollView cycleScrollViewWithFrame:vBanners.bounds delegate:self placeholderImage:nil];
    banners.width=APP_W;
    banners.currentPageDotImage = [UIImage imageNamed:@"v1011_drawable_icon_dot_selected"];//v1011_drawable_icon_dot_selected pageControlCurrentDot
    banners.pageDotImage = [UIImage imageNamed:@"v1011_drawable_icon_dot_defout"];
//    banners.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
//    banners.imageURLStringsGroup = imagesURLStrings;
    
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    banners.autoScrollTimeInterval = 3.0;
    
    [vBanners addSubview:banners];
    
    
    [self loadBanners];
    /*
    NSArray *imagesURLStrings = @[
                                  @"http://static.vsochina.com/data/uploads/2016/07/28/9189474885799a7d94fc66.jpg",
                                  @"http://static.vsochina.com/data/uploads/2016/04/22/1205954082571979428a881.jpg",
                                  @"http://static.vsochina.com/data/uploads/2016/06/22/1464280084576a4e448b6f7.jpg",
                                  @"http://static.vsochina.com/data/uploads/2016/06/30/12404070185774dd7f3bfb6.jpg",
                                  @"http://static.vsochina.com/data/uploads/2016/06/29/122600357457739fc3f0766.jpg"
                                  
                                  ];
    */
    
}

- (void)loadBanners{
    [OtherAPI BannersWithLimit:4 success:^(NSMutableArray *arr) {
        arrBannes=arr;
        NSMutableArray *imagesURLStrings=[[NSMutableArray alloc]initWithCapacity:arr.count];
        for (BannerModel *mm in arrBannes) {
            [imagesURLStrings addObject:mm.image];
        }
        
        //        banners = [SDCycleScrollView cycleScrollViewWithFrame:vBanners.bounds delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //        banners.width=APP_W;
        //        banners.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        //        //    banners.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        //        banners.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        banners.imageURLStringsGroup = imagesURLStrings;
        
        //         --- 轮播时间间隔，默认1.0秒，可自定义
        //        banners.autoScrollTimeInterval = 3.0;
        //
        //        [vBanners addSubview:banners];
    } failure:^(NetError *err) {
        
    }];
}

//跑马灯
- (void)rollingMessageInit{
    if (msgRolling) {
        return;
    }
    
    msgRolling=[[QYRollingLbl alloc]init];
    
    CGRect frm=vMsg.bounds;
    frm.origin.x=45;
    frm.size.width=APP_W;
    
    msgRolling.frame=frm;
    
    
    [vMsg addSubview:msgRolling];
    
//    msgRolling.backgroundColor=[UIColor yellowColor];
//    [self rollingMessageAttributedText];
}

- (void)rollingStart{
    [OtherAPI RollingWithOffset:0 success:^(NSMutableArray *arr) {
//        DLog(@">>>%@",arr);
        NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:arr.count];
        for (TaskSimpleModel* mm in arr) {
            UILabel *lbl_name=[self rollingMessage:mm.username color:RGBHex(kColorGray203)];
            [list addObject:lbl_name];
            UILabel *lbl_text=[self rollingMessage:@"中标了" color:RGBHex(kColorAuxiliary101)];
            [list addObject:lbl_text];
            UILabel *lbl_title=[self rollingMessage:mm.title color:RGBHex(kColorGray203)];
            [list addObject:lbl_title];
            UILabel *lbl_real_cash=[self rollingMessage:mm.real_cash color:RGBHex(kColorAuxiliary101)];
            [list addObject:lbl_real_cash];
        }
        msgRolling.arrLabels=list;
        
        [msgRolling start];
    } failure:^(NetError *err) {
        
    }];
    
}

- (UILabel *)rollingMessage:(NSString*)str color:(UIColor*)color{
    // 设置组
    NSArray *array = @[// 全局设置
                       [ConfigAttributedString font:[UIFont systemFontOfSize:10.f] range:[str range]],
                       [ConfigAttributedString foregroundColor:color range:[str range]],
                       ];
    
    // 初始化富文本
    UILabel *label       = [[UILabel alloc] initWithFrame:vMsg.bounds];
    label.numberOfLines  = 0;

    label.attributedText = [str createAttributedStringAndConfig:array];
 
    return label;
}

- (UILabel *)rollingMessageAttributed:(NSString*)str{
    // 设置组
    NSArray *array = @[// 全局设置
      [ConfigAttributedString font:[UIFont systemFontOfSize:10.f] range:[str range]],
//      [ConfigAttributedString paragraphStyle:[self style]         range:[str range]],
      
      // 局部设置
      [ConfigAttributedString foregroundColor:[UIColor redColor]
                                        range:[@":" rangeFrom:str]],
      [ConfigAttributedString font:[UIFont systemFontOfSize:14.f]
                             range:[@":" rangeFrom:str]]];
    
    // 初始化富文本
    UILabel *label       = [[UILabel alloc] initWithFrame:vMsg.bounds];
    label.numberOfLines  = 0;
    label.attributedText = [str createAttributedStringAndConfig:array];
//    label.backgroundColor=RGBAHex(kColorMain001, .5);
    return label;
}

// 段落样式
- (NSMutableParagraphStyle *)style
{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing              = 10.f;
    style.firstLineHeadIndent      = 10.f;
    
    return style;
}
#pragma mark - 检查活动
- (BOOL)isBannerActivity:(NSString*)url{
    if ([url isEqualToString:@"http://m.vsochina.com/activity/likeapp"]) {//
        ActivityCmtListVC *vc=[[ActivityCmtListVC alloc]initWithNibName:@"ActivityCmtListVC" bundle:nil];
        vc.hidesPopNav=YES;
     
//        vc.title=@"详情";
        if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
            [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
            [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
        }
        return YES;
    }
    return false;
}
#pragma mark - 检查订阅
- (void)checkSubscription{
    

//    DLog(@"--- checkSubscription %@",QGLOBAL.usermodel.toDictionary);
//    btnSubscription.hidden=YES;
//    if ([QGLOBAL hadAuthToken]) {
//        btnSubscription.hidden=NO;;
//    }
//    if (StrIsEmpty(QGLOBAL.usermodel.indus_name) || StrIsEmpty(QGLOBAL.usermodel.lable)) {
//        btnSubscription.hidden=NO;
//    }else{
//        
//    }
}
#pragma mark - 猜你喜欢需求列表
- (void)preferList{
    page = 0;
    [TaskAPI PreferTaskList:nil offset:page success:^(NSMutableArray *arr) {
        arrData=arr;
        [self.tableMain reloadData];
        [self didLoad];
        [self.tableMain.header endRefreshing];
    } failure:^(NetError *err) {
        [self didLoad];
        [self.tableMain.header endRefreshing];
        
        if (err.errStatusCode==13862) {
            DLog(@">>> 猜你喜欢需求列表 无数据 ");
            
            return ;
        }
        
        
        [self showText:err.errMessage];
    }];
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
    [self preferList];
    [self rollingStart];
    [self loadBanners];
}

- (void)getListNext
{
    page ++;
    [TaskAPI PreferTaskList:nil offset:page  success:^(NSMutableArray *arr) {
        
        [arrData addObjectsFromArray:arr];
        
        [self didLoad];
        [self.tableMain.footer endRefreshing];
        
        footerMJ.automaticallyHidden = YES;
        if (arr.count == 0) {
            [footerMJ endRefreshingWithNoMoreData];
        }
        
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
#pragma mark - 导航栏文字按钮
- (id)naviSearchView{
    UIView* aView=[[UIView alloc]init];
    float ww=APP_W-70;
    CGRect frm=CGRectMake(0, 0, ww, 44);//self.navigationController.navigationBar.bounds;
    aView.frame=frm;
    aView.backgroundColor=[UIColor clearColor];
    
    frm.size.width-=15;
    frm.size.height=30;
//    frm.origin.x=15;
    frm.origin.y=(aView.height-frm.size.height)/2;
    UIButton *btn=[[UIButton alloc]initWithFrame:frm];
    btn.backgroundColor=RGBHex(kColorW);
    btn.layer.cornerRadius=btn.height/2;
    btn.clipsToBounds=YES;
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:btn];

    [self.navigationItem setTitleView:aView];
    
    return aView;
}
#pragma mark - action
- (IBAction)navLeftAction:(id)sender{
 
    [QGLOBAL.mainFrame showLeftView];
}

- (IBAction)searchAction:(id)sender{
    [MobClick event:UMHomeSearchBar];
    
    SearchHistoryVC *vc=[QGLOBAL viewControllerName:@"SearchHistoryVC" storyboardName:@"Search"];
//    [[SearchHistoryVC alloc]initWithNibName:@"SearchHistoryVC" bundle:nil];
    vc.hidesPopNav=YES;
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tasksAction:(id)sender{
    [MobClick event:UMHomeTaskHouse];
    SearchListVC *vc=[[SearchListVC alloc]initWithNibName:@"SearchListVC" bundle:nil];
    vc.hidesPopNav=YES;
//    [self.navigationController pushViewController:vc animated:YES];
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
}

- (IBAction)hotTaskAction:(id)sender{
    [MobClick event:UMTaskHot];
    TaskListVC *vc=[[TaskListVC alloc]initWithNibName:@"TaskListVC" bundle:nil];
    vc.hidesPopNav=YES;
    vc.taskStyle=TaskListStyleHot;
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
}

- (IBAction)richTaskAction:(id)sender{
    [MobClick event:UMTaskRich];
    TaskListVC *vc=[[TaskListVC alloc]initWithNibName:@"TaskListVC" bundle:nil];
    vc.hidesPopNav=YES;
    vc.taskStyle=TaskListStyleRich;
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
}

- (IBAction)subscriAciton:(id)sender{
    
    [self hybrid];
    return;
    ////测试

    if ([QGLOBAL hadAuthToken]) {
        [MobClick event:UMSubscrFromHome];
        
        SubscripNewVC *vc=[[SubscripNewVC alloc]initWithNibName:@"SubscripNewVC" bundle:nil];
        
        vc.delegate=self;
        vc.delegatePopVC=QGLOBAL.mainFrame;
        vc.hidesPopNav=YES;
        
        if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
            [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
            [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
        }
    }
    else {
        loginVC *vc=[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
        vc.backButtonEnabled=YES;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
    }
    

}
#pragma mark - TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString *tableID;
    
    if (row<arrData.count) {
        TaskModel * mm=[arrData objectAtIndex:row];
        
        BaseTableCell *cell;
        tableID = @"TaskCell";
        
        cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] firstObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        cell.delegate=self;
        [cell setCell:mm];
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    return nil;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    if (row<arrData.count) {
        TaskModel * mm=[arrData objectAtIndex:row];
        
        TaskDetailsVC *vc = [[TaskDetailsVC alloc] initWithNibName:@"TaskDetailsVC" bundle:nil];
        vc.taskBn = mm.task_bn;
        vc.hidesPopNav=YES;
        vc.delegatePopVC=self.delegatePopVC;
        if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
            [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
            [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
        }
//        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    [super getNotifType:type data:data target:obj];
    if (type == NotifLoginSuccess){
        //login
        
        if ([QGLOBAL object:data isClass:[UIImage class]]) {
            [self viewWillAppear:NO];
        }
        
    }
    if (type == NotifQuitOut){
        //logout

        [self viewWillAppear:NO];
    }
    if (type == NotifUserInfo) {
        [self checkSubscription];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    DLog(@"---点击了第%ld张图片", (long)index);
    if (index<arrBannes.count) {
        BannerModel *mm=arrBannes[index];
        if ([self isBannerActivity:mm.link]) {
            return;
        }
        BannersVC *vc=[[BannersVC alloc]initWithNibName:@"BannersVC" bundle:nil];
//        HybridAppVC *vc=[[HybridAppVC alloc]initWithNibName:@"HybridAppVC" bundle:nil];
        vc.hidesPopNav=YES;
        vc.link=mm.link;
        vc.title=@"详情";
        if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
            [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
            [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
        }
    }
    
}

#pragma mark - 混合开发
- (void)hybrid{
    HybridAppVC *vc=[[HybridAppVC alloc]initWithNibName:@"HybridAppVC" bundle:nil];
    vc.hidesPopNav=YES;
   
    vc.title=@"混合开发调试";
    if (QGLOBAL.mainFrame && [QGLOBAL.mainFrame navigationController]) {
        [[QGLOBAL.mainFrame navigationController] setNavigationBarHidden:NO animated:NO];
        [[QGLOBAL.mainFrame navigationController] pushViewController:vc animated:NO];
    }
}
@end
