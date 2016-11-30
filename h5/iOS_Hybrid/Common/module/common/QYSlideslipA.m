//
//  QYSlideslipA.m
//  cyy_task
//
//  Created by Qingyang on 16/7/6.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "QYSlideslipA.h"

@interface QYSlideslipA ()<UIGestureRecognizerDelegate>
{
    UIViewController * leftControl;
    UIViewController * mainControl;
    UIView *shadow;
    CGFloat posX;
}
@end

@implementation QYSlideslipA

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden=YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.isSideMenu) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//        [UIView beginAnimations:nil context:nil];
//        leftControl.view.transform = CGAffineTransformMakeTranslation(self.sideWidth, 0);
//        leftControl.view.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
//        [UIView commitAnimations];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(QYSlideslipADelegate:mainViewWillAppear:)]) {
            [self.delegate QYSlideslipADelegate:self mainViewWillAppear:animated];
        }
    }
}


#pragma mark - init
-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
             width:(CGFloat)width
{
    if(self){
        posX=0;
        self.speedf = 0.5;
        
        leftControl = LeftView;
        mainControl = MainView;
        
        self.sideWidth=width>0?width:44;
        
        //滑动手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        pan.delegate=self;
        [leftControl.view addGestureRecognizer:pan];
        
        
        [self.view addSubview:mainControl.view];
        [self.view addSubview:leftControl.view];
        
        //侧栏位置隐藏
        CGRect frm=leftControl.view.frame;
        frm.origin.x-=CGRectGetWidth(leftControl.view.frame);
        leftControl.view.frame=frm;
//        DLog(@"%@ %@",NSStringFromCGRect(frm),NSStringFromCGRect(mainControl.view.frame));
        
        self.isSideMenu=false;
        
        frm=[UIScreen mainScreen].bounds;
        shadow=[[UIView alloc] initWithFrame:frm];
        shadow.backgroundColor=RGBAHex(kColorB, 0.35);
        [self.view insertSubview:shadow aboveSubview:mainControl.view];
        shadow.hidden=YES;
    }
    return self;
}

#pragma mark - 滑动手势

//滑动手势
- (void)handlePan:(UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:self.view];

    posX = rec.view.frame.origin.x + point.x;
    
    //根据视图位置判断
    if (posX>=(self.sideWidth-CGRectGetWidth(rec.view.frame))){
        //超边距，不能滑动
    }
    else
    {
        rec.view.center = CGPointMake(rec.view.center.x + point.x,rec.view.center.y);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];

    }

    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded) {
        //如果只滑动80不收起左页面
        if (posX+rec.view.width>self.sideWidth-80){
            [self showLeftView];
        }
        else
        {
            [self showMainView];
            posX = 0;
        }
    }
    
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self showMainView];
    }
}

- (void)removeTap{
    shadow.hidden=YES;
    
    [shadow removeGestureRecognizer:self.sideslipTapGes];

}

- (void)addTap{
    shadow.hidden=NO;
    
    if (self.sideslipTapGes == nil) {
        //单击手势
        self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        self.sideslipTapGes.delegate=self;
        
    }
    [shadow removeGestureRecognizer:self.sideslipTapGes];
    [shadow addGestureRecognizer:self.sideslipTapGes];
}
#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[UIControl class]]){
//        // we touched a button, slider, or other UIControl
//        return NO; // ignore the touch
//    }
//    
//    return YES;
//
//}

#pragma mark - 修改视图位置
//恢复位置
-(void)showMainView{
    [UIView beginAnimations:nil context:nil];
    leftControl.view.transform = CGAffineTransformMakeTranslation(0, 0);
    leftControl.view.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self removeTap];

    self.isSideMenu=false;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(QYSlideslipADelegate:hiddenLeftView:)]) {
        [self.delegate QYSlideslipADelegate:self hiddenLeftView:YES];
    }
    
}

//显示左视图
-(void)showLeftView{
    [MobClick event:UMNavSlide];
    [UIView beginAnimations:nil context:nil];
    leftControl.view.transform = CGAffineTransformMakeTranslation(self.sideWidth, 0);
    leftControl.view.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    
    //变色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self addTap];

    self.isSideMenu=true;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(QYSlideslipADelegate:hiddenLeftView:)]) {
        [self.delegate QYSlideslipADelegate:self hiddenLeftView:NO];
    }
}

//隐藏左视图
-(void)hiddenLeftView{
    [UIView beginAnimations:nil context:nil];
    leftControl.view.transform = CGAffineTransformMakeTranslation(0, 0);
    leftControl.view.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self removeTap];
    
    self.isSideMenu=false;
}
@end
