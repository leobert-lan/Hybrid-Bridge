//
//  AppDelegate.m
//  H5
//
//  Created by Qingyang on 16/2/3.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "LanguageManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UMSocialData setAppKey:@"569c5b3f67e58ea4060016ca"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx5c56bb2e1c024b49" appSecret:@"a18afaec1ef0f9b05dd6abee96056a45" url:@"www.vsochina.com"];
    [UMSocialQQHandler setQQWithAppId:@"1105135204" appKey:@"4chGRPEZQxtrZZ54" url:@"www.vsochina.com"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"535673299"
                                              secret:@"57187e986afd826a8ee27b58d6c85c08"
                                         RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    // Override point for customization after application launch.
    
    NSString *languageStr = [LanguageManager currentLanguageCode];
    if ([[self getCurrentLanguage] isEqualToString:[NSString stringWithFormat:@"%@-US",languageStr]]) {
        [LanguageManager sharedInstance].language = [self getCurrentLanguage];
    }else{
        [LanguageManager sharedInstance].language = languageStr;
    }
    NSInteger index = [[LanguageManager languageCodes] indexOfObject:[LanguageManager sharedInstance].language];
    [LanguageManager saveLanguageByIndex:index];
    return YES;
}
- (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

@end
