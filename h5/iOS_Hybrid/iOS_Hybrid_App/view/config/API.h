//
//  API.h
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//
/*
#ifndef API_h
#define API_h
//正式环境
#define BASE_URL_V3                         @"https://api.vsochina.com"
#define BASE_URL_INNER                      @"http://req.vsochina.com/api/curl"
//统计环境


#define API_Search                          BASE_URL_V3 @"/req/search"

#define API_Login                           BASE_URL_V3 @"/user/login/index"
#define API_Register                        BASE_URL_V3 @"/message/mobile/send-message-by-mobile"
#define API_Logout                          BASE_URL_V3 @"/user/login/logout"
#define API_LoginStatus                     BASE_URL_V3 @"/user/user/login-status"
#define API_UserInfo                        BASE_URL_V3 @"/user/info/view-req-app"

//验证手机号是否可用
#define API_RegisterIsMobile                BASE_URL_V3 @"/user/auth/is-available-mobile"
//验证验证码
#define API_RegisterValid_code              BASE_URL_V3 @"/message/mobile/check-valid-code-by-mobile"
// 注册用户
#define API_RegisterUser                    BASE_URL_V3 @"/user/register/mobile"
// 注册需要的四个参数
// 注册验证码
#define API_RegisterMessage     @"valid_code_register"
// 发送验证码
#define API_SendMessage         @"valid_code"
// 重置密码
#define API_ResetPassword       @"reset_password"
// 修改登录密码
#define  API_ChangePassword     @"change_password"
// 第三方登录
#define API_ThirdIsExist                    BASE_URL_V3 @"/user/auth/is-available-oauth"
#define API_ThirdLogin                      BASE_URL_V3 @"/user/login/oauth"
//第三方登录修改密码
#define API_ThirdLoginChangePwd             BASE_URL_V3 @"/user/safe/reset-password"
//忘记密码
#define API_ForgotPwd                       BASE_URL_V3 @"/user/safe/reset-password-by-name"
// 修改密码
#define API_ChangePwd                       BASE_URL_V3 @"/user/safe/change-password"
#pragma mark - 我的关注
#define API_MyConcernList                   BASE_URL_V3 @"/favor/talent/get-user-favor-talent-list"
#define Api_MyConcernAdd                    BASE_URL_V3 @"/favor/talent/create-favor-talent"
#define Api_MyConcernCancel                 BASE_URL_V3 @"/favor/talent/delete-favor-talent"
#define API_ChangeInfo                      BASE_URL_V3 @"/user/info/update-user-basic-info"
#define API_Feedback                        BASE_URL_V3 @"/tools/feedback/create"
#define API_IndusList                       BASE_URL_V3 @"/task/category/get-cate-list"
//实名认证查询
#define API_RealnameQuery                   BASE_URL_V3 @"/auth/realname/view"
#define API_CompanyAuthQuery                BASE_URL_V3 @"/auth/enterprise/view"
// 实名认证添加
#define API_RealnameCreat                   BASE_URL_V3 @"/auth/realname/create"
#define API_CompanyCreat                    BASE_URL_V3 @"/auth/enterprise/create"
// 手机绑定
#define API_PhoneBound                BASE_URL_V3 @"/auth/mobile/update"
// 地区
#define API_CityList                BASE_URL_V3 @"/auth/area/list"
// 消息
#define API_SysMessageList                  BASE_URL_V3 @"/message/message/get-user-message-list"
#define API_NemMessage                      BASE_URL_V3 @"/message/message/list-by-type"
#define API_MessageDelete                   BASE_URL_V3 @"/message/message/delete"
#define API_MessageRead                     BASE_URL_V3 @"/message/message/read"

//需求
#define API_TaskListHot                     API_Search @"/list-hot"
#define API_TaskListRich                    API_Search @"/list-expensive"

//搜索
#define API_SearchTaskList                  API_Search @"/list"
#define API_SearchTaskHistory               API_Search @"/list-search-history"

// 需求详情
#define API_TaskDetail                      BASE_URL_V3 @"/req/info/view"

//添加收藏
#define API_FavorAdd                        BASE_URL_V3 @"/req/favor/create"
// 取消收藏
#define API_FavorDelete                     BASE_URL_V3 @"/req/favor/delete"
// 评价获取配置项
#define API_EvaluateConfig                  BASE_URL_V3 @"/req/mark-config/view"
// 承接需求校验
#define API_SubmissionCheck                 BASE_URL_V3 @"/req/undertake/check-permission"
// 承接需求
#define API_Submission                      BASE_URL_V3 @"/req/undertake/create"
// 评级
#define API_Evaluate                        BASE_URL_V3 @"/req/mark/create"
// 稿件列表
#define API_TaskWorkList                    BASE_URL_V3 @"/req/work/list"
// 我承接的需求列表

#define API_MyTakeTask                      BASE_URL_V3 @"/req/undertake/list"
#define API_MyFavoTask                      BASE_URL_V3 @"/req/favor/list"

//搜索行业
#define API_IndustryList                    BASE_URL_V3 @"/req/industry/list"
//返回行业列表为二叉树形式
#define API_IndustryListII                  BASE_URL_V3 @"/industry/get-industry-list"

//猜你喜欢
#define API_TaskPrefer                      BASE_URL_V3 @"/req/recom/list-prefer"

//上传
#define API_Upload                          BASE_URL_V3 @"/file/index/upload"
#endif 
*/
