//
//  loginVC.m
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "loginVC.h"
#import "SignAPI.h"
#import "UMSocial.h"
#import "ThirdLoginVC.h"
#import "ForgotPwdVerifyPhoneVC.h"
#import "RegisterVC.h"
@interface loginVC ()<UITextFieldDelegate>
{
    IBOutlet UITextField *txtUser,*txtPwd;
    IBOutlet UIButton *btnOk;
    IBOutlet UIButton *btnQQ,*btnWeibo,*btnWeixin;
    IBOutlet UIView *ThirdLeftView,*ThirdRightView;
    IBOutlet UILabel *lblQQLeft,*lblQQRight,*lblThirdCenter;
    
    BOOL isTrdSuccess;
}
@end

@implementation loginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [MobClick event:UMUserLoginPage];
    [self addTapGesture];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    [self didLoad];
//}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    AuthModel *aa=[AuthModel getModelFromDB];
    if (aa && aa.loginID.length) {
        txtUser.text=StrFromObj(aa.loginID);
    }else{
        txtUser.text=@"";
    }
    [self naviTitle:@"登录"];
    txtUser.textColor = RGBHex(kColorGray201);
    txtPwd.textColor = RGBHex(kColorGray201);
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    lblThirdCenter.textColor = RGBHex(kColorGray203);
    ThirdLeftView.backgroundColor = RGBHex(kColorGray203);
    ThirdRightView.backgroundColor = RGBHex(kColorGray203);
    [btnWeibo setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    [btnWeixin setTitleColor:RGBHex(kColorGray203) forState:UIControlStateNormal];
    lblQQLeft.backgroundColor = RGBHex(kColorGray203);
    lblQQRight.backgroundColor = RGBHex(kColorGray203);
    [self naviRightButton:@"注册" action:@selector(navRightAction:)];

    UIView *viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtUser.leftView = viewUser;
    txtUser.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtPwd.leftView = viewPwd;
    txtPwd.leftViewMode = UITextFieldViewModeAlways;
    
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

- (void)addTapGesture{
    // 点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}
#pragma mark - action
- (void)navRightAction:(UIBarButtonItem *)sender
{
    RegisterVC *vc=(RegisterVC *)[QGLOBAL viewControllerName:@"RegisterVC" storyboardName:@"Register"];
    vc.delegatePopVC=self.delegatePopVC;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tapAction:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)btnOkAction:(id)sender {
    
    if ([[txtUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[txtPwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self.view endEditing:YES];
        [self alertMessage:@"用户名或密码格式不正确"];
    }else{
    
        [self.view endEditing:YES];
        [self showLoading];
        [SignAPI login:txtUser.text password:txtPwd.text success:^(AuthModel*  authmodel) {
            [MobClick event:UMUserLogin attributes:@{@"success":StrFromInt(1)}];
            
            authmodel.loginID = txtUser.text;
            QGLOBAL.auth = authmodel;
//
//            UserModel *usermodel = [UserModel getModelFromDB];
//            DLog(@"%@",usermodel);
//            QGLOBAL.usermodel = usermodel;
////            DLog(@"success:%@",mm);
//            
//            [QGLOBAL.sideMenu setUserInfo:QGLOBAL.auth];
//            //                [APPDelegate mainInit];
//            if ([self.loginType isEqualToString:@"first"]) {
//                [APPDelegate mainInit];//引导页进入
//            }else{
//            [self popVCAction:nil];
//            }
//            //登录成功
//            [QGLOBAL postNotif:NotifLoginSuccess data:nil object:authmodel];
//            
//            [self didLoad];
            
            //获取用户信息
            [SignAPI getUserInfoUsername:QGLOBAL.auth.username success:^(UserModel *usermodel) {
//                authmodel.loginID = txtUser.text;
//                QGLOBAL.auth = authmodel;
                
                QGLOBAL.usermodel = usermodel;
                //            DLog(@"success:%@",mm);
                
                [QGLOBAL.sideMenu setUserInfo:QGLOBAL.auth];
                //                [APPDelegate mainInit];
                if ([self.loginType isEqualToString:@"first"]) {
                    [APPDelegate mainInit];//引导页进入
                }else{
                    [self jumpToPopVCAction:nil];
//                    [self popVCAction:nil];
                }
                //登录成功
                [QGLOBAL postNotif:NotifLoginSuccess data:nil object:authmodel];
                
                [self didLoad];
                
                //delegate回调
                [self loginSuccess];
                
            } failure:^(NetError* err) {
                [MobClick event:UMUserLogin attributes:@{@"failureUInfo":StrFromInt(err.errStatusCode)}];
                [self didLoad];
                [self showText:err.errMessage];
                DLog(@">>> checkAuthResult err:%li",err.errStatusCode);
            }];
            
            
            
            
            
        } failure:^(NetError* err) {
            [MobClick event:UMUserLogin attributes:@{@"failure":StrFromInt(err.errStatusCode)}];
            
            [self didLoad];
            DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            if (err.errStatusCode == 13003) {
                UIAlertController *alt = [UIAlertController alertControllerWithTitle:Msg_Login message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *real = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    txtUser.text = @"";
                    txtPwd.text = @"";
                }];
                UIAlertAction *company = [UIAlertAction actionWithTitle:@"注册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    RegisterVC *vc=(RegisterVC *)[QGLOBAL viewControllerName:@"RegisterVC" storyboardName:@"Register"];
                    vc.delegatePopVC=self.delegatePopVC;
                    vc.delegate=self.delegate;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
                [alt addAction:real];
                [alt addAction:company];
                [self presentViewController:alt animated:YES completion:nil];
            }else{
                [self showText:err.errMessage];
            }
//            if (err==nil) {
//                err.errStatusCode=400;
//                //            err.errMessage=@"登录失败";
//                [self showText:@"用户名或密码错误!"];
//            }
//            else if (!StrIsEmpty(err.errMessage)) {
//                if (err.errStatusCode==400) {
//                    err.errMessage=@"用户名或密码错误!";
//                }
//                [self showText:err.errMessage];
//            }
//            else {
//                [self showText:@"用户名或密码错误!"];
//            }
            
//            DLog(@"err:%@",err);
            
        }];
    }
}

- (IBAction)btnForgotPasswordAction:(id)sender {
    ForgotPwdVerifyPhoneVC *vc=(ForgotPwdVerifyPhoneVC *)[QGLOBAL viewControllerName:@"ForgotPwdVerifyPhoneVC" storyboardName:@"login"];
    vc.verifyType = PhoneTypeLogin;
    vc.delegatePopVC=self.delegatePopVC;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)btnQQAction:(id)sender {
    [MobClick event:UMUserLoginQQ];
    isTrdSuccess=false;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
    [self showLoading];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
   
        //  用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            isTrdSuccess=true;
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];

            DLog(@"username is %@, uid is %@, token is %@ url is %@ \nopenId:%@ \nunionId:%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,snsAccount.openId,snsAccount.unionId);

            [self thirdLoginRequestVia:@"qq" username:snsAccount.userName openid:snsAccount.openId];
            
        }});
    }else{
        [self alertMessage:@"您的设备没有安装QQ" nav:self.navigationController];
    }
}
- (IBAction)btnWeixnAction:(id)sender {
    [MobClick event:UMUserLoginWX];
    isTrdSuccess=false;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
    [self showLoading];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //  用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            isTrdSuccess=true;
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            DLog(@"username is %@, uid is %@, token is %@ url is %@ \nopenId:%@ \nunionId:%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,snsAccount.openId,snsAccount.unionId);
            [self thirdLoginRequestVia:@"weixin" username:snsAccount.userName openid:snsAccount.unionId];
        }});
    }else{
        [self didLoad];
        [self alertMessage:@"您的设备没有安装微信" nav:self.navigationController];
    }
}
- (IBAction)btnWeiboAction:(id)sender {
    [MobClick event:UMUserLoginWB];
    
    isTrdSuccess=false;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
    [self showLoading];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            isTrdSuccess=true;
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            DLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self thirdLoginRequestVia:@"weibo" username:snsAccount.userName openid:snsAccount.usid];
        }});
    }else{
        [self didLoad];
        [self alertMessage:@"您的设备没有安装微博" nav:self.navigationController];
    }
}
- (void)alertMessage:(NSString *)message nav:(UINavigationController *)nav
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:can];
    [nav presentViewController:alt animated:YES completion:nil];
}
- (void)popVCAction:(id)sender{
    if (_canJump) {
        [self jumpToPopVCAction:nil];
    }
    else {
        [super popVCAction:nil];
    }
}
#pragma mark - textDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1000) {
        [txtPwd becomeFirstResponder];
    }else if (textField.tag == 1001){
        [textField resignFirstResponder];
//        [self btnOkAction:nil];
    }
    return YES;
}
- (void)thirdLoginVia:(NSString *)via username:(NSString *)username openid:(NSString *)openid authModel:(AuthModel *)authModel
{
    [self didLoad];
    
    ThirdLoginVC *vc = (ThirdLoginVC *)[QGLOBAL viewControllerName:@"ThirdLoginVC" storyboardName:@"ThirdLogin"];
    vc.username = username;
    vc.openid = openid;
    vc.via = via;
    vc.authModel = authModel;
    vc.delegatePopVC=self.delegatePopVC;
    vc.delegate=self.delegate;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)thirdLoginRequestVia:(NSString *)via username:(NSString *)username openid:(NSString *)openid
{
    [self showLoading];
    //先判断是不是老用户
    [SignAPI thirdLoginVia:via openid:openid success:^(AuthModel *model) {
        
        if (model.isnewpwd == 2) {
            
            //不是老用户，去注册填密码
            [self thirdLoginVia:via username:username openid:openid authModel:model];
        }else{
            //是老用户
            [SignAPI thirdLoginVia:via openid:openid success:^(AuthModel *model) {
                [MobClick event:UMUserLogin3rd attributes:@{@"success":StrFromInt(1)}];
                
                
                model.loginID = txtUser.text;
                QGLOBAL.auth = model;
                
                UserModel *usermodel = [UserModel getModelFromDB];

                QGLOBAL.usermodel = usermodel;
                
                [QGLOBAL.sideMenu setUserInfo:QGLOBAL.auth];
            
                if ([self.loginType isEqualToString:@"first"]) {
                    [APPDelegate mainInit];//引导页进入
                }else{
                    [self popVCAction:nil];
                }
                //登录成功
                [QGLOBAL postNotif:NotifLoginSuccess data:nil object:model];
                
                [self didLoad];
                
                //delegate回调
                [self loginSuccess];
                
            } failure:^(NetError * err) {
                [self showText:Msg_ThirdLoginErr];
                [self didLoad];
                
                [MobClick event:UMUserLogin3rd attributes:@{@"failure":StrFromInt(1)}];
                DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            }];
        }
    } failure:^(NetError * err) {
        [self showText:Msg_ThirdLoginErr];
        [self didLoad];
        
        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
    }];
}
- (void)alertMessage:(NSString *)message
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:can];
    [self presentViewController:alt animated:YES completion:nil];
}

