//
//  SearchConditionSection.h
//  cyy_task
//
//  Created by Qingyang on 16/8/16.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@interface SearchConditionSection : UICollectionReusableView
{
    IBOutlet UIButton *btnTitle;
    CollectionItemTypeModel *model;
}
- (void)setCell:(CollectionItemTypeModel*)model;
+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView forIndexPath:(NSIndexPath*)indexPath withKind:(NSString*)kind;
@end
