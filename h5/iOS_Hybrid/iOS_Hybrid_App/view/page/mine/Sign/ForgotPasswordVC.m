//
//  ForgotPasswordVC.m
//  cyy_task
//
//  Created by zhchen on 16/7/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "SignAPI.h"
#import "loginVC.h"
@interface ForgotPasswordVC ()
{
    IBOutlet UITextField *txtNewPwd,*txtNewPwdS;
    IBOutlet UIButton *btnOk;
}
@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"设置密码"];
    txtNewPwd.textColor = RGBHex(kColorGray201);
    txtNewPwdS.textColor = RGBHex(kColorGray201);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    UIView *viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtNewPwd.leftView = viewUser;
    txtNewPwd.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtNewPwdS.leftView = viewPwd;
    txtNewPwdS.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *sp1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, APP_W, 0.5)];
    sp1.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp1];
    UIView *sp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 61, APP_W, 0.5)];
    sp2.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp2];
    UIView *sp3 = [[UIView alloc] initWithFrame:CGRectMake(0, 107, APP_W, 0.5)];
    sp3.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp3];
}
#pragma mark - action
- (IBAction)btnOkAction:(id)sender {
    if ([QGLOBAL isPassword:txtNewPwd.text] == NO) {
        [self alertMessage:@"格式错误,仅限字母数字及字符"];
    }else if (![txtNewPwd.text isEqualToString:txtNewPwdS.text]){
        [self alertMessage:@"密码不一致"];
    }else{
        [self showLoading];
        [SignAPI ForgotPwdUserName:self.phoneNum pwd:txtNewPwd.text success:^(id model) {
            
            [self didLoad];
            
//            NSArray *arr=self.navigationController.viewControllers;
//            if (arr.count>=3) {
//                id obj=arr[arr.count-3];
//                if ([QGLOBAL object:obj isClass:[loginVC class]]) {
//                    [self.navigationController popToViewController:obj animated:NO];
//                }
//            }
            loginVC *vc=(loginVC *)[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
            vc.delegatePopVC=self.delegatePopVC;
            vc.canJump=YES;
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NetError *err) {
            [self didLoad];
            [self showText:err.errMessage];
            DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            
        }];
    }
}
- (void)alertMessage:(NSString *)message
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:can];
    [self presentViewController:alt animated:YES completion:nil];
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
