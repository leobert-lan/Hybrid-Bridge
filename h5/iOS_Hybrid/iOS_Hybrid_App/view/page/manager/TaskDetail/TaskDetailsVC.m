//
//  TaskDetailsVC.m
//  cyy_task
//
//  Created by zhchen on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskDetailsVC.h"
#import "loginVC.h"
#import "TaskDetailCell.h"
#import "TaskAPI.h"
#import "TaskDetailHideCell.h"
#import "ThirdShare.h"
#import "SubmissionVC.h"
#import "MineAPI.h"
#import "MJRefresh.h"
#import "ProtocolVC.h"
#import "EvaluateVC.h"
#import "phoneBound.h"
#import "OpenFileDetailVC.h"

#import "ImagesPreviewVC.h"
#import "OpenFileModel.h"

#import "RealNameNew.h"
#import "CompanyAuthNewVC.h"

@interface TaskDetailsVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,cloudBaseCellDelegate,TaskDetailCellDelegate>
{
    IBOutlet UITableView *tblDetail;
    CGFloat menuW;
    UIView *vBlue;
    IBOutlet UIView *vTaskMenu,*vTask,*vRequire,*vManu,*vBottom,*vBotSubmission,*vbotBid,*vBotPub,*vBotChoose,*vEvaluate,*vTop,*vhal,*vDown,*vLineK,*vFileAtt,*vBootomLine;
    IBOutlet UIScrollView *requireScro;
    IBOutlet UILabel *lblBid,*lblBotChoose,*lblhint,*lblFileSize,*lblFile;
    IBOutlet UIButton *btnSubmission,*btnShare,*btnCollect,*btnBid,*btnBidCall,*btnPubCall,*btnSignature,*btnvEvaluate,*btnFile;
    IBOutlet NSLayoutConstraint *btnFileW;
    TaskDetailModel *Taskmodel;
    IBOutlet UILabel *lblName,*lblMoney,*lblMold,*lblDeposit,*lblstatus,*lblSelect,*lblData,*lblRequire,*lblPublisher,*lblReleaseData;
    IBOutlet NSLayoutConstraint *vRequireH,*vFileAttH;
    IBOutlet UIImageView *imgRelease;
    // 状态
    IBOutlet UILabel *lblPublish,*lblSubmission,*lblChoose,*lblPublicity,*lblPay,*lblEnd;
    IBOutlet UIView *vProgressO,*vProgressT,*vProgressS,*vProgressF,*vProgressFi,*vProgressSi,*vProgressSe;
    IBOutlet UIButton *btnAdd;
    IBOutlet NSLayoutConstraint *lblRequireH;
    int isConcern;
    BOOL isCollect;
    int page;
    MJRefreshNormalHeader *headerMJ;
    IBOutlet UIView *vkong;
    IBOutlet UIImageView *imgKong;
    IBOutlet UILabel *lblKong;
    IBOutlet NSLayoutConstraint *vTopH,*vFileT,*vBottomH,*lblMoldL,*lblDepositL,*lblstatusL,*lblSelectL,*lblmoenyW;
    UIView *vNodata;
    NSInteger totalBids;
    NSString *menuNum;
    NSMutableArray *imgArr;
    NSMutableArray *fileArr;
    UIButton *btnDetailFile,*btnDetailImg;
}
@end

@implementation TaskDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;

    [self taskMenuInit];
    [self tableDataSourceInit];
    
    
//    vNodata = [[UIView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:vNodata];
//    vNodata.backgroundColor = [UIColor whiteColor];
//    
//    [self showLoading];
//    [self refreshList];
//    if ([menuNum isEqualToString:@"1"]) {
//        
//    }else{
//        [self refreshListWork];
//    }
    
    [self setupMJ];
    [self upLoadData];
    
    // Do any additional setup after loading the view.

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    vNodata = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:vNodata];
    vNodata.backgroundColor = [UIColor whiteColor];
    
    [self showLoading];
    [self refreshList];
    if ([menuNum isEqualToString:@"1"]) {
        
    }else{
    [self refreshListWork];
    }
}

#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"任务详情"];
//    self.taskBn = @"5953383139800";
    vTask.width = APP_W;
    vBottom.width = APP_W;
    vRequire.frame = CGRectMake(0, 0, APP_W, APP_H-273.5);
    [vTask addSubview:vRequire];
    
    lblName.textColor = RGBHex(kColorGray201);
    lblName.font = fontSystemBold(kFontS30);
    lblMoney.textColor = RGBHex(kColorAuxiliary102);
    lblMold.textColor = RGBHex(kColorGray203);
    lblDeposit.textColor = RGBHex(kColorGray203);
    lblstatus.textColor = RGBHex(kColorGray203);
    lblSelect.textColor = RGBHex(kColorGray203);
    lblData.textColor = RGBHex(kColorGray203);
    lblRequire.textColor = RGBHex(kColorGray201);
    lblPublisher.textColor = RGBHex(kColorGray201);
    lblReleaseData.textColor = RGBHex(kColorGray203);
    lblhint.textColor = RGBHex(kColorGray201);
    
    lblPublish.textColor = RGBHex(kColorGray208);
    lblSubmission.textColor = RGBHex(kColorGray208);
    lblChoose.textColor = RGBHex(kColorGray208);
    lblPublicity.textColor = RGBHex(kColorGray208);
    lblPay.textColor = RGBHex(kColorGray208);
    lblEnd.textColor = RGBHex(kColorGray208);
    
    [btnAdd setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    btnAdd.backgroundColor = RGBAHex(kColorW, 1);
    btnAdd.layer.borderWidth = 1;
    btnAdd.layer.cornerRadius = kCornerRadius;
    btnAdd.layer.borderColor = RGBHex(kColorMain001).CGColor;
    
    vProgressO.backgroundColor = RGBHex(kColorGray211);
    vProgressT.backgroundColor = RGBHex(kColorGray211);
    vProgressS.backgroundColor = RGBHex(kColorGray211);
    vProgressF.backgroundColor = RGBHex(kColorGray211);
    vProgressFi.backgroundColor = RGBHex(kColorGray211);
    vProgressSi.backgroundColor = RGBHex(kColorGray211);
    vProgressSe.backgroundColor = RGBHex(kColorGray211);
    
    tblDetail.backgroundColor = RGBHex(kColorGray207);
    [tblDetail setSeparatorColor:RGBHex(kColorGray206)];
    self.view.backgroundColor = RGBHex(kColorGray207);
    vLineK.backgroundColor = RGBHex(kColorGray207);
    lblKong.textColor = RGBHex(kColorGray203);
}

