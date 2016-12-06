package com.lht.cloudjob.native4js;


import com.lht.lhtwebviewlib.base.Interface.BridgeHandler;

/**
 * <p><b>Package</b> com.lht.cloudjob.native4js
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> Native4JsExtendAPI
 * <p><b>Description</b>: 额外提供给js的扩展的API收纳，一般都是特殊业务或者存在模块依赖
 * Created by leobert on 2016/6/12.
 */
public interface Native4JsExpandAPI {

    interface VsoAuthInfoHandler extends BridgeHandler {
        /**
         * API_NAME:获取vso验证信息方法
         */
         String API_NAME = "APP_N_PUBLIC_SIGN_AUTHINFO";
    }

    interface VsoLoginHandler extends BridgeHandler {
        /**
         * API_NAME:vso登录
         */
        String API_NAME = "APP_N_PUBLIC_SIGN_LOGIN";
    }

    interface DownloadHandler extends BridgeHandler {
        /**
         * API_NAME:下载
         */
        String API_NAME = "APP_N_TOOLS_LOAD_FILE";
    }
}
