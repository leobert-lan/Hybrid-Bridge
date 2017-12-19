//
//  ThirdLoginVC.h
//  Chuangyiyun
//
//  Created by zhchen on 16/6/30.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"
#import "SubscripNewVC.h"
@interface ThirdLoginVC : BaseViewController
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *openid;
@property(nonatomic,copy)NSString *via;
@property(nonatomic,strong)AuthModel *authModel;
@end