- (void)taskMenuInit{
    CGRect frm;
    int num=2;
    vTaskMenu.width = APP_W;
    menuW=vTaskMenu.width/num;
    
    vTaskMenu.backgroundColor=RGBHex(kColorW);
    frm=vTaskMenu.bounds;
    frm.size.height=0.5;
    frm.origin.y=40-0.5;
    UIView *sep=[[UIView alloc]initWithFrame:frm];
    sep.backgroundColor=RGBHex(kColorGray206);
    [vTaskMenu addSubview:sep];
    
    
    //菜单
    int i =0;
    while (i<num) {
        
        frm=CGRectMake(30, 0, menuW, 40);
        frm.origin.x=i*frm.size.width;
        
        UIButton *btn=[[UIButton alloc]initWithFrame:frm];
        btn.titleLabel.font=fontSystem(kFontS28);
        [btn setTitleColor:RGBHex(kColorGray202) forState:UIControlStateNormal];
        [btn setTitleColor:RGBHex(kColorGray211) forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+300;
        switch (i) {
            case 0:
                [btn setTitle:@"具体要求" forState:UIControlStateNormal];
                [btn setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
                break;
            case 1:
                [btn setTitle:@"所有投稿(0)" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [vTaskMenu addSubview:btn];
        
        //分割线
        if (i+1 != num) {
            frm=CGRectMake((i+1)*menuW, (40-22)/2, 0.5, 22);
            UIView *fg=[[UIView alloc]initWithFrame:frm];
            fg.backgroundColor=RGBHex(kColorGray206);
            [vTaskMenu addSubview:fg];
        }
        i++;
    }
    
    frm=CGRectMake(30, sep.y-0.5, menuW-30*2, 1);
    vBlue=[[UIView alloc]initWithFrame:frm];
    vBlue.backgroundColor=RGBHex(kColorMain001);
    [vTaskMenu addSubview:vBlue];
    
}

#pragma mark - 上下拉刷新
- (void)setupMJ {
    headerMJ = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshListWork)];
    [headerMJ setTitle:@"松开即可刷新" forState:MJRefreshStateIdle];
    tblDetail.header = headerMJ;
    headerMJ.stateLabel.textColor = RGBHex(kColorGray201);
    headerMJ.stateLabel.font = fontSystem(kFontS26);
    headerMJ.lastUpdatedTimeLabel.textColor = RGBHex(kColorGray203);
    headerMJ.lastUpdatedTimeLabel.font = fontSystem(kFontS20);
    
}

- (void)refreshData{
    [headerMJ beginRefreshing];
}
- (void)upLoadData
{
    self.footerMJ = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getListNext)];
    
    [self.footerMJ endRefreshingWithNoMoreData];
    [self.footerMJ setTitle:@"" forState:MJRefreshStateIdle];
    //[footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    tblDetail.footer = self.footerMJ;
}

#pragma mark - 获取数据
- (void)refreshList{
    [TaskAPI TaskDetailsWithTaskbn:self.taskBn html2text:true success:^(TaskDetailModel *model) {        
        [self setDetailPage:model];
        [UIView animateWithDuration:0.25 animations:^{
            vNodata.alpha = 0;
            
        }];
        if ([model.username isEqualToString:QGLOBAL.usermodel.username]) {
            QGLOBAL.isEmployer = YES;
        }else{
            QGLOBAL.isEmployer = NO;
        }
        if ([model.model isEqualToString:@"1"]) {// 悬赏
            QGLOBAL.detailTaskWorkType = @"1";
        }else if ([model.is_mark isEqualToString:@"1"] || [model.is_mark isEqualToString:@"2"]){// 明标
            QGLOBAL.detailTaskWorkType = @"2";
        }
        if ([model.is_mark isEqualToString:@"1"]) {
            QGLOBAL.detailTaskWorkBid = @"1";
        }else if([model.is_mark isEqualToString:@"2"]){
            QGLOBAL.detailTaskWorkBid = @"2";
        }
        [self didLoad];
    } failure:^(NetError* err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
        [self showText:err.errMessage];
    }];
}

- (void)refreshListWork
{
    page = 0;
    [self.footerMJ resetNoMoreData];
    [TaskAPI TaskDetailWorkListWithTaskbn:self.taskBn offset:page success:^(TaskWorkListModel *model) {
        totalBids = model.total_bids.integerValue;
        UIButton *btn = (UIButton *)[self.view viewWithTag:301];
        [btn setTitle:[NSString stringWithFormat:@"所有投稿(%ld)",model.total_bids.integerValue] forState:UIControlStateNormal];
        self.arrData=nil;
        self.arrData=[[NSMutableArray alloc]initWithCapacity:kPageSize];
        
        if (model && model.works.count) {
            [self.arrData addObjectsFromArray:model.works];
        }
        [tblDetail reloadData];
        if ([menuNum isEqualToString:@"1"]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 301;
            [self menuAction:btn];
        }
        [tblDetail.header endRefreshing];
        [self didLoad];
        
    } failure:^(NetError* err) {
        [tblDetail.header endRefreshing];
        UIButton *btn = (UIButton *)[self.view viewWithTag:301];
        [btn setTitle:[NSString stringWithFormat:@"所有投稿(%d)",0] forState:UIControlStateNormal];
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
//        [self showText:err.errMessage];
    }];
}
- (void)getListNext
{
    if (self.arrData.count < 20) {
        [self.footerMJ endRefreshingWithNoMoreData];
    }else{
        page++;
        [TaskAPI TaskDetailWorkListWithTaskbn:self.taskBn offset:page success:^(TaskWorkListModel *model) {
            
            [self.arrData addObjectsFromArray:model.works];
            [tblDetail reloadData];
            [tblDetail.footer endRefreshing];
            
            if (kPageSize *page >= [model.total_bids intValue]) {
                [self.footerMJ endRefreshingWithNoMoreData];
            }
            
            [self didLoad];
            
        } failure:^(NetError* err) {
            if (err.errStatusCode == 13862) {
                [self.footerMJ endRefreshingWithNoMoreData];
            }else{
            [self.footerMJ setTitle:@"" forState:MJRefreshStateIdle];
            [tblDetail.footer endRefreshing];
            }
            DLog(@"~~~getListNext:%li ---",(long)err.errStatusCode);
        }];
    }
}

