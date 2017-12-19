//
//  RegisterWebVC.m
//  CloudBox
//
//  Created by zhchen on 16/1/20.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import "RegisterWebVC.h"

@interface RegisterWebVC ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>
{
    
}
@end

@implementation RegisterWebVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webViewMain = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webViewMain.opaque = NO;
    self.webViewMain.backgroundColor = [UIColor whiteColor];
    self.webViewMain.navigationDelegate = self;
    self.webViewMain.UIDelegate = self;
    self.webViewMain.allowsBackForwardNavigationGestures = YES;
    self.webViewMain.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webViewMain];
    [self.webViewMain addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webViewMain addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0)];
    progressView.tintColor = [UIColor orangeColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    self.progressView.progress = 0.01;
    [self.view insertSubview:self.webViewMain belowSubview:self.progressView];
    NSURL *url;
    
    if (self.registerF == WebTypeRegister) {
        [self naviTitle:@"蓝海创意云用户服务协议"];
        url = [NSURL URLWithString:Msg_RegisterzhCN];
    }else if(self.registerF == WebTypeMessage){
        [self naviTitle:@"消息详情"];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?auth_token=%@&auth_username=%@",Msg_Message,self.msgId,QGLOBAL.auth.vso_token,QGLOBAL.auth.username];
        DLog(@"%@",urlStr);
        url = [NSURL URLWithString:urlStr];
        DLog(@"%@",url);
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webViewMain loadRequest:request];
    
}
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviBackButton];
//    [self naviLeftButtonImage:[UIImage imageNamed:@"fanh"] highlighted:nil action:@selector(leftAction:)];
}

#pragma mark - action
- (IBAction)leftAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *str=request.URL.absoluteString;

    if ([str containsString:@"/user/login"]) {
//        DLog(@">>> web:%@",request);
        [self leftAction:nil];
    }
    return YES;
}
@end
