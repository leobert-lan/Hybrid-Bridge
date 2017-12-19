//
//  RConstant.h
//  resource
//
//  Created by Yan Qingyang on 15/10/21.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#ifndef RConstant_h
#define RConstant_h

#pragma mark - 生产环境
//#define kAppChannel @"apple store"  //正式环境切这个，代表apple store
#define kIsPushProduction YES

#pragma mark - 开发环境
#define kAppChannel @"VSO_DEV"


//#define kIsPushProduction NO

#pragma mark -
#define kAppleStoreID @"1134389499"

#define kUMengKey @"57873f5fe0f55a7f8f00093b"
#define kJPUSHKey @"2a681fe1b2e459df63730412"

#define kAppStoreVersion @"kAppStoreVersion" 
#define kSideMenuShadow AutoValue(80)
#define kPageSize 20 //每页数据条数
//#define kADTime 5 //广告时间延迟5秒
#define kBtnCornerRadius 4 //按钮圆角度数
//#define kAdviseSize 500

#define kCellHeight 53 //cell高度
#define kRegisterTime 120 //手机验证等待
#define kTaskLineSpac 1.2 // 具体要求行距
#define kTelNum @"400-164-7979"

#pragma mark - 广告文件夹
#define kADFolderName @"ADFolder" 

#pragma mark - 常用语
#define Msg_WIFIOnly @"您设置了WI-FI下载!"
#define Msg_4GDownload @"正在使用流量下载!"
#define Msg_4GUpload @"正在使用流量上传!"
#define Msg_NeedWIFI @"等待WiFi，或者你可以去我的菜单中关闭“仅在WiFi上传下载”功能"
#define Msg_ThirdLoginErr @"网络连接超时，请重试"

#define Err_DataErr @"数据异常!"

#define Msg_NoTaskHistory @"暂无需求，赶快去添加吧~"
#define Msg_NoFavoHistory @"没有收藏，快去找需求吧~"
#define Msg_AuthRealName @"投稿需要实名认证，请先认证"
#define Msg_AuthCompany @"投稿需要企业认证，请先认证"
#define Msg_AuthTeam @"投稿需要团队认证，请先认证"
#define Msg_Auth @"投稿需要信息认证，请先认证"
#define Msg_CheckPhoneBound @"投稿需先绑定手机号，请先绑定"
#define Msg_CheckBound @"投稿需先绑定邮箱／银行卡,请到电脑上绑定"
#define Msg_Submissionnum   @"投稿次数达到上限,请稍后再试"
#define Msg_Login @"该账号尚未注册"
// 评级提示语
#define Msg_Evaluate @"请完善评价信息"
// 分享
#define Msg_ShareTitle @"云差事，让赚钱更简单"
#define Msg_ShareContent @"一款为文创工作者精心打造的赚钱神器，海量需求，智能搜索，一键管理，让赚钱更简单!"
// 需求详情分享
#define Msg_ShareTaskDeati @"赚钱神器来也！让赚钱更简单"
// 签署协议提示语
#define Msg_ProtocolAgree @"请先勾选你已阅读协议内容"

#define Msg_PwdFormat @"格式错误,仅限字母数字及字符"
#define Txt_PwdNum @"请设置6-20位密码"
//-----------1.0.20新加提示语----------//
#define Msg_CheckInternet @"网络异常、请检查网络设置"
#define Msg_Is4G @"文件大小为%@，您当前为2G/3G/4G环境，继续预览将耗费较多流量"//@"正在使用手机流量，下载可能产生大量流量消费"
#define Msg_FileNoExist @"文件不存在"

#define Msg_FileDownloadSuccess @"文件下载成功"
#define Msg_FileDownloadNoDiskSpace @"没有足够空间，下载失败"
#define Msg_FileDownloadFailure @"文件下载失败"
#define Msg_FileDownloadCancel @"放弃下载"
//---------------------//
#define H5_BASE_URL @"http://m.vsochina.com/"
// 推荐好友页面
#define Msg_ShareRecommand H5_BASE_URL @"protocol/downloadApp"
// 协议
#pragma mark - 注册协议地址
#define Msg_RegisterzhCN H5_BASE_URL @"protocol/user-agreement"//@"http://www.vsochina.com/protocol/pro_id/219.html" //简体中文
#define Msg_RegisterzhTW @"http://www.vsochina.com/protocol/pro_id/1250.html" //繁体中文
#define Msg_Registerenen @"http://www.vsochina.com/protocol/pro_id/1249.html" //英文
// 签署协议
#define Msg_Subbmision   H5_BASE_URL @"protocol?taskbn="
// 消息
#define Msg_Message H5_BASE_URL @"message/detail/"//http://mobile.vsochina.com/message/detail/268314?auth_token=0f505d41649dbaaa0c4978d66a500aca&auth_username=86140469
//umeng key

