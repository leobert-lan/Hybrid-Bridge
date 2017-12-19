//
//  loginVC.h
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"

@protocol loginVCDelegate <NSObject>
@optional
- (void)loginVCDelegate:(id)delegate auth:(AuthModel*)auth;

@end

@interface loginVC : BaseViewController
@property (assign) BOOL canJump;
@property(nonatomic,copy)NSString *loginType;
@end
