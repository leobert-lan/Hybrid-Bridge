package com.lht.jsbridge_lib.business.impl;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
import com.lht.jsbridge_lib.business.API.NativeRet;
import com.lht.jsbridge_lib.business.bean.BaseResponseBean;
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
			
			BaseResponseBean bean = new BaseResponseBean();
			bean.setRet(NativeRet.RET_SUCCESS);
			bean.setMsg("OK");
			bean.setData("");

			mFunction.onCallBack(JSON.toJSONString(bean));
		} else {
			//TODO 完善逻辑
		}
	}

	@Override
	protected boolean isBeanError(Object o) {
		if (o instanceof PhoneNumBean) {
			PhoneNumBean bean = (PhoneNumBean) o;
			if (TextUtils.isEmpty(bean.getTelphone())) {
				Log.wtf(API_NAME,
						"30001:data error,check bean:" + JSON.toJSONString(bean));
				return BEAN_IS_ERROR;
			}
			if (!bean.getTelphone().matches("[0-9]+")) {
				Log.wtf(API_NAME,
						"30002:data error,check bean:" + JSON.toJSONString(bean));
				return BEAN_IS_ERROR;
			}
			return BEAN_IS_CORRECT;
		} else {
			Log.wtf(API_NAME,
					"check you code,bean not match because your error");
			return BEAN_IS_ERROR;
		}
	}

}