#pragma mark - umeng key
///页面的统计 [MobClick beginLogPageView:@"OnePage"]; [MobClick endLogPageView:@"OnePage"];

///普通事件 [MobClick event:@"Forward"];

///计数事件 [MobClick event:(NSString *)eventId attributes:(NSDictionary *)attributes];
///////////[MobClick event:@"purchase" attributes:@{@"type" : @"book", @"quantity" : @"3"}];

///属性内容 [MobClick event:@"Mac_Category" label:cell.textLabel.text];
///////////[MobClick event:@"pay" attributes:@{@"book" : @"Swift Fundamentals"} counter:110];

#pragma mark - 社交统计

#define UMUserRegist @"UMUserRegist" //,注册是否成功,1
#define UMUserTelVerfPage @"UMUserTelVerfPage" //,验证手机页面,0
#define UMUserLoginPage @"UMUserLoginPage" //,登录页面,0
#define UMUserLogin @"UMUserLogin" //,登录,1
#define UMUserLoginQQ @"UMUserLoginQQ" //,QQ登录,0
#define UMUserLoginWB @"UMUserLoginWB" //,微博登录,0
#define UMUserLoginWX @"UMUserLoginWX" //,微信登录,0
#define UMUserUpdateAvatar @"UMUserUpdateAvatar" //,用户更新头像,0
#define UMAuthPerso @"UMAuthPerso" //,个人认证,0
#define UMAuthComp @"UMAuthComp" //,企业认证,0
#define UMSubscrFromHome @"UMSubscrFromHome" //,主页订阅,0
#define UMSubscrFromMine @"UMSubscrFromMine" //,个人菜单订阅,0
#define UMSubscrFromReg @"UMSubscrFromReg" //,注册后订阅,0
#define UMSubscrLeave @"UMSubscrLeave" //,离开订阅,0
#define UMSubscrSuccess @"UMSubscrSuccess" //,成功订阅,1
#define UMHomeSearchBar @"UMHomeSearchBar" //,主页搜索框,0
#define UMHomeTaskHouse @"UMHomeTaskHouse" //,主页需求大厅,0
#define UMSearchCondition @"UMSearchCondition" //,搜索－条件,1
#define UMSearchHistory @"UMSearchHistory" //,搜索－历史关键词,0
#define UMSearchPropose @"UMSearchPropose" //,搜索－推荐,0
#define UMTaskSubmisPage @"UMTaskSubmisPage" //,需求投稿页面,0
#define UMTaskSubmission @"UMTaskSubmission" //,需求投稿,1
#define UMTaskSubmisIncompl @"UMTaskSubmisIncompl" //,需求投稿没填完整,0
#define UMTaskShare @"UMTaskShare" //,需求分享,1
#define UMTaskFavo @"UMTaskFavo" //,需求收藏,0
#define UMTaskComment @"UMTaskComment" //,需求评价,0
#define UMTaskDetailPage @"UMTaskDetailPage" //,需求详情页面,0
#define UMMgrTaskMenu @"UMMgrTaskMenu" //,需求管理菜单,1
#define UMNavSlide @"UMNavSlide" //,导航栏侧滑,0
#define UMTaskFavoList @"UMTaskFavoList" //,需求收藏列表,0
#define UMTaskHot @"UMTaskHot" //,需求最火,0
#define UMTaskRich @"UMTaskRich" //,需求最壕,0
#define UMUserLogin3rd @"UMUserLogin3rd" //,第三方登录,1
#define UMUserRegist3rd @"UMUserRegist3rd" //,第三方登录,1
#define UMTaskShareWB @"UMTaskShareWB" //,需求分享WB,0
#define UMTaskShareWX @"UMTaskShareWX" //,需求分享WX,0
#define UMTaskShareWXFrd @"UMTaskShareWXFrd" //,需求分享WXfrd,0
#define UMTaskShareQQ @"UMTaskShareQQ" //,需求分享QQ,0
#define UMTaskShareQQZone @"UMTaskShareQQZone" //,需求分享QQZ,0
#define UMTaskGuide @"UMTaskGuide" //引导页,1
#pragma mark - 图片名字

#endif /* RConstant_h */
