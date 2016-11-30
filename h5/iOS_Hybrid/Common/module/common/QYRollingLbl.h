//
//  QYRollingLbl.h
//  跑马灯
//
//  Created by Qingyang on 16/7/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYRollingOrientation){
    RollingOrientationNone = 0,
    RollingOrientationLeft,
    RollingOrientationRight
};

@interface QYRollingLbl : UIView
@property (nonnull, retain) NSArray *arrLabels;
@property (nonatomic, assign) QYRollingOrientation orientation;
//@property (nullable, nonatomic, copy)   NSAttributedString *attributedText;
//开始
- (void)start;
@end