- (void)setDetailPage:(TaskDetailModel *)model
{
    if (model == nil) {
        return;
    }else{
        vBootomLine.hidden = NO;
        vRequireH.constant = kAutoScale *220;
        Taskmodel = [[TaskDetailModel alloc] init];
        Taskmodel = model;
        NSString *moenyStr;
        if ([Taskmodel.is_mark intValue] == 2) {
            moenyStr = @"暗标";
        }else{
            moenyStr = [NSString stringWithFormat:@"¥%.d",[Taskmodel.task_cash intValue]];
        }
        
        CGRect rectFile = [moenyStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
        CGFloat num;
        num = (APP_W-214-rectFile.size.width-5) / 4;
        if(209+rectFile.size.width+5+(num*4)>APP_W){
            num -= (214+rectFile.size.width+5+(num*4)-APP_W)/4;
        }
        if (num < 0) {
            if (model.is_select.intValue == 1) {
                rectFile.size.width = APP_W - (214+(5*4));
                num = (APP_W-214-rectFile.size.width-5) / 4;
                if(209+rectFile.size.width+5+(num*4)>APP_W){
                    num -= (214+rectFile.size.width+5+(num*4)-APP_W)/4;
                }
            }else{
                rectFile.size.width = APP_W - (160+(5*3));
                num = (APP_W-160-rectFile.size.width-5) / 3;
                if(209+rectFile.size.width+5+(num*3)>APP_W){
                    num -= (160+rectFile.size.width+5+(num*3)-APP_W)/3;
                }
            }
        }
        lblmoenyW.constant = rectFile.size.width+5;
        lblMoldL.constant = num;
        lblDepositL.constant = num;
        lblstatusL.constant = num;
        lblSelectL.constant = num;
        
        if ([Taskmodel.username isEqualToString:QGLOBAL.usermodel.username]) {
            btnAdd.hidden = YES;
        }else{
            btnAdd.hidden = NO;
        }
        
        lblName.text = Taskmodel.title;
        if ([Taskmodel.is_mark intValue] == 2) {
            lblMoney.text = @"暗标";
            
        }else{
            lblMoney.text = [NSString stringWithFormat:@"¥%.d",[Taskmodel.task_cash intValue]];
        }
        if (model.is_select.intValue == 1) {
            lblSelect.hidden = NO;
            lblstatus.text = @"承诺选稿";
        }else{
            lblSelect.hidden = YES;
            
            int stepType = [Taskmodel.step intValue];
            switch (stepType) {
                case TaskStepTypeSubmission:
                    lblstatus.text = Taskmodel.status_alias;
                    break;
                case TaskStepTypeDraft:
                    lblstatus.text = @"选标中";
                    break;
                case TaskStepTypePublicity:
                    lblstatus.text = @"公示中";
                    break;
                case TaskStepTypeProduction:
                    lblstatus.text = @"制作中";
                    break;
                case TaskStepTypeEnd:
                    lblstatus.text = @"结束";
                    break;
                default:
                    break;
            }
            
        }
        int tt=Taskmodel.model.intValue; //需求类型（1=>悬赏，2=>招标，3=>雇佣）
        switch (tt) {
            case 1:
                lblMold.text=@"悬赏";
                break;
            case 2:
                lblMold.text=@"招标";
                break;
            case 3:
                lblMold.text=@"雇佣";
                break;
                
            default:
                break;
        }
        // 下部操作按钮
        NSMutableArray *operateArr = [NSMutableArray array];
        operateArr = Taskmodel.operate;
        DLog(@"%@",operateArr);
        //    if ([Taskmodel.username isEqualToString:QGLOBAL.usermodel.username]) {
        //        [operateArr removeAllObjects];
        //    }
        //    operateArr = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:12]];
        if ([operateArr containsObject:[NSNumber numberWithInt:1]] || [operateArr containsObject:[NSNumber numberWithInt:13]]) { //我要投稿
            [btnShare setTitleColor:RGBHex(kColorGray208) forState:UIControlStateNormal];
            [btnShare setTitleColor:RGBHex(kColorMain001) forState:UIControlStateHighlighted];
            [btnCollect setTitleColor:RGBHex(kColorGray208) forState:UIControlStateNormal];
            [btnCollect setTitleColor:RGBHex(kColorMain001) forState:UIControlStateHighlighted];
            btnSubmission.backgroundColor = RGBHex(kColorMain001);
            vBotSubmission.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vBotSubmission];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:2]]){ // 等待选稿
            vBotChoose.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vBotChoose];
            lblBotChoose.textColor = RGBHex(kColorAuxiliary101);
        }else if ([operateArr containsObject:[NSNumber numberWithInt:4]]){ // 签署协议
            btnPubCall.backgroundColor = RGBHex(kColorW);
            [btnPubCall setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
            btnSignature.backgroundColor = RGBHex(kColorMain001);
            vBotPub.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vBotPub];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:5]]){ // 等待签署协议
            btnBidCall.backgroundColor = RGBHex(kColorMain001);
            lblBid.textColor = RGBHex(kColorAuxiliary101);
            lblBid.text = @"等待对方签署协议";
            vbotBid.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vbotBid];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:6]]){
            btnBidCall.backgroundColor = RGBHex(kColorMain001);
            lblBid.textColor = RGBHex(kColorAuxiliary101);
            lblBid.text = @"请至Web端上传源文件";
            vbotBid.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vbotBid];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:7]]){
            btnBidCall.backgroundColor = RGBHex(kColorMain001);
            lblBid.textColor = RGBHex(kColorAuxiliary101);
            lblBid.text = @"等待对方确认";
            vbotBid.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vbotBid];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:8]]){
            btnBidCall.backgroundColor = RGBHex(kColorMain001);
            lblBid.textColor = RGBHex(kColorAuxiliary101);
            lblBid.text = @"请至Web端重新上传";
            vbotBid.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vbotBid];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:9]]){
            btnBidCall.backgroundColor = RGBHex(kColorMain001);
            lblBid.textColor = RGBHex(kColorAuxiliary101);
            lblBid.text = @"等待签署协议";
            vbotBid.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vbotBid];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:10]]){
            btnBidCall.backgroundColor = RGBHex(kColorMain001);
            lblBid.textColor = RGBHex(kColorAuxiliary101);
            lblBid.text = @"等待对方托管资金";
            vbotBid.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vbotBid];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:11]]){
            btnBidCall.backgroundColor = RGBHex(kColorMain001);
            lblBid.textColor = RGBHex(kColorAuxiliary101);
            lblBid.text = @"等待二期托管资金";
            vbotBid.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vbotBid];
        }else if ([operateArr containsObject:[NSNumber numberWithInt:12]]){ // 评价
            btnvEvaluate.backgroundColor = RGBHex(kColorMain001);
            vEvaluate.frame = CGRectMake(0, 0, CGRectGetWidth(vBottom.frame), CGRectGetHeight(vBottom.frame));
            [vBottom addSubview:vEvaluate];
        }
        if (operateArr.count < 1) {
            vBottomH.constant = 0;
        }
        
        if ([Taskmodel.deposit isEqualToString:@"1"]) {
            lblDeposit.text = @"资金已托管";
        }else{
            lblDeposit.text = @"资金未托管";
        }
        
        int stepType = [Taskmodel.step intValue];
        switch (stepType) {
            case TaskStepTypeSubmission:
                lblSelect.text = Taskmodel.status_alias;
                [self checkTime:Taskmodel];
                break;
            case TaskStepTypeDraft:
                lblSelect.text = @"选标中";
                lblData.text = @"选标中";
                break;
            case TaskStepTypePublicity:
                lblSelect.text = @"公示中";
                lblData.text = @"公示中";
                break;
            case TaskStepTypeProduction:
                lblSelect.text = @"制作中";
                lblData.text = @"制作中";
                break;
            case TaskStepTypeEnd:
                lblSelect.text = @"结束";
                lblData.text = @"结束";
                break;
            default:
                break;
        }
        imgRelease.clipsToBounds = YES;
        imgRelease.layer.cornerRadius = 50/2;
        [imgRelease setImageWithURL:[NSURL URLWithString:Taskmodel.publisher.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        lblReleaseData.text = [QGLOBAL dateTimeIntervalToStr:Taskmodel.create_time];
        lblPublisher.text = Taskmodel.publisher.nickname;
        lblRequire.text = Taskmodel.taskDescription;
        
        if (btnDetailImg || btnDetailFile) {
            
        }else{
            imgArr = [NSMutableArray array];
            fileArr = [NSMutableArray array];
            if (Taskmodel.attachment.count > 0) {
                lblhint.hidden = NO;
                
                for (int i = 0; i < Taskmodel.attachment.count; i++) {
                    TaskFileModel *filemodel = Taskmodel.attachment[i];
                    CloudFileContentType tp=[self checkFileType:filemodel.mime name:filemodel.file_name];
                    if (tp==CloudFileContentTypeImage) {
                        if (StrIsEmpty(filemodel.url_preview) && StrIsEmpty(filemodel.url_thumbnail)) {
                            [fileArr addObject:filemodel];
                        }else{
                            [imgArr addObject:filemodel];
                        }
                    }else{
                        [fileArr addObject:filemodel];
                    }
                }
                if (imgArr.count>0) {
                    for (int i = 0; i < imgArr.count; i++) {
                        TaskFileModel *filemodel = imgArr[i];
                        
                        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i*65*kAutoScale+(APP_W-30-65*kAutoScale*5)/4*i, 0, 65*kAutoScale, 65*kAutoScale)];
                        __block UIImageView *_selfImgv=image;
                        [image setImageWithURL:[NSURL URLWithString:filemodel.url_thumbnail] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                            
                            if (error!=nil) {
                                _selfImgv.image=[UIImage imageNamed:@"tulie"];
                            }
                        }];
                        [vFileAtt addSubview:image];
                        btnDetailImg = [UIButton buttonWithType:UIButtonTypeCustom];
                        btnDetailImg.backgroundColor = [UIColor clearColor];
                        btnDetailImg.frame = CGRectMake(i*65*kAutoScale+(APP_W-30-65*kAutoScale*5)/4*i, 0, 65*kAutoScale, 65*kAutoScale);
                        btnDetailImg.tag = i;
                        [vFileAtt addSubview:btnDetailImg];
                        btnDetailImg.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        [btnDetailImg addTarget:self action:@selector(btnImgAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    for (int i = 0; i < fileArr.count; i++) {
                        btnDetailFile = [UIButton buttonWithType:UIButtonTypeCustom];
                        btnDetailFile.frame = CGRectMake(0, (i*20)+85+i*15, APP_W-30, 20);
                        [self creatBtnDetailFileindex:i];
                    }
                    vFileAttH.constant = 30*fileArr.count+85+15*(fileArr.count-1);
                    
                }else{
                    for (int i = 0; i < fileArr.count; i++) {
                        btnDetailFile = [UIButton buttonWithType:UIButtonTypeCustom];
                        btnDetailFile.frame = CGRectMake(0, i*20+i*15, APP_W-30, 20);
                        [self creatBtnDetailFileindex:i];
                    }
                    vFileAttH.constant = 30*fileArr.count+15*(fileArr.count-1);
                }
            }else{
                vFileT.constant = -40;
                lblhint.hidden = YES;
            }
        }
    
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:lblRequire.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:kTaskLineSpac];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [lblRequire.text length])];
        [lblRequire setAttributedText:attributedString1];
        CGRect rect = [lblRequire.text boundingRectWithSize:CGSizeMake(APP_W - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:paragraphStyle1} context:nil];
        lblRequireH.constant = rect.size.height+5;
        NSNumber *publisher = Taskmodel.favored.publisher;
        isConcern = [publisher intValue];
        if ([publisher intValue] == 0) {
            
        }else{
            [btnAdd setTitle:@"取消关注" forState:UIControlStateNormal];
            [btnAdd setImage:nil forState:UIControlStateNormal];
        }
        
        
        for (int i = 0; i < [Taskmodel.step integerValue]; i++) {
            if (i == 5) {
                UIView *view = (UIView *)[self.view viewWithTag:101+i];
                view.backgroundColor = RGBHex(kColorAuxiliary105);
            }
            UIView *view = (UIView *)[self.view viewWithTag:100+i];
            view.backgroundColor = RGBHex(kColorAuxiliary105);
            UIImageView *img = (UIImageView *)[self.view viewWithTag:1000+i];
            img.image = [UIImage imageNamed:@"arrow_Select"];
            UILabel *lbl = (UILabel *)[self.view viewWithTag:10000+i];
            lbl.textColor = RGBHex(kColorAuxiliary105);
        }
        if ([Taskmodel.favored.task intValue] == 1) {
            [btnCollect setImage:[UIImage imageNamed:@"Collect2"] forState:UIControlStateNormal];
        }
    }
    
}

