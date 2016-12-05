//
//  FeedbackCell.m
//  cyy_task
//
//  Created by zhchen on 16/7/25.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "FeedbackCell.h"

@implementation FeedbackCell
- (void)setCellImg:(UIImage *)img
{
    self.imgPhoto.image = img;
    self.img = img;
}
- (IBAction)btnDelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(FeedbackCellDelegateDel:img:)]) {
        [self.delegate FeedbackCellDelegateDel:self img:self.img];
    }
}

@end
