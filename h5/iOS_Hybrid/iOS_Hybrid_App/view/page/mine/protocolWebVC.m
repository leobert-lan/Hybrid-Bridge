//
//  protocolWebVC.m
//  cyy_task
//
//  Created by zhchen on 16/7/7.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "protocolWebVC.h"

@interface protocolWebVC ()<UIWebViewDelegate>
{
    IBOutlet UIWebView *protocolWeb;
    IBOutlet UIActivityIndicatorView *protocolAct;
    NSURL *url;
}
@end

@implementation protocolWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    protocolWeb.delegate = self;
    [self naviTitle:@"用户协议"];
    url = [[NSBundle mainBundle] URLForResource:nil withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [protocolWeb loadRequest:request];
    // Do any additional setup after loading the view.
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
/**
 *  网页加载时开始使用
 *
 *  @param webView <#webView description#>
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [protocolAct startAnimating];
}
/**
 *  网页加载完成时使用
 *
 *  @param webView <#webView description#>
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [protocolAct stopAnimating];
    [protocolAct removeFromSuperview];
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
