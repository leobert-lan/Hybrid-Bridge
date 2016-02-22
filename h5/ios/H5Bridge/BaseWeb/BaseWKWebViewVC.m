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




#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@">>>web didFailNavigation:%@",error.description);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@">>>web didFailProvisionalNavigation:%@",error.description);
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"JS");
//    UIAlertController *alt = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [alt addAction:can];
//    [self presentViewController:alt animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
}
#pragma mark - web UI

- (void)WebUIInit{
    
}
//- (void)callHandler:(id)sender {
//    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
//    [self.bridgeMain callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
//        NSLog(@"testJavascriptHandler responded: %@", response);
//    }];
//}

#pragma mark - 添加监听 
- (void)listener:(WKWebViewJavascriptBridge*)bridge{
    [bridge registerHandler:@"oneClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"H5 调 oneClick: %@",data);
        //回传给H5
        
    }];
    
    [bridge registerHandler:@"GPSCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"H5 调 GPS: %@",data);
        //回传给H5
        responseCallback(@"回传给H5坐标: 1.2324, 0.42325");
    }];
}
@end
