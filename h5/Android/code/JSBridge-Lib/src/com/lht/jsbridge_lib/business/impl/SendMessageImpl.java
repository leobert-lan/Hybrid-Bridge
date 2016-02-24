package com.lht.jsbridge_lib.business.impl;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
import com.lht.jsbridge_lib.business.API.NativeRet;
import com.lht.jsbridge_lib.business.bean.BaseResponseBean;
import com.lht.jsbridge_lib.business.bean.CopyToClipboardBean;
<<<<<<< HEAD
=======
import com.lht.jsbridge_lib.business.bean.DemoBean;
import com.lht.jsbridge_lib.business.bean.PhoneNumBean;
import com.lht.jsbridge_lib.business.bean.SendMessageBean;
>>>>>>> 5ea60f936592c6188004228c49d996fd00b97ee2

/**
 * @ClassName: DemoImpl
 * @Description: TODO
 * @date 2016年2月19日 下午4:11:26
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class SendMessageImpl extends ABSApiImpl implements API.SendMessage {

	private final Context mContext;

	private CallBackFunction mFunction;

	public SendMessageImpl(Context mContext) {
		this.mContext = mContext;
	}

	@Override
	public void handler(String data, CallBackFunction function) {
		mFunction = function;

<<<<<<< HEAD
		CopyToClipboardBean copyClipboardBean = JSON.parseObject(data,
				CopyToClipboardBean.class);
		boolean bool = isBeanError(copyClipboardBean);

		if (!bool) {
			String clipBoard = copyClipboardBean.getContent();
			ClipboardManager myClipboardManager = (ClipboardManager) mContext
					.getSystemService(Context.CLIPBOARD_SERVICE);
			ClipData myClip;
			myClip = ClipData.newPlainText("text", clipBoard);
			myClipboardManager.setPrimaryClip(myClip);
=======
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
>>>>>>> 5ea60f936592c6188004228c49d996fd00b97ee2

			BaseResponseBean bean = new BaseResponseBean();
			bean.setRet(NativeRet.RET_SUCCESS);
			bean.setMsg("OK");
			bean.setData("");
			mFunction.onCallBack(JSON.toJSONString(bean));
		} else {

		}
	}

	@Override
	protected boolean isBeanError(Object o) {
		if (o instanceof SendMessageBean) {
			SendMessageBean bean = (SendMessageBean) o;
			if (TextUtils.isEmpty(bean.getContacts())) {
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
