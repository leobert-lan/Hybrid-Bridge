//
//  BaseCollectionDataSource.h
//  cyy_task
//
//  Created by Qingyang on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BaseCollectionDataSourceDelegate <NSObject>
@optional
- (void)BaseCollectionDataSourceDelegate:(id)delegate  didSelectItemModel:(id)model;

@end

@interface BaseCollectionDataSource : NSObject<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/* delegate */
@property (nonatomic, weak) id delegate;

/**
 *  传递需要返回到的页面位置
 */
@property (nonatomic, weak) id delegatePopVC;


@property (nonatomic, assign) NSMutableArray *arrData;

@property (assign) NSInteger tag;
@end
