//
//  GuideVC.m
//  CloudBox
//
//  Created by zhchen on 15/12/17.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "GuideVC.h"
#import "UIView+Extension.h"
#import "loginVC.h"
#import "RegisterVC.h"
#define kScreenWidh [UIScreen mainScreen].bounds.size.width
@interface GuideVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIWindow *window;
@property(nonatomic,strong)UIImageView *image;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *labelS;
@property(nonatomic,strong)UIImageView *pageImage;
@property(nonatomic,strong)UIImageView *pageImage2;
@property(nonatomic,strong)UIImageView *pageImage3;
@end

@implementation GuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatScroll];
    // Do any additional setup after loading the view.
    [MobClick event:UMTaskGuide];
}

- (void)creatScroll
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H+20)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
    self.scrollView.pagingEnabled = YES;
    for (int i = 0; i < 3; i++) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidh, 0, APP_W, CGRectGetHeight(self.scrollView.frame))];
        self.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]];
        [self.scrollView addSubview:self.image];
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = RGBHex(kColorMain001);
        self.label.font = fontSystemBold(kFontS48*kAutoScale);
        
        self.label.x = i * kScreenWidh;
        self.label.y = APP_H-151*kAutoScale;
        self.label.width = APP_W;
        self.label.height = 30;
        
        [self.scrollView addSubview:self.label];
        if (i == 0) {
            self.label.text = @"海量需求,智能搜索";
        }else if (i == 1){
            self.label.text = @"个性订阅,专人专事";
        }else if(i == 2){
            self.label.text = @"一键管理,尽在掌握";
        }
        
        self.labelS = [[UILabel alloc] initWithFrame:CGRectMake(i * kScreenWidh, CGRectGetMaxY(self.label.frame)+10, APP_W, 15)];
        self.labelS.textAlignment = NSTextAlignmentCenter;
        self.labelS.textColor = RGBHex(kColorMain001);
        self.labelS.font = fontSystem(kFontS24*kAutoScale);
        [self.scrollView addSubview:self.labelS];
        if (i == 0) {
            self.labelS.text = @"八大行业,百种类型,总能找到合适你的";
        }else if (i == 1){
            self.labelS.text = @"数据匹配,精准推送,专属于你的需求推荐";
        }else if(i == 2){
            self.labelS.text = @"一目了然,实时监管,随时随地进行管理";
        }
            UIButton *btnR = [UIButton buttonWithType:UIButtonTypeSystem];
            btnR.frame = CGRectMake(APP_W*2+15, APP_H-61*kAutoScale,(APP_W - 40) / 2 ,40);
            [btnR setTitleColor:RGBHex(kColorGray201) forState:UIControlStateNormal];
            [btnR setTitle:@"注册" forState:UIControlStateNormal];
            btnR.titleLabel.font = fontSystem(kFontS24);
            btnR.backgroundColor = RGBHex(kColorW);
            btnR.layer.borderWidth = 0.5;
            btnR.layer.cornerRadius = kCornerRadius;
            btnR.layer.borderColor = RGBHex(kColorGray201).CGColor;
            [self.scrollView addSubview:btnR];
            [btnR addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *btnL = [UIButton buttonWithType:UIButtonTypeSystem];
            btnL.frame = CGRectMake(CGRectGetMaxX(btnR.frame)+10, APP_H-61*kAutoScale,(APP_W - 40) / 2 ,40);
            [btnL setTitle:@"登录" forState:UIControlStateNormal];
            [btnL setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
            btnL.titleLabel.font = fontSystem(kFontS24);
            btnL.backgroundColor = RGBHex(kColorMain001);
            btnL.layer.borderWidth = 0.5;
            btnL.layer.cornerRadius = kCornerRadius;
            btnL.layer.borderColor = RGBHex(kColorMain001).CGColor;
            [self.scrollView addSubview:btnL];
            [btnL addTarget:self action:@selector(btnLAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.pageImage = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W/2 -5-10- 17*kAutoScale, APP_H - 51*kAutoScale, 10, 10)];
    self.pageImage.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_selected"];
    [self.view addSubview:self.pageImage];
    
    self.pageImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W/2-5, APP_H - 51*kAutoScale, 10, 10)];
    self.pageImage2.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_defout"];
    [self.view addSubview:self.pageImage2];
    
    self.pageImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(APP_W/2+5+17*kAutoScale, APP_H-51*kAutoScale, 10, 10)];
    self.pageImage3.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_defout"];
    [self.view addSubview:self.pageImage3];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger a = scrollView.contentOffset.x / kScreenWidh;
    if (a == 0) {
        self.pageImage.hidden = NO;
        self.pageImage2.hidden = NO;
        self.pageImage3.hidden = NO;
        self.pageImage.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_selected"];
        self.pageImage2.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_defout"];
        self.pageImage3.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_defout"];
    }else if (a == 1){
        self.pageImage.hidden = NO;
        self.pageImage2.hidden = NO;
        self.pageImage3.hidden = NO;
        self.pageImage.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_defout"];
        self.pageImage2.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_selected"];
        self.pageImage3.image = [UIImage imageNamed:@"v1011_drawable_icon_dot_defout"];
    }else if (a == 2){
        self.pageImage.hidden = YES;
        self.pageImage2.hidden = YES;
        self.pageImage3.hidden = YES;
    }
}

- (void)buttonAction:(UIButton *)sender
{
    RegisterVC *vc=(RegisterVC *)[QGLOBAL viewControllerName:@"RegisterVC" storyboardName:@"Register"];
    vc.backButtonEnabled=YES;
    vc.typeRegis = @"first";
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}
- (void)btnLAction:(UIButton *)sender
{
    loginVC *vc=(loginVC *)[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
    vc.backButtonEnabled=YES;
    vc.loginType = @"first";
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