- (void)checkTime:(TaskDetailModel*)mm{
    if (!StrIsEmpty(mm.sub_end_time_alias)) {
        lblData.text=mm.sub_end_time_alias;
    }
    else {
        lblData.text=[QGLOBAL dateDiffFromTimeInterval:mm.sub_end_time];
    }
}
- (void)creatBtnDetailFileindex:(int)index{
    TaskFileModel *filemodel = fileArr[index];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@(%@)",filemodel.file_name,[QGLOBAL stringFromFileSize:filemodel.file_size.doubleValue]]];
    NSRange range = [[NSString stringWithFormat:@"  %@(%@)",filemodel.file_name,[QGLOBAL stringFromFileSize:filemodel.file_size.doubleValue]] rangeOfString:filemodel.file_name];
    [str addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorMain001) range:range];
    NSRange range2 = [[NSString stringWithFormat:@"  %@(%@)",filemodel.file_name,[QGLOBAL stringFromFileSize:filemodel.file_size.doubleValue]] rangeOfString:[NSString stringWithFormat:@"(%@)",[QGLOBAL stringFromFileSize:filemodel.file_size.doubleValue]]];
    [str addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorGray201) range:range2];
    btnDetailFile.backgroundColor = RGBHex(kColorW);
    
    [btnDetailFile setImage:[UIImage imageNamed:@"wenjtb"] forState:UIControlStateNormal];
    
    [btnDetailFile setAttributedTitle:str forState:UIControlStateNormal];
    
    NSMutableAttributedString *strHighlighted = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@(%@)",filemodel.file_name,[QGLOBAL stringFromFileSize:filemodel.file_size.doubleValue]]];
    [strHighlighted addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorGray211) range:range];
    [strHighlighted addAttribute:NSForegroundColorAttributeName value:RGBHex(kColorGray211) range:range2];
    [btnDetailFile setAttributedTitle:strHighlighted forState:UIControlStateHighlighted];
    btnDetailFile.titleLabel.font = fontSystem(kFontS28);
    btnDetailFile.tag = index;
    [vFileAtt addSubview:btnDetailFile];
    btnDetailFile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnDetailFile addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 图片
