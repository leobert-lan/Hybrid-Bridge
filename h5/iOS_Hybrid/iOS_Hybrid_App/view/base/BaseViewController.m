 //
//  basePage.m
//  Show
//
//  Created by YAN Qingyang on 15-2-11.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "loginVC.h"
static float kTopBarItemWidth = 48;
static float kTopBarItemHeight = 40;
static float kTopBarItemInsetsMargin = 12;
static float kTopBarItemFixMargin = -20;
//static float kTopBtnMargin = -16.f;

@interface BaseViewController ()
{
    UIView *vQLog;
    
    UITextView *txtQLog;
    
}
@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //友盟统计：进入页面
    [MobClick beginLogPageView:StrFromObj([self class])];
    
    if (self.navigationController.viewControllers.count<=1 && _backButtonEnabled == NO) {
        return;
    }
    else [self naviBackButton];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //友盟统计：离开页面
    [MobClick endLogPageView:StrFromObj([self class])];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self UIGlobal];
    [self setupGesture];

    /**
     *  如果不要显示头部的下拉刷新，添加header              `              Hidden=YES;
     */
    //self.tableMain.headerHidden=YES;
    
    //    self.tableMain.dataSource = self;
    //    self.tableMain.delegate = self;
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self naviTitleView:nil];
    
    
//    DLog(@"###2 %@ %@",[self class],NSStringFromCGRect(self.view.bounds));
}

- (void)dealloc {
    self.tableMain.delegate = nil;
}




