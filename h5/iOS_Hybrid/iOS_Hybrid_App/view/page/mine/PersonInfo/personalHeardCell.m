//
//  personalHeardCell.m
//  cyy_task
//
//  Created by zhchen on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "personalHeardCell.h"

@implementation personalHeardCell
- (void)setCell:(UserModel *)model
{
    heardImg.clipsToBounds = YES;
    heardImg.layer.cornerRadius = 26.5;
    DLog(@"+++personalHeardCell %@",model.avatar);
//    [heardImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageRefreshCached];
    lblName.font = fontSystemBold(kFontS34);
    lblName.textColor = RGBHex(kColorB);
    lblChange.font = fontSystem(kFontS24);
    lblChange.textColor = RGBHex(kColorGray208);
    lblName.text = model.nickname;
    

    if (_imgAvatar!=nil) {
        heardImg.image=_imgAvatar;
        return;
    }
    
    [heardImg setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        DLog(@"%li:%li",receivedSize,expectedSize);

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        //全局更换头像
        [QGLOBAL.sideMenu updateAvatar:image];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
