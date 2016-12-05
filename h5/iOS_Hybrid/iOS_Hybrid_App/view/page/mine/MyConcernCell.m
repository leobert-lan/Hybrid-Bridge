//
//  MyConcernCell.m
//  cyy_task
//
//  Created by zhchen on 16/7/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "MyConcernCell.h"

@implementation MyConcernCell
- (void)setCell:(MyConcernModel *)model
{
    self.model = model;
    _btnCancel.layer.borderWidth = 0.5;
    _btnCancel.layer.borderColor = RGBHex(kColorGray201).CGColor;
    _btnCancel.layer.cornerRadius = 2;
    [_btnCancel setTitleColor:RGBHex(kColorGray208) forState:UIControlStateNormal];
    _btnCancel.titleLabel.font = fontSystem(kFontS24);
    _lblName.font = fontSystem(kFontS28);
    _lblName.textColor = RGBHex(kColorGray201);
    _lblProfile.font = fontSystem(kFontS24);
    _lblProfile.textColor = RGBHex(kColorGray208);
    _imgHeard.clipsToBounds = YES;
    _imgHeard.layer.cornerRadius = 27.5;
    [_imgHeard setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    _lblName.text = model.nickname;
    _lblProfile.text = model.indus_name;
}

- (IBAction)btnUnfollowAcyion:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myConcernCellDeDelegate:MyConcernModel:)]) {
        [self.delegate myConcernCellDeDelegate:self MyConcernModel:self.model];
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