#pragma mark - 滑动返回上一页
- (void)setupGesture
{
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (self.navigationController.viewControllers.count<=1 && _backButtonEnabled == NO) {
            return;
        }
        else
            [self popVCAction:nil];
        
//        if(self.navigationController.viewControllers.count > 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    }
}
#pragma mark - 全局界面UI
- (void)UIGlobal{
    [super UIGlobal];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.view.backgroundColor=RGBHex(kColorGray207);
    
//    if (self.hidesBottomBarWhenPushed==YES) {

//        [QGLOBAL.menu hideTabBar:YES];
//    }
//    [QGLOBAL.menu hideTabBar:self.hidesMenu];
    
    if (self.tableMain==nil) {
        self.tableMain=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    
    _tableMain.backgroundColor=RGBAHex(0x000000, 0);
    _tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
//    if (self.searchTableView==nil) {
//        self.searchTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    }
//    
//    _searchTableView.backgroundColor=RGBAHex(0x000000, 0);
//    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableMain.allowsSelection = NO;
    
//    [self.tableMain addHeaderWithTarget:self action:@selector(headerRereshing)];
//    [self.tableMain addFooterWithTarget:self action:@selector(footerRereshing)];
//    
//    self.tableMain.footerPullToRefreshText = kWarning6;
//    self.tableMain.footerReleaseToRefreshText = kWarning7;
//    self.tableMain.footerRefreshingText = kWarning9;
}

#pragma mark - table 刷新
- (void)headerRereshing{
    
}

- (void)footerRereshing{
    
}



#pragma mark - 导航返回按钮自定义
- (void)naviBackButton
{
    [self naviLeftButtonImage:[UIImage imageNamed:@"fanh"] highlighted:nil action:@selector(popVCAction:)];
}

- (void)naviBackButtonWithTitle:(NSString*)ttl
{
    [self naviLeftButtonImage:[UIImage imageNamed:@"fanh"] title:ttl action:@selector(popVCAction:)];
}

#pragma mark - 左上按钮
- (void)naviLeftButtonImage:(UIImage*)aImg highlighted:(UIImage*)hImg action:(SEL)action{
    [self.navigationItem setHidesBackButton:YES];
    
    CGFloat imgsize=36;//图片固定大小36
    
    CGFloat margin=kTopBarItemInsetsMargin;
    CGFloat ww=kTopBarItemWidth, hh=kTopBarItemHeight;
    CGFloat bw,bh;
    
    //12,21 nav_btn_back
    bw=imgsize;//aImg.size.width;
    bh=imgsize;//aImg.size.height;
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
    [btn setImage:aImg forState:UIControlStateNormal];
    [btn setImage:aImg forState:UIControlStateHighlighted];
    if (hImg)
        [btn setImage:hImg forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake((hh-bh)/2, margin, (hh-bh)/2-1, ww-margin-bw)];//上下偏移1像素
    
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor=[UIColor clearColor];
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = kTopBarItemFixMargin;
    //
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[fixed,btnItem];
}

- (void)naviLeftButtonImage:(UIImage*)aImg title:(NSString*)title action:(SEL)action{
    [self.navigationItem setHidesBackButton:YES];
    
    
    CGFloat margin=kTopBarItemInsetsMargin-6;
    CGFloat ww=kTopBarItemWidth, hh=kTopBarItemHeight;
    CGFloat bw,bh;
    
    //12,21 nav_btn_back
    bw=aImg.size.width;
    bh=aImg.size.height;
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
    [btn setImage:aImg forState:UIControlStateNormal];
    [btn setImage:aImg forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake((hh-bh)/2, margin, (hh-bh)/2, ww-margin-bw)];
    
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:fontSystem(kFontS30)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [btn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor=[UIColor clearColor];
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = kTopBarItemFixMargin;
    //
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[fixed,btnItem];
}
#pragma mark - 右上按钮
- (void)naviRightButtonImage:(UIImage*)aImg highlighted:(UIImage*)hImg action:(SEL)action{
//    [self.navigationItem setHidesBackButton:YES];
    
    CGFloat imgsize=36;//图片固定大小36
    
    CGFloat margin=kTopBarItemInsetsMargin;
    CGFloat ww=kTopBarItemWidth, hh=kTopBarItemHeight;
    CGFloat bw,bh;
    
    //12,21 nav_btn_back
    bw=imgsize;//aImg.size.width;
    bh=imgsize;//aImg.size.height;
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
    [btn setImage:aImg forState:UIControlStateNormal];
    [btn setImage:aImg forState:UIControlStateHighlighted];
    if (hImg)
        [btn setImage:hImg forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake((hh-bh)/2, margin, (hh-bh)/2-1, ww-margin-bw)];//上下偏移1像素
    
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor=[UIColor clearColor];
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -20;
    //
    
    self.navigationItem.rightBarButtonItems = @[fixed,btnItem];
}
#pragma mark - 导航栏文字按钮
- (void)naviRightButton:(NSString*)aTitle action:(SEL)action
{
    CGFloat ww=kTopBarItemWidth, hh=kTopBarItemHeight;
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
    
    [btn setTitle:aTitle forState:UIControlStateNormal];
    btn.titleLabel.font=fontSystem(kFontS30);
    btn.titleLabel.textColor=RGBHex(kColorW);
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kTopBarItemInsetsMargin)];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.backgroundColor=[UIColor clearColor];
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = kTopBarItemFixMargin;
    
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = @[fixed,btnItem];
}

- (void)naviLeftButton:(NSString*)aTitle action:(SEL)action
{
    if (aTitle==nil) {
        self.navigationItem.leftBarButtonItems=nil;
        return;
    }
    CGFloat ww=kTopBarItemWidth, hh=kTopBarItemHeight;
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
    
    [btn setTitle:aTitle forState:UIControlStateNormal];
    btn.titleLabel.font=fontSystem(kFontS30);
    btn.titleLabel.textColor=RGBHex(kColorW);
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, kTopBarItemInsetsMargin, 0, 0)];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor=[UIColor clearColor];
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = kTopBarItemFixMargin;
    
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[fixed,btnItem];
}


- (id)naviTitleView:(UIView*)vTitle{
    id aView=vTitle;
    float ww=APP_W/2-40;
    CGRect frm=CGRectMake(0, 0, ww, 44);//self.navigationController.navigationBar.bounds;
    if (aView==nil) {
        aView=[[UIView alloc]init];
        
        UILabel *lbl=[[UILabel alloc]initWithFrame:frm];
        [lbl setFont:fontSystem(kFontS34)];
        [lbl setTextColor:RGBHex(kColorW)];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setText:self.title];
        [lbl setBackgroundColor:RGBAHex(kColorW, 0)];
        
        [aView addSubview:lbl];
    }
    
//    if ([aView respondsToSelector:@selector(setBackgroundColor:)])
//        [aView setBackgroundColor:RGBAHex(0xff00ff, 0.5)];
    
