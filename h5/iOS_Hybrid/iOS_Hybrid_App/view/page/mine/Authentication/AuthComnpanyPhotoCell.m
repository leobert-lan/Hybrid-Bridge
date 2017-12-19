//
//  AuthComnpanyPhotoCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/19.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthComnpanyPhotoCell.h"

@implementation AuthComnpanyPhotoCell
- (void)setCell:(NSMutableArray *)model
{
    self.backgroundColor = [UIColor clearColor];
    [_imgPhoto setImageWithURL:[NSURL URLWithString:model[0]] placeholderImage:[UIImage imageNamed:@"license"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
