//
//  AuthTextFieldCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthTextFieldCell.h"

@implementation AuthTextFieldCell
- (void)setCell:(NSString *)model{
    self.contentView.backgroundColor = RGBHex(kColorW);
//    if ([model isEqualToString:@"请输入姓名"] || [model isEqualToString:@"请输入身份证号"]) {
//        _txtField.placeholder = model;
//    }else{
//        _txtField.text = model;
//    }
 self.txtField.text = model;
 self.txtField.textColor = RGBHex(kColorGray201);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
