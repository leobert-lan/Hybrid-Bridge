//
//  ThirdLoginVC.m
//  Chuangyiyun
//
//  Created by zhchen on 16/6/30.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ThirdLoginVC.h"
#import "SignAPI.h"
#import "PerfectVC.h"
@interface ThirdLoginVC ()<UITextFieldDelegate>
{
    IBOutlet UILabel *lblID;
    IBOutlet UITextField *txtPassword,*txtName,*txtPwdS;
    IBOutlet UIButton *btnOk;
}
@end

@implementation ThirdLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:UMUserRegist3rd];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self didLoad];
}
- (void)UIGlobal
{
    [super UIGlobal];
    
    [self naviBackButton];
    [self naviTitle:@"设置密码"];
    
    txtPassword.placeholder=Txt_PwdNum;
    txtPassword.textColor = RGBHex(kColorGray201);
    txtName.textColor = RGBHex(kColorGray201);
    txtPwdS.textColor = RGBHex(kColorGray201);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    
//    [self naviLeftButtonImage:[UIImage imageNamed:@"fanh"] highlighted:nil action:@selector(leftAction:)];
    lblID.text = self.authModel.username;
    UIView *viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtPassword.leftView = viewUser;
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtName.leftView = viewPwd;
    txtName.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewPwdS = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtPwdS.leftView = viewPwdS;
    txtPwdS.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    UIView *sp1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, APP_W, 0.5)];
    sp1.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp1];
    UIView *sp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APP_W, 0.5)];
    sp2.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp2];
    UIView *sp3 = [[UIView alloc] initWithFrame:CGRectMake(0, 104, APP_W, 0.5)];
    sp3.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp3];
    UIView *sp4 = [[UIView alloc] initWithFrame:CGRectMake(0, 149, APP_W, 0.5)];
    sp4.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp4];
    
}

#pragma mark - action
- (IBAction)leftAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (IBAction)btnOKAcyion:(id)sender {
    
    if ([QGLOBAL isPassword:txtPassword.text] == NO){
        [self alertMessage:Msg_PwdFormat];
    }else if (![txtPassword.text isEqualToString:txtPwdS.text]){
        [self alertMessage:@"密码不一致"];
    }else{
        [self.view endEditing:YES];
        
        [self showLoading];
        [SignAPI thirdLoginChangePwdUserName:self.authModel.username pwd:txtPassword.text success:^(id model) {
            [MobClick event:UMUserRegist3rd attributes:@{@"success":StrFromInt(1)}];
            
            QGLOBAL.auth = self.authModel;
            //去选择行业和擅长领域
            SubscripNewVC *vc=[[SubscripNewVC alloc]initWithNibName:@"SubscripNewVC" bundle:nil];
            vc.delegatePopVC=self.delegatePopVC;
            vc.canJump=YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
            [QGLOBAL.sideMenu setUserInfo:QGLOBAL.auth];
            [self didLoad];
            
//            [SignAPI getUserInfoUsername:self.authModel.username success:^(UserModel *model) {
//                QGLOBAL.usermodel = model;
//
//                
//            } failure:^(NetError* err) {
//                [self didLoad];
//                [self showText:err.errMessage];
//            }];
//            
//            
//            [self didLoad];
        } failure:^(NetError *err) {
            [MobClick event:UMUserRegist3rd attributes:@{@"failure":StrFromInt(1)}];
            [self didLoad];
            [self showText:err.errMessage];
            DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            
        }];
    
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
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
