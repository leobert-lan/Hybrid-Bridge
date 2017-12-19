//
//  SearchHistoryVC.m
//  cyy_task
//
//  Created by Qingyang on 16/7/21.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchHistoryVC.h"
#import "SearchListVC.h"

@interface SearchHistoryVC ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    IBOutlet UIView *vHeader,*vFooter;
    UITextField *txtSearch;
    NSMutableArray *arrHistory,*arrHotList;
}
@end

@implementation SearchHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setHot:nil];
    [self getHotList];
}

- (void)UIGlobal{
    [super UIGlobal ];

    [self naviSearchTextfield:70];
    
    vHeader.backgroundColor=RGBHex(kColorW);
    vFooter.backgroundColor=RGBHex(kColorW);
    
    lblHistoryTTL.font=fontSystem(kFontS28);
    lblHistoryTTL.textColor=RGBHex(kColorGray201);
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkHistory];
}

#pragma mark - 数据
- (void)checkHistory{
    [self.tableMain setTableHeaderView:nil];
    [SearchHistoryModel getModelListFromDBWithWhere:nil orderBy:@"datetime DESC" count:5 callback:^(NSMutableArray *list) {
        arrHistory = nil;
        arrHistory = [list mutableCopy];
        
        SyncBegin
        if (arrHistory.count > 0) {
            [self.tableMain setTableHeaderView:vHeader];
        }
        else {
            [self.tableMain setTableHeaderView:nil];
        }
        
        [self.tableMain reloadData];
        SyncEnd
    }];
    
}

- (void)setHot:(NSMutableArray*)list   {
    if (dsHotSerarch==nil) {
        dsHotSerarch=[[SearchColleDataSource alloc]init];
        dsHotSerarch.delegate=self;
        [dsHotSerarch setColWidth:APP_W margin:kSearchColleMargin sectionHeaderDisabled:NO];
        
        colHotSearch.dataSource=dsHotSerarch;
        colHotSearch.delegate=dsHotSerarch;
        

        
        [colHotSearch setContentInset:UIEdgeInsetsMake(0, kSearchColleMargin, kSearchColleMargin, kSearchColleMargin)];
        
    }
    
    
    
    SyncBegin
    if (list==nil || list.count==0) {
        [self.tableMain setTableFooterView:nil];
    }
    else {
        dsHotSerarch.arrData=list;
        
        
        //计算高度
        vFooter.height=[dsHotSerarch getSizeWithCollectionView:colHotSearch].height;
        
        [self.tableMain setTableFooterView:vFooter];
    }
    
//    CGSize sz = colHotSearch.contentSize;
//    DLog(@"@@@ %f",sz.height);
    [self.tableMain reloadData];
    [colHotSearch reloadData];
//    sz = colHotSearch.contentSize;
//    DLog(@"@@@ %f",sz.height);
    SyncEnd
}

- (void)getHotList{
    arrHotList=nil;
    arrHotList=[[NSMutableArray alloc]init];

    //获取历史数据
    [SearchHistoryHotModel getModelListFromDBWithWhere:nil orderBy:nil count:12 callback:^(NSMutableArray *list) {
        [self checkHotList:list];
    }];
    
    //获取服务器最新数据
    [TaskAPI SearchTaskHotHistory:nil limit:12 success:^(NSMutableArray *list) {
        
        [SearchHistoryHotModel deleteModelFromDB];
        [SearchHistoryHotModel insertModelListToDB:list filter:^(id model, BOOL inseted, BOOL *rollback) {
            //
        }];
        
        [self checkHotList:list];
        
    } failure:^(NetError *err) {
        //
    }];
}

- (void)checkHotList:(NSMutableArray*)list{
    NSMutableArray *tmp=[[NSMutableArray alloc]initWithCapacity:list.count];
    for (SearchHistoryHotModel *mm in list) {
        CollectionItemTypeModel *mh=[CollectionItemTypeModel new];
        mh.title=mm.search_key;
        [tmp addObject:mh];
    }
    
    CollectionItemTypeModel *sm=[CollectionItemTypeModel new];
    sm.title=@"热门搜索:";
    sm.list=tmp;
    
    [arrHotList removeAllObjects];
    [arrHotList addObject:sm];
    [self setHot:arrHotList];
}
#pragma mark - 导航栏文字按钮

