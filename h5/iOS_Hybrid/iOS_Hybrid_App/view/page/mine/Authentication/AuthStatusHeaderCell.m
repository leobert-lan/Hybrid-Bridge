//
//  AuthStatusHeaderCell.m
//  cyy_task
//
//  Created by zhchen on 16/10/18.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AuthStatusHeaderCell.h"

@implementation AuthStatusHeaderCell
- (void)setCell:(id)model
{
    if ([model isKindOfClass:[RealNameModel class]]) {
        RealNameModel *realNameModel = model;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 229)];
        view.backgroundColor = RGBHex(kColorGray207);
        if ([realNameModel.auth_status integerValue] == 2 || [realNameModel.auth_status integerValue] == 3) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((APP_W-127)/2, 27, 127, 137)];
            imageView.image = [UIImage imageNamed:@"pic_nopass"];
            [view addSubview:imageView];
            UILabel *lblshow = [[UILabel alloc] initWithFrame:CGRectMake(15, 186, APP_W-30, 17)];
            lblshow.textColor = RGBHex(kColorAuxiliary102);
            lblshow.font = fontSystem(kFontS28);
            lblshow.textAlignment = NSTextAlignmentCenter;
            [view addSubview:lblshow];
            lblshow.text = @"认证未通过";
            [self addSubview:view];
        }else if ([realNameModel.auth_status integerValue] == 1){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((APP_W-152)/2, 27, 152, 143)];
            imageView.image = [UIImage imageNamed:@"pic_success"];
            [view addSubview:imageView];
            UILabel *lblshow = [[UILabel alloc] initWithFrame:CGRectMake(15, 192, APP_W-30, 17)];
            lblshow.textColor = RGBHex(kColorAuxiliary102);
            lblshow.font = fontSystem(kFontS28);
            lblshow.textAlignment = NSTextAlignmentCenter;
            [view addSubview:lblshow];
            lblshow.text = @"认证成功!";
            [self addSubview:view];
        }else if ([realNameModel.auth_status integerValue] == 0){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((APP_W-261)/2, 27, 261, 122)];
            imageView.image = [UIImage imageNamed:@"pic_waiting"];
            [view addSubview:imageView];
            UILabel *lblshow = [[UILabel alloc] initWithFrame:CGRectMake(15, 192, APP_W-30, 17)];
            lblshow.textColor = RGBHex(kColorAuxiliary102);
            lblshow.font = fontSystem(kFontS28);
            lblshow.textAlignment = NSTextAlignmentCenter;
            lblshow.text = @"等待审核...";
            [view addSubview:lblshow];
            [self addSubview:view];
        }
    }else if ([model isKindOfClass:[CompanyAuthModel class]]){
        CompanyAuthModel *companyAuthModel = model;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 229)];
        view.backgroundColor = RGBHex(kColorGray207);
        if ([companyAuthModel.auth_status integerValue] == 2 || [companyAuthModel.auth_status integerValue] == 3) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((APP_W-127)/2, 27, 127, 137)];
            imageView.image = [UIImage imageNamed:@"pic_nopass"];
            [view addSubview:imageView];
            UILabel *lblshow = [[UILabel alloc] initWithFrame:CGRectMake(15, 186, APP_W-30, 17)];
            lblshow.textColor = RGBHex(kColorAuxiliary102);
            lblshow.font = fontSystem(kFontS28);
            lblshow.textAlignment = NSTextAlignmentCenter;
            [view addSubview:lblshow];
            lblshow.text = @"认证未通过";
            [self addSubview:view];
        }else if ([companyAuthModel.auth_status integerValue] == 1){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((APP_W-152)/2, 27, 152, 143)];
            imageView.image = [UIImage imageNamed:@"pic_success"];
            [view addSubview:imageView];
            UILabel *lblshow = [[UILabel alloc] initWithFrame:CGRectMake(15, 192, APP_W-30, 17)];
            lblshow.textColor = RGBHex(kColorAuxiliary102);
            lblshow.font = fontSystem(kFontS28);
            lblshow.textAlignment = NSTextAlignmentCenter;
            [view addSubview:lblshow];
            lblshow.text = @"认证成功!";
            [self addSubview:view];
        }else if ([companyAuthModel.auth_status integerValue] == 0){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((APP_W-261)/2, 27, 261, 122)];
            imageView.image = [UIImage imageNamed:@"pic_waiting"];
            [view addSubview:imageView];
            UILabel *lblshow = [[UILabel alloc] initWithFrame:CGRectMake(15, 171, APP_W-30, 17)];
            lblshow.textColor = RGBHex(kColorAuxiliary102);
            lblshow.font = fontSystem(kFontS28);
            lblshow.textAlignment = NSTextAlignmentCenter;
            lblshow.text = @"等待审核...";
            [view addSubview:lblshow];
            [self addSubview:view];
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
