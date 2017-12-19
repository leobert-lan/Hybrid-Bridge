//
//  API.h
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#ifndef API_h
#define API_h

#pragma mark - 正式环境

#define BASE_URL_INNER                      @"https://req.vsochina.com/api/curl"

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 统计环境


#pragma mark - API
#define API_Search                           @"req/search/"

#define API_Login                            @"user/login/index"
// 获取验证码
#define API_Register                         @"message/mobile/send-message-by-mobile"
#define API_SendValidUsername                    @"message/mobile/send-mobile-valid-code"

#define API_Logout                           @"user/login/logout"
#define API_LoginStatus                      @"user/user/login-status"
#define API_UserInfo                         @"user/info/view-req-app"

//验证手机号是否可用
#define API_RegisterIsMobile                 @"user/auth/is-available-mobile"
//验证验证码
#define API_RegisterValid_code               @"message/mobile/check-valid-code-by-mobile"
#define API_CheckValidUsername               @"message/mobile/check-mobile-valid-code"
// 注册用户
#define API_RegisterUser                     @"user/register/mobile"
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
#define API_ThirdIsExist                     @"user/auth/is-available-oauth"
#define API_ThirdLogin                       @"user/login/oauth"
//第三方登录修改密码
#define API_ThirdLoginChangePwd              @"user/safe/reset-password"
//忘记密码
#define API_ForgotPwd                        @"user/safe/reset-password-by-name"
// 修改密码
#define API_ChangePwd                        @"user/safe/change-password"
#pragma mark - 我的关注
#define API_MyConcernList                    @"favor/talent/get-user-favor-talent-list"
#define Api_MyConcernAdd                     @"favor/talent/create-favor-talent"
#define Api_MyConcernCancel                  @"favor/talent/delete-favor-talent"
#define API_ChangeInfo                       @"user/info/update-user-basic-info"
#define API_Feedback                         @"tools/feedback/create"
#define API_IndusList                        @"task/category/get-cate-list"
// 身份证校验
#define API_IDcardCheck                      @"user/auth/is-id-format"
//实名认证查询
#define API_RealnameQuery                    @"auth/realname/view"
#define API_CompanyAuthQuery                 @"auth/enterprise/view"
// 实名认证添加
#define API_RealnameCreat                    @"auth/realname/create"
#define API_CompanyCreat                     @"auth/enterprise/create"
// 手机绑定
#define API_PhoneBoundCreat                  @"auth/mobile/create"
// 手机更新
#define API_PhoneBound                       @"auth/mobile/update"
// 地区
#define API_CityList                         @"auth/area/list"
// 消息
#define API_SysMessageList                   @"message/message/get-user-message-list"
#define API_NemMessage                       @"message/message/list-by-type"
#define API_MessageDelete                    @"message/message/delete"
#define API_MessageRead                      @"message/message/read"

//需求
#define API_TaskListHot                     API_Search @"list-hot"
#define API_TaskListRich                    API_Search @"list-expensive"

//搜索
#define API_SearchTaskList                  API_Search @"list"
#define API_SearchTaskHistory               API_Search @"list-search-history"

// 需求详情
#define API_TaskDetail                       @"req/info/view"

//添加收藏
#define API_FavorAdd                         @"req/favor/create"
// 取消收藏
#define API_FavorDelete                      @"req/favor/delete"
// 评价获取配置项
#define API_EvaluateConfig                   @"req/mark-config/view"
// 承接需求校验
#define API_SubmissionCheck                  @"req/undertake/check-permission"
// 承接需求
#define API_Submission                       @"req/undertake/create"
// 签署协议
#define API_Protocol                         @"req/protocol/sign"
// 评级
#define API_Evaluate                         @"req/mark/create"
// 稿件列表
#define API_TaskWorkList                     @"req/work/list"
// 我承接的需求列表

#define API_MyTakeTask                       @"req/undertake/list"
#define API_MyFavoTask                       @"req/favor/list"

//搜索行业
#define API_IndustryList                     @"req/industry/list"
//返回行业列表为二叉树形式
#define API_IndustryListII                   @"industry/get-industry-list"

//猜你喜欢
#define API_TaskPrefer                       @"req/recom/list-prefer"



//跑马灯 最新成交
#define API_Rolling                            @"req/search/list-bid-latest"

//跑马灯 最新成交
#define API_Banners                         @"req/recom/list-banner"

#pragma mark - 独立接口
#pragma mark 上传

#define API_Upload                           @"https://req.vsochina.com/cloud-file/upload?createFolder=true&overwritePolicy=1"
#define API_UploadForAuth                   @"file/index/upload"
//订阅新接口
#define API_SubscriptionUpdate              @"user/info/update-req-indus"
#define API_SubscriptionList                @"user/info/view-req-indus"


#endif /* API_h */
