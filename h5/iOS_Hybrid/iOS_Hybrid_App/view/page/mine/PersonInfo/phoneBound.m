//
//  phoneBound.m
//  Chuangyiyun
//
//  Created by zhchen on 16/5/11.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "phoneBound.h"
#import "MZTimerLabel.h"
#import "changePhoneNumVC.h"
#import "SignAPI.h"
#import "MineAPI.h"
#import "PersonalInfoVC.h"
@interface phoneBound ()<MZTimerLabelDelegate,UITextFieldDelegate>
{
    IBOutlet UIButton *btnPwd,*btnOk;
    IBOutlet UITextField *txtPhoneNum,*txtVerCode;
    UILabel *lblPwd;
    dispatch_source_t _timer;
}
@end

@implementation phoneBound

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *sp1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, APP_W, 0.5)];
    sp1.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp1];
    UIView *sp2 = [[UIView alloc] initWithFrame:CGRectMake(0, 61, APP_W, 0.5)];
    sp2.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp2];
    UIView *sp3 = [[UIView alloc] initWithFrame:CGRectMake(0, 107, APP_W, 0.5)];
    sp3.backgroundColor = RGBHex(kColorGray206);
    [self.view addSubview:sp3];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    txtPhoneNum.textColor = RGBHex(kColorGray201);
    txtPhoneNum.delegate = self;
    txtVerCode.textColor = RGBHex(kColorGray201);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    
    btnPwd.layer.borderWidth = 1;
    btnPwd.layer.cornerRadius = kCornerRadius;
    btnPwd.layer.borderColor = RGBHex(kColorMain001).CGColor;
    btnPwd.backgroundColor = RGBAHex(kColorMain001, 1);
    if ([_boundType isEqualToString:@"ForgotPwdVerifyPhoneVC"]) {
        QGLOBAL.time = @"0";
    }
    if (StrIsEmpty(QGLOBAL.time) || QGLOBAL.time.intValue <=0) {
        [btnPwd setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        [btnPwd setTitle:[NSString stringWithFormat:@"%@",QGLOBAL.time] forState:UIControlStateNormal];
        [self timeCount:QGLOBAL.time.intValue];
    }
    UIView *viewPhoneNum = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtPhoneNum.leftView = viewPhoneNum;
    txtPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    UIView *viewVerCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    txtVerCode.leftView = viewVerCode;
    txtVerCode.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    [self naviTitle:@"手机绑定"];
}
#pragma mark - action
- (IBAction)btnPWDAction:(id)sender {
    
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
- (void)timeCount:(int)time{//倒计时函数
    __block int timeout=time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            QGLOBAL.time = @"0";
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btnPwd setTitle:@"获取验证码" forState:UIControlStateNormal];
                btnPwd.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                QGLOBAL.time = strTime;
                [btnPwd setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                btnPwd.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [btnPwd setTitle:@"获取验证码" forState:UIControlStateNormal];
    [lblPwd removeFromSuperview];
    btnPwd.userInteractionEnabled = YES;
}
- (IBAction)btnOKAction:(id)sender {
    [self.view endEditing:YES];
    if ([txtVerCode.text isEqualToString:@""] || [txtVerCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < txtVerCode.text.length) {
        [self alertMessage:@"验证码格式不正确"];
    }else{
        [self showLoading];
        [SignAPI registerIsMobile:txtPhoneNum.text success:^(id model) {
        [SignAPI registerValidCode:txtVerCode.text mobile:txtPhoneNum.text success:^(id model) {
        
            [MineAPI PhoneBoundMobile:txtPhoneNum.text success:^(id model) {
                UserModel *usermodel = [[UserModel alloc] init];
                usermodel = QGLOBAL.usermodel;
                usermodel.mobile = txtPhoneNum.text;
                QGLOBAL.usermodel = usermodel;
                PersonalInfoVC *recordVc = nil;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[PersonalInfoVC class]]) {
                        recordVc = (PersonalInfoVC *)vc;
                        break;
                    }
                }
                if (recordVc == nil) {
                    ;
                }else{
                    if (self.phoneBoundBlock) {
                        self.phoneBoundBlock(txtPhoneNum.text);
                    }
                    [self.navigationController popToViewController:recordVc animated:YES];
                    if (_timer) {
                        QGLOBAL.time = @"0";
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [btnPwd setTitle:@"获取验证码" forState:UIControlStateNormal];
                            btnPwd.userInteractionEnabled = YES;
                        });
                    }
                }
                [self didLoad];
            } failure:^(NetError *err) {
                [self didLoad];
                [self showText:err.errMessage];
                DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
            }];
        } failure:^(NetError *err) {
            [self didLoad];
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
