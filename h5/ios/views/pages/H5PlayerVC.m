//
//  H5PlayerVC.m
//  H5
//
//  Created by zhchen on 16/3/9.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "H5PlayerVC.h"
@interface H5PlayerVC ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>

@end

@implementation H5PlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"video"];
    
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"123" message:@"abv" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alt addAction:ok];
    [self presentViewController:alt animated:YES completion:nil];
    
    UIAlertController *alt2 = [UIAlertController alertControllerWithTitle:@"345" message:@"zxc" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alt2 addAction:ok2];
    [self presentViewController:alt2 animated:YES completion:nil];
}


- (void)WebUIInit
{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.webViewMain == nil) {
        
        self.webViewMain = [[WKWebView alloc] initWithFrame:self.view.bounds];
        self.webViewMain.navigationDelegate = self;
        self.webViewMain.UIDelegate = self;
        self.webViewMain.allowsBackForwardNavigationGestures = YES;
        self.webViewMain.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.webViewMain];
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        progressView.tintColor = [UIColor orangeColor];
        progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:progressView];
        self.progressView = progressView;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(100, 100, 100, 100);
        button.backgroundColor = [UIColor redColor];
        [self.webViewMain addSubview:button];
        [button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.webViewMain loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://172.16.7.140/MediaTest/test/test.html"]]];
        [self.view insertSubview:self.webViewMain belowSubview:self.progressView];
        
        
    }
    
    [self.webViewMain addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webViewMain addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)ButtonAction:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }else{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
                SEL selector = NSSelectorFromString(@"setOrientation:");
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:[UIDevice currentDevice]];
                int val = UIInterfaceOrientationPortrait;
                [invocation setArgument:&val atIndex:2];
                [invocation invoke];
            }
    }
    //[self preferredInterfaceOrientationForPresentation];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"start");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"finish");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.webViewMain && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutorotate
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
