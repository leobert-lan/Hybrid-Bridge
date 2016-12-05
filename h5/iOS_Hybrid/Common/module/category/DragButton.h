//
//  DragButton.h
//  CloudBox
//
//  Created by Qingyang on 16/3/22.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragButton : UIButton//<UIGestureRecognizerDelegate>
{
    CGPoint prePoint;                  // 移动过程中的上一个点
    CGFloat firstX,firstY;
}
- (void)setupLongPress;
@end
