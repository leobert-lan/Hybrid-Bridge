//
//  CompanyTextViewCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "CompanyTextViewCell.h"

@implementation CompanyTextViewCell
- (void)setCell:(NSString *)model
{
    self.txtView.textColor = RGBHex(kColorGray201);
    self.txtView.text = model;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
