//
//  BaseDataSource.h
//  cyy_task
//
//  Created by Qingyang on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BaseTableDataSourceDelegate <NSObject>
@optional
- (void)BaseTableDataSourceDelegate:(id)delegate  didSelectCellModel:(id)model;
- (void)BaseTableDataSourceDelegate:(id)delegate  tableViewDidScroll:(UIScrollView *)tableView;
@end

@interface BaseTableDataSource : NSObject<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
/* delegate */
@property (nonatomic, weak) id delegate;

/**
 *  传递需要返回到的页面位置
 */
@property (nonatomic, weak) id delegateNav;
/**
 *  传递需要返回到的页面位置
 */
@property (nonatomic, weak) id delegatePopVC;

@property (nonatomic, weak) NSMutableArray *arrData;

@property (assign) NSInteger tag;
@end