- (id)naviSearchTextfield:(CGFloat)margin{
    UIView* aView=[[UIView alloc]init];
    float ww=APP_W-margin;
    CGRect frm=CGRectMake(0, 0, ww, 44);//self.navigationController.navigationBar.bounds;
    aView.frame=frm;
    aView.backgroundColor=[UIColor clearColor];
    
    frm.size.width-=15;
    frm.size.height=30;
//    frm.origin.x=15;
    frm.origin.y=(aView.height-frm.size.height)/2;
    
    txtSearch=nil;
    txtSearch=[[UITextField alloc]initWithFrame:frm];
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
    
    //显示键盘
    [txtSearch becomeFirstResponder];
    
    return aView;
}
#pragma mark - action
#pragma mark 返回上一页
- (IBAction)popVCAction:(id)sender{
    [txtSearch resignFirstResponder];
//    [self popVCAction:sender];
    [self performSelector:@selector(backPreview) withObject:nil afterDelay:0.1];
}

- (void)backPreview{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        if (self.navigationController.viewControllers.count>1) {
            if (self.hidesMenu) {
                //                [QGLOBAL.menu hideTabBar:NO];
            }
           
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
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
    
    //如果需要，返回的时候隐藏导航栏
    if (self.hidesPopNav)
        [self.navigationController setNavigationBarHidden:YES animated:YES];

}
//- (IBAction)searchAction:(id)sender{
//    SearchListVC *vc=[[SearchListVC alloc]initWithNibName:@"SearchListVC" bundle:nil];
//    vc.popRootEnabled=YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark - search
- (void)search:(NSString*)key{
    if (!StrIsEmpty(key)) {
        SearchHistoryModel *mm = [[SearchHistoryModel alloc] init];
        mm.keyword = key;
        mm.datetime=[QGLOBAL dateToTimeInterval:[NSDate date]];
        [SearchHistoryModel updateModelToDB:mm key:nil];
    }
    
    SearchListVC *vc=[[SearchListVC alloc]initWithNibName:@"SearchListVC" bundle:nil];
    vc.popRootEnabled=YES;
    vc.keyword=key;
    [self.navigationController pushViewController:vc animated:NO];
    
    txtSearch.text=nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [super textFieldShouldReturn:textField];
    [self search:textField.text];
    
    return YES;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [txtSearch resignFirstResponder];
}
#pragma mark - TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrHistory.count>0) {
        return arrHistory.count+1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString *tableID;
    
    if (row<arrHistory.count) {
        SearchHistoryModel * mm=[arrHistory objectAtIndex:row];
        
        BaseTableCell *cell;
        tableID = @"SearchHistoryCell";
        
        cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
//        if (cell == nil)
//            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] firstObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        cell.delegate=self;
        [cell setCell:mm];
        return cell;
    }
    else if(row==arrHistory.count){
        BaseTableCell *cell;
        tableID = @"SearchHistoryCleanCell";
        
        cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];

        cell.delegate=self;
        cell.separatorHidden=YES;
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    return nil;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
//    DLog(@"%li",row);
    if (row<arrHistory.count) {
        [MobClick event:UMSearchHistory];
        
        SearchHistoryModel * mm=[arrHistory objectAtIndex:row];
        [self search:mm.keyword];
    }
    else if(row==arrHistory.count){
        //清空历史
        [SearchHistoryModel deleteModelFromDB];
        [self checkHistory];
    }
}


#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;

    if (row<arrHistory.count) {
        return [SearchHistoryCell getCellHeight:nil];
    }
    else if(row==arrHistory.count){
        return [SearchHistoryCleanCell getCellHeight:nil];
    }
    return 0;
}

#pragma mark - BaseCollectionDataSourceDelegate
- (void)BaseCollectionDataSourceDelegate:(id)delegate didSelectItemModel:(CollectionItemTypeModel*)model{
//    DLog(@"%@",model.toDictionary);
    //推荐key
    [MobClick event:UMSearchPropose];
    [self search:model.title];
}
@end
