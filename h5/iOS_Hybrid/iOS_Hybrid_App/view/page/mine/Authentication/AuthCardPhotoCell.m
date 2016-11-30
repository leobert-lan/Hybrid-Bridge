//
//  AuthCardPhotoCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthCardPhotoCell.h"

@implementation AuthCardPhotoCell
- (void)setCell:(NSString *)model
{
    _imgCardR.constant = kAutoScale *65;
    self.backgroundColor = RGBHex(kColorGray207);
    if ([model isEqualToString:@"card1"] || [model isEqualToString:@"license"]) {
        _imgCard.image = [UIImage imageNamed:model];
    }else{
        [_imgCard setImageWithURL:[NSURL URLWithString:model] placeholderImage:[UIImage imageNamed:@"card1"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        
    }
    
    _vCardPhoto.layer.borderWidth = 1;
    _vCardPhoto.layer.cornerRadius = kCornerRadius;
    _vCardPhoto.layer.borderColor = RGBHex(kColorGray206).CGColor;
}

- (IBAction)btnSelectCardPhotoAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(AuthCardPhotoDeDelegate:tag:)]) {
        [self.delegate AuthCardPhotoDeDelegate:self tag:sender.tag];
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
