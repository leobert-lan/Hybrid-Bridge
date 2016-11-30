//
//  AuthSeleteAreaCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthSeleteAreaCell.h"

@implementation AuthSeleteAreaCell
- (void)setCell:(NSString *)model{
    _lblSelect.textColor = RGBHex(kColorGray203);
    _lblSelect.text = model;
    
}

- (IBAction)btnSelectAreaAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(AuthSelectAreaDeDelegate:)]) {
        [self.delegate AuthSelectAreaDeDelegate:self];
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
