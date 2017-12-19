//
//  SearchColleDataSource.h
//  cyy_task
//
//  Created by Qingyang on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseCollectionDataSource.h"
#import "SearchConditionCell.h"
#import "SearchConditionSection.h"
#define kSearchColleMargin 15

@interface SearchColleDataSource : BaseCollectionDataSource
@property (assign, nonatomic) int num;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat cellMinWidth;
@property (assign, nonatomic) BOOL separatorEnabled;
@property (assign, nonatomic) BOOL sectionHeaderDisabled;
- (CGSize)getSizeWithCollectionView:(UICollectionView *)collectionView;
- (void)setColWidth:(CGFloat)width margin:(CGFloat)margin sectionHeaderDisabled:(BOOL)sectionHeaderDisabled;
- (void)setColWidth:(CGFloat)width cellMinWidth:(CGFloat)cellMinWidth margin:(CGFloat)margin sectionHeaderDisabled:(BOOL)sectionHeaderDisabled;
@end
