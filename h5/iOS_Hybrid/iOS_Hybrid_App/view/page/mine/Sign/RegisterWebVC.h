//
//  RegisterWebVC.h
//  CloudBox
//
//  Created by zhchen on 16/1/20.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, WebType) {
    WebTypeRegister = 0,
    WebTypeMessage = 1,
    WebTypeagreement
};

@interface RegisterWebVC : BaseViewController
@property(nonatomic,assign)NSInteger registerF;
@property(nonatomic,copy)NSString *msgId;
@property (nonatomic, strong) WKWebView* webViewMain;
@property (nonatomic,strong) UIProgressView *progressView;
@end