- (void)openImages:(NSMutableArray*)list index:(NSInteger)index{
    ImagesPreviewVC *vc=[[ImagesPreviewVC alloc]init];
//    vc.delegate=self;
    vc.arrPhotos=list;
    vc.indexSelected=index;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)test{
//    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:imgArr.count];
//    ImagesPreviewModel *m1=[ImagesPreviewModel new];
//    m1.title=@"镜头缓缓推向格伦和亚伯拉罕";
//    m1.imgPreviewURL=@"http://news.vsochina.com/uploadfile/2016/1104/20161104045849653.gif";
//    m1.imgSize=@"50000000";
//    m1.imgSizeString=@"5MB";
//    [tmp addObject:m1];
//    
//    ImagesPreviewModel *m2=[ImagesPreviewModel new];
//    m2.title=@"abc 222222 towo two 大师大师大大方式方法 ";
//    m2.imgPreviewURL=@"http://image17-c.poco.cn/mypoco/myphoto/20151204/12/61830202015120412592407_640.jpg?800x962_120";
//    m2.imgURL=@"http://image17-c.poco.cn/mypoco/myphoto/20151204/12/61830202015120412592407.jpg?800x962_120";
//    m2.imgSize=@"5000000000";
//    m2.imgSizeString=@"5MB";
//    m2.oid=self.taskBn;
//    [tmp addObject:m2];
//    
//    ImagesPreviewModel *m3=[ImagesPreviewModel new];
//    m3.title=@"333333333";
//    m3.imgPreviewURL=@"http://img.lkong.cn/avatar/000/38/91/88_avatar_middle.jpg";
//    m3.imgSize=@"5000000000";
//    m3.imgSizeString=@"5MB";
//    [tmp addObject:m3];
//    
//    ImagesPreviewModel *m4=[ImagesPreviewModel new];
//    m4.title=@"是《行尸走肉》最引人入胜";
//    m4.imgPreviewURL=@"http://news.vsochina.com/uploadfile/2016/1104/20161104045858143.jpg";
//    [tmp addObject:m4];
//
//    [self openImages:tmp index:0];
//}
#pragma mark - action
- (IBAction)menuAction:(id)sender{
//    [self test];
//    return;
    
    UIButton *btn=sender;
    int tag = (int)btn.tag;
    if (tag == 300) {
        UIButton *btnl = (UIButton *)[self.view viewWithTag:300];
        [btnl setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
        UIButton *btnr = (UIButton *)[self.view viewWithTag:301];
        [btnr setTitleColor:RGBHex(kColorGray202) forState:UIControlStateNormal];
        [vTask removeAllSubviews];
        vRequire.frame = CGRectMake(0, 0, CGRectGetWidth(vTask.frame), CGRectGetHeight(vTask.frame));
        if (vTopH.constant < 1) {
            vRequireH.constant = APP_H;
        }
        [vTask addSubview:vRequire];
    }else if (tag == 301){
        UIButton *btnl = (UIButton *)[self.view viewWithTag:300];
        [btnl setTitleColor:RGBHex(kColorGray202) forState:UIControlStateNormal];
        
        UIButton *btnr = (UIButton *)[self.view viewWithTag:301];
        [btnr setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
        [vTask removeAllSubviews];
        if (self.arrData.count > 0) {
            tblDetail.frame = CGRectMake(0, 0, CGRectGetWidth(vTask.frame), CGRectGetHeight(vTask.frame));
            [vTask addSubview:tblDetail];
        }else{
            
            vkong.frame = CGRectMake((APP_W / 2) - 83.5, 10, 167, 181);
            [vTask addSubview:vkong];
            UISwipeGestureRecognizer *swipeGesture;
            swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
            
            swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
            [vTask addGestureRecognizer:swipeGesture];
            swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
            swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
            [vTask addGestureRecognizer:swipeGesture];
        }
        
    }
    [UIView animateWithDuration:0.05*((tag-300)+1) animations:^{
        vBlue.x=(tag-300)*menuW+30;
    }];
    
}
#pragma mark - 点击打开附件方法
- (void)btnAction:(UIButton *)sender
{
    // sender.tag  是第几个附件。
    TaskFileModel *filemodel = fileArr[sender.tag];
    CloudFileContentType tp=[self checkFileType:filemodel.mime name:filemodel.file_name];
    NSArray *arr=[filemodel.mime componentsSeparatedByString:@"/"];
    NSString *ss=arr.lastObject;
    if (tp == CloudFileContentTypeDocument || [ss isEqualToString:@"gif"]){
        OpenFileModel *model = [[OpenFileModel alloc] init];
        model.fileExt = filemodel.file_ext;
        model.urlDownload = filemodel.url_download;
        model.fileName = filemodel.file_name;
        model.filePath = filemodel.file_path;
        model.mime = filemodel.mime;
        model.fileSizeAlias = filemodel.file_size_alias;
        model.fileSize = filemodel.file_size;
        OpenFileDetailVC *vc = [[OpenFileDetailVC alloc]init];
        //    vc.filePath = filemodel.file_path;
        vc.fileModel = model;
        vc.hidesMenu = YES;
        vc.FileTitle = filemodel.file_name;
        vc.contentType=filemodel.mime;
        vc.taskBn = Taskmodel.task_bn;
        //    NSArray *nameArr=[title componentsSeparatedByString:@"."];
        //    [MobClick event:cb_open_document attributes:@{@"file":StrFromObj([nameArr lastObject])}];
        [self.navigationController pushViewController:vc animated:YES];
        DLog(@"文件路径 :%@",filemodel.file_path);
    }else{
        [self showText:@"暂不支持该类型文件预览"];
    }
}
#pragma mark - 点击打开图片附件
- (void)btnImgAction:(UIButton *)sender
{
    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:imgArr.count];
    for (TaskFileModel *mm in imgArr) {
        ImagesPreviewModel *mod=[[ImagesPreviewModel alloc]init];
        mod.title=mm.file_name;
        mod.imgURL=mm.url_download;
        mod.imgPreviewURL=mm.url_preview;
        mod.oid=self.taskBn;
        mod.imgSize=mm.file_size;
        mod.imgSizeString=mm.file_size_alias;
        [tmp addObject:mod];
//        DLog(@"%@",[mod toDictionary]);
    }
    [self openImages:tmp index:sender.tag];
}
- (void)TaskDetailFileDelegate:(id)delegate model:(TaskDetailWorksModel *)model
{
    CloudFileContentType tp=[self checkFileType:model.work_ext.mime name:model.work_ext.file_name];
    if ([model.username isEqualToString:QGLOBAL.auth.username] || [QGLOBAL.auth.username isEqualToString:Taskmodel.username]) {
        NSArray *arr=[model.work_ext.mime componentsSeparatedByString:@"/"];
        NSString *ss=arr.lastObject;
        if (tp == CloudFileContentTypeDocument || [ss isEqualToString:@"gif"]){
            OpenFileModel *FileModel = [[OpenFileModel alloc] init];
            FileModel.fileExt = model.work_ext.file_ext;
            FileModel.urlDownload = model.work_ext.url_download;
            FileModel.fileName = model.work_ext.file_name;
            FileModel.filePath = model.work_ext.file_path;
            FileModel.mime = model.work_ext.mime;
            FileModel.fileSizeAlias = model.work_ext.file_size_alias;
            FileModel.fileSize = model.work_ext.file_size;
            OpenFileDetailVC *vc = [[OpenFileDetailVC alloc]init];
            //    vc.filePath = filemodel.file_path;
            vc.fileModel = FileModel;
            vc.hidesMenu = YES;
            vc.FileTitle = model.work_ext.file_name;
            vc.contentType=model.work_ext.mime;
            vc.taskBn = Taskmodel.task_bn;
            //    NSArray *nameArr=[title componentsSeparatedByString:@"."];
            //    [MobClick event:cb_open_document attributes:@{@"file":StrFromObj([nameArr lastObject])}];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self showText:@"暂不支持该类型文件预览"];
        }
    }else{
        [self showText:@"仅限发布者和投稿者自己预览"];
    }
}
- (void)TaskDetailImageDelegate:(id)delegate model:(TaskDetailWorksModel *)model
{
    if ([model.username isEqualToString:QGLOBAL.auth.username] || [QGLOBAL.auth.username isEqualToString:Taskmodel.username]) {
        NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:1];
        if (model.work_ext) {
            TaskFileModel *mm=model.work_ext;
            ImagesPreviewModel *mod=[[ImagesPreviewModel alloc]init];
            mod.title=mm.file_name;
            mod.imgURL=mm.url_download;
            mod.imgPreviewURL=mm.url_preview;
            mod.oid=self.taskBn;
            mod.imgSize=mm.file_size;
            mod.imgSizeString=mm.file_size_alias;
            [tmp addObject:mod];
        }
//        DLog(@"投稿者:%@",[model.work_ext toDictionary]);
        [self openImages:tmp index:0];
    }else{
        [self showText:@"仅限发布者和投稿者自己预览"];
    }
}
#pragma mark 轻扫手势方法
- (void)swipeGestureAction:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.25 animations:^{
            vDown.y = 0;
            vTopH.constant = 0;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            vDown.y = 189;
            vTopH.constant = 189;
        }];
    }
}
// 分享
- (IBAction)btnShareAction:(id)sender {
    
    [[ThirdShare sharedInstance] ThirdShareView:Taskmodel.link name:Taskmodel.title nav:self.navigationController title:Msg_ShareTaskDeati btnCopy:NO];
}
// 收藏
- (IBAction)btncollectAction:(id)sender {
  
    if (![QGLOBAL hadAuthToken]) {
//        BaseViewController* vc=[QGLOBAL viewControllerName:@"RegisterVC" storyboardName:@"Register"];
        loginVC *vc=[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
        vc.backButtonEnabled=YES;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
//        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MobClick event:UMTaskFavo];
        [self showLoading];  
        DLog(@"btncollectAction");
        if ([Taskmodel.favored.task intValue] == 1) {
            
            [btnCollect setImage:[UIImage imageNamed:@"Collect"] forState:UIControlStateNormal];
            [TaskAPI FavorDeleteTaskBn:@[StrFromObj(self.taskBn)] success:^(id model) {
                Taskmodel.favored.task = [NSNumber numberWithInt:0];
                [self showText:@"取消成功"];
                [self didLoad];
            } failure:^(NetError* err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
                [btnCollect setImage:[UIImage imageNamed:@"Collect2"] forState:UIControlStateNormal];
            }];
            
        }else{
            [btnCollect setImage:[UIImage imageNamed:@"Collect2"] forState:UIControlStateNormal];
            [TaskAPI FavorAddTaskBn:self.taskBn success:^(id model) {
                Taskmodel.favored.task = [NSNumber numberWithInt:1];
                [self showText:@"收藏成功"];
                [self didLoad];
            } failure:^(NetError* err) {
                DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
                [self didLoad];
                
                [self showText:err.errMessage];
                [btnCollect setImage:[UIImage imageNamed:@"Collect"] forState:UIControlStateNormal];
            }];
        }
    }
}
// 投稿
- (IBAction)btnPostAction:(id)sender {
    [self showLoading];
    if (![QGLOBAL hadAuthToken]) {
        loginVC *vc=(loginVC *)[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
        vc.backButtonEnabled=YES;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            //
            [self didLoad];
        }];
    }else{
        [TaskAPI SubmissionCheckSuccess:^(id model) {
            SubmissionVC *vc = [[SubmissionVC alloc] initWithNibName:@"SubmissionVC" bundle:nil];
            vc.taskBn = self.taskBn;
            if ([Taskmodel.is_mark intValue] == 1) {
                vc.isMArk = @"1";
            }else if ([Taskmodel.is_mark intValue] == 2){
                vc.isMArk = @"2";
            }else if ([Taskmodel.model intValue] == 1){
                vc.isMArk = @"3";
            }
            vc.submissionBlock = ^(){
                menuNum = @"1";
                
                [self refreshListWork];
                
            };
            [self.navigationController pushViewController:vc animated:YES];
            [self didLoad];
        } failure:^(NetError *err) {
            DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
            [self didLoad];
            if (err.errStatusCode == 15128 || err.errStatusCode == 15131 || err.errStatusCode == 15132 || err.errStatusCode == 15134) {
                DLog(@"%@",QGLOBAL.auth.mobile);
                if ([QGLOBAL.auth.mobile isEqualToString:@""] || QGLOBAL.auth.mobile == nil) {
                    UIAlertController *alt = [UIAlertController alertControllerWithTitle:Msg_CheckPhoneBound message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *can = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        phoneBound *vc=(phoneBound *)[QGLOBAL viewControllerName:@"phoneBound" storyboardName:@"PersonalInfo"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alt addAction:can];
                    [alt addAction:cancel];
                    
                    [self presentViewController:alt animated:YES completion:nil];
                }else{
                    [self showText:Msg_CheckBound delay:2.0];
                }
                
            }else if (err.errStatusCode == 15121){
                UIAlertController *alt = [UIAlertController alertControllerWithTitle:Msg_AuthRealName message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *real = [UIAlertAction actionWithTitle:@"个人认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self menuRealNameVC];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alt addAction:real];
                [alt addAction:cancel];
                [self presentViewController:alt animated:YES completion:nil];
            }else if (err.errStatusCode == 15123 || err.errStatusCode == 15122 || err.errStatusCode == 15126){
                UIAlertController *alt = [UIAlertController alertControllerWithTitle:Msg_AuthTeam message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *company = [UIAlertAction actionWithTitle:@"企业认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self menuCompany];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alt addAction:company];
                [alt addAction:cancel];
                
                [self presentViewController:alt animated:YES completion:nil];
            }else if (err.errStatusCode == 15124 || err.errStatusCode == 15125 || err.errStatusCode == 15127){
                UIAlertController *alt = [UIAlertController alertControllerWithTitle:Msg_Auth message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *real = [UIAlertAction actionWithTitle:@"个人认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self menuRealNameVC];
                }];
                UIAlertAction *company = [UIAlertAction actionWithTitle:@"企业认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self menuCompany];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alt addAction:real];
                [alt addAction:company];
                [alt addAction:cancel];
                [self presentViewController:alt animated:YES completion:nil];
            }else if (err.errStatusCode == 15139){
                [self showText:Msg_Submissionnum delay:2.0];
            }else if(err.errStatusCode == 15129 || err.errStatusCode == 15130 || err.errStatusCode == 15135 || err.errStatusCode == 15136 || err.errStatusCode == 15137 || err.errStatusCode == 15138 || err.errStatusCode == 15133){
                [self showText:Msg_CheckBound delay:2.0];
            }
//            [self showText:err.errMessage];
        }];
        
        
//        SubmissionVC *vc = [[SubmissionVC alloc] initWithNibName:@"SubmissionVC" bundle:nil];
//        vc.taskBn = self.taskBn;
//        if ([Taskmodel.is_mark intValue] == 1) {
//            vc.isMArk = @"1";
//        }else if ([Taskmodel.is_mark intValue] == 2){
//            vc.isMArk = @"2";
//        }else if ([Taskmodel.model intValue] == 1){
//            vc.isMArk = @"3";
//        }
//        [self.navigationController pushViewController:vc animated:YES];
//        
    }
}



- (void)menuRealNameVC{
    
    RealNameNew *vc = [[RealNameNew alloc] initWithNibName:@"RealNameNew" bundle:nil];
    vc.delegatePopVC=self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)menuCompany
{
    CompanyAuthNewVC *vc=[[CompanyAuthNewVC alloc] initWithNibName:@"CompanyAuthNewVC" bundle:nil];
    vc.delegatePopVC=self;
    [self.navigationController pushViewController:vc animated:YES];
}

// 关注
- (IBAction)btnConcernAction:(id)sender {
    if (![QGLOBAL hadAuthToken]) {
        loginVC *vc=(loginVC *)[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
        vc.backButtonEnabled=YES;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
    }else{
        [self showLoading];
        if (isConcern == 0) {
            [MineAPI concernAddObjName:Taskmodel.username success:^(id model) {
                [self didLoad];
                isConcern = 1;
                [btnAdd setTitle:@"取消关注" forState:UIControlStateNormal];
                [btnAdd setImage:nil forState:UIControlStateNormal];
                [self showText:@"关注成功"];
            } failure:^(NetError *err) {
                [self didLoad];
                [self showText:err.errMessage];
                DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            }];
        }else{
            [MineAPI myConcernCancelObjName:Taskmodel.username success:^(id model) {
                [self didLoad];
                [btnAdd setTitle:@"加关注" forState:UIControlStateNormal];
                [btnAdd setImage:[UIImage imageNamed:@"subscription"] forState:UIControlStateNormal];
                isConcern = 0;
                [self showText:@"取消成功"];
            } failure:^(NetError *err) {
                [self didLoad];
                [self showText:err.errMessage];
                DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
                
            }];
        }
    }
}
// 签署协议
- (IBAction)btnProtocol:(id)sender {
    ProtocolVC *vc=[[ProtocolVC alloc] initWithNibName:@"ProtocolVC" bundle:nil];
    vc.protocolType = Taskmodel.model;
    vc.taskbn = self.taskBn;
    [self.navigationController pushViewController:vc animated:YES];
}
// 联系发布者相关信息
- (IBAction)btnCallAction:(id)sender
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"是否拨打 %@?",Taskmodel.mobile] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",Taskmodel.mobile];
        if (str != nil) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]]];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alt addAction:can];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
}
- (IBAction)btnEvaluateAction:(id)sender {
    [MobClick event:UMTaskComment];
    EvaluateVC *vc = [[EvaluateVC alloc] initWithNibName:@"EvaluateVC" bundle:nil];
    vc.taskBn = self.taskBn;
    vc.imgstr = Taskmodel.publisher.avatar;
    vc.name = Taskmodel.publisher.nickname;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    [super getNotifType:type data:data target:obj];
    if (type == NotifLoginSuccess){
        //login
        DLog(@">>> 需求详情用户登录成功，赶紧刷新下界面～～～");
        
    }
    
}

#pragma mark - table
- (void)tableDataSourceInit{
    TaskDetailWorksModel *model  = [[TaskDetailWorksModel alloc] init];
    model.isSelct = [NSNumber numberWithBool:NO];

    tblDetail.delegate=self;
    tblDetail.dataSource=self;
    
}

#pragma mark - TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString *tableID;
    if (row < self.arrData.count) {
        TaskDetailWorksModel *model = self.arrData[indexPath.row];
        BaseTableCell *cell;
        if ([model.is_mark integerValue] == 1) {
            
        tableID = @"TaskDetailCell";
        
        }else if ([model.is_mark integerValue] == 2){
            tableID = @"TaskDetailHideCell";
            
        }
        cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] lastObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        cell.delegate=self;
        [cell setCell:model];
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //底部高度
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    // 自定义的Footer
    UIView *vv=[[UIView alloc]init];
    vv.backgroundColor=[UIColor clearColor];
    return vv;
}

