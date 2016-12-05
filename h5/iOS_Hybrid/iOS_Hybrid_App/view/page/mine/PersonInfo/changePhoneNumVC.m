//
//  changePhoneNumVC.m
//  cyy_task
//
//  Created by zhchen on 16/7/6.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "changePhoneNumVC.h"
#import "PersonalInfoVC.h"
#import "phoneBound.h"
#import "ForgotPwdVerifyPhoneVC.h"
@interface changePhoneNumVC ()
{
    IBOutlet UILabel *lblphone;
        IBOutlet UIButton *btnOk;
}
@end

@implementation changePhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (void)UIGlobal{
    [super UIGlobal];
    lblphone.textColor = RGBHex(kColorGray203);
    lblphone.text = [NSString stringWithFormat:@"   %@",self.phoneNum];
    
    btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    btnOk.layer.borderWidth = 1;
    btnOk.layer.cornerRadius = kCornerRadius;
    btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    
    [self naviTitle:@"手机绑定"];
}
#pragma mark - action
- (IBAction)popVCAction:(id)sender{
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
        [self.navigationController popToViewController:recordVc animated:YES];
    }
}
- (IBAction)btnChangePhoneAction:(id)sender {
    ForgotPwdVerifyPhoneVC *vc=(ForgotPwdVerifyPhoneVC *)[QGLOBAL viewControllerName:@"ForgotPwdVerifyPhoneVC" storyboardName:@"login"];
    vc.phoneNum = QGLOBAL.usermodel.mobile;
    vc.verifyType = PhoneTypePer;
    vc.delegatePopVC=self.delegatePopVC;
    vc.forgotPwdVerifyPhoneBlock = ^(NSString *phoneNum){
        if (self.changePhoneNumBlock) {
            self.changePhoneNumBlock(phoneNum);
        }
    };
    [self.navigationController pushViewController:vc animated:YES];

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
