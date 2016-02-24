package com.lht.jsbridge_lib.business.impl;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Bundle;
import android.os.Looper;
import android.os.Message;

import com.alibaba.fastjson.JSON;
import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
import com.lht.jsbridge_lib.business.API.NativeRet;
import com.lht.jsbridge_lib.business.API.NativeRet.NativeGpsRet;
import com.lht.jsbridge_lib.business.bean.BaseResponseBean;
import com.lht.jsbridge_lib.business.bean.GPSResponseBean;

/**
 * @ClassName: OpneGPSImpl
 * @Description: TODO
 * @date 2016年2月19日 上午9:22:49
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class OpenGPSImpl extends ABSLTRApiImpl implements API.GPSHandler {

	private final Context mContext;

	private CallBackFunction mFunction;

	public LocationClient mLocationClient = null;
	public MyLocationListener myListener = new MyLocationListenerImpl();

	public OpenGPSImpl(Context ctx) {
		this.mContext = ctx;
	}

	@SuppressLint("DefaultLocale")
	@Override
	public void handler(String data, CallBackFunction function) {
		mFunction = function;
		execute(getLTRExecutor());
	}

	@Override
	protected boolean isBeanError(Object o) {
		return BEAN_IS_CORRECT;
	}

	@Override
	protected LTRHandler getLTRHandler() {
		return new LTRHandler() {

			@Override
			public void onJobExecuted(String data) {
				Log("try callback" + data);

				mFunction.onCallBack(data);
			}

		};
	}

	@Override
	protected LTRExecutor getLTRExecutor() {
		return new GPSExecutor(getLTRHandler());
	}

	class GPSExecutor extends LTRExecutor {

		public GPSExecutor(LTRHandler h) {
			super(h);
		}

		@Override
		public void run() {
			Looper.prepare();
			mLocationClient = new LocationClient(mContext);
			myListener.setLTRHandler(this.mHandler);
			mLocationClient.registerLocationListener(myListener);

			mLocationClient.start();
			Looper.loop();
		}

	}

	interface MyLocationListener extends BDLocationListener {
		void setLTRHandler(LTRHandler h);
	}

	class MyLocationListenerImpl implements MyLocationListener {

		private LTRHandler handler;

		@Override
		public void setLTRHandler(LTRHandler h) {
			handler = h;
		}

		@Override
		public void onReceiveLocation(BDLocation location) {

			GPSResponseBean bean = new GPSResponseBean();
			bean.setTime(location.getTime());
			bean.setLongitude(String.valueOf(location.getLongitude()));
			bean.setLatitude(String.valueOf(location.getLatitude()));
			bean.setRadius(String.valueOf(location.getRadius()));

			String data = JSON.toJSONString(bean);

			BaseResponseBean baseResponseBean = new BaseResponseBean();
			baseResponseBean.setData(data);

			if (location.getLocType() == BDLocation.TypeGpsLocation) {
				baseResponseBean.setRet(NativeRet.RET_SUCCESS);
				baseResponseBean.setMsg("gps定位成功");

			} else if (location.getLocType() == BDLocation.TypeNetWorkLocation) {// 网络定位结果
				baseResponseBean.setRet(NativeRet.RET_SUCCESS);
				baseResponseBean.setMsg("网络定位成功");
			} else if (location.getLocType() == BDLocation.TypeOffLineLocation) {// 离线定位结果
				baseResponseBean.setRet(NativeRet.RET_SUCCESS);
				baseResponseBean.setMsg("离线定位成功");
			} else if (location.getLocType() == BDLocation.TypeServerError) {
				baseResponseBean.setRet(NativeGpsRet.RET_FAILURE);
				baseResponseBean.setMsg("服务端网络定位失败;");
			} else if (location.getLocType() == BDLocation.TypeNetWorkException) {
				baseResponseBean.setRet(NativeGpsRet.RET_FAILURE);
				baseResponseBean.setMsg("网络不同导致定位失败，请检查网络是否通畅");
			} else if (location.getLocType() == BDLocation.TypeCriteriaException) {
				baseResponseBean.setRet(NativeGpsRet.RET_FAILURE);
				baseResponseBean.setMsg("无法获取有效定位依据导致定位失败，一般是由于手机的原因");
			} else {
				baseResponseBean.setRet(NativeGpsRet.RET_FAILURE);
				baseResponseBean.setMsg("unknown error");
			}
			String response = JSON.toJSONString(baseResponseBean);
			// Log(response);
			Message msg = new Message();
			msg.what = LTRHandler.MSG_JOBEXECUTED;
			Bundle bundle = new Bundle();
			bundle.putString(LTRHandler.KEY_DATA, response);
			msg.setData(bundle);
			handler.sendMessage(msg);
		}
	}
}
