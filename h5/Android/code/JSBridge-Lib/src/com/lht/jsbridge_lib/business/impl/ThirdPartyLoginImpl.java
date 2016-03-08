package com.lht.jsbridge_lib.business.impl;

import java.util.Map;
import java.util.Set;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
import com.lht.jsbridge_lib.business.API.NativeRet;
import com.lht.jsbridge_lib.business.bean.BaseResponseBean;
import com.lht.jsbridge_lib.business.bean.LoginStatusBean;
import com.lht.jsbridge_lib.demo.MainActivity;
import com.lht.jsbridge_lib.demo.QQLogin;
import com.lht.jsbridge_lib.demo.QQLogin.QQUserInfoCallBack;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.UMAuthListener;
import com.umeng.socialize.controller.listener.SocializeListeners.UMDataListener;
import com.umeng.socialize.exception.SocializeException;
import com.umeng.socialize.sso.UMQQSsoHandler;

/**
 * @ClassName: ThirdPartyLoginImpl
 * @Description: TODO
 * @date 2016年2月26日 下午5:10:41
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class ThirdPartyLoginImpl extends ABSLTRApiImpl implements
		API.ThirdPartyLoginHandler {
	
	//Attention activity向此处通信使用广播，
	private Context mContext;
	
	private CallBackFunction mBackFunction;
	
	public ThirdPartyLoginImpl(Context mContext) {
		super();
		this.mContext = mContext;
	}

	@Override
	public void handler(String data, CallBackFunction function) {
		
		mBackFunction = function;
		LoginStatusBean loginStatusBean = JSON.parseObject(data, LoginStatusBean.class);
		String loginStatus = loginStatusBean.getType();
		if (loginStatus.equals("1")) {
			QQLogin qqLogin = new QQLogin(mContext);
			qqLogin.setCallback(qqUserInfo);
			qqLogin.setQQLogin();
		}else if(loginStatus.equals("2")) {
			
		}
	}

	QQUserInfoCallBack qqUserInfo = new QQUserInfoCallBack() {
		
		@Override
		public void onSuccess(String info) {
			Toast.makeText(mContext, info.toString(), Toast.LENGTH_SHORT).show();
			BaseResponseBean bean = new BaseResponseBean();
			bean.setRet(NativeRet.RET_SUCCESS);
			bean.setMsg("OK");
			bean.setData("");
			mBackFunction.onCallBack(JSON.toJSONString(bean));
		}
	};
	
	@Override
	protected LTRHandler getLTRHandler() {
		return null;
	}

	@Override
	protected LTRExecutor getLTRExecutor() {
		return null;
	}

	@Override
	protected boolean isBeanError(Object o) {
		return false;
	}

}
