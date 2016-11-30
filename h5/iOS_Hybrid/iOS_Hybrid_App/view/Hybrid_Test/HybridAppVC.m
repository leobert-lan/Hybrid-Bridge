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
    
    [self loadH5:self.webViewMain];

}


- (void)loadH5:(WKWebView*)webView {
    NSURL *url=[NSURL URLWithString:@"http://m.vsochina.com:8080/bridge/test/"];

    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
@end
