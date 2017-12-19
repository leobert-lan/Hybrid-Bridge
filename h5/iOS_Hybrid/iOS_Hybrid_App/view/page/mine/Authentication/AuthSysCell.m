//
//  AuthSysCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthSysCell.h"

@implementation AuthSysCell
-(void)setCell:(id)model{
    self.backgroundColor = RGBHex(kColorGray207);
    _lblCardShow.textColor = RGBHex(kColorGray201);
    _lblCardShow.font = fontSystemBold(kFontS30);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
