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

        
        self.webViewMain = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:vTest1.bounds];
        self.webViewMain.navigationDelegate = self;
//        self.webViewMain.UIDelegate = self;
        [vTest1 addSubview:self.webViewMain];
    }
    
    
    
//    [self.bridgeMain callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    [self loadExamplePage:self.webViewMain];
    
    [self renderButtons];
}

- (void)renderButtons {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callbackButton];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:self.webViewMain action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadButton ];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)sendAction:(id)sender {
    //调H5方法
    id data = @{ @"key1": @"严庆扬.数据内容" };
    NSString *key=@"JF_DEMO";
    [self.bridgeMain callHandler:key data:data responseCallback:^(id response) {
        NSLog(@">>>%@: %@",key, response);
    }];
    
//    [self send2Action:nil];
}

- (void)send2Action:(id)sender {
    id data = @{ @"user": @"严庆扬" };
    NSString *key=@"authH5Handler";
    [self.bridgeMain callHandler:key data:data responseCallback:^(id response) {
        NSLog(@">>>%@: %@",key, response);
    }];
}

- (void)loadExamplePage:(WKWebView*)webView {
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
//    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp"
//                                                          ofType:@"html"];
//    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    [webView loadHTMLString:htmlCont baseURL:baseURL];
    
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
    
    [bridge registerHandler:@"NF_DEMO" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"H5 调 NF_DEMO: %@",data);
        //回传给H5
        responseCallback(@"nv监听回传给H5 data");
    }];
    
    [bridge registerHandler:@"GPSCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"H5 调 GPS: %@",data);
        //回传给H5
        responseCallback(@"回传给H5坐标: 1.2324, 0.42325");
    }];
}
@end
