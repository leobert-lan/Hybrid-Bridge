//
//  QYSlideslipA.h
//  cyy_task
//
//  Created by Qingyang on 16/7/6.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseVC.h"

@interface QYSlideslipB : BaseVC
//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (assign,nonatomic) CGFloat speedf;
//是否允许点击视图恢复视图位置。默认为yes
@property (strong) UITapGestureRecognizer *sideslipTapGes;

- (instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
             andBackgroundImage:(UIImage *)image;
@end
