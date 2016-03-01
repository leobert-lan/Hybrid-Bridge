package com.lht.jsbridge_lib.base.Interface;

/**
 * @ClassName: IJSFuncCollection
 * @Description: TODO
 * @date 2016年2月19日 下午5:17:09
 * 
 * @author leobert.lan
 * @version 1.0
 */
public interface IJSFuncCollection {
	public final String JF_DEMO = "JS_FUNCTION_DEMO";
	
	public final String JF_THIRDLOGIN="JS_FUNCTION_INJECTTHIRDPARTYLOGININFO";

	void callJsDemo(String data, CallBackFunction responseCallBack);

	void callJsThirdLogin(String data, CallBackFunction responseCallBack);
}
