//
//  ActivityCmtListVC.m
//  cyy_task
//
//  Created by Qingyang on 16/11/14.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ActivityCmtListVC.h"
#import "ActivityCommentVC.h"
#import "ActivityCmtListCell.h"
#import "loginVC.h"
@interface ActivityCmtListVC ()<ActivityCommentDelegate>

@end

@implementation ActivityCmtListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self naviTitle:@"APP上线啦，评论集赞赢红包"];

//
    [self setupMJHeader];
    [self setupMJFooter];
    
    [self showLoading];
//    [self checkTime];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshList];
    
}

- (void)UIGlobal{
    [super UIGlobal];
    vHeader.height=AutoValue(250);//APP_W/1.5;
    lblBannerTime.y=AutoValue(130);
    
    [self.tableMain setTableHeaderView:vHeader];
    [self.tableMain setTableFooterView:nil];
    [vFooter removeFromSuperview];
    
    
    btnHuodong.clipsToBounds = YES;
    btnHuodong.layer.cornerRadius = btnHuodong.height/2;
    
    btnHuodong.backgroundColor=RGBHex(kColorTmp005);
    [btnHuodong setTitleColor:RGBHex(kColorTmp003) forState:UIControlStateNormal];
    
    vFooter.backgroundColor=RGBAHex(kColorB, 0) ;
    vHeader.backgroundColor=RGBAHex(kColorB, 0) ;
    
    self.view.backgroundColor=RGBHex(kColorTmp003);
    lblBannerTime.textColor=RGBHex(kColorTmp003);
    
    
    //个人
    lblUser.textColor=RGBHex(kColorTmp006);
    lblTime.textColor=RGBAHex(kColorTmp007,.6);
    lblContent.textColor=RGBHex(kColorTmp007);
    lblStatus.textColor=RGBHex(kColorTmp005);
    vMyCmt.backgroundColor=RGBHex(kColorTmp004);
    
    
    //按钮
    btnJoinCmt.backgroundColor=RGBHex(kColorTmp001);
    [btnJoinCmt setTitleColor:RGBHex(kColorTmp004) forState:UIControlStateNormal];
    [btnJoinCmt setTitleColor:RGBHex(kColorTmp004) forState:UIControlStateHighlighted];
    [btnJoinCmt setBackgroundColor:RGBHex(kColorTmp001) forState:UIControlStateNormal];
    [btnJoinCmt setBackgroundColor:RGBHex(kColorTmp002) forState:UIControlStateHighlighted];
    
    //规则
    vRulesMain.backgroundColor=RGBHex(kColorTmp003);
    lblRuleTime.textColor=RGBHex(kColorTmp005);
}

- (void)rulesInit{
    scroll.frame=self.view.bounds;
    vRules.frame=self.view.bounds;
    
    vRulesMain.width=vRules.width-AutoValue(30);
    vRulesMain.y=AutoValue(33);
    
    //316x440
    bgHuodong.width=vRulesMain.width;
    bgHuodong.height=bgHuodong.width*440.0/316.0;
    
    vRulesText.y=bgHuodong.height;
    vRulesText.width=vRulesMain.width;
    
    [lblR1 sizeToFit];
    [lblR2 sizeToFit];
    [lblR3 sizeToFit];
    [lblR4 sizeToFit];
    
    lblR1.width=vRulesText.width-40-15;
    lblR2.width=lblR1.width;
    lblR3.width=lblR1.width;
    lblR4.width=lblR1.width;
    
    lblR2.y=CGRectGetMaxY(lblR1.frame)+10;
    lblR3.y=CGRectGetMaxY(lblR2.frame)+10;
    lblR4.y=CGRectGetMaxY(lblR3.frame)+10;
    
    iconNo1.y=lblR1.y;
    iconNo2.y=lblR2.y;
    iconNo3.y=lblR3.y;
    iconNo4.y=lblR4.y;
    
    sp1=nil;
    sp1=[[UILabel alloc]initWithFrame:lblR1.frame];
    sp1.height=0.5;
    sp1.backgroundColor=RGBHex(kColorTmp008);
    sp1.y=CGRectGetMaxY(lblR1.frame)+5;
    [vRulesText addSubview:sp1];
    
    sp2=nil;
    sp2=[[UILabel alloc]initWithFrame:sp1.frame];
    sp2.backgroundColor=RGBHex(kColorTmp008);
    sp2.y=CGRectGetMaxY(lblR2.frame)+5;
    [vRulesText addSubview:sp2];
    
    sp3=nil;
    sp3=[[UILabel alloc]initWithFrame:sp1.frame];
    sp3.backgroundColor=RGBHex(kColorTmp008);
    sp3.y=CGRectGetMaxY(lblR3.frame)+5;
    [vRulesText addSubview:sp3];
    
    
    vRulesText.height=CGRectGetMaxY(lblR4.frame)+22;

    
    vRulesMain.height=vRulesText.height+bgHuodong.height;
    vRules.height=vRulesMain.height+AutoValue(33)*2;
    
    vRulesMain.clipsToBounds = YES;
    vRulesMain.layer.cornerRadius = 4;
    
    
    
    [scroll setContentSize:vRules.bounds.size];
    [scroll addSubview:vRules];
    
    
    scroll.backgroundColor=RGBAHex(kColorB, .75);
//    DLog(@">>>>>>> %@ %@",NSStringFromCGRect(scroll.frame),NSStringFromCGRect(vRules.frame));
}


