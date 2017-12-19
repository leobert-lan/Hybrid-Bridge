//
//  MyConcernVC.m
//  cyy_task
//
//  Created by zhchen on 16/7/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "MyConcernVC.h"
#import "MyConcernCell.h"
#import "MineAPI.h"
#import "MJRefresh.h"
@interface MyConcernVC ()<UITableViewDelegate,UITableViewDataSource,cloudBaseCellDelegate>
{
    NSInteger page;
    MJRefreshNormalHeader *headerMJ;
}
@end

@implementation MyConcernVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;
    [self showLoading];
    [self refreshList];
    [self setupMJ];
    [self upLoadData];
    // Do any additional setup after loading the view.
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"我的关注"];
    self.tableMain.backgroundColor = RGBHex(kColorGray207);
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
    [MineAPI myConcernListOffset:page success:^(NSMutableArray *data) {
        self.arrData=nil;
        self.arrData=[[NSMutableArray alloc]initWithCapacity:kPageSize];
        [self.arrData addObjectsFromArray:data];
        
//        for (NSDictionary *dd in data) {
//            NSError* err = nil;
//            MyConcernModel *mm = [[MyConcernModel alloc] initWithDictionary:dd error:&err];
//            if (mm == nil) {
//                [self didLoad];
//                return ;
//            }
//            [self.arrData addObject:mm];
//        }
        if (self.arrData.count > 0) {
            [self noSearchResult:NO message:nil];
        }else{
            [self noSearchResult:YES message:@"还未关注任何雇主"];
        }
        [self.tableMain.header endRefreshing];
        [self.tableMain reloadData];
        [self didLoad];
    } failure:^(NetError* err) {
        if (err.errStatusCode == 13862) {
            [self noSearchResult:YES message:@"还未关注任何雇主"];
            [self showText:@"还未关注任何雇主"];
        }else{
        [self showText:err.errMessage];
        }
        [self.tableMain.header endRefreshing];
        [self didLoad];
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
    }];
}
- (void)getListNext
{
    page ++;
    [MineAPI myConcernListOffset:page success:^(NSMutableArray *data) {
        
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
        [self showInfoView:message image:@"pic_nothing"];
        
    }
    else {
        [self removeInfoView];
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
    if (indexPath.row < self.arrData.count) {
        MyConcernCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyConcernCell" forIndexPath:indexPath];
        MyConcernModel *mm = self.arrData[indexPath.row];
        cell.delegate = self;
        [cell setCell:mm];
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)myConcernCellDeDelegate:(id)delegate MyConcernModel:(MyConcernModel *)model
{
    [self showLoading];
    [MineAPI myConcernCancelObjName:model.obj_name success:^(id responseObj) {
        [self didLoad];
        [self showText:@"取消成功" delay:1.2];
        NSInteger index=[self.arrData indexOfObject:model];
        DLog(@"%ld",(long)index);
        if (index != NSNotFound) {
            MyConcernModel *mm=[self.arrData objectAtIndex:index];
            
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:index inSection:0];
            [self.arrData removeObject:mm];
            [self.arrData removeObject:model];
            
            [self.tableMain beginUpdates];
            [self.tableMain deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil]  withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableMain endUpdates];
            
        }
        
        if (self.arrData.count==0) {
            [self refreshList];
        }
    } failure:^(NetError *err) {
        [self didLoad];
        [self showText:err.errMessage];
        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
    }];
    
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
