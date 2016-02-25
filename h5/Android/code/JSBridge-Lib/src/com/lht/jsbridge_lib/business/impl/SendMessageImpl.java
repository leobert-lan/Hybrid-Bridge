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
import com.lht.jsbridge_lib.business.bean.SendMessageBean;

/**
 * @ClassName: DemoImpl
 * @Description: TODO
 * @date 2016年2月19日 下午4:11:26
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class SendMessageImpl extends ABSApiImpl implements API.SendMessageHandler {

	private final Context mContext;

	private CallBackFunction mFunction;

	public SendMessageImpl(Context mContext) {
		this.mContext = mContext;
	}

	@Override
	public void handler(String data, CallBackFunction function) {
		mFunction = function;

		SendMessageBean sendMessageBean = JSON.parseObject(data,
				SendMessageBean.class);
		boolean bool = isBeanError(sendMessageBean);

		if (!bool) {
			String message = sendMessageBean.getMessageContent();
			Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse("smsto:"
					+ sendMessageBean.getContacts()));
			intent.putExtra("sms_body", message);
			mContext.startActivity(intent);
			mContext.startActivity(intent);

			BaseResponseBean bean = new BaseResponseBean();
			bean.setRet(NativeRet.RET_SUCCESS);
			bean.setMsg("OK");
			bean.setData("");
			mFunction.onCallBack(JSON.toJSONString(bean));
		} 
	}

	@Override
	protected boolean isBeanError(Object o) {
		if (o instanceof SendMessageBean) {
			SendMessageBean bean = (SendMessageBean) o;
			if (TextUtils.isEmpty(bean.getContacts())) {
				Log.wtf(API_NAME,
						"41001,data error,check bean:" + JSON.toJSONString(bean));
				return BEAN_IS_ERROR;
			}
			if (TextUtils.isEmpty(bean.getMessageContent())) {
				Log.wtf(API_NAME,
						"41002,data error,check bean:" + JSON.toJSONString(bean));
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
