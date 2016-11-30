//
//  CityListCell.m
//  cyy_task
//
//  Created by zhchen on 16/9/2.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "CityListCell.h"

@implementation CityListCell
- (void)setCell:(id)model
{
    if ([model isKindOfClass:[AuthAreaListModel class]]) {
        lblnameL.constant = 15;
        imgDown.hidden = NO;
        cityName.textColor = RGBHex(kColorGray201);
        AuthAreaListModel *obj = model;
        cityName.text = obj.p;
        if (obj.isEx.intValue == 1) {
            imgDown.image = [UIImage imageNamed:@"Submission_drop_top"];
        }else{
            imgDown.image = [UIImage imageNamed:@"Submission_drop_down"];
        }
    }else if ([model isKindOfClass:[AuthCityModel class]]){
        lblnameL.constant = 20;
        imgDown.hidden = NO;
        AuthCityModel *obj = model;
        cityName.textColor = RGBHex(kColorGray201);
        cityName.text = obj.n;
        if (obj.isEx.intValue == 1) {
            imgDown.image = [UIImage imageNamed:@"Submission_drop_top"];
        }else{
            imgDown.image = [UIImage imageNamed:@"Submission_drop_down"];
        }
    }else if ([model isKindOfClass:[AuthCountyModel class]]){
        lblnameL.constant = 25;
        cityName.textColor = RGBHex(kColorGray201);
        imgDown.hidden = YES;
        AuthCountyModel *obj = model;
        cityName.text = obj.s;
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
