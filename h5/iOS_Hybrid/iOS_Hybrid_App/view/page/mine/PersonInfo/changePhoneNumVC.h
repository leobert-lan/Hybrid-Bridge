//
//  changePhoneNumVC.h
//  cyy_task
//
//  Created by zhchen on 16/7/6.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ChangePhoneNumBlock)(NSString *phoneNum);
@interface changePhoneNumVC : BaseViewController
@property (nonatomic,strong)NSString *phoneNum;
@property(nonatomic,copy)ChangePhoneNumBlock changePhoneNumBlock;
@end
