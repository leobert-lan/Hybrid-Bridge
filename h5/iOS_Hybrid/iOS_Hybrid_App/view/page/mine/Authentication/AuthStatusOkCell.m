//
//  AuthStatusOkCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/9.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthStatusOkCell.h"
#import "RealNameNew.h"
#import "MineAPI.h"
#import "CompanyAuthNewVC.h"
@implementation AuthStatusOkCell
- (void)setCell:(id)model
{
    self.backgroundColor = RGBHex(kColorGray207);
    _btnOk.backgroundColor = RGBAHex(kColorMain001, 1);
    _btnOk.layer.borderWidth = 1;
    _btnOk.layer.cornerRadius = kCornerRadius;
    _btnOk.layer.borderColor = RGBHex(kColorMain001).CGColor;
    
    if ([model isKindOfClass:[CompanyAuthModel class]]) {
        CompanyAuthModel *companyModel = model;
        if (companyModel.auth_status.integerValue == 2 || companyModel.auth_status.integerValue == 3) {
            [_btnOk setTitle:@"重新认证" forState:UIControlStateNormal];
        }
    }else if ([model isKindOfClass:[RealNameModel class]]){
        RealNameModel *realModel = model;
        if (realModel.auth_status.integerValue == 1) {
            [_btnOk setTitle:@"升级为企业认证" forState:UIControlStateNormal];
        }else if (realModel.auth_status.integerValue == 2 || realModel.auth_status.integerValue == 3){
            [_btnOk setTitle:@"重新认证" forState:UIControlStateNormal];
        }
    }
    
    self.model = model;
    
}
- (IBAction)btnOkAction:(id)sender {
    if ([self.model isKindOfClass:[CompanyAuthModel class]]) {
        CompanyAuthModel *companyModel = self.model;
        if ([companyModel.auth_status integerValue] == 2 || [companyModel.auth_status integerValue] == 3) {
            CompanyAuthNewVC *vc = [[CompanyAuthNewVC alloc] initWithNibName:@"CompanyAuthNewVC" bundle:nil];
            vc.isAgain = YES;
            CompanyAuthModelDB *mm = [[CompanyAuthModelDB alloc] init];
            mm.isEdit = [NSNumber numberWithBool:NO];
            QGLOBAL.companyAuthModelDB = mm;
            vc.delegatePopVC=self.delegatePopVC;
            [self.delegateNav pushViewController:vc animated:NO];
        }
        
    }else if ([self.model isKindOfClass:[RealNameModel class]]){
        
        RealNameModel *realModel = self.model;
        QGLOBAL.usermodel = [UserModel getModelFromDB];
        if ([realModel.auth_status integerValue] == 2 || [realModel.auth_status integerValue] == 3) {
            RealNameNew *vc = [[RealNameNew alloc] initWithNibName:@"RealNameNew" bundle:nil];
            vc.isAgain = YES;
            RealNameModelDB *mm = [[RealNameModelDB alloc] init];
            mm.isEdit = [NSNumber numberWithBool:NO];
            QGLOBAL.realNameModelDB = mm;
            vc.delegatePopVC=self.delegatePopVC;
            [self.delegateNav pushViewController:vc animated:NO];
        }else if ([realModel.auth_status integerValue] == 1){
            CompanyAuthNewVC *vc = [[CompanyAuthNewVC alloc] initWithNibName:@"CompanyAuthNewVC" bundle:nil];
            CompanyAuthModelDB *mm = [[CompanyAuthModelDB alloc] init];
            mm.isEdit = [NSNumber numberWithBool:NO];
            QGLOBAL.companyAuthModelDB = mm;
            vc.delegatePopVC=self.delegatePopVC;
            [self.delegateNav pushViewController:vc animated:NO];
        }
        
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
