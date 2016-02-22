//
//  BaseWKWebViewVC.h
//  H5
//
//  Created by Qingyang on 16/2/5.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
@interface BaseWKWebViewVC : UIViewController<WKNavigationDelegate,WKUIDelegate>
{
    
}
@property (nonatomic, strong) IBOutlet WKWebView* webViewMain;
@property (nonatomic,strong) WKWebViewJavascriptBridge* bridgeMain;

#pragma mark - web UI
//初始化H5页面
- (void)WebUIInit;

#pragma mark - web init
- (void)webInit;
#pragma mark - 添加监听
- (void)listener:(WKWebViewJavascriptBridge*)bridge;
@end
