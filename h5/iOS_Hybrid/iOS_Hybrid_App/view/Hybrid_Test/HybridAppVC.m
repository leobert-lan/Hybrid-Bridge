//
//  HybridAppVC.m
//  H5
//
//  Created by YAN Qingyang on 16/11/25.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "HybridAppVC.h"

@interface HybridAppVC ()
{
    WVJBResponseCallback webLoginCallback;
}
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

#pragma mark - 添加监听
- (void)listener:(WKWebViewJavascriptBridge*)bridge{
    [super listener:bridge];
    
    //auth监听
    [WebAuthAPI AuthInfoListener:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        DLog(@"H5 %@-调 AuthListener: %@",bridge,data);
        //回传给H5
        NSMutableDictionary *dd=[NSMutableDictionary new];
        dd[@"ret"]=@"0";
        dd[@"msg"]=@"";
        dd[@"status"]=@"1";
        
        NSMutableDictionary *dd2=[[NSMutableDictionary alloc]init];
        if (!StrIsEmpty(QGLOBAL.auth.vso_token) && !StrIsEmpty(QGLOBAL.auth.username)){
            dd2[@"auth_token"]=StrFromObj(QGLOBAL.auth.vso_token);
            dd2[@"auth_username"]=StrFromObj(QGLOBAL.auth.username);
        }
        else {
            dd[@"status"]=@"0";
        }
            
        
        dd[@"data"]=dd2;
        responseCallback([QGLOBAL toJSONStr:dd]);
//        responseCallback(dd);
//
//        //同时传个值给第二个H5页面
        
//
//        [DemoH5API demoCall:self.bridge2 data:dd callback:^(id bridge, id data, NetError *err) {
//            DLog(@">>>%@: %@",bridge, data);
//        }];
        
    }];
    
    //login监听
    [WebAuthAPI LoginListener:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        DLog(@"H5 %@-调 LoginListener: %@",bridge,webLoginCallback);
        webLoginCallback=responseCallback;
        DLog(@"H5 %@-调 LoginListener: %@",bridge,webLoginCallback);
        
        if (![QGLOBAL hadAuthToken]){
            loginVC *vc=[QGLOBAL viewControllerName:@"loginVC" storyboardName:@"login"];
            vc.delegate=self;
            vc.backButtonEnabled=YES;
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
            
            [self presentViewController:nav animated:YES completion:^{
                //
            }];
           
            
            return;
        }
        else {
            [self webLoginCallBack];
        }
        
    }];
    /*
    [QRCodeH5API openCameraListener:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        //扫描二维码
        SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
        qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
            //self.saomiaoLabel.text = qrString;
            
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
            responseCallback(qrString);
        };
        qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
            //self.saomiaoLabel.text = @"fail~";
            responseCallback(@"fail~");
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
        };
        qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
            //responseCallback(@"cancle~");
            //self.saomiaoLabel.text = @"cancle~";
        };
        [self presentViewController:qrcodevc animated:YES completion:nil];
    }];
    // GPS
    [GPSH5API OpenGpsListener:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        
        // 2,设置代理
        self.manager.delegate = self;
        // 3,请求获取位置
        // 一直请求
        [self.manager requestAlwaysAuthorization];
        // 4,启动定位
        [self.manager startUpdatingLocation];
        
        self.opengps = ^(CLLocation *location,NSString *name){
            NSString *gps = [NSString stringWithFormat:@"经度:%f,纬度:%f,街道:%@",location.coordinate.longitude,location.coordinate.latitude,name];
            responseCallback(gps);
        };
        
    }];
    
    // qqLogin
    [ThirdpartyLoginAPI thirdPartyLoginListener:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                responseCallback(snsAccount.accessToken);
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
            }});
        
    }];
    
    [ThirdpartyLoginAPI thirdPartyLoginListenerSina:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                responseCallback(snsAccount.accessToken);
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
            }});
    }];
    
    [ThirdpartyLoginAPI thirdPartyLoginListenerWeixin:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                
                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                
            }
            
        });
    }];
    
    [ThirdpartyLoginAPI thirdPartyShareListenerSina:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sinaweibo://"]]) {
            DLog(@"aaaa");
        }
        [[UMSocialControllerService defaultControllerService] setShareText:@"分享内嵌文字" shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:self];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }];
    
    [ThirdpartyLoginAPI thirdPartyShareListenerWeixin:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字" image:@"toux" location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }];
    
    [ThirdpartyLoginAPI thirdPartyShareListenerQQ:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        //        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"www.baidu.com" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        //            if (response.responseCode == UMSResponseCodeSuccess) {
        //                NSLog(@"分享成功！");
        //            }
        //        }];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
            [UMSocialData defaultData].extConfig.qzoneData.url = @"http://baidu.com";
        }];
    }];
    */
}

#pragma mark - loginVCDelegate
- (void)loginVCDelegate:(id)delegate auth:(AuthModel*)auth{
    [self webLoginCallBack];
}

- (void)webLoginCallBack{
    if (webLoginCallback!=nil && ![QGLOBAL hadAuthToken]) {
        //回传给H5
        NSMutableDictionary *dd=[NSMutableDictionary new];
        dd[@"ret"]=@"0";
        dd[@"msg"]=@"";
        dd[@"status"]=@"1";
        
//        NSMutableDictionary *dd2=[[NSMutableDictionary alloc]init];
//        if (!StrIsEmpty(QGLOBAL.auth.vso_token) && !StrIsEmpty(QGLOBAL.auth.username)){
//            dd2[@"auth_token"]=StrFromObj(QGLOBAL.auth.vso_token);
//            dd2[@"auth_username"]=StrFromObj(QGLOBAL.auth.username);
//        }
//        else {
//            dd[@"status"]=@"0";
//        }
        
        
        dd[@"data"]=[QGLOBAL.auth toDictionary];
        webLoginCallback([QGLOBAL toJSONStr:dd]);
    }
    webLoginCallback=nil;
}
@end
