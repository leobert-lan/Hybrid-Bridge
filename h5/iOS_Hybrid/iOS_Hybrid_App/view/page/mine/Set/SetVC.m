//
//  SetVC.m
//  Chuangyiyun
//
//  Created by zhchen on 16/5/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SetVC.h"
#import "phoneBound.h"
#import "changePwdVC.h"
#import "FeedbackVC.h"
#import "loginVC.h"
#import "RegisterVC.h"
#import "PersonalInfoVC.h"
#import "Aboutme.h"
#import "MyConcernVC.h"
#import "SetCell.h"
#import "SignAPI.h"
@interface SetVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *setArray;
    IBOutlet UIButton *btnloginOut;
    IBOutlet UIView *lineView,*lineViewT;
    IBOutlet UIView *vLoginout;
}
@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![QGLOBAL hadAuthToken]) {
        setArray = @[@"清除缓存",@"关于我们"];
        vLoginout.hidden = YES;
    }else{
    setArray = @[@"清除缓存",@"意见反馈",@"关于我们"];
        vLoginout.hidden = NO;
    }
    // Do any additional setup after loading the view.
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    lineView.backgroundColor = RGBHex(kColorGray206);
    lineViewT.backgroundColor = RGBHex(kColorGray206);
    self.tableMain.backgroundColor = RGBHex(kColorGray207);
    [btnloginOut setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
    [self naviTitle:@"设置"];
}
#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return setArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
    cell.lblName.font = fontSystem(kFontS28);
    cell.lblName.textColor = RGBHex(kColorGray201);
    cell.lblName.text = setArray[indexPath.row];
    cell.lblNum.font = fontSystem(kFontS28);
    cell.lblNum.textColor = RGBHex(kColorGray203);
    if (indexPath.row == 0) {
        cell.lblNum.text = [self cacheSize];
        if ([cell.detailTextLabel.text isEqualToString:@"0"]) {
            cell.detailTextLabel.text = @"0M";
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"是否清空缓存?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cleanCache];
            [tableView reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alt addAction:can];
        [alt addAction:cancel];
        [self presentViewController:alt animated:YES completion:nil];
    }else if (indexPath.row == 1){
        if (![QGLOBAL hadAuthToken]) {
            Aboutme *vc=(Aboutme *)[QGLOBAL viewControllerName:@"Aboutme" storyboardName:@"Set"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            FeedbackVC *vc=(FeedbackVC *)[QGLOBAL viewControllerName:@"FeedbackVC" storyboardName:@"Set"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.row == 2){
        Aboutme *vc=(Aboutme *)[QGLOBAL viewControllerName:@"Aboutme" storyboardName:@"Set"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
#pragma mark - action
- (IBAction)btnlogoutAction:(id)sender {
    
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"是否退出登录?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showLoading];
//        [QGLOBAL logout];
        
        [QGLOBAL logoutSuccess:^(BOOL isLogout) {
            [self didLoad];
            
            [APPDelegate mainInit];
//            if (isLogout) {
//                
//            }
//            else{
//                
//            }
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:can];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
    
    
    
    
}

#pragma mark - 检查大小
- (NSString *)cacheSize{
    double num=(double)[QGLOBAL sizeOfFolder:[FileManager getCachePath]];
    num=(num<1024)?0:num;
    NSString *sz=[QGLOBAL stringFromFileSize:num];
    DLog(@">>>cache:%@",sz);
    return sz;
}
#pragma mark - 清理空间
- (void)cleanCache{
    [FileManager cleanDirectory:[FileManager getCachePath]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)popVCAction:(id)sender{
//    [super popVCAction:sender];
//    if (self.hidesPopNav)
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [[self.delegatePopVC navigationController] setNavigationBarHidden:YES animated:YES];
//    [super viewWillAppear:animated];
//}

//- (void)viewWillDisappear:(BOOL)animated {
//    [[self navigationController] setNavigationBarHidden:NO animated:animated];
//    [super viewWillDisappear:animated];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
