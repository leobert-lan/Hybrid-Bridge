//
//  CompanySelectDateCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "CompanySelectDateCell.h"

@implementation CompanySelectDateCell
- (void)setCell:(NSString *)model
{
    _lblShow.text = model;
    _lblShow.textColor = RGBHex(kColorGray201);
}
- (IBAction)btnDateAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(AuthCompanySelectDateDelegate:)]) {
        [self.delegate AuthCompanySelectDateDelegate:self];
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
