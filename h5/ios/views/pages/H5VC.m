//
//  ExampleWKWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "H5VC.h"
#import <CoreLocation/CoreLocation.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
typedef void(^openGps)(CLLocation *location,NSString *name);
@interface H5VC ()<CLLocationManagerDelegate,UMSocialUIDelegate>
{
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
}
/**
 *  1,定义定位管理者属性
 */
@property(nonatomic,strong)CLLocationManager *manager;
/**
 *  地理编码
 */
@property(nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,copy)openGps opengps;
@property(nonatomic,strong)CLLocation *location;
@end

@implementation H5VC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    [self webFrame];
}

#pragma mark - 全局界面UI

- (void)WebUIInit{
    [super WebUIInit];
    
    if (self.webViewMain == nil) {

        
//        self.webViewMain = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:vTest1.bounds];
//        WKWebViewConfiguration *configuretion=[[WKWebViewConfiguration alloc]init];
//        // Webview的偏好设置
//        configuretion.preferences = [WKPreferences new];
//        configuretion.preferences.minimumFontSize = 10;
//        configuretion.preferences.javaScriptEnabled = true;
//        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
//        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = YES;
//        self.webViewMain = [[WKWebView alloc]initWithFrame:vTest1.bounds configuration:configuretion];
    
        self.webViewMain = [[WKWebView alloc]init];
        self.webViewMain.frame= CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
        self.webViewMain.navigationDelegate = self;
        self.webViewMain.UIDelegate = self;
        [vTest1 addSubview:self.webViewMain];
    }
    
    if (self.webView2 == nil) {
        
        self.webView2 = [[WKWebView alloc]init];
        self.webView2.frame=vTest2.bounds;
        self.webView2.navigationDelegate = self;
        self.webView2.UIDelegate = self;
        [vTest2 addSubview:self.webView2];
        
    }
    
    //添加监听
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge2 = [WKWebViewJavascriptBridge bridgeForWebView:self.webView2];
    [self listener2:self.bridge2];
//    [self.bridgeMain callHandler:@"toH5" data:@{ @"auth":@"USER_ID_AND_TOKEN" }];
    
    [self loadExamplePage:self.webViewMain];
    [self loadExamplePage:self.webView2];
}
#pragma mark - 设置页面frame
- (void)webFrame{
    self.webViewMain.frame = self.view.bounds;
//    self.webViewMain.y=kNavibarH;
//    self.webViewMain.height-=kNavibarH;
    //    DLog(@"webFrame %f-%f:%@",APP_H,SCREEN_H,NSStringFromCGRect(self.view.bounds));
}
- (void)reload {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:self.webViewMain action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadButton ];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (IBAction)sendAction:(id)sender {
    //调H5方法
    NSMutableDictionary *dd=[NSMutableDictionary new];
    dd[@"ret"]=@"200";
    dd[@"msg"]=@"it works okey";
    dd[@"data"]=[NSDictionary dictionaryWithObjectsAndKeys:@"value",@"key1", nil];

    [DemoH5API demoCall:self.bridgeMain data:dd callback:^(id bridge, id data, NetError *err) {
        DLog(@">>>%@: %@",bridge, data);
    }];
    

}



- (void)loadExamplePage:(WKWebView*)webView {
//    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
//    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    //https://qingyang.sinaapp.com/h5/ExampleApp.html
    NSURL *url=[NSURL URLWithString:@"https://m.vsochina.com/maker/module/test.html"];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - 添加监听
- (void)listener:(WKWebViewJavascriptBridge*)bridge{
    [super listener:bridge];
    
    //demo监听
    [DemoH5API demoListener:bridge handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        DLog(@"H5 %@-调 NATIVE_FUNCTION_DEMO: %@",bridge,data);
        //回传给H5
        responseCallback(@"nv监听回传给H5 data");
        
        //同时传个值给第二个H5页面
        NSMutableDictionary *dd=[NSMutableDictionary new];
        dd[@"ret"]=@"200";
        dd[@"msg"]=@"这是第一个H5的内容";
        dd[@"data"]=data;
       
//        [DemoH5API demoCall:self.bridge2 data:dd callback:^(id bridge, id data, NetError *err) {
//            DLog(@">>>%@: %@",bridge, data);
//        }];

    }];
    
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
    
}


#pragma mark - 定位
- (CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        
        // 设置 间隔之后重新定位
        _manager.distanceFilter = 10;
        // 定位的精确度
        _manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    return _manager;
}
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)listener2:(WKWebViewJavascriptBridge*)bridge{
    [super listener:bridge];
    
    [QRCodeH5API openCameraListener:self.bridge2 handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
//        QRCodeVC *vc = [[QRCodeVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        
        //扫描二维码
        SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
        qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
            //self.saomiaoLabel.text = qrString;
            responseCallback(qrString);
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
        };
        qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
            //self.saomiaoLabel.text = @"fail~";
            responseCallback(@"fail~");
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
        };
        qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
            responseCallback(@"cancle~");
            //self.saomiaoLabel.text = @"cancle~";
        };
        [self presentViewController:qrcodevc animated:YES completion:nil];
    }];
    
    [GPSH5API OpenGpsListener:self.bridge2 handler:^(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback) {
        
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
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    self.location = locations.firstObject;
    [self.geocoder reverseGeocodeLocation:self.                                                                                                                                                                                                                                                    location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = placemarks.firstObject;
        if (self.opengps) {
            self.opengps(self.location,place.thoroughfare);
        }
        NSLog(@"%@",place.thoroughfare);
    }];
    
    
    // 停止定位
    [self.manager stopUpdatingLocation];
}
//处理定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"定位失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:ok];
    [self presentViewController:alt animated:YES completion:nil];
    if(error.code == kCLErrorLocationUnknown)
    {
        
        NSLog(@"Currently unable to retrieve location.");
    }
    else if(error.code == kCLErrorNetwork)
    {
        NSLog(@"Network used to retrieve location is unavailable.");
    }
    else if(error.code == kCLErrorDenied)
    {
        NSLog(@"Permission to retrieve location is denied.");
        [self.manager stopUpdatingLocation];
        self.manager = nil;
    }
}

@end
