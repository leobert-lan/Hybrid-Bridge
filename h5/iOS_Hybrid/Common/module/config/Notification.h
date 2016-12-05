/*!
 @header Notification.h
 @abstract 所有通知常量
 @author .
 @version 1.00 2015/01/01  (1.00)
 */


#ifndef APP_Notification_h
#define APP_Notification_h



//#define PRO_CLASS_SELECTED      @"PRO_CLASS_SELECTED"
//#define DRUG_GRIDE_EDIT         @"DRUG_GRIDE_EDIT"
//#define STORE_CHANGED_PHONE     @"STORE_CHANGED_PHONE"
//#define STORE_CHANGED_ADDRESS   @"STORE_CHANGED_ADDRESS"
//#define LOGIN_SUCCESS           @"LOGIN_SUCCESS"
//#define MESSAGE_NEED_UPDATE     @"MESSAGE_NEED_UPDATE"
//#define OFFICIAL_MESSAGE            @"OFFICIAL_MESSAGE"
//#define QUIT_OUT                @"QUIT_OUT"
//#define KICK_OFF                @"KICK_OFF"
//#define PHARMACY_NEED_UPDATE        @"PHARMACY_NEED_UPDATE"
//#define NETWORK_DISCONNECT     @"networkDisconnect"
//#define NETWORK_RESTART     @"networkRestart"
//#define NEED_RELOCATION             @"NEED_RELOCATION"
//#define LOCATION_UPDATE             @"LOCATION_UPDATE"
//#define APP_CHECK_VERSION           @"App_check_version"
//#define LOCATION_UPDATE_ADDRESS     @"LOCATION_UPDATE_ADDRESS"
//UpdateUserNickNameSuccess
//@"NetworkReachabilityChangedNotification"


typedef NS_ENUM(NSInteger, Enum_Notification_Type)  {
    //用户
    NotifQuitOut = 1,             //用户退出
    NotifLoginSuccess,              //登录成功
    NotifUserInfo,
    
  
    //消息
    NotifMessageNeedUpdate,    //更新message
    NotifMessageOfficial,
    NotifKickOff,
    
    //网络
    NotifNetworkDisconnect,    //网络断线
    NotifNetworkReconnect,          //网络重连
    NotifNetworkReachabilityChanged,
    
    //GPS
    NotifLocationUpdate,       //地址更新
    NotifLocationUpdateAddress,
    NotifLocationNeedReload,        //需要重新刷新地址
    
    //系统
    NotifAppCheckVersion,
    
    NotifAppDidEnterBackground,  //到后台
    NotifAppDidBecomeActive,
    NotifAppWillEnterForeground,//前台
    NotifAppWillTerminate, //杀进程
    
    //self
    NotifDeleteItems,
    NotifInsertItems,
    NotifMoveItems,
    NotifUploadingFinished,
//    NotifSubscriptionSuccess,
    
};
#endif

