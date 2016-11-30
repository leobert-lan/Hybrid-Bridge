//
//  ProtocolVC.h
//  cyy_task
//
//  Created by zhchen on 16/9/1.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseViewController.h"

@interface ProtocolVC : BaseViewController
@property(nonatomic,copy)NSString *protocolType;
@property(nonatomic,copy)NSString *taskbn;
@property (nonatomic, strong) WKWebView* webViewMain;
@property (nonatomic,strong) UIProgressView *progressView;
@end
