//
//  SubscriptionCollVC.m
//  cyy_task
//
//  Created by Qingyang on 16/8/25.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SubscriptionCollVC.h"
#import "MineAPI.h"
static int numSel=3;
@interface SubscriptionCollVC ()

@end

@implementation SubscriptionCollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrSel=[[NSMutableArray alloc]initWithCapacity:numSel];
}

- (void)UIGlobal{
    [super UIGlobal];
    
    btnOK.hidden=NO;
    btnClose.y=12+CGRectGetMaxY(btnOK.frame);
    
    [self labelAttributed];

    vFooter.hidden=NO;
    [self.tableMain setTableFooterView:vFooter];
    
    vHeader.height=50;
    [self.tableMain setTableHeaderView:vHeader];
    
    spLine.y=vHeader.height-0.5;
    
    [btnClose setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    btnClose.hidden = !self.canJump;
    
    [btnOK addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    
    btnOK.backgroundColor = RGBAHex(kColorMain001, 1);
    btnOK.layer.cornerRadius = kCornerRadius;
    btnOK.titleLabel.font = fontSystem(kFontS26);
}


- (void)labelAttributed{
    NSString *str=@"根据选择的标签为您推荐相关需求 (最多3个标签，确认后不可修改)";
    
    NSRange r1=[@"(" rangeFrom:str];
    NSRange r2=[@")" rangeFrom:str];
    NSRange rr=NSMakeRange(r1.location, (r2.location-r1.location)+1);
    // 设置组
    NSArray *array = @[// 全局设置
                       [ConfigAttributedString font:fontSystem(kFontS26) range:[str range]],
                       //      [ConfigAttributedString paragraphStyle:[self style]         range:[str range]],
                       
                       // 局部设置
                       [ConfigAttributedString foregroundColor:RGBHex(kColorGray206)
                                                         range:rr],
                       [ConfigAttributedString font:fontSystem(kFontS22)
                                              range:rr]];
    
 
    lblTTL.attributedText = [str createAttributedStringAndConfig:array];
    //    label.backgroundColor=RGBAHex(kColorMain001, .5);

    [lblTTL sizeToFit];
}
#pragma mark - action
- (IBAction)okAction:(id)sender{
    if (arrSel.count) {
        NSString *str=nil;
        for (CollectionItemTypeModel* mm in arrSel) {
            if (str==nil) {
                str=[NSString stringWithFormat:@"%@",StrFromObj(mm.oid)];
            }
            else
                str=[NSString stringWithFormat:@"%@,%@",str,StrFromObj(mm.oid)];
        }
        [MineAPI SubscripIndusIds:str success:^(id model) {
            NSString *str=nil;
            for (CollectionItemTypeModel* mm in arrSel) {
                if (str==nil) {
                    str=[NSString stringWithFormat:@"%@",StrFromObj(mm.title)];
                }
                else
                    str=[NSString stringWithFormat:@"%@,%@",str,StrFromObj(mm.title)];
            }
            
            QGLOBAL.usermodel.indus_name=self.title;
            QGLOBAL.usermodel.lable=str;
            
            [self showText:@"选择成功!"];
            [self jumpToPopVCAction:nil];
        } failure:^(NetError *err) {
            [self showText:err.errMessage];
        }];
    }
    else {
        [self showText:@"您还没有选择标签!"];
    }
}
#pragma mark - table
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
        cell.typeI=NO;
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
        if (mm.selected==false) {
            if (arrSel.count<numSel) {
                NSInteger ii=[arrSel indexOfObject:mm];
                if (ii == NSNotFound) {
                    [arrSel addObject:mm];
                }
            }
            else {
                //alert num
                [self showText:[NSString stringWithFormat:@"最多%i个标签",numSel]];
                return;
            }
            
        }
        else {
            [arrSel removeObject:mm];
        }
        
        mm.selected=!mm.selected;
        
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
//        [self.tableMain reloadData];

        
    }
}

@end
