//
//  AuthStatusImgCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/9.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthStatusImgCell.h"

@implementation AuthStatusImgCell
- (void)setCell:(NSMutableArray *)model
{
    self.backgroundColor = [UIColor clearColor];
    if (model.count > 1) {
        _imgConPhoto.hidden = NO;
        _imgPerPhoto.hidden = NO;
        [_imgPhoto setImageWithURL:[NSURL URLWithString:model[0]] placeholderImage:[UIImage imageNamed:@"card1"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        [_imgConPhoto setImageWithURL:[NSURL URLWithString:model[1]] placeholderImage:[UIImage imageNamed:@"card2"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        [_imgPerPhoto setImageWithURL:[NSURL URLWithString:model[2]] placeholderImage:[UIImage imageNamed:@"card3"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        
    }else{
        _imgConPhoto.hidden = YES;
        _imgPerPhoto.hidden = YES;
        [_imgPhoto setImageWithURL:[NSURL URLWithString:model[0]] placeholderImage:[UIImage imageNamed:@"license"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
