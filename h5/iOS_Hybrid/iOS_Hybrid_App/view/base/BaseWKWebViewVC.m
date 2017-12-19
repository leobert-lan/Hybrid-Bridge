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
    //必须加，获取WKNavigationDelegate回调
    [self.bridgeMain setWebViewDelegate:self];
    
    //添加监听
    [self listener:self.bridgeMain];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self webInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (void)loadHybridWeb:(WKWebView*)webView {
//    NSURL *url=[NSURL URLWithString:@"http://m.vsochina.com:8080/bridge/test/"];
//    
//    
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    DLog(@">>>web didFailNavigation:%@",error.description);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    DLog(@">>>web didFailProvisionalNavigation:%@",error.description);
    [self checkErrorUserInfo:error];
}

#pragma mark - check userinfo
- (void)checkErrorUserInfo:(NSError*)error{
    NSDictionary *userinfo=error.userInfo;
    NSString *strUrl=[userinfo objectForKey:NSURLErrorFailingURLStringErrorKey];
    DLog(@">>> %@",strUrl);
    
    NSString* prefix = nil;
    
    NSString *call=@"tel:";
    prefix = [strUrl substringWithRange:NSMakeRange(0,call.length)];
    if([prefix isEqualToString:call]){
        NSString *ttl=[NSString stringWithFormat:@"是否拨打 %@?",[strUrl substringWithRange:NSMakeRange(call.length,strUrl.length-call.length)]];
        
        UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:ttl preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *can = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strUrl]]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alt addAction:can];
        [alt addAction:cancel];
        [self presentViewController:alt animated:YES completion:nil];
        return;
    }
    
    call=@"mailto:";
    prefix = [strUrl substringWithRange:NSMakeRange(0,call.length)];
    if([prefix isEqualToString:call]){
        NSString *ttl=[NSString stringWithFormat:@"是否发送邮件到 %@?",[strUrl substringWithRange:NSMakeRange(call.length,strUrl.length-call.length)]];
        
        UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:ttl preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *can = [UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strUrl]]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alt addAction:can];
        [alt addAction:cancel];
        [self presentViewController:alt animated:YES completion:nil];
        return;
    }
    
    call=@"sms:";
    prefix = [strUrl substringWithRange:NSMakeRange(0,call.length)];
    if([prefix isEqualToString:call]){
        NSString *ttl=[NSString stringWithFormat:@"是否发送短信到 %@?",[strUrl substringWithRange:NSMakeRange(call.length,strUrl.length-call.length)]];
        
        UIAlertController *alt = [UIAlertController alertControllerWithTitle:nil message:ttl preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *can = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strUrl]]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alt addAction:can];
        [alt addAction:cancel];
        [self presentViewController:alt animated:YES completion:nil];
        return;
    }
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
