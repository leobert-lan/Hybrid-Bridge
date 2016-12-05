//
//  QGlobalManager.h
//  resource
//
//  Created by Yan Qingyang on 15/10/13.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#import "GlobalManager.h"
#import "menuTab.h"
#import "QYSlideslipA.h"
#import "UserModel.h"
#import "sideMenuVC.h"
#define  QGLOBAL [QGlobalManager sharedInstance]
#define APPDelegate (AppDelegate*)[UIApplication sharedApplication].delegate
#define APPRootVC [UIApplication sharedApplication].keyWindow.rootViewController
typedef void(^timeBlock)(int timeout);

@interface QGlobalManager : GlobalManager
{
    dispatch_source_t _timer;
}
@property (nonatomic, retain) NSString *curPath;
@property (nonatomic, retain) NSString *uploadPath;
//把menu放全局，有些页面需要隐藏menu
@property (nonatomic, strong) QYSlideslipA* mainFrame;
@property (nonatomic, strong) menuTab *menu;
@property (nonatomic, strong) AuthModel *auth;
@property (nonatomic, strong) UserModel *usermodel;
@property (nonatomic,strong) GuideModel *guideModel;
@property (nonatomic, strong) RealNameModelDB *realNameModelDB;
@property (nonatomic, strong) CompanyAuthModelDB *companyAuthModelDB;
@property (nonatomic, strong) sideMenuVC *sideMenu;
@property (nonatomic, strong) UIImage *navAvatar;
@property (nonatomic,strong) NSMutableArray *indusArr;
@property (nonatomic,assign) BOOL TaskDetailis;
@property (nonatomic,copy)NSString *time;//phoneBound
@property (nonatomic,copy)NSString *forgotTime;//ForgotPwdVerifyPhoneVC
@property (nonatomic,copy)NSString *registerTime;//Register
@property (nonatomic,copy) NSString *detailTaskWorkType;
@property (nonatomic,copy) NSString *detailTaskWorkBid;
@property (nonatomic,assign) BOOL isEmployer;
@property (nonatomic,assign)int timeOut;
@property(nonatomic,copy)timeBlock timeBlock;

@property(nonatomic,assign)BOOL searchBJView;
@property(nonatomic,assign)BOOL searchBJ;
@property(nonatomic,assign)BOOL searchDB;//是否直接进入搜索页

+ (instancetype)sharedInstance;

#pragma mark - apple store
- (void)openAppStoreLink;

- (void)checkAuthResult:(void(^)(BOOL enabled))block;
- (void)logout;
- (void)logoutSuccess:(void (^)(BOOL isLogout))isLogout;
//- (void)userInfo:(NSString*)uname success:(void(^)(id model))success failure:(void(^)(id err))failure;

#pragma mark - file download

#pragma mark - 自动消息
//- (void)showText:(NSString*)txt;
#pragma mark 时间格式
- (NSString*)dateTimeIntervalToStr:(NSString*)datetime;
- (NSString *)dateDiffFromTimeInterval:(NSString *)datetime;
#pragma mark - video

#pragma mark - file path

#pragma mark - auth
- (BOOL)hadAuthToken;
@end
