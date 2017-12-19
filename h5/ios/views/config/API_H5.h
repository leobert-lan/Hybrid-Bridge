//
//  H5Constant.h
//  H5
//
//  Created by Qingyang on 16/2/24.
//  Copyright © 2016年 Qingyang. All rights reserved.
//

#ifndef H5Constant_h
#define H5Constant_h

typedef void (^H5Listener)(id bridge, id data, NetError *err, WVJBResponseCallback responseCallback);
typedef void (^H5Callback)(id bridge, id data, NetError *err);

//-------正式方法------//
#pragma mark - 调用Native事件
#define APP_N_PUBLIC_SIGN_LOGIN @"APP_N_PUBLIC_SIGN_LOGIN"




#pragma mark - 调用web事件












//-------测试方法------//
//调H5方法
#define JS_FUNCTION_DEMO @"JS_FUNCTION_DEMO"

//监听H5消息事件
#define NATIVE_FUNCTION_DEMO @"NATIVE_FUNCTION_DEMO"
#define NATIVE_FUNCTION_OPENCAMERA @"NATIVE_FUNCTION_OPENCAMERA"
#define NATIVE_FUNCTION_OPENGPS @"NATIVE_FUNCTION_OPENGPS"
#define NATIVE_FUNCTION_OPENCAMERA_SCAN @"NATIVE_FUNCTION_OPENCAMERA_SCAN"
#define NATIVE_FUNCTION_THIRDPARTYLOGIN @"NATIVE_FUNCTION_THIRDPARTYLOGIN"
#define NATIVE_FUNCTION_THIRDPARTYLOGINSINA @"NATIVE_FUNCTION_THIRDPARTYLOGINSINA"
#define NATIVE_FUNCTION_THIRDPARTYLOGINWEIXIN @"NATIVE_FUNCTION_THIRDPARTYLOGINWEIXIN"
#define NATIVE_FUNCTION_THIRDPARTYShareQQ @"NATIVE_FUNCTION_THIRDPARTYShareQQ"
#define NATIVE_FUNCTION_THIRDPARTYShareSina @"NATIVE_FUNCTION_THIRDPARTYShareSina"
#define NATIVE_FUNCTION_THIRDPARTYShareWeixin @"NATIVE_FUNCTION_THIRDPARTYShareWeixin"



#endif /* H5Constant_h */
