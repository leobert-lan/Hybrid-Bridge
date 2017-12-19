//
//  CompanyRegisterCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "CompanyRegisterCell.h"

@implementation CompanyRegisterCell
- (void)setCell:(NSString *)model
{
    _lblSeleShow.text = model;
    _lblSeleShow.textColor = RGBHex(kColorGray201);
}
- (IBAction)btnSelectCityAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(AuthStatusSelectCityDelegate:)]) {
        [self.delegate AuthStatusSelectCityDelegate:self];
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
