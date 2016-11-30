//
//  ImagesPreviewCell.h
//  cyy_task
//
//  Created by Qingyang on 16/11/7.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "ScrollTouch.h"
#import "ImagesPreviewModel.h"
@interface ImagesPreviewCell : BaseCollectionCell
{
    UIActivityIndicatorView *act;
    ImagesPreviewModel *mmImage;
    UILongPressGestureRecognizer *longPress;
    IBOutlet UIButton *btnReload;
}
@property (nonatomic,retain) IBOutlet UIImageView *imgPhoto;
@property (nonatomic, retain) IBOutlet ScrollTouch *scroll;
@property (nonatomic, retain) UIImage *photo;
//- (CGSize)originSize:(CGSize)oSize fitInSize:(CGSize)fSize;
@end;

@protocol ImagesPreviewCellDelegate <NSObject>
@optional
- (void)ImagesPreviewCellTapDelegate:(ImagesPreviewCell*)cell;
- (void)ImagesPreviewCellDelegate:(ImagesPreviewCell*)cell saveImage:(UIImage*)image model:(ImagesPreviewModel*)model;
@end


