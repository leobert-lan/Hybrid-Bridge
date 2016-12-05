//
//  TaskMgrHistoryDataSource.m
//  cyy_task
//
//  Created by Qingyang on 16/7/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskMgrHistoryDataSource.h"

@implementation TaskMgrHistoryDataSource
#pragma mark - TableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_myTaskEnabled) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    NSInteger row=indexPath.row;
    static NSString *tableID;
    
    if (row<self.arrData.count) {
        TaskModel * mm=[self.arrData objectAtIndex:row];

        tableID = @"TaskCell";
        
        TaskMgrCell *cell = (TaskMgrCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] firstObject];
        
        if (_myTaskEnabled) {
            cell.separatorHidden=YES;
        }
//        else {
//            cell.separatorHidden=NO;
//        }
        
        cell.myTaskEnabled=_myTaskEnabled;
        cell.delegate=self;
        
        cell.delegateNav=self.delegateNav;
        cell.hidesPopNav=self.hidesPopNav;
        
        [cell setCell:mm];
        
//        DLog(@">>> %@",[cell class]);
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
}
#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    if (row<self.arrData.count) {
        TaskModel * mm=[self.arrData objectAtIndex:row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(BaseTableDataSourceDelegate:didSelectCellModel:)]) {
            [self.delegate BaseTableDataSourceDelegate:self didSelectCellModel:mm];
        }
    }
}

#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    if (row<self.arrData.count) {
        TaskModel * mm=[self.arrData objectAtIndex:row];
        if (_myTaskEnabled)
            return [TaskMgrCell getCellHeight:mm];
        
    }
    return [TaskCell getCellHeight:nil];
}
@end
