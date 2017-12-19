//
//  QYSlideslipA.h
//  cyy_task
//
//  Created by Qingyang on 16/7/6.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseVC.h"
@protocol QYSlideslipADelegate <NSObject>
@optional
- (void)QYSlideslipADelegate:(id)delegate hiddenLeftView:(BOOL)hidden;
- (void)QYSlideslipADelegate:(id)delegate mainViewWillAppear:(BOOL)animated;
@end

@interface QYSlideslipA : BaseVC
@property (assign) BOOL navBarHidden;
@property (nonatomic,assign) BOOL isSideMenu; //侧边状态
//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (assign,nonatomic) CGFloat speedf;
//侧边宽度
@property (assign,nonatomic) CGFloat sideWidth;
//是否允许点击视图恢复视图位置。默认为yes
@property (strong) UITapGestureRecognizer *sideslipTapGes;

- (instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
             width:(CGFloat)width;

//显示侧栏
- (void)showLeftView;
//隐藏左视图
- (void)hiddenLeftView;
@end