//#pragma mark - 点击事件
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row=indexPath.row;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetailWorksModel *model = self.arrData[indexPath.row];
    if ([model.is_mark integerValue] == 1) {
        return [TaskDetailCell getCellHeight:model];
    }
    return 152;
}
- (void)viewDidLayoutSubviews
{
    if ([tblDetail respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblDetail setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([tblDetail respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblDetail setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:requireScro]) {
        
    
    if (requireScro.contentOffset.y > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            if (vTopH.constant > 1) {
                if (requireScro.contentSize.height-APP_H<0) {
                    requireScro.contentSize = CGSizeMake(0, APP_H);
                }
                vDown.y = 0;
                vTopH.constant = 0;
                
            }
        }];
        vRequire.height = vTask.height;
    }else if(requireScro.contentOffset.y < -20){
        [UIView animateWithDuration:0.25 animations:^{
            vDown.y = 189;
            vTopH.constant = 189;
        }];
    }
    }else{
    if (scrollView.contentOffset.y > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            vDown.y = 0;
            vTopH.constant = 0;
            tblDetail.height = APP_H;
        }];
    }else if(scrollView.contentOffset.y < -10){
        [UIView animateWithDuration:0.25 animations:^{
            vDown.y = 189;
            vTopH.constant = 189;
        }];
    }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
