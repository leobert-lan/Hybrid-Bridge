package com.lht.jsbridge_lib.business.impl;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
import com.lht.jsbridge_lib.business.bean.DemoBean;
import com.lht.jsbridge_lib.business.bean.PhoneNumBean;

/**
 * @ClassName: DemoImpl
 * @Description: TODO
 * @date 2016年2月19日 下午4:11:26
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class CallTelImpl extends ABSApiImpl implements API.CallTelHandler {

	private final Context mContext;

	private CallBackFunction mFunction;

	public CallTelImpl(Context mContext) {
		this.mContext = mContext;
	}

	@Override
	public void handler(String data, CallBackFunction function) {
		mFunction = function;

		PhoneNumBean phoneNumBean = JSON.parseObject(data, PhoneNumBean.class);
		
		boolean bool = isBeanError(phoneNumBean);
		if (!bool) {			
			String number = phoneNumBean.getTelphone();
			Intent intent = new Intent();
			intent.setAction(Intent.ACTION_DIAL);
			intent.setData(Uri.parse("tel:" + number));
			mContext.startActivity(intent);
			mFunction.onCallBack(CallTelHandler.API_NAME);
		}else{
			
		}
	}

	@Override
	protected boolean isBeanError(Object o) {
		
		return BEAN_IS_CORRECT;
	}

}
