//
//  AuthCardPerPhotoCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthCardPerPhotoCell.h"

@implementation AuthCardPerPhotoCell
- (void)setCell:(NSString *)model
{
    _imgCardR.constant = kAutoScale *65;
    self.backgroundColor = RGBHex(kColorGray207);
    if (![model isEqualToString:@"card3"]) {
        [_imgCard setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"card3"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    }else{
        _imgCard.image = [UIImage imageNamed:model];
    }
    
    _vCardPhoto.layer.borderWidth = 1;
    _vCardPhoto.layer.cornerRadius = kCornerRadius;
    _vCardPhoto.layer.borderColor = RGBHex(kColorGray206).CGColor;
}
- (IBAction)btnCardPhotoAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(AuthCardPerPhotoDeDelegate:tag:)]) {
        [self.delegate AuthCardPerPhotoDeDelegate:sender tag:sender.tag];
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
