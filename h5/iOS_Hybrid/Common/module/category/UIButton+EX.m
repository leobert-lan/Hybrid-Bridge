//
//  UIButton+EX.m
//  cyy_task
//
//  Created by Qingyang on 16/11/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "UIButton+EX.h"

@implementation UIButton (EX)
- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state{
    [self setBackgroundImage:[self imageWithColor:color] forState:UIControlStateNormal];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