- (void)checkTime{
    [ActivityAPI ActivityTimeWithSuccess:^(NSString *start, NSString *end) {
//        ssStarts=start;
//        ssEnd=end;
        [self didLoad];
        lblBannerTime.text=[NSString stringWithFormat:@"活动时间: %@-%@",start,end];
        lblRuleTime.text=[NSString stringWithFormat:@"活动时间: %@-%@",start,end];
    } failure:^(NetError *err) {
        [self didLoad];
    }];
}

- (void)checkInfos{
    if ([QGLOBAL hadAuthToken]){

        [ActivityAPI ActivityCmtByUser:QGLOBAL.auth.username success:^(ActivityCmtModel *model) {
//            DLog(@">>> %@",[model toDictionary]);
            mmMyCmt=model;
            [self hadMyCmtView];
        } failure:^(NetError *err) {
            [self hadBtnCmtView];
        }];
    }
    else {
        [self hadBtnCmtView];
    }
    
    
}

- (void)hadBtnCmtView{
    btnJoinCmt.hidden=NO;
    vMyCmt.hidden=YES;
    
    self.tableMain.height=self.view.height-btnJoinCmt.height;
}

- (void)hadMyCmtView{
    btnJoinCmt.hidden=YES;
    vMyCmt.hidden=NO;
    
    self.tableMain.height=self.view.height;

    iconStatus.hidden=YES;
    switch (mmMyCmt.status.integerValue) {//评论状态（0=>待处理，1=>通过，2=>驳回）
        case 0:
            lblStatus.text=@"内容审核中";
            iconStatus.hidden=NO;
            break;
        case 1:
            lblStatus.text=@"通过";
            lblStatus.text=[NSString stringWithFormat:@"当前排名: %@",mmMyCmt.ranking];
            break;
        case 2:
            lblStatus.text=@"驳回";
            break;
        default:
            break;
    }
    [lblStatus sizeToFit];
    lblStatus.height=21;
    lblStatus.y=-4;
    lblStatus.x=APP_W-lblStatus.width-30;
    iconStatus.x=lblStatus.x-2-iconStatus.width;
    
    lblTime.text=[QGLOBAL dateToStr:[QGLOBAL dateFromTimeInterval:mmMyCmt.created_at] format:@"yyyy-MM-dd HH:mm"];
    lblUser.text=QGLOBAL.usermodel.nickname;
    lblUser.width=iconStatus.x-lblUser.x-4;
    
    imgAvatar.clipsToBounds = YES;
    imgAvatar.layer.cornerRadius = imgAvatar.width/2;
    [imgAvatar setImageWithURL:[NSURL URLWithString:QGLOBAL.auth.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    //重绘size
    lblContent.text=StrFromObj(mmMyCmt.content);
    [lblContent sizeToFit];
    lblContent.width=APP_W-15-15;
    lblContent.x=15;
//    CGSize sz=[QGLOBAL sizeText:lblContent.text font:lblContent.font limitWidth:APP_W-30];
//    lblContent.height=sz.height;
//    if (sz.height<21) {
//        lblContent.height=21;
//    }
//    else if (sz.height>42){
//        if (0) {//_mmMyCmt.isOpen.boolValue
//            lblContent.height=sz.height;
//            
//        }
//        else {
//            lblContent.height=42;
//        }
////        btnOpenContent.y=lblContent.height+lblContent.y;
////        btnOpenContent.hidden=NO;
//    }
//    else {
//        lblContent.height=42;
//    }
    
    vMyCmt.height=lblContent.y+lblContent.height+12;
    vMyCmt.y=self.view.height-vMyCmt.height;
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
    [footerMJ setTitle:@"" forState:MJRefreshStateIdle];
    [self.tableMain.footer endRefreshing];
    
    page = 0;
    [ActivityAPI ActivityCmtListWithOffset:page success:^(NSMutableArray *list) {
//        
        arrData=list;
        if (arrData.count>0) {
            [self.tableMain setTableFooterView:nil];
            [vFooter removeFromSuperview];
        }
        
        [self.tableMain reloadData];
        [self didLoad];
        [self.tableMain.header endRefreshing];
    } failure:^(NetError *err) {
        [self didLoad];
        [self.tableMain.header endRefreshing];
        
        if (err.errStatusCode==13862) {
            DLog(@">>>  无数据 ");
            if (arrData.count==0) {
                [self.tableMain setTableFooterView:vFooter];
            }
            return ;
        }
        
        
        [self showText:err.errMessage];
    }];
    
    [self checkInfos];
    [self checkTime];
}

- (void)getListNext
{
    page ++;
    [ActivityAPI ActivityCmtListWithOffset:page success:^(NSMutableArray *list) {
        
        [arrData addObjectsFromArray:list];
        [self.tableMain.footer endRefreshing];
        
        footerMJ.automaticallyHidden = YES;
        if (list.count == 0) {
            [footerMJ endRefreshingWithNoMoreData];
        }
        [self.tableMain reloadData];
        [self didLoad];
    } failure:^(NetError* err) {
        
        if (err.errStatusCode == 13862) {
            [footerMJ endRefreshingWithNoMoreData];
        }else{
            DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
            [footerMJ setTitle:@"" forState:MJRefreshStateIdle];
            [self.tableMain.footer endRefreshing];
            [self showText:err.errMessage];
        }
        
    }];
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
        ActivityCmtModel * mm=[arrData objectAtIndex:row];
        mm.ranking=StrFromInt(row+1);
        
        BaseTableCell *cell;
        tableID = @"ActivityCmtListCell";
        
        cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] firstObject];
 
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
        
    }
}