/*
- (IBAction)btnTestAction:(id)sender {
    [self showLoading];
    NSString *oid=@"1234523255309023";
    [SignAPI thirdLoginVia:@"weibo" openid:oid success:^(AuthModel *model) {
        if (model.isnewpwd == 2) {
            [self didLoad];
            [self thirdLoginVia:@"weibo" username:model.username openid:oid authModel:model];
        }else{
            [SignAPI thirdLoginVia:@"weibo" openid:oid success:^(AuthModel *model) {
                AuthModel *mm = [[AuthModel alloc] init];
                mm = model;
                mm.loginID = txtUser.text;
                QGLOBAL.auth = mm;
                UserModel *usermodel = [UserModel getModelFromDB];
                DLog(@"%@",usermodel);
                QGLOBAL.usermodel = usermodel;
                //            DLog(@"success:%@",mm);
                
                [QGLOBAL.sideMenu setUserInfo:QGLOBAL.auth];
                //                [APPDelegate mainInit];
                [self popVCAction:nil];
                //登录成功
                [QGLOBAL postNotif:NotifLoginSuccess data:nil object:model];
                
                [self didLoad];
                
            } failure:^(NetError * err) {
                [self didLoad];
                DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            }];
        }
    } failure:^(NetError * err) {
        [self didLoad];
        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
    }];
}
*/

#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    [super getNotifType:type data:data target:obj];
    if (type == NotifAppDidBecomeActive){
        //login
        DLog(@"+++ re back");
        if (isTrdSuccess==false) {
            [self didLoad];
        }
        
    }
    
}

#pragma mark - 回调auth
- (void)loginSuccess{
    if ([self.delegate respondsToSelector:@selector(loginVCDelegate:auth:)]) {
        [self.delegate loginVCDelegate:self auth:QGLOBAL.auth];
    }
}
@end
