//
//  ExampleWKWebViewController.h
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseWKWebViewVC.h"

#import "DemoH5API.h"

@interface H5VC : BaseWKWebViewVC
{
    IBOutlet UIView *vTest1,*vTest2;
}

@property (nonatomic, strong) WKWebView* webView2;
@property (nonatomic,strong) WKWebViewJavascriptBridge* bridge2;
@end