//    if ([aView respondsToSelector:@selector(setFrame:)]) {
//        [aView setFrame:frm];
//    }
    
//    [aView setFrame:self.navigationController.navigationBar.frame];
    [self.navigationItem setTitleView:aView];
    
    return aView;
}

- (void)naviTitle:(NSString*)ttl{
    [self.navigationItem setTitleView:nil];
//    [self.navigationItem setTitle:ttl];
    float ww=APP_W/2-80;
    CGRect frm=CGRectMake(0, 0, ww, 44);
    UILabel *lbl=[[UILabel alloc]initWithFrame:frm];
    [lbl setFont:fontSystem(kFontS34)];
    [lbl setTextColor:RGBHex(kColorW)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [lbl setText:ttl];
    
    [self.navigationItem setTitleView:lbl];
}

- (void)naviSpaceWidth:(float)width pos:(UIRectEdge)edge{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = width;
    if (edge==UIRectCornerBottomLeft)
        self.navigationItem.leftBarButtonItems = @[fixed];
    if (edge==UIRectCornerBottomRight)
        self.navigationItem.rightBarButtonItems = @[fixed];
}
#pragma mark - tmp
#pragma mark 时间格式
//- (NSString*)date:(NSDate*)date format:(NSString*)format{
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone;
//    
//    //获取并设置时间的时区,获取系统时间
//    timeZone = [NSTimeZone systemTimeZone];
//    
//    [df setTimeZone:timeZone];
//    
//    if (format==nil)
//        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//附加时区 @"yyyy-MM-dd'T'HH:mm:ssZ"
//    else
//        [df setDateFormat:format];
//    
//    return [df stringFromDate:date];
//}

- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
}

#pragma mark - 返回主页，收藏等列表
//- (void)setUpRightItem
//{
//    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixed.width = -6;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-unfold.PNG"] style:UIBarButtonItemStylePlain target:self action:@selector(returnIndex)];
//    self.navigationItem.rightBarButtonItems = @[fixed,rightItem];
//}

//- (void)returnIndex
//{
//    self.indexView = [ReturnIndexView sharedManagerWithImage:@[@"icon home.PNG"] title:@[@"首页"]];
//    self.indexView.delegate = self;
//    [self.indexView show];
//}
//
//- (void)RetunIndexView:(ReturnIndexView *)ReturnIndexView didSelectedIndex:(NSIndexPath *)indexPath
//{
//    [self.indexView hide];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self performSelector:@selector(delayPopToHome) withObject:nil afterDelay:0.01];
//}

//- (void)delayPopToHome
//{
//    [[QWGlobalManager sharedInstance].tabBar setSelectedIndex:0];
//}

#pragma mark 全局通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    [super getNotifType:type data:data target:obj];
    
    if (type==NotifAppDidEnterBackground) {
//        NSDictionary *dd=[NSDictionary dictionaryWithObject:StrFromObj([self class]) forKey:@"page"];
//        [MobClick event: cb_bg attributes:dd];
    }
    if (type==NotifAppWillEnterForeground) {
//        NSDictionary *dd=[NSDictionary dictionaryWithObject:StrFromObj([self class]) forKey:@"page"];
//        [MobClick event: cb_Foreground attributes:dd];
    }
    if (type==NotifAppWillTerminate) {
//        NSDictionary *dd=[NSDictionary dictionaryWithObject:StrFromObj([self class]) forKey:@"page"];
//        [MobClick event: cb_Terminate attributes:dd];
    }
    
}

