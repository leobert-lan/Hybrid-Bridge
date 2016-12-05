//
//  AuthStatusLblCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/9.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthStatusLblCell.h"

@implementation AuthStatusLblCell
+ (float)getCellHeight:(NSString *)data
{
    if ([[self alloc] getTextHeightWithString:data withFontSize:14.0f]+5 > 45) {
        
        return [[self alloc] getTextHeightWithString:data withFontSize:14.0f]+5;
    }else{
        return 45;
    }
}
- (void)setCell:(NSString *)model
{
    _lblName.text = model;
    _lblName.textColor = RGBHex(kColorGray201);
    _lblName.font = fontSystem(kFontS28);
    
}
// 取消点击高亮颜色
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
- (CGFloat)getTextHeightWithString:(NSString *)text withFontSize:(CGFloat)fontSize
{
    // 计算高度,必须对宽度进行限定
    // 第三个参数字体的大小必须和label上的字体保持一致,否则计算不准确
    CGRect rect = [text boundingRectWithSize:CGSizeMake(APP_W - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
