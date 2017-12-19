//
//  API_WEB.h
//  HybridApp
//
//  Created by Qingyang on 16/11/30.
//  Copyright © 2016年 QY. All rights reserved.
//

#ifndef API_WEB_h
#define API_WEB_h

typedef void (^H5Listener)(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback);
typedef void (^H5Callback)(id bridge, id data, NetError *err);

//-------正式方法------//
#pragma mark - 调用Native事件
#define APP_N_PUBLIC_SIGN_AUTHINFO @"APP_N_PUBLIC_SIGN_AUTHINFO" //认证用户
#define APP_N_PUBLIC_SIGN_LOGIN @"APP_N_PUBLIC_SIGN_LOGIN" //登录




#pragma mark - 调用web事件
#define APP_W_REQ_SEARCH_LIST @"APP_W_REQ_SEARCH_LIST" //搜索

#endif /* API_WEB_h */
