package com.lht.jsbridge_lib.business.impl;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
import com.lht.jsbridge_lib.business.API.NativeRet;
import com.lht.jsbridge_lib.business.API.API.CallTelHandler;
import com.lht.jsbridge_lib.business.bean.BaseResponseBean;
import com.lht.jsbridge_lib.business.bean.CopyToClipboardBean;
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
public class SendEmailImpl extends ABSApiImpl implements API.CopyHandler {

	private final Context mContext;

	private CallBackFunction mFunction;

	public SendEmailImpl(Context mContext) {
		this.mContext = mContext;
	}

	@Override
	public void handler(String data, CallBackFunction function) {
		mFunction = function;

		CopyToClipboardBean copyClipboardBean = JSON.parseObject(data, CopyToClipboardBean.class);
		boolean bool = isBeanError(copyClipboardBean);

		if (!bool) {
			String clipBoard = copyClipboardBean.getContent();
			ClipboardManager myClipboardManager = (ClipboardManager) mContext
					.getSystemService(Context.CLIPBOARD_SERVICE);
			ClipData myClip;
			myClip = ClipData.newPlainText("text", clipBoard);
			myClipboardManager.setPrimaryClip(myClip);	
			
			BaseResponseBean bean = new BaseResponseBean();
			bean.setRet(NativeRet.NativeCopyToClipBorad.RET_SUCCESS);
			bean.setMsg("OK");
			bean.setData("");
			mFunction.onCallBack(JSON.toJSONString(bean));
		}else {
			
		}
	}

	@Override
	protected boolean isBeanError(Object o) {
		if (o instanceof CopyToClipboardBean) {
			CopyToClipboardBean bean = (CopyToClipboardBean) o;
			if (TextUtils.isEmpty(bean.getContent())) {
				Log.wtf(API_NAME,
						"501,data error,check bean:" + JSON.toJSONString(bean));
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
