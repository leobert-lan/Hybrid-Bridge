//
//  PerfectVC.m
//  cyy_task
//
//  Created by zhchen on 16/7/28.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "PerfectVC.h"

@interface PerfectVC ()
{
    IBOutlet UIButton *btnOk;
}
@end

@implementation PerfectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"完善信息"];
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
}
#pragma mark - action
- (IBAction)btnOkAction:(id)sender {
    [APPDelegate mainInit];
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
