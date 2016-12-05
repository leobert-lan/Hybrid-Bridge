//
//  RegisterVC.m
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "RegisterVC.h"
#import "MZTimerLabel.h"
#import "SignAPI.h"
#import "loginVC.h"
#import "PerfectVC.h"
#import "RegisterWebVC.h"
@interface RegisterVC ()<MZTimerLabelDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *txtphoneNum,*txtVerCode,*txtPwd;
    IBOutlet UIButton *btnVerCode,*btnOk;
    UILabel *lblVerCode;
    dispatch_source_t _timer;
}
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"注册"];
    txtphoneNum.textColor = RGBHex(kColorGray201);
    txtVerCode.textColor = RGBHex(kColorGray201);
    txtPwd.textColor = RGBHex(kColorGray201);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    
    btnVerCode.layer.borderWidth = 1;
    btnVerCode.layer.cornerRadius = kCornerRadius;
    btnVerCode.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnVerCode.backgroundColor = RGBAHex(kColorMain001, 1);
    if (StrIsEmpty(QGLOBAL.registerTime) || QGLOBAL.registerTime.intValue <=0) {
        [btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        [btnVerCode setTitle:[NSString stringWithFormat:@"%@",QGLOBAL.registerTime] forState:UIControlStateNormal];
        [self timeCount:QGLOBAL.registerTime.intValue];
    }
    UIView *viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtphoneNum.leftView = viewUser;
    txtphoneNum.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewVerCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtVerCode.leftView = viewVerCode;
    txtVerCode.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtPwd.leftView = viewPwd;
    txtPwd.leftViewMode = UITextFieldViewModeAlways;
    [self naviRightButton:@"登录" action:@selector(navRightAction:)];
    
    UIView *sp1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, APP_W, 0.5)];
    sp1.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp1];
    UIView *sp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 61, APP_W, 0.5)];
    sp2.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp2];
    UIView *sp3 = [[UIView alloc] initWithFrame:CGRectMake(0, 107, APP_W, 0.5)];
    sp3.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp3];
    UIView *sp4 = [[UIView alloc] initWithFrame:CGRectMake(0, 153, APP_W, 0.5)];
    sp4.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp4];
    
    
    
}
#pragma mark - action
- (void)navRightAction:(UIBarButtonItem *)sender
{
    if ([self.typeRegis isEqualToString:@"first"]) {
        //引导页进入
        loginVC *vc=(loginVC *)[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
        vc.backButtonEnabled=YES;
        vc.loginType = @"first";
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:^{
            //
        }];
    }else{
//        [self.navigationController popViewControllerAnimated:YES];
        [self popVCAction:nil];
    }
    

}
- (IBAction)btnVerCode:(id)sender {
    if ([QGLOBAL isPhoneNumber:txtphoneNum.text] == NO) {
        [self alertMessage:@"手机号格式不正确"];
    }else{
        [self showLoading];
        [SignAPI registerIsMobile:txtphoneNum.text success:^(id model) {
            [SignAPI registerGetValidCodeMobile:txtphoneNum.text action:API_SendMessage success:^(id model) {
                [self didLoad];
                [self timeCount:kRegisterTime];
            } failure:^(NetError *err) {
                [self didLoad];
                [self showText:err.errMessage];
                DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            }];
            
        } failure:^(NetError *err) {
            [self didLoad];
            if (err.errStatusCode == 13183) {
                
                UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"该号码已注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *can = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    txtphoneNum.text = nil;
                }];
                UIAlertAction *login = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
                    [self popVCAction:nil];
                }];
                [alt addAction:can];
                [alt addAction:login];
                [self presentViewController:alt animated:YES completion:nil];
            }else{
            [self showText:err.errMessage];
            }
            DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            
        }];
        
    }
    
}
- (IBAction)btnRegisterAction:(id)sender {
    [self.view endEditing:YES];
    if ([txtVerCode.text isEqualToString:@""] || [txtVerCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < txtVerCode.text.length) {
        [self alertMessage:@"验证码格式不正确"];
    }else{
        [self showLoading];
        if ([QGLOBAL isPassword:txtPwd.text] == NO) {
            [self alertMessage:@"格式错误,仅限字母数字及字符"];
            [self didLoad];
        }else{
            
        [SignAPI registerValidCode:txtVerCode.text mobile:txtphoneNum.text success:^(id model) {
            
            [SignAPI registerUserMobile:txtphoneNum.text password:txtPwd.text success:^(id model) {
                [MobClick event:UMUserRegist attributes:@{@"success":StrFromInt(1)}];
                
                [SignAPI login:txtphoneNum.text password:txtPwd.text success:^(AuthModel*  model) {
                    model.loginID = txtphoneNum.text;
                    QGLOBAL.auth = model;
                    
                    [SignAPI getUserInfoUsername:model.username success:^(UserModel *model) {
                        [self didLoad];
                        QGLOBAL.usermodel = model;
                        [QGLOBAL.sideMenu setUserInfo:QGLOBAL.auth];
                        
                        //去选择行业和擅长领域
                        SubscripNewVC *vc=[[SubscripNewVC alloc]initWithNibName:@"SubscripNewVC" bundle:nil];
                        vc.canJump=YES;
                        vc.delegatePopVC=self.delegatePopVC;
//                        vc.backButtonEnabled=false;
                        [self.navigationController pushViewController:vc animated:YES];
                        if (_timer) {
                            QGLOBAL.registerTime = @"0";
                            dispatch_source_cancel(_timer);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                                btnVerCode.userInteractionEnabled = YES;
                            });
                        }
                    } failure:^(NetError* err) {
                        [self didLoad];
                        [self showText:@"注册成功,请到登录页面登录"];
                        [self performSelector:@selector(popVCAction:) withObject:nil afterDelay:0.5];
                        
                        /*
                        //去选择行业和擅长领域
                        SubscripNewVC *vc=[[SubscripNewVC alloc]initWithNibName:@"SubscripNewVC" bundle:nil];
                        vc.canJump=YES;
                        vc.delegatePopVC=self.delegatePopVC;
                        //                        vc.backButtonEnabled=false;
                        [self.navigationController pushViewController:vc animated:YES];
                        */
                    }];
                    

                } failure:^(NetError* err) {
                    [self didLoad];
                    [self showText:@"注册成功,请到登录页面登录"];
                    [self performSelector:@selector(popVCAction:) withObject:nil afterDelay:0.5];
                    /*
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    */
                    
                }];
            } failure:^(NetError *err) {
                [MobClick event:UMUserRegist attributes:@{@"failure":StrFromInt(1)}];
                
                [self didLoad];
                //                [self alertMessage:@"注册失败"];
                [self showText:err.errMessage];
                DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            }];
            
        } failure:^(NetError *err) {
            [self didLoad];
            [self showText:err.errMessage];
            DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
        }];
        
    }
    }
}
- (IBAction)agreementBtn:(id)sender {
    RegisterWebVC *vc=(RegisterWebVC *)[QGLOBAL viewControllerName:@"RegisterWebVC" storyboardName:@"RegisterWeb"];
    vc.registerF = WebTypeRegister;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:^{
        //
    }];
}

