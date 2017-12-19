//
//  ProtocolVC.m
//  cyy_task
//
//  Created by zhchen on 16/9/1.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "ProtocolVC.h"
#import "TaskAPI.h"
#import "RegisterWebVC.h"
@interface ProtocolVC ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>
{
    IBOutlet UIView *vBottom,*vReward,*vBid;
    IBOutlet UIButton *btnOkR,*btnOkB,*btnNo;
    IBOutlet UIView *vWeb;
    IBOutlet UIButton *btnAgree;
    int protocoltype;
//    IBOutlet UIWebView *protocolWeb;
//    IBOutlet UIActivityIndicatorView *protocolAct;
}
@end

@implementation ProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webViewMain = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, APP_W, APP_H-174)];
    self.webViewMain.opaque = NO;
    self.webViewMain.backgroundColor = [UIColor whiteColor];
    self.webViewMain.navigationDelegate = self;
    self.webViewMain.UIDelegate = self;
    self.webViewMain.allowsBackForwardNavigationGestures = YES;
//    self.webViewMain.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [vWeb addSubview:self.webViewMain];
    [self.webViewMain addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webViewMain addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0)];
    progressView.tintColor = [UIColor orangeColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [vWeb addSubview:progressView];
    self.progressView = progressView;
    self.progressView.progress = 0.01;
    [vWeb insertSubview:self.webViewMain belowSubview:self.progressView];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@&auth_token=%@&auth_username=%@",Msg_Subbmision,self.taskbn,QGLOBAL.auth.vso_token,QGLOBAL.auth.username];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webViewMain loadRequest:request];
    if ([self.protocolType intValue] == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 60)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        btn.backgroundColor = RGBHex(kColorMain001);
        [btn setTitle:@" 确认签署" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
        [btn setTitleColor:RGBHex(kColorW) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnOkAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [vBottom addSubview:view];
        
    }else if ([self.protocolType intValue] == 2){
        btnOkB.backgroundColor = RGBHex(kColorMain001);
        btnNo.backgroundColor = RGBHex(kColorW);
        [btnNo setTitleColor:RGBHex(kColorMain001) forState:UIControlStateNormal];
        vBid.frame = CGRectMake(0, 0, APP_W, 60);
        [vBottom addSubview:vBid];
    }
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - UI
- (void)UIGlobal
{
    [super UIGlobal];
    [self naviTitle:@"蓝海创意云交付协议"];
    
//    [self naviLeftButtonImage:[UIImage imageNamed:@"fanh"] highlighted:nil action:@selector(leftAction:)];
}

#pragma mark - action
- (IBAction)leftAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnProtocolAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        protocoltype = 1;
        [btnAgree setImage:[UIImage imageNamed:@"Check2"] forState:UIControlStateNormal];
        
    }else{
        protocoltype = 0;
        [btnAgree setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnOkAction:(id)sender {
    if (protocoltype == 0) {
        [self showText:Msg_ProtocolAgree];
    }else{
    [TaskAPI ProtocolTaskbn:self.taskbn flagAgree:true success:^(id model) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self popVCAction:nil];
    } failure:^(NetError *err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
        [self showText:err.errMessage];
    }];
    }
}
- (IBAction)btnNoAction:(id)sender {
    [TaskAPI ProtocolTaskbn:self.taskbn flagAgree:false success:^(id model) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self popVCAction:nil];
    } failure:^(NetError *err) {
        DLog(@"~~~refreshList err:%li ---",(long)err.errStatusCode);
        [self didLoad];
        
        [self showText:err.errMessage];
    }];
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
