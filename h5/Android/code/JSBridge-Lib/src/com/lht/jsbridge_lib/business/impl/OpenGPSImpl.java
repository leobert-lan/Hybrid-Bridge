package com.lht.jsbridge_lib.business.impl;

import android.annotation.SuppressLint;
import android.app.PendingIntent;
import android.app.PendingIntent.CanceledException;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
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

	private LocationManager locationManager;

	private final Context mContext;

	private GPSResponseBean gpsResponseBean;

	private CallBackFunction mFunction;

	public OpenGPSImpl(Context ctx) {
		this.mContext = ctx;
	}

	@SuppressLint("DefaultLocale")
	@Override
	public void handler(String data, CallBackFunction function) {
		gpsResponseBean = new GPSResponseBean();
		mFunction = function;
		execute(getLTRExecutor());
	}

	@Override
	protected boolean isBeanError(Object o) {
		return BEAN_IS_CORRECT;
	}

	private void toggleGPS() {
		Intent gpsIntent = new Intent();
		gpsIntent.setClassName("com.android.settings",
				"com.android.settings.widget.SettingsAppWidgetProvider");
		gpsIntent.addCategory("android.intent.category.ALTERNATIVE");
		gpsIntent.setData(Uri.parse("custom:3"));
		try {
			Log.d(TAG, "call open");
			PendingIntent.getBroadcast(mContext, 0, gpsIntent, 0).send();
		} catch (CanceledException e) {
			e.printStackTrace();
		}
	}

	private String getLocation() {
		Location location = locationManager
				.getLastKnownLocation(LocationManager.GPS_PROVIDER);
		if (location != null) {
			gpsResponseBean.setLatitude(String.valueOf(location.getLatitude()));
			gpsResponseBean
					.setLongitude(String.valueOf(location.getLongitude()));
			return JSON.toJSONString(gpsResponseBean);
		} else {
			locationManager.requestLocationUpdates(
					LocationManager.GPS_PROVIDER, 1000, 0, locationListener);
			return null;
		}
	}

	LocationListener locationListener = new LocationListener() {

		/**
		 * 位置信息变化时触发
		 */
		public void onLocationChanged(Location location) {
			Log.i(TAG, "经度：" + location.getLongitude());
			Log.i(TAG, "纬度：" + location.getLatitude());
		}

		/**
		 * GPS状态变化时触发
		 */
		public void onStatusChanged(String provider, int status, Bundle extras) {
		}

		/**
		 * GPS开启时触发
		 */
		public void onProviderEnabled(String provider) {
			Location location = locationManager.getLastKnownLocation(provider);
			Log.i(TAG, "时间：" + location.getTime());
			Log.i(TAG, "经度：" + location.getLongitude());
			Log.i(TAG, "纬度：" + location.getLatitude());
			Log.i(TAG, "海拔：" + location.getAltitude());
		}

		/**
		 * GPS禁用时触发
		 */
		public void onProviderDisabled(String provider) {
			Log.i(TAG, "gps disabled");
		}
	};

	@Override
	protected LTRHandler getLTRHandler() {
		return new LTRHandler() {

			@Override
			public void onJobExecuted(String data) {
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
			locationManager = (LocationManager) mContext
					.getSystemService(Context.LOCATION_SERVICE);
			if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
				String ret = getLocation();
				if (ret != null)
					onJobExecuted(ret);
				else {
					Log.d(TAG, "gps location is null");
					new Handler().postDelayed(new Runnable() {
						@Override
						public void run() {
							String ret = getLocation();
							if (ret != null)
								onJobExecuted(ret);
							else
								onJobExecuted("gps location is null,error may happen on native");
						}
					}, 2000);
				}

			} else {
				// 打开gps并获取位置
				Log.d(TAG, "gps not opened");
				toggleGPS();
				new Handler().postDelayed(new Runnable() {
					@Override
					public void run() {
						String ret = getLocation();
						if (ret != null)
							onJobExecuted(ret);
						else
							onJobExecuted("gps location is null,error may happen on native");
					}
				}, 2000);
			}

			Looper.loop();
		}

	}

}
