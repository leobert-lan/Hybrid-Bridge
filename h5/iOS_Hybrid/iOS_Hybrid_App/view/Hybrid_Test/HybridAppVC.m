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
- (void)UIGlobal{
    [super UIGlobal];
    
    self.view.backgroundColor=RGBHex(kColorAuxiliary101);
}

- (void)WebUIInit{
    [super WebUIInit];
    
    if (self.webViewMain == nil) {
        self.webViewMain = [[WKWebView alloc]init];
        self.webViewMain.frame= CGRectMake(5, 5, APP_W-10, self.view.height - 10);
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
