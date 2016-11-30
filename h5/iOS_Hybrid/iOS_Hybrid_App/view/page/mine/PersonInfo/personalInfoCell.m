//
//  personalInfoCell.m
//  cyy_task
//
//  Created by zhchen on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "personalInfoCell.h"

@implementation personalInfoCell
- (void)setNameL:(NSString *)nameL nameR:(NSString *)nameR
{
    lblNameL.font = fontSystem(kFontS28);
    lblNameL.textColor = RGBHex(kColorGray201);
    lblNameR.font = fontSystem(kFontS28);
    lblNameR.textColor = RGBHex(kColorGray203);
    lblNameL.text = nameL;
    lblNameR.text = nameR;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
