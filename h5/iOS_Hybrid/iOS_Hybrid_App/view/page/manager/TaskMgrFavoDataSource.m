//
//  TaskMgrFavoDataSource.m
//  cyy_task
//
//  Created by Qingyang on 16/7/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskMgrFavoDataSource.h"

@implementation TaskMgrFavoDataSource
#pragma mark - TableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString *tableID;
    
    if (row<self.arrData.count) {
        TaskModel * mm=[self.arrData objectAtIndex:row];
        
        TaskCell *cell;
        tableID = @"TaskCell";
        
        cell = (TaskCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] firstObject];
 
        cell.delegate=self;
        cell.selectionEnabled=self.selectionEnabled;
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
        TaskModel * mm=[self.arrData objectAtIndex:row];
        if (self.selectionEnabled) {
            mm.selected=!mm.selected;
            
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            
            NSInteger ii=[self.arrSelected indexOfObject:mm];
            if (mm.selected) {
                if (ii == NSNotFound) {
                    [self.arrSelected addObject:mm];
                }
                
            }
            else {
                if (ii != NSNotFound) {
                    [self.arrSelected removeObject:mm];
                }
            }
        }
        else if (self.delegate && [self.delegate respondsToSelector:@selector(BaseTableDataSourceDelegate:didSelectCellModel:)]) {
            [self.delegate BaseTableDataSourceDelegate:self didSelectCellModel:mm];
        }
    }
}


#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
@end
