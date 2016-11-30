//
//  InformVC.m
//  cyy_task
//
//  Created by zhchen on 16/8/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "InformVC.h"
#import "InformCell.h"
#import "MessageAPI.h"
#import "MJRefresh.h"
#import "DetailVC.h"
#import "RegisterWebVC.h"
@interface InformVC ()<UITableViewDelegate,UITableViewDataSource,cloudBaseCellDelegate>
{
    BOOL isStyleSel;
    BOOL isAllSel;
    UIButton *btnEndRead,*btndele;
    NSInteger page;
    MJRefreshNormalHeader *headerMJ;
    NSString *cellType;
    NSString *relistType;
    UIView *vline;
}

@end

@implementation InformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;
    self.arrClick=nil;
    self.arrClick=[NSMutableArray array];
    [self refreshList];
    [self setupMJ];
    [self upLoadData];
    
    // Do any additional setup after loading the view.
}
#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![QGLOBAL hadAuthToken]) {
        DLog(@"未登录");
        
        [self showInfoViewLogin:@"您还未登录," image:@"goLogin"];
    }else {
        [self removeInfoLoginView];
        if ([relistType isEqualToString:@"1"]) {
            [self refreshList];
        }else {
            //刷新表，未读成已读
            [self.tableMain reloadData];
        }
        
    }
    
}
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"通知"];
    
    btnEndRead = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEndRead.frame = CGRectMake(0, APP_H - 94, APP_W / 2, 50);
    btnEndRead.backgroundColor = RGBHex(kColorW);
    [btnEndRead setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    [btnEndRead setTitle:@"标记为已读" forState:UIControlStateNormal];
    [self.view addSubview:btnEndRead];
    btnEndRead.hidden = YES;
    
    vline = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnEndRead.frame), CGRectGetMinY(btnEndRead.frame), 0.5, 50)];
    vline.backgroundColor = RGBHex(kColorGray206);
    vline.hidden = YES;
    [self.view addSubview:vline];
    
    btndele = [UIButton buttonWithType:UIButtonTypeCustom];
    btndele.backgroundColor = RGBHex(kColorW);
    [btndele setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    [btndele setTitle:@"删除" forState:UIControlStateNormal];
    btndele.hidden = YES;
    btndele.frame = CGRectMake(CGRectGetMaxX(vline.frame), CGRectGetMinY(btnEndRead.frame), APP_W / 2, 50);
    [self.view addSubview:btndele];
    [btndele addTarget:self action:@selector(btnDeleAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnEndRead addTarget:self action:@selector(btnReadAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)naviRight
{
    if ([QGLOBAL hadAuthToken]) {
        if (self.arrData.count > 0) {
            [self naviRightButton:@"编辑" action:@selector(navRightAction:)];
        }else{
            [self naviRightButton:@"" action:nil];
        }
    }
}
#pragma mark - 上下拉刷新
- (void)setupMJ {
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
- (void)upLoadData
{
    self.footerMJ = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getListNext)];
    
    [self.footerMJ endRefreshingWithNoMoreData];
    [self.footerMJ setTitle:@"" forState:MJRefreshStateIdle];
    //[footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tableMain.footer = self.footerMJ;
}

#pragma mark - 获取数据
- (void)refreshList{
    page = 0;
    [self.footerMJ resetNoMoreData];
    [MessageAPI SystemMessageListType:@"appmsg" offset:page success:^(NSMutableArray *data) {
        relistType = @"0";
        self.arrData=nil;
        self.arrData=[[NSMutableArray alloc]initWithCapacity:kPageSize];
        [self.arrData addObjectsFromArray:data];
        if (self.arrData.count > 0) {
            [self removeInfoView];
            [self naviRight];
        }else{
            [self showInfoView:@"没有消息" image:@"pic_nothing"];
        }
        [self.tableMain.header endRefreshing];
        [self.tableMain reloadData];
        [self didLoad];
    } failure:^(NetError* err) {
        if (err.errStatusCode == 13862) {
            if ([QGLOBAL hadAuthToken]) {
                [self.arrData removeAllObjects];
                [self naviRight];
                [self showInfoView:@"没有消息" image:@"pic_nothing"];
            }else{
                relistType = @"1";
                [self noSearchResult:YES message:@"您还未登录,"];
            }
        }else{
            [self showText:err.errMessage];
        }
        [self.tableMain.header endRefreshing];
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
    }];
    
}

- (void)getListNext
{
    page ++;
    [MessageAPI SystemMessageListType:@"appmsg" offset:page success:^(NSMutableArray *data) {
        [self.arrData addObjectsFromArray:data];
        [self.tableMain.footer endRefreshing];
        
        self.footerMJ.automaticallyHidden = YES;
        if (data.count == 0) {
            [self.footerMJ endRefreshingWithNoMoreData];
        }
        [self.tableMain reloadData];
        [self didLoad];
    } failure:^(NetError* err) {
        if (err.errStatusCode == 13862) {
            [self.footerMJ endRefreshingWithNoMoreData];
        }else{
            DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
            [self.footerMJ setTitle:@"" forState:MJRefreshStateIdle];
            [self.tableMain.footer endRefreshing];
            [self showText:err.errMessage];
        }
    }];
}

- (void)noSearchResult:(BOOL)show message:(NSString *)message{
    if (show) {
        [self showInfoViewLogin:message image:@"goLogin"];
    }
    else {
        [self removeInfoLoginView];
    }
}
#pragma mark - tableview代理方法
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
    static NSString *tableID;
    if (indexPath.row < self.arrData.count) {
        tableID = @"InformCell";
        InformCell *cell;
        cell = (InformCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] lastObject];
        SysMessagesModel *mm = [self.arrData objectAtIndex:indexPath.row];
        if ([cellType isEqualToString:@"1"]) {
            cell.vShowL.constant = 65;
            cell.lblDetailR.constant = -55;
        }else{
            cell.vShowL.constant = 0;
            cell.lblDetailR.constant = 10;
        }
        if (indexPath.row == self.arrData.count-1) {
            cell.separatorHidden = YES;
        }
        
        cell.delegate = self;
        [cell setCell:mm];
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SysMessagesModel *mm = [self.arrData objectAtIndex:indexPath.row];
    if (isStyleSel) {
        BOOL st=mm.isSel.boolValue;
        mm.isSel=[NSNumber numberWithBool:!st];
        [self.tableMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        InformCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.vShowL.constant = 65;
        cell.lblDetailR.constant = -55;
        if (mm != nil) {
            [self checkSelectedList:indexPath.row SysMessagesModel:mm];
        }
        
    }else{
        RegisterWebVC *vc=(RegisterWebVC *)[QGLOBAL viewControllerName:@"RegisterWebVC" storyboardName:@"RegisterWeb"];
        vc.registerF = WebTypeMessage;
        
        vc.msgId = mm.msg_id;
        [self.navigationController pushViewController:vc animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

#pragma mark - cloudBaseCellDelegate
- (void)cloudBaseCellDelegate:(id)delegate  UserItemModel:(SysMessagesModel*)mm{
    
    if (isStyleSel) {
        //多选状态
        [self checkSelectedList:[self.arrData indexOfObject:mm] SysMessagesModel:mm];
    }
}

- (void)checkSelectedList:(NSInteger)index SysMessagesModel:(SysMessagesModel*)mm{
    if (mm.isSel.boolValue) {
        [self.arrClick addObject:mm];
    }
    else {
        NSInteger ii=[self.arrClick indexOfObject:mm];
        [self.arrClick removeObjectAtIndex:ii];
    }
}
#pragma mark - action
- (IBAction)navRightAction:(id)sender{
    isStyleSel = !isStyleSel;
    for (SysMessagesModel *mm in self.arrClick) {
        mm.isSel=[NSNumber numberWithBool:NO];
    }
    
    [self.arrClick removeAllObjects];
    if (isStyleSel) {
        btnEndRead.hidden = NO;
        btndele.hidden = NO;
        vline.hidden = NO;
        if (self.arrClick.count > 0) {
            [self.arrClick removeAllObjects];
        }
        [self naviRightButton:@"取消" action:@selector(navRightAction:)];
        [self naviLeftButton:@"全选" action:@selector(navLeftAction:)];
        isAllSel = NO;
        cellType = @"1";
        [self.tableMain reloadData];
    }else{
        btnEndRead.hidden = YES;
        btndele.hidden = YES;
        vline.hidden = YES;
        [self naviRightButton:@"编辑" action:@selector(navRightAction:)];
        [self naviLeftButtonImage:[UIImage imageNamed:@"back"] highlighted:nil action:@selector(popVCAction:)];
        cellType = @"0";
        [self.tableMain reloadData];
        
    }
}

- (IBAction)navLeftAction:(id)sender{
    isAllSel=!isAllSel;
    
//    if (isAllSel) {
//        [self naviLeftButton:@"全不选" action:@selector(navLeftAction:)];
//        
//    }
//    else {
        [self naviLeftButton:@"全选" action:@selector(navLeftAction:)];
//    }
    
    [self allSelected:isAllSel];
    [self.tableMain reloadData];
}
- (void)allSelected:(BOOL)selected{
    
    for (NSInteger i=0 ; i<self.arrData.count; i++) {
        SysMessagesModel *mm=[self.arrData objectAtIndex:i];
        mm.isSel=[NSNumber numberWithBool:YES];
//        if (selected) {
            //避免重复选，先移除再加入
            [self.arrClick removeObject:mm];
            [self.arrClick addObject:mm];
            //            DLog(@"%ld",self.arrClick.count);
//        }
//        else [self.arrClick removeObject:mm];
    }
}
- (IBAction)btnDeleAction:(id)sender {
    if (self.arrClick.count != 0) {
        
        btndele.backgroundColor = RGBHex(kColorMain001);
        [btndele setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showLoading];
        NSMutableArray *idArr = [NSMutableArray array];
        for (SysMessagesModel *model in self.arrClick) {
            [idArr addObject:model.msg_id];
        }
        NSString *idStr = [idArr componentsJoinedByString:@","];
        
        [MessageAPI MessageDeleteId:idStr success:^(id model) {
            DLog(@"多选del:%lu",(unsigned long)self.arrClick.count);
            if (self.arrClick.count==0) {
                return ;
            }
            [self.arrData removeObjectsInArray:self.arrClick];
            [self.arrClick removeAllObjects];
            [self naviRight];
            if (self.arrData.count<kPageSize) {
                [self refreshData];
            }
            else
                [self.tableMain reloadData];
            
            [self showText:@"删除成功!"];
            if (self.InformBlock) {
                self.InformBlock();
            }
            isAllSel=NO;
            [self navRightAction:nil];
            [self didLoad];
        } failure:^(NetError* err) {
            DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
            [self didLoad];
            
            [self showText:err.errMessage];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btndele.backgroundColor = RGBHex(kColorW);
        [btndele setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    }];
    
    [alertVC addAction:can];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
    }
}
- (void)btnReadAction:(UIButton *)sender{
    
    if (self.arrClick.count != 0) {
        
        btnEndRead.backgroundColor = RGBHex(kColorMain001);
        [btnEndRead setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
        [self showLoading];
    NSMutableArray *idArr = [NSMutableArray array];
    for (SysMessagesModel *model in self.arrClick) {
        [idArr addObject:model.msg_id];
    }
    NSString *idStr = [idArr componentsJoinedByString:@","];
    [MessageAPI MessageReadId:idStr success:^(id model) {
        [self showText:@"标记成功!"];
        isAllSel=NO;
        [self navRightAction:nil];
        if (self.InformBlock) {
            self.InformBlock();
        }
        [self refreshList];
        [self didLoad];
    } failure:^(NetError* err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
        [self showText:err.errMessage];
    }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
