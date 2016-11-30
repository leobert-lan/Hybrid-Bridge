//
//  SearchTableDataSource.m
//  cyy_task
//
//  Created by Qingyang on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SearchTableDataSource.h"

@implementation SearchTableDataSource
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
        
        SearchTypeCell *cell;
        tableID = @"SearchTypeCell";
        
        cell = (SearchTypeCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
//            cell=[[SearchTypeCell alloc]init]; //无xib，sb
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] firstObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        cell.typeI=self.typeI;
        cell.delegate=self;
        
        if (self.typeI) {
            cell.separatorHidden=YES;
        }
        else
            cell.separatorHidden=NO;
        
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
    if (row<self.arrData.count){
        CollectionItemTypeModel * mm=[self.arrData objectAtIndex:row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(BaseTableDataSourceDelegate:didSelectCellModel:)]) {
            [self.delegate BaseTableDataSourceDelegate:self didSelectCellModel:mm];
        }
//        if (mm.oid.integerValue!=0) {
//            DLog(@">>> %@",mm.oid);
//        }
//        else {
//            //全部
//        }
    }
}


#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
@end
