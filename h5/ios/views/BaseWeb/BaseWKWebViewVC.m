//
//  BaseWKWebViewVC.m
//  H5
//
//  Created by Qingyang on 16/2/5.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "BaseWKWebViewVC.h"

@interface BaseWKWebViewVC ()

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
    
    //添加监听
    [self listener:self.bridgeMain];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self webInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}




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

#pragma mark - WKUIDelegate
//alert弹出框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alt addAction:ok];
    [self presentViewController:alt animated:YES completion:nil];
    
}

///
 //Confirm弹出框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(true);
    }];
    [alt addAction:ok];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(false);
    }];
    [alt addAction:cancel];
    [self presentViewController:alt animated:YES completion:nil];
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
