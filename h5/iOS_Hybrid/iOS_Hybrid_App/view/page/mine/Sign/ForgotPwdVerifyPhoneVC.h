//
//  ForgotPwdVerifyPhoneVC.h
//  cyy_task
//
//  Created by zhchen on 16/7/12.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ForgotPwdVerifyPhoneBlock)(NSString *phoneNum);
typedef NS_ENUM(NSInteger, PhoneVerifyType) {
    PhoneTypeLogin = 0,
    PhoneTypePer = 1
};
@interface ForgotPwdVerifyPhoneVC : BaseViewController
@property(nonatomic,assign)NSInteger verifyType;
@property(nonatomic,copy)ForgotPwdVerifyPhoneBlock forgotPwdVerifyPhoneBlock;
@property(nonatomic,copy)NSString *phoneNum;
@end
