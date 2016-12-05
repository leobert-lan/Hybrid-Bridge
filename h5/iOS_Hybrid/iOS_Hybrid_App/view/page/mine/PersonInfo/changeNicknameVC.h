//
//  changeNicknameVC.h
//  cyy_task
//
//  Created by zhchen on 16/7/5.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ChangeNicknameBlock)(NSString *nickname);
@interface changeNicknameVC : BaseViewController
@property (nonatomic,copy)NSString *nickname;

@property (nonatomic,copy)ChangeNicknameBlock changeNickname;
@end
