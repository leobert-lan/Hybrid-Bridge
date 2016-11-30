//
//  AuthCardConPhotoCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthCardConPhotoCell.h"

@implementation AuthCardConPhotoCell
- (void)setCell:(NSString *)model
{
    _imgCardR.constant = kAutoScale *65;
    self.backgroundColor = RGBHex(kColorGray207);
    if (![model isEqualToString:@"card2"]) {
        [_imgCard setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"card2"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    }else{
        _imgCard.image = [UIImage imageNamed:model];
    }
    
    _vCardConPhoto.layer.borderWidth = 1;
    _vCardConPhoto.layer.cornerRadius = kCornerRadius;
    _vCardConPhoto.layer.borderColor = RGBHex(kColorGray206).CGColor;
}
- (IBAction)btnCardPhotoAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(AuthCardConPhotoDeDelegate:tag:)]) {
        [self.delegate AuthCardConPhotoDeDelegate:sender tag:sender.tag];
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
