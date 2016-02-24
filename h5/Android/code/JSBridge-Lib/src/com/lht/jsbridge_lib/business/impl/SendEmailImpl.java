package com.lht.jsbridge_lib.business.impl;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
import com.lht.jsbridge_lib.business.bean.SendEmailBean;

/**
 * @ClassName: DemoImpl
 * @Description: TODO
 * @date 2016年2月19日 下午4:11:26
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class SendEmailImpl extends ABSApiImpl implements API.SendEmailHandler {

	private final Context mContext;

	private CallBackFunction mFunction;

	public SendEmailImpl(Context mContext) {
		this.mContext = mContext;
	}

	@Override
	public void handler(String data, CallBackFunction function) {
		mFunction = function;

		SendEmailBean sendEmailBean = JSON.parseObject(data,
				SendEmailBean.class);
		boolean bool = isBeanError(sendEmailBean);

		if (!bool) {

			Intent myIntent = new Intent(android.content.Intent.ACTION_SEND);
			myIntent.setType("plain/text");
			myIntent.putExtra(android.content.Intent.EXTRA_EMAIL,
					sendEmailBean.getAddressee());
			myIntent.putExtra(android.content.Intent.EXTRA_TEXT,
					sendEmailBean.getMessage());
			mContext.startActivity(Intent.createChooser(myIntent, "请选择邮件"));

			BaseResponseBean bean = new BaseResponseBean();
			bean.setRet(NativeRet.NativeCopyToClipBorad.RET_SUCCESS);
			bean.setMsg("OK");
			bean.setData("");
			mFunction.onCallBack(JSON.toJSONString(bean));
		} else {

		}
	}

	@Override
	protected boolean isBeanError(Object o) {
		if (o instanceof SendEmailBean) {
			SendEmailBean bean = (SendEmailBean) o;
			if (TextUtils.isEmpty(bean.getAddressee().toString())) {
				Log.wtf(API_NAME,
						"501,data error,check bean:" + JSON.toJSONString(bean));
				return BEAN_IS_ERROR;
			}
//			if (Pattern.compile("^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$").matches(bean.getAddressee())) {
//				
//			}
			return BEAN_IS_CORRECT;

		} else {
			Log.wtf(API_NAME,
					"check you code,bean not match because your error");
			return BEAN_IS_ERROR;
		}
	}

//	private void checkEmail() {
//		String check = ;
//		Pattern regex = Pattern.compile(check);
//		Matcher matcher = regex.matcher("12241@qq.name");
//		boolean isMatched = matcher.matches();
//	}

}
