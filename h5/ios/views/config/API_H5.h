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

//调H5方法
#define JS_FUNCTION_DEMO @"JS_FUNCTION_DEMO"

//监听H5消息事件
#define NATIVE_FUNCTION_DEMO @"NATIVE_FUNCTION_DEMO"
#define NATIVE_FUNCTION_OPENCAMERA @"NATIVE_FUNCTION_OPENCAMERA"
#define NATIVE_FUNCTION_OPENGPS @"NATIVE_FUNCTION_OPENGPS"
#endif /* H5Constant_h */
