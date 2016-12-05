//
//  ForgotPwdVerifyPhoneVC.m
//  cyy_task
//
//  Created by zhchen on 16/7/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ForgotPwdVerifyPhoneVC.h"
#import "MZTimerLabel.h"
#import "ForgotPasswordVC.h"
#import "SignAPI.h"
#import "phoneBound.h"
@interface ForgotPwdVerifyPhoneVC ()<MZTimerLabelDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *txtPhoneNum,*txtVerCode;
    IBOutlet UIButton *btnVerCode,*btnOk;
    UILabel *lblVerCode;
    dispatch_source_t _timer;
}
@end

@implementation ForgotPwdVerifyPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"验证手机号"];
    txtPhoneNum.textColor = RGBHex(kColorGray201);
    txtPhoneNum.delegate = self;
    txtVerCode.textColor = RGBHex(kColorGray201);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    if (StrIsEmpty(QGLOBAL.forgotTime) || QGLOBAL.forgotTime.intValue <=0) {
        [btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        [btnVerCode setTitle:[NSString stringWithFormat:@"%@",QGLOBAL.forgotTime] forState:UIControlStateNormal];
        [self timeCount:QGLOBAL.forgotTime.intValue];
    }
    btnVerCode.layer.borderWidth = 1;
    btnVerCode.layer.cornerRadius = kCornerRadius;
    btnVerCode.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnVerCode.backgroundColor = RGBAHex(kColorMain001, 1);
    UIView *viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtPhoneNum.leftView = viewUser;
    txtPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewPwd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtVerCode.leftView = viewPwd;
    txtVerCode.leftViewMode = UITextFieldViewModeAlways;
    if (self.phoneNum != nil) {
        txtPhoneNum.enabled = NO;
    }
    txtPhoneNum.text = self.phoneNum;
    
    UIView *sp1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, APP_W, 0.5)];
    sp1.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp1];
    UIView *sp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 61, APP_W, 0.5)];
    sp2.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp2];
    UIView *sp3 = [[UIView alloc] initWithFrame:CGRectMake(0, 107, APP_W, 0.5)];
    sp3.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp3];
    
    [self naviTitle:@"验证手机号"];
}
#pragma mark - action
- (IBAction)btnVerCodeAction:(id)sender {
    if ([QGLOBAL isPhoneNumber:txtPhoneNum.text] == NO) {
        [self alertMessage:@"手机号格式不正确"];
    }else{
        [self showLoading];
        [SignAPI registerGetValidCodeMobile:txtPhoneNum.text action:API_ResetPassword success:^(id model) {
            [self didLoad];
            [self timeCount:kRegisterTime];
        } failure:^(NetError *err) {
            [self didLoad];
            //[self alertMessage:@"手机号不正确或已注册"];
            [self showText:err.errMessage];
            DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
        }];
    }
}
- (IBAction)btnOkAction:(id)sender {
    [self.view endEditing:YES];
    if ([txtVerCode.text isEqualToString:@""] || [txtVerCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < txtVerCode.text.length) {
        [self alertMessage:@"验证码格式不正确"];
    }else{
        [self showLoading];
        [SignAPI registerValidCode:txtVerCode.text mobile:txtPhoneNum.text success:^(id model) {
            [self didLoad];
            NSInteger num = self.verifyType;
            switch (num) {
                case 0:
                {
                    ForgotPasswordVC *vc=(ForgotPasswordVC *)[QGLOBAL viewControllerName:@"ForgotPasswordVC" storyboardName:@"login"];
                    vc.phoneNum = txtPhoneNum.text;
                    vc.delegatePopVC=self.delegatePopVC;
                    [self.navigationController pushViewController:vc animated:YES];
                    if (_timer) {
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                            btnVerCode.userInteractionEnabled = YES;
                        });
                    }
                }
                    break;
                case 1:
                {
                    phoneBound *vc=(phoneBound *)[QGLOBAL viewControllerName:@"phoneBound" storyboardName:@"PersonalInfo"];
                    vc.boundType = @"ForgotPwdVerifyPhoneVC";
                    vc.phoneBoundBlock = ^(NSString *phoneNum){
                        if (self.forgotPwdVerifyPhoneBlock) {
                            self.forgotPwdVerifyPhoneBlock(phoneNum);
                        }
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    if (_timer) {
                        QGLOBAL.forgotTime = @"0";
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [btnVerCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                            btnVerCode.userInteractionEnabled = YES;
                        });
                    }
                }
                    break;
                default:
                    break;
            }
            
            
        } failure:^(NetError *err) {
            [self didLoad];
            //            [self alertMessage:@"验证码不正确或已过期"];
            [self showText:err.errMessage];
            DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
        }];
    }
    
}
- (IBAction)callServiceAction:(id)sender {
    NSString *ttl=[NSString stringWithFormat:@"是否拨打 %@?",kTelNum];
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:ttl preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = [NSString stringWithFormat:@"tel:%@",kTelNum];
        if (str != nil) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str]]];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alt addAction:can];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
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
            QGLOBAL.forgotTime = @"0";
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
                QGLOBAL.forgotTime = strTime;
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
    [lblVerCode removeFromSuperview];
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

#pragma mark - textFieldDelegat
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (txtPhoneNum == textField) {
        if (aString.length > 11) {
            textField.text = [aString substringToIndex:11];
            return NO;
        }
    }
    return YES;
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
