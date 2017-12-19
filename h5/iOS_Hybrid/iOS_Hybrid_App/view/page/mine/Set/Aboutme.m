//
//  Aboutme.m
//  cyy_task
//
//  Created by zhchen on 16/7/7.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "Aboutme.h"
#import "protocolWebVC.h"
#import "RegisterWebVC.h"
@interface Aboutme ()
{
    IBOutlet UILabel *verLab;
    IBOutlet UIButton *verBtn;
    IBOutlet UILabel *copyrightLab;
    IBOutlet NSLayoutConstraint *verLabTop;
    IBOutlet NSLayoutConstraint *verBtnTop;
    IBOutlet NSLayoutConstraint *copyrightLabDown;
}
@end

@implementation Aboutme

- (void)viewDidLoad {
    [super viewDidLoad];
    verLab.textColor = RGBHex(kColorGray201);
    [verBtn setTintColor:RGBHex(kColorMain001)];
    copyrightLab.textColor = RGBHex(kColorMain001);
    
    if (APP_H <= 548) {
        verLabTop.constant = 0;
        verBtnTop.constant = 0;
        copyrightLabDown.constant = 0;
    }
    // Do any additional setup after loading the view.
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"关于我们"];
    NSString *version = VERSION;
    //lblVer.text = [NSString stringWithFormat:@"当前版本:%@",version];
    verLab.font = fontSystem(kFontS30);
    verLab.textColor = RGBHex(kColorGray201);
    verLab.text = [NSString stringWithFormat:@"云差事%@",version];
}
#pragma mark - action
- (IBAction)verBtn:(id)sender {
    RegisterWebVC *vc=(RegisterWebVC *)[QGLOBAL viewControllerName:@"RegisterWebVC" storyboardName:@"RegisterWeb"];
    vc.registerF = WebTypeRegister;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
