package com.lht.jsbridge_lib.business.impl;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Looper;

import com.alibaba.fastjson.JSON;
import com.lht.jsbridge_lib.ApiUtil.Scan.MipcaActivityCapture;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
import com.lht.jsbridge_lib.business.API.NativeRet;
import com.lht.jsbridge_lib.business.API.NativeRet.NativeScanCodeRet;
import com.lht.jsbridge_lib.business.bean.BaseResponseBean;
import com.lht.jsbridge_lib.business.bean.ScanCodeResponseBean;

/**
 * @ClassName: ScanCodeImpl
 * @Description: TODO
 * @date 2016年2月24日 上午10:17:01
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class ScanCodeImpl extends ABSLTRApiImpl implements API.ScanCodeHandler {

	private final Context mContext;

	private CallBackFunction mCallBackFunction;

	public ScanCodeImpl(Context ctx) {
		mContext = ctx;
	}

	@Override
	public void handler(String data, CallBackFunction function) {
		mCallBackFunction = function;
		execute(getLTRExecutor());
		Intent i = new Intent(mContext, MipcaActivityCapture.class);
		mContext.startActivity(i);
	}

	@Override
	protected LTRHandler getLTRHandler() {
		return new LTRHandler() {

			@Override
			public void onJobExecuted(String data) {
				Log("解除广播");
				mContext.unregisterReceiver(mReceiver);
				mCallBackFunction.onCallBack(data);
			}
		};
	}

	@Override
	protected LTRExecutor getLTRExecutor() {
		executor = new ScanCodeExecutor(getLTRHandler());
		return executor;
	}

	private LTRExecutor executor;

	@Override
	protected boolean isBeanError(Object o) {
		return false;
	}

	class ScanCodeExecutor extends LTRExecutor {

		public ScanCodeExecutor(LTRHandler h) {
			super(h);
		}

		@Override
		public void run() {
			Looper.prepare();
			IntentFilter intentFilter = new IntentFilter(
					MipcaActivityCapture.BROADCAST_ACTION);
			mContext.registerReceiver(mReceiver, intentFilter);
			Looper.loop();
		}

	}

	private BroadcastReceiver mReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			Log("receive broadcast");
			if (intent.getAction()
					.equals(MipcaActivityCapture.BROADCAST_ACTION)) {
				// TODO
				// 处理情况
				int scanResultCode = intent.getIntExtra(
						MipcaActivityCapture.RESULT_CODE,
						MipcaActivityCapture.SCAN_FAILURE);
				String data = intent
						.getStringExtra(MipcaActivityCapture.RESULT);
				ScanCodeResponseBean scanCodeResponseBean = new ScanCodeResponseBean();
				scanCodeResponseBean.setContent(data);
				switch (scanResultCode) {
				case MipcaActivityCapture.SCAN_OK:
					response(NativeRet.RET_SUCCESS, "success", data);
					break;
				case MipcaActivityCapture.SCAN_FAILURE:
					response(NativeScanCodeRet.RET_UNSUPPORT, "unsupported encoding type", data);
					break;
				case MipcaActivityCapture.SCAN_TIMEOUT:
					response(NativeScanCodeRet.RET_TIMEOUT, "scan time out", data);
					break;
				case MipcaActivityCapture.SCAN_CANCEL:
					response(ScanCodeResponseBean.RET_CANCEL, "scan canceled by user", data);
				default:
					break;
				}
				
			} else {
				Log("check broadcast,seem error!");
			}
		}
		
		private void response(int ret,String msg,String data) {
			BaseResponseBean bean = new BaseResponseBean();
			bean.setData(data);
			bean.setMsg(msg);
			bean.setRet(ret);
			executor.mHandler.onJobExecuted(JSON.toJSONString(bean));
		}
	};
}