#pragma mark - check type
- (CloudFileContentType)checkFileType:(NSString*)type name:(NSString*)name{
    if (type==nil) {
        return CloudFileContentTypeNone;
    }
    
    NSArray *arr=[type componentsSeparatedByString:@"/"];
    NSString *ss=arr.firstObject;
    NSString *ls = arr.lastObject;
    if ([ss compareInsensitive:@"image"]) {
        //判断是否是ps文档
        if ([ls rangeOfString:@"photoshop"].location != NSNotFound) {//image/vnd.adobe.photoshop
            return CloudFileContentTypeVirtual;
        }
        if ([ls rangeOfString:@"tiff"].location != NSNotFound) {//image/tiff
            return CloudFileContentTypeVirtual;
        }
        return CloudFileContentTypeImage;
    }
    if ([ss compareInsensitive:@"video"]) {
        return CloudFileContentTypeVideo;
    }
    if ([ss compareInsensitive:@"audio"]) {
        return CloudFileContentTypeAudio;
    }
    if ([ss compareInsensitive:@"text"]) {
        return CloudFileContentTypeDocument;
    }
    if ([ss compareInsensitive:@"application"]) {
        
        CloudFileContentType ty ;
        ty= [self checkDocument:ls name:name];
        if (ty==CloudFileContentTypeDocument) {
            return CloudFileContentTypeDocument;
        }
        
//        ty = [self checkVirtual:ls name:name];
//        if (ty==CloudFileContentTypeVirtual) {
//            return CloudFileContentTypeVirtual;
//        }
        
        return CloudFileContentTypeApplication;
    }
    
    return CloudFileContentTypeUnknow;
}
- (CloudFileContentType)checkDocument:(NSString*)ls name:(NSString*)name{
    //判断是否是office文档
    if ([ls rangeOfString:@"officedocument"].location != NSNotFound) {
        return CloudFileContentTypeDocument;
    }
    if ([ls rangeOfString:@"word"].location != NSNotFound) {//msword
        return CloudFileContentTypeDocument;
    }
    if ([ls rangeOfString:@"excel"].location != NSNotFound) {//vnd.ms-excel
        return CloudFileContentTypeDocument;
    }
    if ([ls rangeOfString:@"powerpoint"].location != NSNotFound) {//vnd.ms-powerpoint
        return CloudFileContentTypeDocument;
    }
//    if ([ls rangeOfString:@"zip"].location != NSNotFound) {//vnd.ms-powerpoint
//        return CloudFileContentTypeDocument;
//    }
    if ([ls rangeOfString:@"txt"].location != NSNotFound) {//vnd.ms-powerpoint
        return CloudFileContentTypeDocument;
    }
    if ([ls rangeOfString:@"ppt"].location != NSNotFound) {//vnd.ms-powerpoint
        return CloudFileContentTypeDocument;
    }
    if ([ls rangeOfString:@"pptx"].location != NSNotFound) {//vnd.ms-powerpoint
        return CloudFileContentTypeDocument;
    }
    //编程文档
//    if ([ls rangeOfString:@"javascript"].location != NSNotFound) {
//        return CloudFileContentTypeDocument;
//    }
//    if ([ls rangeOfString:@"xml"].location != NSNotFound) {
//        return CloudFileContentTypeDocument;
//    }
    if ([ls rangeOfString:@"pdf"].location != NSNotFound) {
        return CloudFileContentTypeDocument;
    }
//    if ([ls rangeOfString:@"rtf"].location != NSNotFound) {
//        return CloudFileContentTypeDocument;
//    }
//    if ([ls rangeOfString:@"sql"].location != NSNotFound) {//x-sql
//        return CloudFileContentTypeDocument;
//    }
    //未知文件，看后缀
    if ([ls rangeOfString:@"octet-stream"].location != NSNotFound) {
        DLog(@">>>open:%@",name);
        if (!StrIsEmpty(name)) {
            NSArray *arr2=[name componentsSeparatedByString:@"."];
            if (arr2.count>=2) {
                //全部变小写
                NSString *ext = [arr2.lastObject lowercaseString];
                //mac os文档
                if ([ext isEqualToString:@"numbers"] || [ext isEqualToString:@"key"] || [ext isEqualToString:@"pages"]) {
                    return CloudFileContentTypeDocument;
                }
                //编程文档
                if ([ext isEqualToString:@"m"]) {
                    return CloudFileContentTypeDocument;
                }
            }
        }
    }
    
    return CloudFileContentTypeUnknow;
}
- (void)TaskDetailCellDelegateOpenOrClose
{
    [tblDetail reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
