//
//  AuthCardCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/8.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthCardCell.h"

@implementation AuthCardCell

- (void)setCell:(NSMutableArray *)model{
    _lblCard.textColor = RGBHex(kColorGray201);
    _lblShow.textColor = RGBHex(kColorGray201);
    [_btnSta setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
    [_btnEnd setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
    if (model.count == 1) {
        [_btnSta setTitle:model[0] forState:UIControlStateNormal];
    }else if (model.count == 2){
        [_btnSta setTitle:model[0] forState:UIControlStateNormal];
        [_btnEnd setTitle:model[1] forState:UIControlStateNormal];
    }
    
    
    
}

- (IBAction)btnStartDateAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(AuthSelectStartDateDeDelegate:)]) {
        [self.delegate AuthSelectStartDateDeDelegate:self];
    }
}

- (IBAction)btnEndDateAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(AuthSelectEndDateDeDelegate:)]) {
        [self.delegate AuthSelectEndDateDeDelegate:self];
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
