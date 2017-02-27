//
//  BaseWKWebViewVC.m
//  H5
//
//  Created by Qingyang on 16/2/5.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "BaseWKWebViewVC.h"

@interface BaseWKWebViewVC ()
{
    //增加两判断，是否可弹框，防止crash
    BOOL didAppear;
    BOOL hadAlert;
}
@end

@implementation BaseWKWebViewVC
#pragma mark web init
- (void)webInit{
    [self WebUIInit];
    
    if (self.bridgeMain) {
        
        return;
    }
    
    
    [WKWebViewJavascriptBridge enableLogging];
    self.bridgeMain = [WKWebViewJavascriptBridge bridgeForWebView:self.webViewMain];
    [self.bridgeMain setWebViewDelegate:self];
    
    //添加监听
    [self listener:self.bridgeMain];
    
}
#pragma mark 显示
- (void)viewWillAppear:(BOOL)animated {
    [self webInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    DLog(@"viewDidLoad");
}

//增加检查，避免页面未显示或消失后，js有alert导致野指针崩溃
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    didAppear=YES;
    DLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    didAppear=NO;
    DLog(@"viewWillDisappear");
}
#pragma mark -


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@">>>web didFailNavigation:%@",error.description);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    DLog(@">>>web didFailProvisionalNavigation:%@",error.description);
}

//ios9 支持
/*! @abstract Invoked when the web view's web content process is terminated.
 @param webView The web view whose underlying web content process was terminated.
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    //占用内存过大导致不显示，需要反复刷新
    DLog(@"!!! 警告:web页面内存占用过多，无法显示，需要reload !!!");
    [webView reload];
}

#pragma mark - WKUIDelegate
//alert弹出框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    DLog(@"--- 1 %@",message);
    /*UIViewController of WKWebView has finish push or present animation*/
    if (didAppear==false || hadAlert) {
        DLog(@"--- false (%i,%i): %@",didAppear,hadAlert,message);
        completionHandler();
        return;
    }
    
    DLog(@"--- 2 alert: %@",message);
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
        hadAlert=NO;
        
    }];
    [alt addAction:ok];


    
    /*UIViewController of WKWebView is visible*/
    if (didAppear && hadAlert==false){
        hadAlert=YES;
        [self presentViewController:alt animated:YES completion:^{
            
        }];
    }
    else {
        DLog(@"--- end (%i,%i): %@",didAppear,hadAlert,message);
        completionHandler();
    }
}

 //Confirm弹出框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    /*UIViewController of WKWebView has finish push or present animation*/
    if (didAppear==false || hadAlert) {
        completionHandler(false);
        return;
    }

    UIAlertController *alt = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(true);
    }];
    [alt addAction:ok];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(false);
    }];
    [alt addAction:cancel];
    
    /*UIViewController of WKWebView is visible*/
    if (didAppear && hadAlert==false){
        hadAlert=YES;
        [self presentViewController:alt animated:YES completion:^{
            
        }];
    }
    else {
        completionHandler(false);
    }
}
//*/
#pragma mark - web UI

- (void)WebUIInit{
    
}


#pragma mark - 添加监听 
- (void)listener:(WKWebViewJavascriptBridge*)bridge{
    /*
    [bridge registerHandler:@"oneClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"H5 调 oneClick: %@",data);
        //回传给H5
        responseCallback(@"回传给H5坐标: 1.2324, 0.42325");
    }];
    */
   
}
@end
