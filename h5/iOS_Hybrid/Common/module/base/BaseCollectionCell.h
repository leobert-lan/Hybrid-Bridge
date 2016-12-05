//
//  BaseCollectionCell.h
//  cyy_task
//
//  Created by Qingyang on 16/8/15.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionCell : UICollectionViewCell
@property(nonatomic, assign) id delegate;

/**
 *  传递需要返回到的页面位置
 */
@property (nonatomic, weak) id delegatePopVC;

+ (CGSize)getCellSize:(id)data;
- (void)setCell:(id)mod;
- (void)UIGlobal;
@end
