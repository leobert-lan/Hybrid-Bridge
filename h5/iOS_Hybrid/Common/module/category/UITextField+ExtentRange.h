//
//  UITextField+ExtentRange.h
//  resource
//
//  Created by Yan Qingyang on 15/10/9.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)
//获取光标位置
- (NSRange)selectedRange;
//设置光标位置
- (void)setSelectedRange:(NSRange)range;
@end
