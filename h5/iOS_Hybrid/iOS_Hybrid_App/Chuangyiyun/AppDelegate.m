//
//  AppDelegate.m
//  Chuangyiyun
//
//  Created by Qingyang on 16/5/4.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "QYSlideslipB.h"
#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self checkStatus];
    [self initDBData];
    
    //统计
//    [self initStatistic];
    
    //网络
    [self networkingInit];
    
    //设置推送通知,需要用户允许
    [self registJPush:launchOptions];
    
    [UMSocialData setAppKey:kUMengKey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxf7accfde133e4669" appSecret:@"1c4ea139abb5fe40d2256961ff34024d" url:@"www.vsochina.com"];
    [UMSocialQQHandler setQQWithAppId:@"1105220998" appKey:@"dQYBGvNAUEcCdcAB" url:@"www.vsochina.com"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"906437742"
                                              secret:@"60f387d9a090ce1da76ca335e346c01d"
                                         RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
    //判断是不是点击推送唤起的app
    [self checkOpenAppStyle:launchOptions];
    
    DLog(@"***** cache path:%@",[FileManager getCachePath]);
    return YES;
}


- (void)registJPush:(NSDictionary *)launchOptions {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil

    }
    
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:kJPUSHKey
                          channel:kAppChannel //统计渠道
                 apsForProduction:kIsPushProduction //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
            advertisingIdentifier:nil];//不用广告为空
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 程序进入前台
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 程序重新激活，比如锁屏
    [QGLOBAL postNotif:NotifAppDidBecomeActive data:nil object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark  导航栏
/**
 *  初始化导航栏样式
 */
- (void)initNavigationBarStyle
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //背景色
    [[UINavigationBar appearance] setBarTintColor:RGBHex(kColorMain001)];
    //左右按钮文字颜色
    [[UINavigationBar appearance] setTintColor:RGBHex(kColorW)];
    //标题色
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:RGBHex(kColorW)}];
    
    //把分割线设同色
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[RGBHex(kColorMain001) CGColor]);
    CGContextFillRect(context, rect);
    UIImage * imge = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}
- (void)test{
    _nav=nil;
    _nav=[[UINavigationController alloc]initWithRootViewController:[QGLOBAL viewControllerName:@"ViewController" storyboardName:@"Main"]];
//    _nav.navigationBarHidden=YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = _nav;
}

#pragma mark - 初始化
- (void)initStatistic{
    //iOS平台数据发送策略包括BATCH（启动时发送）和SEND_INTERVAL（按间隔发送）两种
    [MobClick setAppVersion:VERSION];
    [MobClick startWithAppkey:kUMengKey reportPolicy:BATCH channelId:kAppChannel];
    
}

- (void)initDBData{
    [OtherAPI getIndustryList:YES success:^(NSMutableArray *arr) {

    } failure:^(NetError *err) {
        //
    }];
}

#pragma mark  网络
- (void)networkingInit{
    [QGLOBAL checkConnection];
}
#pragma mark - check login
- (void)checkStatus{
    [self initNavigationBarStyle];
    if ([[GuideModel getModelFromDB] firstOpen] == NO) { //第一次运行
        GuideModel *model = [[GuideModel alloc] init];
        model.firstOpen = YES;
        model.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        QGLOBAL.guideModel = model;
        [self guideInit];
    }else{
    [QGLOBAL checkAuthResult:^(BOOL enabled) {
        if (enabled) {
            [self mainInit];
        }else{
            [self mainInit];
        }
        
    }];
    }
}

- (void)mainInit{
    
    QGLOBAL.mainFrame=nil;
    
    _nav=nil;
    _nav=[[UINavigationController alloc]initWithRootViewController:[QGLOBAL mainFrame]];
    _nav.navigationBarHidden=YES;
    

    
    self.window.rootViewController = _nav;
}
- (void)guideInit{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [QGLOBAL viewControllerName:@"GuideVC" storyboardName:@"Guide"];
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

#pragma mark - 通过外部程序打开app
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    // 接受传过来的参数
    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"云差事欢迎您"
                                                        message:text
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    return YES;
}
#pragma mark - 通过通知等打开app
- (void)checkOpenAppStyle:(NSDictionary *)launchOptions{
    //badge数字
    [self checkBadgeNumber:nil];
    
    id obj =nil;
    
    obj = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([QGLOBAL object:obj isClass:[NSDictionary class]]) {
        DLog(@">>> 是推送点击: %@", obj);
        /*
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@">>> 是推送点击: %@", obj] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alt show];
        */
    }
    
    obj = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if ([QGLOBAL object:obj isClass:[UILocalNotification class]]) {
        DLog(@">>> 本地通知: %@", obj);
    }
    
    obj = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if ([QGLOBAL object:obj isClass:[NSURL class]]) {
        NSString *bundleId = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
        DLog(@">>> 由其他应用程序:%@ 通过openURL启动:%@",bundleId, obj);
    }
}

#pragma mark - 角标 BadgeNumber
- (void)checkBadgeNumber:(NSDictionary *)userInfo{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
#pragma mark - 设置推送类型,不用极光
- (void)setPushType{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        /*
        UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
        [acceptAction setActivationMode:UIUserNotificationActivationModeBackground];
        [acceptAction setTitle:@"One"];
        [acceptAction setIdentifier:@"QY1_ACTION"];
        [acceptAction setDestructive:NO];
        [acceptAction setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *denyAction = [[UIMutableUserNotificationAction alloc] init];
        [denyAction setActivationMode:UIUserNotificationActivationModeBackground];
        [denyAction setTitle:@"Two"];
        [denyAction setIdentifier:@"QY2_ACTION"];
        [denyAction setDestructive:NO];
        [denyAction setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:@"ACTIONABLE"];
        [actionCategory setActions:@[acceptAction, denyAction]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:categories];
        */
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    
}

#pragma mark 注册远程推送通知
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    //检查当前用户是否允许通知
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        DLog(@">>> 注册远程推送通知");
        [application registerForRemoteNotifications];
    }
}

//获取 DeviceToken
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /*
    NSString *deviceTokenSt = [[[[deviceToken description]
                                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                stringByReplacingOccurrencesOfString:@">" withString:@""]
                               stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@">>> 获取 DeviceToken: %@", deviceTokenSt);
    
    //保存DeviceToken并提交服务器
    */
    
    // JPush - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//无法获取设备ID
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@">>> 注册失败，无法获取设备ID, 具体错误: %@", error);
}
/*
//远程推送:应用正在运行，或者被挂起在后台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    DLog(@">>> 收到推送：%@",userInfo);
}
*/
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
    DLog(@"+++ iOS 10 收到推送：%@",userInfo);
    
    //badge数字
    [self checkBadgeNumber:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    DLog(@"+++ 收到推送：%@",userInfo);
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    //badge数字
    [self checkBadgeNumber:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark -
//定义锁屏状态右滑后出现按钮的回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo completionHandler:(nonnull void (^)())completionHandler{
    /*
    if ([identifier isEqualToString:@"QY1_ACTION"]) {
        
    }
    else if ([identifier isEqualToString:@"QY@_ACTION"]) {
        
    }
    
    if (completionHandler) {
        completionHandler();
    }
    */
}
/*
#pragma mark - iOS 10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"willPresentNotification:%@",notification.request.content.title);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.request.content.userInfo objectForKey:@"aps"];
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
    NSString *notMess = [response.notification.request.content.userInfo objectForKey:@"aps"];
    NSLog(@"didReceiveNotificationResponse:%@",response.notification.request.content.title);
    //    response.notification.request.identifier
}
*/
@end
