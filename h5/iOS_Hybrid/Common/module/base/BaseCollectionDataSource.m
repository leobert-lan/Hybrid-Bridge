//
//  BaseCollectionDataSource.m
//  cyy_task
//
//  Created by Qingyang on 16/8/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseCollectionDataSource.h"

@implementation BaseCollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [[UICollectionViewCell alloc] init];
}
@end
