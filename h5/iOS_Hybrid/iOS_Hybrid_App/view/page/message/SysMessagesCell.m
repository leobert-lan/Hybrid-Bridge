//
//  SysMessagesCell.m
//  cyy_task
//
//  Created by zhchen on 16/8/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "SysMessagesCell.h"

@implementation SysMessagesCell
- (void)setCell:(SysMessagesModel*)model{
    
    if (model.view_status.integerValue == 0) {
        _vStamp.hidden = NO;
        _vStamp.layer.cornerRadius = 5;
        _vStamp.backgroundColor = RGBHex(kColorAuxiliary102);
    }else{
        _vStamp.hidden = YES;
        
    }
    
    self.modItem = model;
    _vSpa.backgroundColor = RGBHex(kColorGray207);
    _lblName.text = model.title;
    _lblData.text = [QGLOBAL dateTimeIntervalToStr:model.on_time];
    _lblContent.text = [[self filterHTML:model.content] removeSpaceAndNewline];
//    [[self filterHTML:model.content]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    _lblName.textColor = RGBHex(kColorGray201);
    _lblName.font = fontSystemBold(kFontS28);
    _lblData.textColor = RGBHex(kColorGray203);
    _lblContent.textColor = RGBHex(kColorGray201);
    [_imgHeader setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"Default_avatar"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload|SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    [self status];
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}
- (void)status{
    if (self.modItem.isSel.boolValue) {
        [_btnClick setImage:[UIImage imageNamed:@"Check2"] forState:UIControlStateNormal];
        
    }
    else {
        [_btnClick setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
        
    }
}
- (IBAction)btnAction:(id)sender{
    
    BOOL st=self.modItem.isSel.boolValue;
    self.modItem.isSel=[NSNumber numberWithBool:!st];
    if ([self.delegate respondsToSelector:@selector(cloudBaseCellDelegate:UserItemModel:)]) {
        [self.delegate cloudBaseCellDelegate:self UserItemModel:self.modItem];
    }
    
    [self status];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
