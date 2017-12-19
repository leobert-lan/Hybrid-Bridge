//
//  QGlobalManager.m
//  resource
//
//  Created by Yan Qingyang on 15/10/13.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "QGlobalManager.h"
#import "SignAPI.h"
//#import "UserAPI.h"
//#import "Zhuge.h"

#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h> //mp是av的再封装
#import <AVFoundation/AVFoundation.h>//相对底层，要自己定义界面
#import "MZTimerLabel.h"

@interface QGlobalManager ()<MZTimerLabelDelegate,QYSlideslipADelegate>
{
//    BOOL ;
}
@end
@implementation QGlobalManager
@synthesize mainFrame=_mainFrame;

+ (instancetype)sharedInstance
{
    InstanceByBlock(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self) {
        //全局配置SDWebImage 下载配置
        [UIImageView SDWebImageLastModifySetting];
    }
    return self;
}
#pragma mark - apple store
- (void)openAppStoreLink{
    NSString *url=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",kAppleStoreID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
#pragma mark - auth
- (BOOL)hadAuthToken{
    if (StrIsEmpty(_auth.vso_token) || StrIsEmpty(_auth.username)) {
        return false;
    }
    return true;
}
-  (void)setAuth:(AuthModel *)auth{
    _auth=auth;
    if (auth)
        [AuthModel updateModelToDB:auth];
}

-  (void)setUsermodel:(UserModel *)usermodel{
    _usermodel=usermodel;
    if (usermodel)
        [UserModel updateModelToDB:usermodel];
}
- (void)setGuideModel:(GuideModel *)guideModel
{
    _guideModel = guideModel;
    [GuideModel updateModelToDB:guideModel];
}
-  (void)setRealNameModelDB:(RealNameModelDB *)realNameModelDB{
    _realNameModelDB=realNameModelDB;
    if (realNameModelDB)
        [RealNameModelDB updateModelToDB:realNameModelDB];
}
-  (void)setCompanyAuthModelDB:(CompanyAuthModelDB *)companyAuthModelDB{
    _companyAuthModelDB=companyAuthModelDB;
    if (companyAuthModelDB)
        [CompanyAuthModelDB updateModelToDB:companyAuthModelDB];
}

#pragma mark - logout
- (void)logout{
    
    [self logoutSuccess:^(BOOL isLogout) {
        if (isLogout) {
            [APPDelegate mainInit];
        }
    }];
}

- (void)logoutSuccess:(void (^)(BOOL isLogout))isLogout{
    NSString *sess = [NSString stringWithFormat:@"%@,%@,v-s-o-c-h*i*n*a",QGLOBAL.auth.username,QGLOBAL.auth.uid];
    [SignAPI logout:QGLOBAL.auth.uid session:[sess MD5] token:QGLOBAL.auth.vso_token success:^(id model) {
        _auth.username=nil;
        _auth.vso_token=nil;
        [AuthModel updateModelToDB:_auth];
        QGLOBAL.auth = nil;
        [QGLOBAL.sideMenu setUserInfo:QGLOBAL.auth];

        //登出
        //        [QGLOBAL postNotif:NotifQuitOut data:nil object:nil];
        QGLOBAL.time = @"0";
        QGLOBAL.forgotTime = @"0";
        QGLOBAL.registerTime = @"0";
        //[QGLOBAL postNotif:NotifQuitOut data:nil object:nil];
        
        if (isLogout) {
            isLogout(YES);
        }
    } failure:^(NetError* err) {
        DLog(@"~~~getList:%li ---",(long)err.errStatusCode);
        //        [self showText:err.errMessage];
        if (isLogout) {
            isLogout(NO);
        }
    }];
}
#pragma mark - 重设头像
- (void)setNavAvatar:(UIImage *)navAvatar{
    //重设头像
//    DLog(@"*** 头像大小 %@",NSStringFromCGSize(navAvatar.size));
    _navAvatar=navAvatar;//[navAvatar imageByScalingAndCroppingForSize:CGSizeMake(240, 240)];
//    DLog(@"*** 重设头像 %@",NSStringFromCGSize(_navAvatar.size));
}
#pragma mark - menu
- (menuTab *)menu{
    if (_menu==nil) {
        _menu=[[menuTab alloc]initWithDelegate:nil];
    }
    return _menu;
}

- (QYSlideslipA *)mainFrame{
    if (_mainFrame==nil) {
        QGLOBAL.menu=nil;
        
        self.sideMenu = [[sideMenuVC alloc]initWithNibName:@"sideMenuVC" bundle:nil];
        
//        [QGLOBAL viewControllerName:@"ViewController" storyboardName:@"Main"];
//        [[UINavigationController alloc]initWithRootViewController:[QGLOBAL viewControllerName:@"ViewController" storyboardName:@"Main"]];
        menuTab * main = [self menu];
        
        
        _mainFrame = [[QYSlideslipA alloc] initWithLeftView:self.sideMenu andMainView:main width:[UIScreen mainScreen].bounds.size.width-kSideMenuShadow];
        _mainFrame.delegate=self;
        //滑动速度系数
        [_mainFrame setSpeedf:0.5];
        
        //点击视图是是否恢复位置
        _mainFrame.sideslipTapGes.enabled = YES;
        
        self.sideMenu.delegatePopVC=_mainFrame;
    }
    return _mainFrame;
}

- (void)setMainFrame:(QYSlideslipA *)mainFrame{
    _mainFrame=mainFrame;
    if (mainFrame==nil) {
        _menu=nil;
    }
}

- (void)checkAuthResult:(void(^)(BOOL enabled))block{
    
    QGLOBAL.auth=[AuthModel getModelFromDB];
    if (QGLOBAL.auth.username.length && QGLOBAL.auth.vso_token.length) {
        
        [SignAPI authUsername:QGLOBAL.auth.username userToken:QGLOBAL.auth.vso_token success:^(id model) {
            
            
            DLog(@">>> auth:%@",QGLOBAL.auth);
            //获取用户信息
            [SignAPI getUserInfoUsername:QGLOBAL.auth.username success:^(UserModel *model) {
                
                [QGLOBAL.sideMenu setUserInfo:model];
//                UserModel *userModel = [[UserModel alloc] init];
//                userModel = model;
                QGLOBAL.usermodel = model;
                AuthModel *authModel = [[AuthModel alloc] init];
                authModel = QGLOBAL.auth;
                authModel.nickname = model.nickname;
                authModel.avatar = model.avatar;
                QGLOBAL.auth = authModel;
//                DLog(@"%@,%@",QGLOBAL.auth,QGLOBAL.usermodel);
                [self postNotif:NotifUserInfo data:QGLOBAL.usermodel object:nil];
                DLog(@">>> 获取用户信息:%@",[QGLOBAL.usermodel toDictionary]);
                if (block) {
                    block(YES);
                }
            } failure:^(NetError* err) {
                if (block) {
                    block(NO);
                }
//                [self showText:err.errMessage];
//                DLog(@">>> checkAuthResult err:%li",err.errStatusCode);
            }];
        } failure:^(id err) {
            QGLOBAL.auth=nil;
            
            if (block) {
                block(NO);
            }
        }];
    }
    else if (block) {
        QGLOBAL.auth=nil;
        block(NO);
    }
}

#pragma mark 时间格式
- (NSString*)dateTimeIntervalToStr:(NSString*)datetime{
    return [self dateToStr:[self dateFromTimeInterval:datetime] format:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)dateDiffFromTimeInterval:(NSString *)datetime{
    NSDate *date=[self dateFromTimeInterval:datetime];
    double ti = [date timeIntervalSince1970];
    double now = [[NSDate date] timeIntervalSince1970];
//    double day=0;
    ti=ti-now;
//    DLog(@">>> %f",ti);
//    if (ti>2629743) {
//        int diff = round(ti / 60 / 60 / 24 / 20.5);
//        return[NSString stringWithFormat:@"%d月后", diff];
//    }
//    else
    if (ti > 86400){
        int diff = floor(ti / 60 / 60 /24);
        ti = ti-diff*60*60*24;
        int hh=floor(ti / 60 / 60);
        if (hh==0) {
            
        }
        return[NSString stringWithFormat:@"%i天%i小时后截稿", diff,hh];
    }
    else if (ti > 3600) {
        int diff = floor(ti / 60 / 60);
        return [NSString stringWithFormat:@"%i小时后截稿", diff];
    }
    else if (ti > 60) {
        int diff = floor(ti / 60);
        return [NSString stringWithFormat:@"%i分钟后截稿", diff];
    }else if (ti > 0) {
        return @"马上截稿";
    }
    return @"过期";
    
}

#pragma mark - QYSlideslipADelegate
- (void)QYSlideslipADelegate:(id)delegate hiddenLeftView:(BOOL)hidden{
    //控制底部菜单显示
    if (hidden) {
        [self performSelector:@selector(showTabbar) withObject:nil afterDelay:0.01];
    }

}

- (void)QYSlideslipADelegate:(id)delegate mainViewWillAppear:(BOOL)animated{
    [self performSelector:@selector(showTabbar) withObject:nil afterDelay:0.01];
}

- (void)showTabbar{
    [QGLOBAL.menu hideTabBar:NO];
}
//- (NSString*)fileURLWithPath:(NSString*)path{
//    
//    NSString *url=[NSString stringWithFormat:API_Download,QGLOBAL.auth.username,[path URLEncodeing]];
//    url=[NSString stringWithFormat:@"%@&access_token=%@&access_id=%@",url,QGLOBAL.auth.access_token,QGLOBAL.auth.access_id];
//    //    url=[NSString stringWithFormat:@"%@&width=%i&height=%i",url,800,800];
//    
//    return url;
//}
/*


- (void)setGuideModel:(GuideModel *)guideModel
{
    _guideModel = guideModel;
    [GuideModel updateModelToDB:guideModel];
}

- (void)setPwdModel:(PwdModel *)pwdModel
{
    _pwdModel = pwdModel;
    [PwdModel updateModelToDB:pwdModel];
}




- (void)userInfo:(NSString*)uname success:(void(^)(id model))success failure:(void(^)(id err))failure{
    [UserAPI userInfo:uname success:^(id model) {
        UserModel *mm=[UserModel getModelFromDB];
        self.user=model;
        if (mm) {
            self.user.onlyWIFI=mm.onlyWIFI;
        }
        else {
            self.user.onlyWIFI=[NSNumber numberWithBool:YES];
        }
        [UserModel updateModelToDB:self.user key:self.user.username];
        if (success) {
            success(model);
        }
    } failure:^(id err) {
        if (failure) {
            failure(err);
        }
    }];
}
#pragma mark - 自动消息
- (void)showText:(NSString*)txt{
    Dispatch_Main_Sync([self showText:txt delay:1.2]);
    ;
}

- (void)showText:(NSString*)txt delay:(double)delay{
//    [self.view endEditing:YES];
    UIWindow *win=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = txt;
    hud.detailsLabelText = txt;
    //    hud.margin = 10.f;
    //    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    double dl=(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}



#pragma mark - file url
- (NSString *)curPath{
    if (StrIsEmpty(_curPath)) {
        return @"/";
    }
    return _curPath;
}

- (NSString*)iconURLWithPath:(NSString*)path{
    
    NSString *url=[NSString stringWithFormat:API_Image_URL,QGLOBAL.auth.username,[path URLEncodeing]];
    url=[NSString stringWithFormat:@"%@&access_token=%@&access_id=%@",url,QGLOBAL.auth.access_token,QGLOBAL.auth.access_id];
    
    return url;
}

- (NSString*)imageURLWithPath:(NSString*)path{

    NSString *url=[NSString stringWithFormat:API_Image_URL,QGLOBAL.auth.username,[path URLEncodeing]];
    url=[NSString stringWithFormat:@"%@&access_token=%@&access_id=%@",url,QGLOBAL.auth.access_token,QGLOBAL.auth.access_id];
    url=[NSString stringWithFormat:@"%@&width=%i&height=%i",url,800,800];
    
    return url;
}

//- (NSString*)imageSharePreURLWithPath:(NSString*)path who:(NSString*)who whoID:(NSString*)whoID {
//    
//    NSString *url=[NSString stringWithFormat:API_ImageShare,who,whoID,[path URLEncodeing],QGLOBAL.auth.username];
//    url=[NSString stringWithFormat:@"%@&access_token=%@&access_id=%@",url,QGLOBAL.auth.access_token,QGLOBAL.auth.access_id];
//    url=[NSString stringWithFormat:@"%@&width=%i&height=%i",url,800,800];
//    
//    return url;
//}
- (NSString*)imageShareURLWithPath:(NSString*)path who:(NSString*)who whoID:(NSString*)whoID {
    
    NSString *url=[NSString stringWithFormat:API_ImageShare,who,whoID,[path URLEncodeing],QGLOBAL.auth.username];
    url=[NSString stringWithFormat:@"%@&access_token=%@&access_id=%@",url,QGLOBAL.auth.access_token,QGLOBAL.auth.access_id];
    url=[NSString stringWithFormat:@"%@&width=%i&height=%i",url,800,800];
    
    return url;
}
- (NSString*)fileURLWithPath:(NSString*)path{
    
    NSString *url=[NSString stringWithFormat:API_Download,QGLOBAL.auth.username,[path URLEncodeing]];
    url=[NSString stringWithFormat:@"%@&access_token=%@&access_id=%@",url,QGLOBAL.auth.access_token,QGLOBAL.auth.access_id];
//    url=[NSString stringWithFormat:@"%@&width=%i&height=%i",url,800,800];
    
    return url;
}

- (NSString*)fileShareURLWithPath:(NSString*)path who:(NSString*)who whoID:(NSString*)whoID {
//    zhou88/share/569f30192bb67c9418753ec1/download?pat h=/大眼.JPG&queryUsername=zhou88&access_token=1&access_id=2
    //BASE_URL_V3 API_Users @"/%@/share/%@/download?path=%@&queryUsername=%@"
    NSString *url=[NSString stringWithFormat:API_DownloadShare,who,whoID,[path URLEncodeing],QGLOBAL.auth.username];
    url=[NSString stringWithFormat:@"%@&access_token=%@&access_id=%@",url,QGLOBAL.auth.access_token,QGLOBAL.auth.access_id];
    //    url=[NSString stringWithFormat:@"%@&width=%i&height=%i",url,800,800];
    
    return url;
}

- (NSString*)urlWithNewToken:(NSString*)url{
    NSArray *arr=[url componentsSeparatedByString:@"&"];
    NSString *path=arr.firstObject;
    
    for (int i = 1; i<arr.count; i++) {
        NSString *ss=[arr objectAtIndex:i];
        if ([ss hasPrefix:@"access_token"]) {
            path=[NSString stringWithFormat:@"%@&access_token=%@",path,QGLOBAL.auth.access_token];
        }
        else if([ss hasPrefix:@"access_id"]){
            path=[NSString stringWithFormat:@"%@&access_id=%@",path,QGLOBAL.auth.access_id];
        }
        else {
            path=[NSString stringWithFormat:@"%@&%@",path,ss];
        }
    }
    return path;
}

- (NSString*)reName:(NSString*)name num:(NSInteger)num{
    //当前文件名 无后缀
    NSString *curName=[name stringByDeletingPathExtension];
    NSString *newName=[NSString stringWithFormat:@"%@(%li)",curName,(long)num];
    
    NSString *ext=[name pathExtension];
    if (ext.length) {
        newName=[NSString stringWithFormat:@"%@.%@",newName,ext];
    }
    return newName;
}

- (BOOL)isExistName:(NSString*)name distName:(NSString*)distName{
    if (distName.length>=name.length) {
        //当前文件名 无后缀
        NSString *curName=[name stringByDeletingPathExtension];
        //目标文件名，无后缀
        NSString *dName=[distName stringByDeletingPathExtension];
        
        NSRange rang = NSMakeRange(0, curName.length);
        NSString *pre=[dName substringWithRange:rang];
        
        if ([curName isEqualToString:pre]) {
            //同名or带自动编号
            if (curName.length==dName.length || [self isNameNum:dName length:curName.length]) {
                return YES;
            }
           
            
        }
    }
    return NO;
}

- (BOOL)isNameNum:(NSString*)distName length:(NSUInteger)length{
    if (distName.length<length+3) {
        return NO;
    }
    NSRange rang = NSMakeRange(length, 1);
    NSString *pre=[distName substringWithRange:rang];
    rang = NSMakeRange(distName.length-1, 1);
    NSString *last=[distName substringWithRange:rang];
    rang = NSMakeRange(length+1, distName.length-length-2);
    NSString *num=[distName substringWithRange:rang];
    if ([pre isEqualToString:@"("] && [last isEqualToString:@")"] && [self isPureInt:num]) {
        return YES;
    }
    return NO;
}

//是否是int
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark - zhuge
- (void)zhuge:(NSString*)key dict:(NSDictionary*)dict{
    if (!key || key.length==0) {
        return;
    }
    
    if (dict.allKeys.count) {
        [[Zhuge sharedInstance] track:key properties:dict];
    }
    else {
        [[Zhuge sharedInstance] track:key];
    }
}

- (void)zhugeUserInfo{
    NSMutableDictionary *user = [NSMutableDictionary dictionary];
//    user[@"name"] = self.name.text;
//    user[@"gender"] = @"男";
//    user[@"birthday"] = @"2014/11/11";
//    user[@"avatar"] = @"http://tp2.sinaimg.cn/2885710157/180/5637236139/1";
//    user[@"email"] = self.email.text;
//    user[@"mobile"] = @"18901010101";
//    user[@"qq"] = [NSString stringWithFormat:@"%@", id];
//    user[@"weixin"] = [NSString stringWithFormat:@"wx%@", id];
//    user[@"weibo"] = [NSString stringWithFormat:@"wb%@", id];
//    user[@"location"] = @"北京 朝阳区";
//    user[@"公司"] = @"YY";
    [[Zhuge sharedInstance] identify:DEVICE_ID properties:user];

    
}

//设备
- (void)zhugeDevices{
    NSDictionary *dz=@{@"ios":StrFromObj(OS_VERSION),@"deviceType":[QGLOBAL deviceType],
                       @"appVersion":StrFromObj(VERSION),@"appName":StrFromObj(APP_NAME),
                       @"deviceName":StrFromObj(DEVICE_NAME),@"language":StrFromObj(USER_LANNGUAGE),
                       @"localTimeZone":StrFromObj([NSTimeZone localTimeZone])};
    [QGLOBAL zhuge:@"Devices" dict:dz];
    
    DLog(@"zhugeDevices:%@",dz);
}

#pragma mark 时间格式
- (NSString*)dateTimeIntervalToStr:(NSString*)datetime{
    return [self dateToStr:[self dateFromTimeInterval:datetime] format:@"yyyy-MM-dd HH:mm"];
}

#pragma mark - video
- (void)videoPlayer:(NSString*)path vc:(UIViewController*)vc{

    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"backspace" ofType:@"mov"];
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:path];
    
//    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:sourceMovieURL];
//    [player.moviePlayer prepareToPlay];
//    [vc presentMoviePlayerViewControllerAnimated:player]; // 这里是presentMoviePlayerViewControllerAnimated
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:sourceMovieURL];
    player.view.frame=vc.view.bounds;
    player.controlStyle=MPMovieControlStyleFullscreen;
    
    // Play the movie!
    [vc.view addSubview:player.view];
}
#pragma mark - time
- (void)stopTime
{
    dispatch_source_cancel(_timer);
}
-(void)startTimeWithTimeOut:(int)timeOut{
    __block int timeout=timeOut; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
        }else{
            timeout--;
            if (self.timeBlock) {
                self.timeBlock(timeout);
            }
        }
    });
    dispatch_resume(_timer);
}




 */
@end
