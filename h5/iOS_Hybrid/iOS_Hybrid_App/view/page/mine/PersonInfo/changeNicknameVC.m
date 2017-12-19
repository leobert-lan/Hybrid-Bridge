//
//  changeNicknameVC.m
//  cyy_task
//
//  Created by zhchen on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "changeNicknameVC.h"
#import "MineAPI.h"
@interface changeNicknameVC ()
{
    IBOutlet UITextField *txtName;
    IBOutlet UIButton *btnOk;
}
@end

@implementation changeNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    txtName.text = self.nickname;
    // Do any additional setup after loading the view.
}
- (void)UIGlobal
{
    [super UIGlobal];
    txtName.textColor = RGBHex(kColorGray201);
    UIView *viewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtName.leftView = viewPwd;
    txtName.leftViewMode = UITextFieldViewModeAlways;
    txtName.textColor = RGBHex(kColorGray201);
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    [self naviTitle:@"修改昵称"];
}
#pragma mark - action
- (IBAction)btnOkAction:(id)sender {
    [self showLoading];
    [MineAPI mineChangeInfoInfoLab:@"nickname" info:txtName.text success:^(id model) {
        if (self.changeNickname) {
            self.changeNickname(txtName.text);
        }
        QGLOBAL.usermodel.nickname = txtName.text;
        [self popVCAction:nil];
        [self didLoad];
    } failure:^(NetError *err) {
        [self didLoad];
        [self showText:err.errMessage];
        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
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