#pragma mark - 无数据页面水印
-(void)showInfoView:(NSString *)text image:(NSString*)imageName {
    [self showInfoView:text image:imageName tag:0];
}
-(void)showInfoView:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfo==nil) {
        self.vInfo = [[UIView alloc]initWithFrame:self.view.bounds];
    }
    
    self.vInfo.frame = self.view.bounds;
    
    for (id obj in self.vInfo.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfo addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS30);
    lblInfo.textColor = RGBHex(kColorGray203);//0x89889b
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:lblInfo];
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=tag;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:btnClick];
    

    float vw=CGRectGetWidth(self.vInfo.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;

    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
    
    self.vInfo.alpha=0;
    [UIView animateWithDuration:.15 animations:^{
        self.vInfo.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
//    self.vInfo.backgroundColor=[UIColor redColor];
}

- (void)removeInfoView{
    [UIView animateWithDuration:.15 animations:^{
        self.vInfo.alpha=0;
    } completion:^(BOOL finished) {
        [self.vInfo removeFromSuperview];
    }];
//    [self.vInfo removeFromSuperview];
}

- (IBAction)viewInfoClickAction:(id)sender{
//    NSInteger tag=[sender tag];
}

#pragma mark - 无数据页面水印
-(void)showInfoViewLogin:(NSString *)text image:(NSString*)imageName {
    [self showInfoViewLogin:text image:imageName tag:0];
}
-(void)showInfoViewLogin:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfoLogin==nil) {
        self.vInfoLogin = [[UIView alloc]initWithFrame:self.view.bounds];
    }
    
    self.vInfoLogin.frame = self.view.bounds;
    
    for (id obj in self.vInfoLogin.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfoLogin addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS30);
    lblInfo.textColor = RGBHex(kColorGray203);//0x89889b
    lblInfo.textAlignment = NSTextAlignmentRight;
    [self.vInfoLogin addSubview:lblInfo];
    
    
    
    
    float vw=CGRectGetWidth(self.vInfoLogin.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw/2,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    
    
    
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblInfo.frame), CGRectGetMinY(lblInfo.frame), 60, CGRectGetHeight(lblInfo.frame))];
    [btnClick setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
//    [btnClick setTitle:@"去登录" forState:UIControlStateNormal];
    btnClick.titleLabel.font = fontSystem(kFontS30);
    btnClick.tag=tag;
    [btnClick addTarget:self action:@selector(viewInfoLoginClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"去登录"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorMain001) range:strRange];
    [btnClick setAttributedTitle:str forState:UIControlStateNormal];
    [self.vInfoLogin addSubview:btnClick];
    
    
    [self.view addSubview:self.vInfoLogin];
    [self.view bringSubviewToFront:self.vInfoLogin];
    
    self.vInfoLogin.alpha=0;
    [UIView animateWithDuration:.15 animations:^{
        self.vInfoLogin.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    //    self.vInfo.backgroundColor=[UIColor redColor];
}

- (void)removeInfoLoginView{
    [UIView animateWithDuration:.15 animations:^{
        self.vInfoLogin.alpha=0;
    } completion:^(BOOL finished) {
        [self.vInfoLogin removeFromSuperview];
    }];
    //    [self.vInfo removeFromSuperview];
}

- (IBAction)viewInfoLoginClickAction:(id)sender{
    //    NSInteger tag=[sender tag];
    loginVC *vc=[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
    vc.backButtonEnabled=YES;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}

#pragma mark - 无数据页面水印
-(void)showInfoRefreshView:(NSString *)text image:(NSString*)imageName btnHidden:(BOOL)btnHidden sel:(SEL)selector
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfoRefresh==nil) {
        self.vInfoRefresh = [[UIView alloc]initWithFrame:self.view.bounds];
    }
    
    self.vInfoRefresh.frame = self.view.bounds;
    
    for (id obj in self.vInfoRefresh.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfoRefresh addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS30);
    lblInfo.textColor = RGBHex(kColorGray203);//0x89889b
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.vInfoRefresh addSubview:lblInfo];
    
    
    
    float vw=CGRectGetWidth(self.vInfoRefresh.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    
    [self.view addSubview:self.vInfoRefresh];
    [self.view bringSubviewToFront:self.vInfoRefresh];
    if (btnHidden) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblInfo.frame), CGRectGetMinY(imgvInfo.frame), CGRectGetWidth(lblInfo.frame), imgInfoBG.size.height+50)];
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        [self.vInfoRefresh addSubview:btn];
    }else{
        UIButton *btnClickRef = [[UIButton alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(lblInfo.frame)+20, APP_W - 160, 40)];
        [btnClickRef addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        btnClickRef.backgroundColor = RGBAHex(kColorW, 1);
        btnClickRef.layer.borderWidth = 1;
        btnClickRef.layer.cornerRadius = kCornerRadius;
        btnClickRef.layer.borderColor = RGBHex(kColorMain001).CGColor;
        [btnClickRef setTitle:@"重新加载" forState:UIControlStateNormal];
        [btnClickRef setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
        [self.vInfoRefresh addSubview:btnClickRef];
    }
    
    
    
    
    self.vInfoRefresh.alpha=0;
    [UIView animateWithDuration:.15 animations:^{
        self.vInfoRefresh.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    //    self.vInfo.backgroundColor=[UIColor redColor];
}

- (void)removeInfoRefreshView{
    [UIView animateWithDuration:.15 animations:^{
        self.vInfoRefresh.alpha=0;
    } completion:^(BOOL finished) {
        [self.vInfoRefresh removeFromSuperview];
    }];
    //    [self.vInfo removeFromSuperview];
}

- (IBAction)btnClickRefAction:(id)sender{
    //    NSInteger tag=[sender tag];
    
}

#pragma mark - 手动
- (void)showLoading {
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        
        HUD.delegate = self;
    }
    [self.view bringSubviewToFront:HUD];
    [HUD show:YES];
}
- (void)showLoadingWin {
    if (HUD==nil) {
        UIWindow *win=[UIApplication sharedApplication].keyWindow;
        HUD = [[MBProgressHUD alloc] initWithView:win];
        [win addSubview:HUD];
        [win bringSubviewToFront:HUD];
        
        HUD.delegate = self;
    }
    
    [HUD show:YES];
}
- (void)showLoadingWithMessage:(NSString*)msg {
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        
        HUD.delegate = self;
    }
    [self.view bringSubviewToFront:HUD];
    HUD.labelText=msg;
    
    [HUD show:YES];
}
- (void)didLoad{
    
    [HUD hide:YES];
}


#pragma mark - 检测网络
- (BOOL)isNetWorking{
    
    BOOL isNet = NO;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([r currentReachabilityStatus]) {
            
        case NotReachable:
            isNet = YES;
            break;
            
        case ReachableViaWWAN:
            isNet = NO;
            break;
            
        case ReachableViaWiFi:
            isNet = NO;
            break;
            
        default:
            break;
    }
    
    return isNet;
}
#pragma mark - 自动消息
- (void)showText:(NSString*)txt{
    [self showText:txt delay:1.2];
}

- (void)showText:(NSString*)txt delay:(double)delay{
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
//    hud.labelText = txt;
    hud.detailsLabelText = txt;
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    double dl=(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}

- (void)showWindowText:(NSString*)txt delay:(double)delay{
    [self.view endEditing:YES];
   UIWindow *win=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = txt;
    hud.detailsLabelText = txt;
    //    hud.margin = 10.f;
    //    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    double dl=(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}


- (void)showError:(NSString *)msg{
    [self showMessage:msg icon:@"error.png" afterDelay:1.2 ];
//    [self show:error icon:@"error.png" view:view];
}

- (void)showSuccess:(NSString *)msg
{
    [self showMessage:msg icon:@"success.png" afterDelay:1.2 ];
}

- (void)showMessage:(NSString*)txt icon:(NSString *)icon afterDelay:(double)delay{
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = txt;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    double dl=(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}

- (void)showErrorMessage:(NSError*)error{
//    NSDictionary *errs=error.userInfo;
//    NSString *code=[self getErrCode:[errs objectForKey:@"errors"]];
//    NSString *err_code=[NSString stringWithFormat:@"ERR_%@",code];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[AppDelegate localized:@"ERROR" defaultValue:nil]
//                                                       message:[AppDelegate localized:err_code defaultValue:code]
//                                                      delegate:self
//                                             cancelButtonTitle:[AppDelegate localized:@"btnClose" defaultValue:nil]
//                                             otherButtonTitles:nil, nil];
//    
//    [alertView show];
}
#pragma mark alert
- (void)showAlert:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion{
    
}
#pragma mark 错误处理
- (NSString*)getErrCode:(id)obj{
    NSMutableString *str=[NSMutableString stringWithString:@"UNKNOW"];
//    NSArray *arrErrs;
//    if (!ObjClass(obj, [NSArray class])) {
//        return str;
//    }
//    arrErrs=(NSArray*)obj;
//    if (arrErrs.count) {
//        NSDictionary *dd=[arrErrs objectAtIndex:0];
//        if ([dd objectForKey:@"err_code"]) {
//            return [dd objectForKey:@"err_code"];
//            //[str appendString:[dd objectForKey:@"err_code"]];
//            //            [str stringByAppendingString:[dd objectForKey:@"err_code"]];
//        }
//    }
    
    return str;
}
#pragma mark 控制台
- (void)showLog:(NSString*)firstObject, ...{

    NSMutableString *allStr=[[NSMutableString alloc]initWithCapacity:0];
    
    NSString *eachObject=nil;
    va_list argumentList;
    if (firstObject>=0)
    {
        [allStr appendFormat:@"%@",firstObject];
        
        va_start(argumentList, firstObject);          // scan for arguments after firstObject.
        eachObject = va_arg(argumentList, NSString*);
        while (eachObject!=nil) // get rest of the objects until nil is found
        {

            [allStr appendFormat:@"\n-------------------------------------------------\n%@",eachObject];
            
            eachObject = va_arg(argumentList, NSString*);
        }
        va_end(argumentList);
    }
    
    CGRect frm=self.view.bounds;
    if (vQLog==nil) {
        vQLog=[[UIView alloc]initWithFrame:frm];
        
        frm.size.height-=80;
        frm.size.width-=2;
        frm.origin.x=1;
        frm.origin.y=20;
        txtQLog=[[UITextView alloc]initWithFrame:frm];
        txtQLog.editable=NO;
        [vQLog addSubview:txtQLog];
        
        frm.size.height=60;
        
        frm.origin.y=CGRectGetMaxY(txtQLog.frame)+1;
        UIButton *btn=[[UIButton alloc]initWithFrame:frm];
        [btn addTarget:self action:@selector(hideLogAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=RGBHex(0xff8a01);//[QYGlobal colorWithHexString:kMainColor alpha:1];
        [btn setTitle:@"关........闭" forState:UIControlStateNormal];
        [vQLog addSubview:btn];
        
        [self.view addSubview:vQLog];
    }
    
//    NSString *ss=allStr;
    if ([txtQLog.text length]) {
        [allStr appendFormat:@"\n\n++++++++++++++++++++++++++++++++++++++++++++++\n\n%@",txtQLog.text];
    }
    txtQLog.text=allStr;
    vQLog.hidden=NO;
}

- (void)hideLogAction:(id)sender{
    vQLog.hidden=YES;
    txtQLog.text=nil;
}

#pragma mark - Delegate 托管模块
#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    /**
     *  HUD消失，添加对应方法
     */
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark －
#pragma mark 返回上一页
- (IBAction)popVCAction:(id)sender{
    [self.view endEditing:YES];
    
    //如果需要，返回的时候隐藏导航栏
    if (self.hidesPopNav)
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
//        DLog(@">>> %@\n%@",self.navigationController,self.navigationController.viewControllers);
        if (self.navigationController.viewControllers.count>1) {
            if (self.hidesMenu) {
//                [QGLOBAL.menu hideTabBar:NO];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if (self.navigationController && [self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                //
            }];
        }
            
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    
    
}

- (void)backToPreviousController:(id)sender{
    
}

- (IBAction)jumpToPopVCAction:(id)sender{
    if (self.navigationController && self.delegatePopVC) {
        DLog(@">>>1 %@ b%@",self.navigationController.viewControllers,self.delegatePopVC);
        
        
        //如果需要，返回的时候隐藏导航栏
        if ([self.delegatePopVC respondsToSelector:@selector(navBarHidden)] && [self.delegatePopVC navBarHidden])
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [self.navigationController popToViewController:self.delegatePopVC animated:YES];
    }
    else if (self.navigationController && [self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        DLog(@">>>2 %@ b%@",self.navigationController.viewControllers,self.delegatePopVC);
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
    else {
        [self popVCAction:sender];
    }
}

#pragma mark - 屏幕方向 禁止旋转
// 允许自动旋转，在支持的屏幕中设置了允许旋转的屏幕方向。
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//// 支持的屏幕方向，这个方法返回 UIInterfaceOrientationMask 类型的值。
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//// 视图展示的时候优先展示为 home键在右边的 横屏
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark - 状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
//#pragma mark - 禁止旋转
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//-(BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
@end
