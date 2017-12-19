//
//  BannersVC.m
//  cyy_task
//
//  Created by Qingyang on 16/8/17.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BannersVC.h"

@interface BannersVC ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>

@end

@implementation BannersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)WebUIInit
{
   
    if (self.webViewMain == nil) {
        
        self.webViewMain = [[WKWebView alloc] initWithFrame:self.view.bounds];
        self.webViewMain.opaque = NO;
        //        self.webViewMain.backgroundColor = [UIColor blackColor];
        
        self.webViewMain.allowsBackForwardNavigationGestures = YES;
        //        self.webViewMain.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.webViewMain];
        
        
    }
    [self.webViewMain addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webViewMain addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0)];
    progressView.tintColor = [UIColor orangeColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    self.progressView.progress = 0.01;
    [self.view insertSubview:self.webViewMain belowSubview:self.progressView];
    self.webViewMain.navigationDelegate = self;
    self.webViewMain.UIDelegate = self;
//    
//    self.title=StrFromObj(mm.title);
    [self.webViewMain loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:StrFromObj(_link)]]];
    [self showLoading];
}

#pragma mark - WkWebView代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    DLog(@">>>>>>start");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    DLog(@">>>>>>finish");
    [self didLoad];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DLog(@">>>>>>%@",error);
    [self didLoad];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [self didLoad];
}
#pragma mark - 进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.webViewMain && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress+0.01 animated:YES];
        }
    }
}
- (void)dealloc {
    [self.webViewMain removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webViewMain removeObserver:self forKeyPath:@"title"];
    // if you have set either WKWebView delegate also set these to nil here
    [self.webViewMain setNavigationDelegate:nil];
    [self.webViewMain setUIDelegate:nil];
}
@end
