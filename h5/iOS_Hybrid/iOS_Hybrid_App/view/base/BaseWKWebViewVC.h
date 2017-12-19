//
//  BaseWKWebViewVC.h
//  H5
//
//  Created by Qingyang on 16/2/5.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
//#import "H5Constant.h"
#import "WKWebViewJavascriptBridge.h"
#import "BaseViewController.h"

@interface BaseWKWebViewVC : BaseViewController<WKNavigationDelegate,WKUIDelegate>
{
    
}
@property (nonatomic, strong) WKWebView* webViewMain;
@property (nonatomic, strong) WKWebViewJavascriptBridge* bridgeMain;

#pragma mark - web UI
//初始化H5页面
- (void)WebUIInit;
//载入页面
- (void)loadHybridWeb:(WKWebView*)webView;
#pragma mark - web init
- (void)webInit;
#pragma mark - 添加监听
- (void)listener:(WKWebViewJavascriptBridge*)bridge;
@end
