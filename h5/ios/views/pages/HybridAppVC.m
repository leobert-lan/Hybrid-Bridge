//
//  HybridAppVC.m
//  H5
//
//  Created by YAN Qingyang on 16/11/25.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "HybridAppVC.h"

@interface HybridAppVC ()

@end

@implementation HybridAppVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 全局界面UI

- (void)WebUIInit{
    [super WebUIInit];
    
    if (self.webViewMain == nil) {
        
        
        //        self.webViewMain = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:vTest1.bounds];
        //        WKWebViewConfiguration *configuretion=[[WKWebViewConfiguration alloc]init];
        //        // Webview的偏好设置
        //        configuretion.preferences = [WKPreferences new];
        //        configuretion.preferences.minimumFontSize = 10;
        //        configuretion.preferences.javaScriptEnabled = true;
        //        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        //        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        //        self.webViewMain = [[WKWebView alloc]initWithFrame:vTest1.bounds configuration:configuretion];
        
        self.webViewMain = [[WKWebView alloc]init];
        self.webViewMain.frame= CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
        self.webViewMain.navigationDelegate = self;
        self.webViewMain.UIDelegate = self;
        [self.view addSubview:self.webViewMain];
    }
    
//    if (self.webView2 == nil) {
//        
//        self.webView2 = [[WKWebView alloc]init];
//        self.webView2.frame=vTest2.bounds;
//        self.webView2.navigationDelegate = self;
//        self.webView2.UIDelegate = self;
//        [vTest2 addSubview:self.webView2];
//        
//    }
    
    //添加监听
//    [WKWebViewJavascriptBridge enableLogging];
//    self.bridge2 = [WKWebViewJavascriptBridge bridgeForWebView:self.webView2];
//    [self listener2:self.bridge2];
    //    [self.bridgeMain callHandler:@"toH5" data:@{ @"auth":@"USER_ID_AND_TOKEN" }];
    
    [self loadH5:self.webViewMain];
//    [self loadExamplePage:self.webView2];
}


- (void)loadH5:(WKWebView*)webView {
    //https://qingyang.sinaapp.com/h5/ExampleApp.html
//
    NSURL *url=[NSURL URLWithString:@"http://m.vsochina.com:8080/req"];
//        NSURL *url=[NSURL URLWithString:@"http://m.vsochina.com:8080/bridge"];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
@end
