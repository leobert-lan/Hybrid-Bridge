//
//  FeedbackCell.h
//  cyy_task
//
//  Created by zhchen on 16/7/25.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedbackCellDelegate <NSObject>
@optional
- (void)FeedbackCellDelegateDel:(id)delegate img:(id)img;
@end
@interface FeedbackCell : UICollectionViewCell
@property(nonatomic,assign)id <FeedbackCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnDel;
@property (nonatomic,strong) UIImage *img;
- (void)setCellImg:(UIImage *)img;
@end
