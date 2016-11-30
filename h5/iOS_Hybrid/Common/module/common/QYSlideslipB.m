//
//  QYSlideslipA.m
//  cyy_task
//
//  Created by Qingyang on 16/7/6.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "QYSlideslipB.h"

@interface QYSlideslipB ()<UIGestureRecognizerDelegate>
{
    UIViewController * leftControl;
    UIViewController * mainControl;
//    UIViewController * righControl;
    
//    UIImageView * imgBackground;
    
    CGFloat scalef;
}
@end

@implementation QYSlideslipB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init
-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
//                   andRightView:(UIViewController *)RighView
             andBackgroundImage:(UIImage *)image
{
    if(self){
        self.speedf = 0.5;
        
        leftControl = LeftView;
        mainControl = MainView;
        //        righControl = RighView;
        
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [imgview setImage:image];
        [self.view addSubview:imgview];
        
        //滑动手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        pan.delegate=self;
        [mainControl.view addGestureRecognizer:pan];
        
        
        
        
        leftControl.view.hidden = YES;
        //        righControl.view.hidden = YES;
        
        [self.view addSubview:leftControl.view];
        //        [self.view addSubview:righControl.view];
        
        [self.view addSubview:mainControl.view];
        
    }
    return self;
}

#pragma mark - 滑动手势

//滑动手势
- (void)handlePan:(UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec translationInView:self.view];
    
    scalef = (point.x*self.speedf+scalef);
    
    //根据视图位置判断是左滑还是右边滑动
    if (rec.view.frame.origin.x>=0){
        rec.view.center = CGPointMake(rec.view.center.x + point.x*self.speedf,rec.view.center.y);
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1-scalef/1000,1-scalef/1000);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        //        righControl.view.hidden = YES;
        leftControl.view.hidden = NO;
        
    }
    else
    {
        rec.view.center = CGPointMake(rec.view.center.x + point.x*self.speedf,rec.view.center.y);
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1+scalef/1000,1+scalef/1000);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        
        //        righControl.view.hidden = NO;
        leftControl.view.hidden = YES;
    }
    
    
    
    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (scalef>140*self.speedf){
            [self showLeftView];
        }
        //        else if (scalef<-140*self.speedf) {
        //            [self showRighView];
        //        }
        else
        {
            [self showMainView];
            scalef = 0;
        }
    }
    
}




#pragma mark - 修改视图位置
//恢复位置
- (void)showMainView{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    mainControl.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    
    [self removeTap];
    DLog(@">>> showMainView END");
}

//显示左视图
- (void)showLeftView{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
    mainControl.view.center = CGPointMake(340,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    
    //单击手势
    [self addTap];
    DLog(@">>> showLeftView END");
}

//显示右视图
//- (void)showRighView{
//    [UIView beginAnimations:nil context:nil];
//    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
//    mainControl.view.center = CGPointMake(-60,[UIScreen mainScreen].bounds.size.height/2);
//    [UIView commitAnimations];
//}



#pragma mark - 单击手势
- (void)addTap{
    self.sideslipTapGes= nil;
    //单击手势
    self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
    [self.sideslipTapGes setNumberOfTapsRequired:1];
    self.sideslipTapGes.delegate=self;
    [mainControl.view addGestureRecognizer:self.sideslipTapGes];
}

- (void)removeTap{
    [mainControl.view removeGestureRecognizer:self.sideslipTapGes];
    self.sideslipTapGes= nil;
}

-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        [UIView commitAnimations];
        scalef = 0;
        
    }
    
}

//#pragma mark - UIGestureRecognizerDelegate
////防止button被手势覆盖
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isKindOfClass:[UIControl class]]){
//        // we touched a button, slider, or other UIControl
//        return NO; // ignore the touch
//    }
//    
//    return YES;
//    
//}
@end
