//
//  UIButton+EX.h
//  cyy_task
//
//  Created by Qingyang on 16/11/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EX)
- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
@end