#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    if (row<arrData.count) {
        ActivityCmtModel * mm=[arrData objectAtIndex:row];
        return  [ActivityCmtListCell getCellHeight:mm];
    }
    return 0;
}
#pragma mark - action
- (IBAction)cmtAction:(id)sender{
    if (![QGLOBAL hadAuthToken]){
        loginVC *vc=[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
        vc.backButtonEnabled=YES;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
        return;
    }
    ActivityCommentVC *vc=[[ActivityCommentVC alloc]initWithNibName:@"ActivityCommentVC" bundle:nil];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)openRulesAction:(id)sender{
    [self rulesInit];
    [self.view addSubview:scroll];
    [self.view bringSubviewToFront:scroll];
    
    scroll.alpha=0;
    [UIView animateWithDuration:.25 animations:^{
        scroll.alpha=1;
    } completion:^(BOOL finished) {
        //
    }];
}

- (IBAction)closeRulesAction:(id)sender{
    [UIView animateWithDuration:.25 animations:^{
        scroll.alpha=0;
    } completion:^(BOOL finished) {
        [scroll removeFromSuperview];
    }];
    
}
#pragma mark - ActivityCommentDelegate
/** 是否成功回调 */
- (void)ActivityCommentDelegate:(id)delegate success:(BOOL)success{
    
}

#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (mmMyCmt==nil) {
        return;
    }
    if (scrollView==scroll) {
        return;
    }
    if (scrollView==self.tableMain) {
        if (scrollView.contentOffset.y > 20){
            
            [UIView animateWithDuration:.25 animations:^{
                vMyCmt.alpha=0;
            } completion:^(BOOL finished) {
                vMyCmt.hidden=YES;
            }];
        }
        else {
            vMyCmt.hidden=NO;
            [UIView animateWithDuration:.25 animations:^{
                vMyCmt.alpha=1;
            } completion:^(BOOL finished) {
                
            }];
        }
        return;
    }
    
}

#pragma mark - ActivityCmtListCellDelegate
- (void)ActivityCmtListCellDelegate:(id)delegate zan:(ActivityCmtModel*)model{
    if (![QGLOBAL hadAuthToken]){
        loginVC *vc=[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
        vc.backButtonEnabled=YES;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
        return;
    }
    if (model.already_zan.boolValue==1) {
        [self showText:@"该条评论已点赞过了，换一条吧"];
    }
    else {
        [self showLoading];
        [ActivityAPI ActivityZanCmtID:model.oid success:^(BOOL success) {
            model.already_zan=@"1";
            model.zans=StrFromInt(model.zans.integerValue+1);
            [self.tableMain reloadData];
            [self didLoad];
        } failure:^(NetError *err) {
            [self didLoad];
            [self showText:err.errMessage];
        }];
    }
}

- (void)ActivityCmtListCellDelegate:(id)delegate  openCell:(ActivityCmtModel*)model{
    [self.tableMain reloadData];
}
@end
