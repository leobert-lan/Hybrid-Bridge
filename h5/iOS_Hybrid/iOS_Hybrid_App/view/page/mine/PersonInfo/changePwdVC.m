//
//  changePwdVC.m
//  Chuangyiyun
//
//  Created by zhchen on 16/5/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "changePwdVC.h"
#import "MZTimerLabel.h"
#import "SignAPI.h"
#import "loginVC.h"
@interface changePwdVC ()<MZTimerLabelDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *txtOldPwd,*txtNewPwd,*txtNewPwdS;
    IBOutlet UIView *changPwdView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *btnOk;
}
@end

@implementation changePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)UIGlobal
{
    [super UIGlobal];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITapGestureRecognizer *tapGresture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGresture:)];
    [self.view addGestureRecognizer:tapGresture];
    scrollView.scrollEnabled = NO;
    UIView *viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtOldPwd.leftView = viewUser;
    txtOldPwd.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewVerCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtNewPwd.leftView = viewVerCode;
    txtNewPwd.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtNewPwdS.leftView = viewPwd;
    txtNewPwdS.leftViewMode = UITextFieldViewModeAlways;
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    txtOldPwd.textColor = RGBHex(kColorGray201);
    txtNewPwd.textColor = RGBHex(kColorGray201);
    txtNewPwdS.textColor = RGBHex(kColorGray201);
    [self naviTitle:@"修改密码"];
    
    UIView *sp1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, APP_W, 0.5)];
    sp1.backgroundColor = RGBHex(kColorGray206);
    [changPwdView addSubview:sp1];
    UIView *sp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 61, APP_W, 0.5)];
    sp2.backgroundColor = RGBHex(kColorGray206);
    [changPwdView addSubview:sp2];
    UIView *sp3 = [[UIView alloc] initWithFrame:CGRectMake(0, 107, APP_W, 0.5)];
    sp3.backgroundColor = RGBHex(kColorGray206);
    [changPwdView addSubview:sp3];
    UIView *sp4 = [[UIView alloc] initWithFrame:CGRectMake(0, 153, APP_W, 0.5)];
    sp4.backgroundColor = RGBHex(kColorGray206);
    [changPwdView addSubview:sp4];
    
}

- (IBAction)btnOkAction:(id)sender {
    
    if ([txtOldPwd.text isEqualToString:txtNewPwd.text]) {
        [self alertMessage:@"新密码与原密码相同"];
        
    }else{
        if (![txtNewPwd.text isEqualToString:txtNewPwdS.text]) {
            [self alertMessage:@"密码不一致"];
        }else if([QGLOBAL isPassword:txtNewPwd.text] == NO){
            [self alertMessage:@"格式错误,仅限字母数字及字符"];
        }else{
            [self showLoading];
            [SignAPI changePwd:QGLOBAL.auth.username oldPwd:txtOldPwd.text newPwd:txtNewPwd.text success:^(id model) {
                [QGLOBAL logoutSuccess:^(BOOL isLogout) {
                    if (isLogout) {
                        loginVC *vc=(loginVC *)[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
                        vc.delegatePopVC=self.delegatePopVC;
                        vc.canJump=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
                
                /*
                UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"密码修改成功，请重新登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
                    loginVC *vc=(loginVC *)[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
                    vc.delegatePopVC=self.delegatePopVC;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [alt addAction:can];
                [self presentViewController:alt animated:YES completion:nil];
                 */
            } failure:^(NetError *err) {
                [self didLoad];
                [self showText:err.errMessage];
                DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            }];
        
        }
    }
}

- (void)tapGresture:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        scrollView.contentOffset = CGPointMake(0, 0);
        scrollView.scrollEnabled = NO;
    }];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    scrollView.scrollEnabled = YES;
    return YES;
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