#pragma mark - textDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1002) {
        [txtVerCode becomeFirstResponder];
    }else if (textField.tag == 1003){
        [txtPwd becomeFirstResponder];
    }else if (textField.tag == 1004){
        [self btnRegisterAction:nil];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (txtphoneNum == textField) {
        if (aString.length > 11) {
            textField.text = [aString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self.view endEditing:YES];
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 11 - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }else{
        [self alertMessage:@"输入长度超过限制"];
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}
- (void)timeCount:(int)time{//倒计时函数
    //    [btnPwd setTitle:nil forState:UIControlStateNormal];
    //    lblPwd = [[UILabel alloc] initWithFrame:btnPwd.bounds];
    //    [btnPwd addSubview:lblPwd];
    //    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:lblPwd andTimerType:MZTimerLabelTypeTimer];
    //    [timer_cutDown setCountDownTime:120.0];
    //    timer_cutDown.timeFormat = @"mm:ss";
    //    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];
    //    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];
    //    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;
    //    timer_cutDown.delegate = self;
    //    btnPwd.userInteractionEnabled = NO;
    //    [timer_cutDown start];//开始计时
    
    __block int timeout=time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
             QGLOBAL.registerTime = @"0";
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                btnVerCode.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                QGLOBAL.registerTime = strTime;
                [btnVerCode setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                btnVerCode.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [lblVerCode removeFromSuperview];//移除倒计时模块
    btnVerCode.userInteractionEnabled = YES;
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
