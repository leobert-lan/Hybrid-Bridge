//
//  TaskDetailHideCell.m
//  cyy_task
//
//  Created by zhchen on 16/8/18.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "TaskDetailHideCell.h"

@implementation TaskDetailHideCell

+ (float)getCellHeight:(id)data
{
    return 152;
}
- (void)setCell:(TaskDetailWorksModel *)model
{
    _lblName.textColor = RGBHex(kColorGray201);
    _lblName.font = fontSystemBold(kFontS28);
    _lblData.textColor = RGBHex(kColorGray203);
    _lblHide.textColor = RGBHex(kColorGray203);
    
    _lblName.text = model.nickname;
    _lblData.text = [QGLOBAL dateTimeIntervalToStr:model.create_time];
    _imgHeader.clipsToBounds = YES;
    _imgHeader.layer.cornerRadius = 50/2;
    [_imgHeader setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //        if (_act==nil)
        //        {
        //            _act = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //            [_selfImg addSubview:_act];
        //            _act.center = _selfImg.center;
        //            [_act startAnimating];
        //        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        //        [_act removeFromSuperview];
        //        _act = nil;
    }];
    
    if ([model.status integerValue] == 3) {
        _imgSucc.image = [UIImage imageNamed:@"Successful"];
        _imgSucc.hidden = NO;
    }else if([model.status integerValue] == 2){
        _imgSucc.image = [UIImage imageNamed:@"Alternate"];
        _imgSucc.hidden = NO;
        
    }else{
        _imgSucc.hidden = YES;
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
