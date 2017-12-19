//
//  AuthCompanyStatusDataSource.m
//  cyy_task
//
//  Created by zhchen on 16/10/18.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthCompanyStatusDataSource.h"
#import "AuthStatusLblCell.h"
@implementation AuthCompanyStatusDataSource
#pragma mark - tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArr.count+1;
    }else{
        if ([self.companyAuthModel.auth_status integerValue] == 2 || [self.companyAuthModel.auth_status integerValue] == 3) {
            return 2;
        }else{
            return 1;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArr.count+1) {
        
        
        static NSString *tableID;
        BaseTableCell *cell;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                tableID = @"AuthStatusHeaderCell";
            }else{
            tableID = @"AuthStatusLblCell";
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                tableID = @"AuthComnpanyPhotoCell";
            }else{
                tableID = @"AuthStatusOkCell";
            }
        }
        cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] lastObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        cell.delegate=self;
        cell.delegatePopVC = self.delegatePopVC;
        cell.delegateNav=self.delegateNav;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [cell setCell:self.companyAuthModel];
            }else{
            [cell setCell:self.dataArr[indexPath.row-1]];
            }
        }else if (indexPath.section == 1){
            cell.separatorHidden = YES;
            if (indexPath.row == 0) {
                [cell setCell:self.cardImgArr];
            }else{
                [cell setCell:self.companyAuthModel];
            }
        }
        
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 229;
        }else{
        return [AuthStatusLblCell getCellHeight:self.dataArr[indexPath.row-1]];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 150*kAutoScale;
        }else if (indexPath.row == 1){
            if ([self.companyAuthModel.auth_status integerValue] == 2 || [self.companyAuthModel.auth_status integerValue] == 3) {
                return 80;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        if (section == 0) {
            return 0;
        }else{
            return 10;
        }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
       
            return nil;
        
    }else{
        UIView *kview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 10)];
        kview.backgroundColor = RGBHex(kColorGray207);
        return kview;
    }
}
@end
