package com.lht.cloudjob.native4js;


import com.lht.lhtwebviewlib.base.Interface.BridgeHandler;

/**
 * <p><b>Package</b> com.lht.cloudjob.native4js
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> Native4JsExtendAPI
 * <p><b>Description</b>: 额外提供给js的扩展的API收纳，一般都是特殊业务或者存在模块依赖
 * Created by leobert on 2016/6/12.
 */
public interface Native4JsExtendAPI {

    interface ScanCodeHandler extends BridgeHandler {
        /**
         * API_NAME:扫码
         */
         String API_NAME = "NATIVE_FUNCTION_OPENCAMERA_SCAN";
    }
}
