//
//  ExampleWKWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "H5VC.h"


@interface H5VC ()



@end

@implementation H5VC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    
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
        self.webViewMain.frame=vTest1.bounds;
        self.webViewMain.navigationDelegate = self;
        self.webViewMain.UIDelegate = self;
        [vTest1 addSubview:self.webViewMain];
    }
    
    if (self.webView2 == nil) {
        
        self.webView2 = [[WKWebView alloc]init];
        self.webView2.frame=vTest2.bounds;
        self.webView2.navigationDelegate = self;
        self.webView2.UIDelegate = self;
        [vTest2 addSubview:self.webView2];
    }
    
    //添加监听
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge2 = [WKWebViewJavascriptBridge bridgeForWebView:self.webView2];
    [self listener2:self.bridge2];
//    [self.bridgeMain callHandler:@"toH5" data:@{ @"auth":@"USER_ID_AND_TOKEN" }];
    
    [self loadExamplePage:self.webViewMain];
    [self loadExamplePage:self.webView2];
}

- (void)reload {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:self.webViewMain action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadButton ];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (IBAction)sendAction:(id)sender {
    //调H5方法
//    id data = @{ @"ret":@"200",@"key1": @"严庆扬.数据内容" };
    NSMutableDictionary *dd=[NSMutableDictionary new];
    dd[@"ret"]=@"200";
    dd[@"msg"]=@"it works okey";
    dd[@"data"]=[NSDictionary dictionaryWithObjectsAndKeys:@"value",@"key1", nil];
    NSString *key=@"JS_FUNCTION_DEMO";
    [self.bridgeMain callHandler:key data:dd responseCallback:^(id response) {
        DLog(@">>>%@: %@",key, response);
    }];
    
//    [self send2Action:nil];
}


- (void)loadExamplePage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    //https://qingyang.sinaapp.com/h5/ExampleApp.html
//    NSURL *url=[NSURL URLWithString:@"https://qingyang.sinaapp.com/h5/ExampleApp.html"];
//    
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
}

#pragma mark - 添加监听
- (void)listener:(WKWebViewJavascriptBridge*)bridge{
    [super listener:bridge];
    
    //demo监听
    [bridge registerHandler:@"NATIVE_FUNCTION_DEMO" handler:^(id data, WVJBResponseCallback responseCallback) {
        DLog(@"H5 调 NATIVE_FUNCTION_DEMO: %@",data);
        //回传给H5
        responseCallback(@"nv监听回传给H5 data");
        
        //同时传个值给第二个H5页面
        NSMutableDictionary *dd=[NSMutableDictionary new];
        dd[@"ret"]=@"200";
        dd[@"msg"]=@"这是第一个H5的内容";
        dd[@"data"]=data;
        NSString *key=@"JS_FUNCTION_DEMO";
        [self.bridge2 callHandler:key data:dd responseCallback:^(id response) {
            DLog(@">>>%@: %@",key, response);
        }];
    }];
    
    [bridge registerHandler:@"NATIVE_FUNCTION_OPENGPS" handler:^(id data, WVJBResponseCallback responseCallback) {
        //调取GPS
//        AsyncBegin
//        //
//        
//        AsyncEnd
        DLog(@"H5 调 GPS: %@",data);
        //回传给H5
        responseCallback(@"回传给H5坐标: 1.2324, 0.42325");
    }];
}

- (void)listener2:(WKWebViewJavascriptBridge*)bridge{
    [super listener:bridge];
    
    //demo监听
    [bridge registerHandler:@"NATIVE_FUNCTION_DEMO" handler:^(id data, WVJBResponseCallback responseCallback) {
        DLog(@"H5 调 NATIVE_FUNCTION_DEMO: %@",data);
        //回传给H5
        responseCallback(@"nv监听回传给H5 data");
    }];
    
    [bridge registerHandler:@"NATIVE_FUNCTION_OPENGPS" handler:^(id data, WVJBResponseCallback responseCallback) {
        //调取GPS
        //        AsyncBegin
        //        //
        //
        //        AsyncEnd
        DLog(@"H5 调 GPS: %@",data);
        //回传给H5
        responseCallback(@"回传给H5坐标: 1.2324, 0.42325");
    }];
}

@end
