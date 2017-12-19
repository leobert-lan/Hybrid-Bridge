//
//  BaseDataSource.m
//  cyy_task
//
//  Created by Qingyang on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseTableDataSource.h"

@implementation BaseTableDataSource
#pragma mark - TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;//arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    static NSString *tableID;
    
    if (row) {
        //Model * mm=[arrData objectAtIndex:row];
        
        BaseTableCell *cell;
        tableID = @"CellID";
        
        cell = (BaseTableCell*)[tableView dequeueReusableCellWithIdentifier:tableID];
        if (cell == nil)
            //xib
            cell=[[[NSBundle mainBundle] loadNibNamed:tableID owner:self options:nil] firstObject];
        //        cell=[tableView dequeueReusableCellWithIdentifier:tableID];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = RGBHex(kColorGray207);
        cell.delegate=self;
        //        [cell setCell:mm];
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    return nil;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    DLog(@"scrollViewDidScroll");
    if (self.delegate && [self.delegate respondsToSelector:@selector(BaseTableDataSourceDelegate:tableViewDidScroll:)]) {
        [self.delegate BaseTableDataSourceDelegate:self tableViewDidScroll:scrollView];
    }
}
@end
