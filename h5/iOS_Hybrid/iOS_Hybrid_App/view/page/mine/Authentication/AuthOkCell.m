//
//  AuthOkCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthOkCell.h"

@implementation AuthOkCell
- (void)setCell:(id)model
{
    self.backgroundColor = RGBHex(kColorGray207);
    [_btnOk setTitle:@"提交" forState:UIControlStateNormal];
    _btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    _btnOk.layer.borderWidth = 1;
    _btnOk.layer.cornerRadius = kCornerRadius;
    _btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
}
- (IBAction)btnOkAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(AuthOkDelegate:)]) {
        [self.delegate AuthOkDelegate:self];
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
