//
//  UserModel.m
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@end
@implementation AuthModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"])
        self.userid = value;
}
@end
@implementation GuideModel

@end
@implementation PersonalInfoModel

@end
@implementation MyConcernModel

@end
@implementation IndusModel

@end
@implementation RealNameModelDB
+ (NSString *)getPrimaryKey{
    return @"username";
}
@end
@implementation RealNameModel

@end
@implementation CompanyAuthModelDB

@end
@implementation CompanyAuthModel

@end
@implementation SysMessagesModel

@end
@implementation MessageModel

@end
@implementation MessageSysModel

@end
@implementation MessageInformModel

@end

@implementation AuthAreaListModel

@end
@implementation AuthCityModel

@end
@implementation AuthCountyModel

@end