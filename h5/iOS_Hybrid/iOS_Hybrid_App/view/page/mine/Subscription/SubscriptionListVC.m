//
//  SubscriptionListVC.m
//  cyy_task
//
//  Created by Qingyang on 16/8/25.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SubscriptionListVC.h"
#import "SubscriptionCollVC.h"
@interface SubscriptionListVC ()
{
    
}
@end

@implementation SubscriptionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getList];
    
//    [HTTPConnecting get:@"https://account.vsochina.com/res/jquery.select/city.min.js" params:nil success:^(id responseObj) {
//        DLog(@"++++ %@",responseObj);
//    } failure:^(NetError *err) {
//        DLog(@"---- %@",err);
//    }];
    
//    [OtherAPI getIndustryListNew:NO success:^(NSMutableArray *arr) {
//        IndustryModel*mm=arr.lastObject ;
//        DLog(@">>> %@",mm.toDictionary);
//    } failure:^(NetError *err) {
//        //
//    }];
    /*
    NSData *dada=UIImageJPEGRepresentation([UIImage imageNamed:@"pic_nopass"], 0.7);
    [OtherAPI UploadFile:dada name:@"test" success:^(NSString* path) {
        DLog(@"上传路径：%@",path);
    } failure:^(NetError *err) {
        
    } sendDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        DLog(@"上传:%lli/%lli",totalBytesSent,totalBytesExpectedToSend);
    }];
    */
    
//    NSData *dada=UIImageJPEGRepresentation([UIImage imageNamed:@"3"], 0.7);
//    [OtherAPI UploadForAuth:dada name:@"hhh.jpg" objtype:UploadFileTypeService size:CGSizeZero success:^(id obj) {
//        DLog(@"上传路径：%@",obj);
//    } failure:^(NetError *err) {
////        DLog(@">>> %@",[err toDictionary]);
//        [self showText:err.errMessage];
//    } sendDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//        DLog(@"上传:%lli/%lli",totalBytesSent,totalBytesExpectedToSend);
//    }];

    
    
    
    
    
    
    
    
}
- (void)getList{
    if (self.arrData==nil) {
        [OtherAPI getIndustryList:NO success:^(NSMutableArray *arr) {
            self.arrData=[OtherAPI collItemsFromSubIndustryList:arr canAll:NO];
            [self.tableMain reloadData];
        } failure:^(NetError *err) {
            //
        }];
    }
}

- (void)UIGlobal{
    [super UIGlobal];
    
    btnOK.hidden=YES;
    btnClose.y=15;
    
    if (self.title==nil)
        [self naviTitle:@"设置订阅标签"];
    
    
    
    [self.tableMain setTableHeaderView:vHeader];
    [self.tableMain setTableFooterView:vFooter];
    
    if (_canJump) {
        [self.tableMain setTableFooterView:vFooter];
    }
    else {
        vFooter.hidden=YES;
        [self.tableMain setTableFooterView:nil];
    }
    
    
    
    self.tableMain.backgroundColor=[UIColor clearColor];
    vHeader.backgroundColor=[UIColor clearColor];
    vFooter.backgroundColor=[UIColor clearColor];
    
    lblTTL.textColor=RGBHex(kColorAuxiliary101);
    lblTTL.font=fontSystem(kFontS26);
    
    [btnClose setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    
    CGRect frm;
    frm=CGRectMake(0, vHeader.height-0.5, APP_W, 0.5);
    spLine=[[UIView alloc]initWithFrame:frm];
    spLine.backgroundColor=RGBHex(kColorGray206);
    [vHeader addSubview:spLine];
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
    
    if (row<self.arrData.count) {
        CollectionItemTypeModel * mm=[self.arrData objectAtIndex:row];
        
        SubScriptionCell *cell;
        tableID = @"SubScriptionCell";
        
        cell = (SubScriptionCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] firstObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        cell.delegate=self;
        cell.typeI=YES;
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
    if (row<self.arrData.count) {
        CollectionItemTypeModel * mm=[self.arrData objectAtIndex:row];
        
        SubscriptionCollVC *vc=[[SubscriptionCollVC alloc]initWithNibName:@"SubscriptionListVC" bundle:nil];
 
        vc.delegate=self.delegate;
        vc.delegatePopVC=self.delegatePopVC;
        vc.title=mm.title;
        vc.indusId=mm.oid;
        vc.arrData=[[NSMutableArray alloc] initWithArray:mm.list copyItems:YES];
        vc.canJump=self.canJump;
        [[self navigationController] pushViewController:vc animated:YES];
    }
}


#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

//#pragma mark - action
//- (IBAction)subAction:(id)sender{
//   
//    
//}

@end
