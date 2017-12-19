//
//  ThirdShare.m
//  CloudBox
//
//  Created by zhchen on 16/3/29.
//  Copyright © 2016年 YAN Qingyang. All rights reserved.
//

#import "ThirdShare.h"
#import "UMSocial.h"
#import "ThirdShareView.h"
@implementation ThirdShare
+ (instancetype)sharedInstance
{
    InstanceByBlock(^{
        return [[self alloc] init];
    });
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    
    
    return self;
}

#pragma mark - 第三方分享
- (void)ThirdShareView:(NSString *)url name:(NSString *)name nav:(UINavigationController *)nav title:(NSString *)title btnCopy:(BOOL)btnCopy
{
    if (btnCopy == YES) {
        ThirdShareView *cn=[ThirdShareView instanceWithBtnCopy:btnCopy Block:^(ThirdShareEnumType obj) {
//            [MobClick event:cb_move attributes:@{@"type":StrFromInt(obj)}];
            switch (obj) {
                case ShareEnumTypeSina:
                    [MobClick event:UMTaskShareWB];
                    [self SinaShare:url name:name nav:nav title:title];
                    break;
                case ShareEnumTypeQQ:
                    [MobClick event:UMTaskShareQQ];
                    [self QQShare:url name:name nav:nav title:title];
                    break;
                case ShareEnumTypeWeixin:
                    [MobClick event:UMTaskShareWX];
                    [self WeixinShare:url name:name nav:nav title:title];
                    break;
                case ShareEnumTypeQQZone:
                    [MobClick event:UMTaskShareQQZone];
                    [self QQZoneShare:url name:name nav:nav title:title];
                    break;
                case ShareEnumTypeWexinLine:
                    [MobClick event:UMTaskShareWXFrd];
                    [self WeixinLineShare:url name:name nav:nav title:title];
                    break;
                case ShareEnumTypeCopy:
                    [self ShareCopy:url nav:nav];
                default:
                    
                    break;
            }
            
        }];
        [cn show];
    }else{
    ThirdShareView *cn=[ThirdShareView instanceWithBtnCopy:btnCopy Block:^(ThirdShareEnumType obj) {
        switch (obj) {
            case ShareEnumTypeSina:
                [MobClick event:UMTaskShareWB];
                [self SinaShare:url name:name nav:nav title:title];
                break;
            case ShareEnumTypeQQ:
                [MobClick event:UMTaskShareQQ];
                [self QQShare:url name:name nav:nav title:title];
                break;
            case ShareEnumTypeWeixin:
                [MobClick event:UMTaskShareWX];
                [self WeixinShare:url name:name nav:nav title:title];
                break;
            case ShareEnumTypeQQZone:
                [MobClick event:UMTaskShareQQZone];
                [self QQZoneShare:url name:name nav:nav title:title];
                break;
            case ShareEnumTypeWexinLine:
                [MobClick event:UMTaskShareWXFrd];
                [self WeixinLineShare:url name:name nav:nav title:title];
                break;
//            case ShareEnumTypeCopy:
//                [self ShareCopy:url nav:nav];
            default:
                
                break;
        }
        
    }];
        [cn show];
    }
    
}

#pragma mark - QQ分享
- (void)QQShare:(NSString *)url name:(NSString *)name nav:(UINavigationController *)nav title:(NSString *)title
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qqData.title = title;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:name image:[UIImage imageNamed:@"icon_about"] location:nil urlResource:nil presentedController:nav completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }else{
        [self alertMessage:@"您的设备没有安装QQ" nav:nav];
    }
    
}
- (void)SinaShare:(NSString *)url name:(NSString *)name nav:(UINavigationController *)nav title:(NSString *)title
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",title,url] image:[UIImage imageNamed:@"icon_about"] location:nil urlResource:nil presentedController:nav completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSLog(@"分享成功！");
        }
    }];
    }else{
        [self alertMessage:@"您的设备没有安装微博" nav:nav];
    }
    
    //登录
    //    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    //
    //    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
    //
    //        //          获取微博用户名、uid、token等
    //
    //        if (response.responseCode == UMSResponseCodeSuccess) {
    //
    //            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
    //
    //            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
    //
    //        }});
}
- (void)QQZoneShare:(NSString *)url name:(NSString *)name nav:(UINavigationController *)nav title:(NSString *)title
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:name image:[UIImage imageNamed:@"icon_about"] location:nil urlResource:nil presentedController:nav completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            NSLog(@"分享成功！");
        }
    }];
    }else{
        [self alertMessage:@"您的设备没有安装QQ" nav:nav];
    }
}
- (void)WeixinShare:(NSString *)url name:(NSString *)name nav:(UINavigationController *)nav title:(NSString *)title
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:name image:[UIImage imageNamed:@"icon_about"] location:nil urlResource:nil presentedController:nav completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            NSLog(@"分享成功！");
        }
    }];
    }else{
        [self alertMessage:@"您的设备没有安装微信" nav:nav];
    }
    //    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    //
    //    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
    //
    //        if (response.responseCode == UMSResponseCodeSuccess) {
    //
    //            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
    //
    //            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
    //
    //        }
    //
    //    });
}
- (void)WeixinLineShare:(NSString *)url name:(NSString *)name nav:(UINavigationController *)nav title:(NSString *)title
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:name image:[UIImage imageNamed:@"icon_about"] location:nil urlResource:nil presentedController:nav completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            NSLog(@"分享成功！");
        }
    }];
    }else{
        [self alertMessage:@"您的设备没有安装微信" nav:nav];
    }
}
- (void)ShareCopy:(NSString *)url nav:(UINavigationController *)nav
{
    UIPasteboard *past = [UIPasteboard generalPasteboard];
    past.string = url;
    
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:@"复制链接成功!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:can];
    [nav presentViewController:alt animated:YES completion:nil];
}
- (void)alertMessage:(NSString *)message nav:(UINavigationController *)nav
{
    UIAlertController *alt = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *can = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alt addAction:can];
    [nav presentViewController:alt animated:YES completion:nil];
}
@end
