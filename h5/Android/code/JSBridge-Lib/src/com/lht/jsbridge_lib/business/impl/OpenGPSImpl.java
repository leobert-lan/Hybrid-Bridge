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
public class OpenGPSImpl extends ABSApiImpl implements API.GPSHandler {

	private LocationManager locationManager;

	private final Context mContext;
	
	private GPSResponseBean gpsResponseBean;

	public OpenGPSImpl(Context ctx) {
		this.mContext = ctx;
	}

	@SuppressLint("DefaultLocale")
	@Override
	public void handler(String data, CallBackFunction function) {
		// TODO Auto-generated method stub
		gpsResponseBean = new GPSResponseBean();
		
		locationManager = (LocationManager) mContext
				.getSystemService(Context.LOCATION_SERVICE);
		if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
			String ret = getLocation();
			if (ret != null)
				function.onCallBack(ret);
			else {
				Log.d(TAG, "gps location is null");
				function.onCallBack("gps location is null,error may happen on native");
			}
				
		} else {
			// 打开gps并获取位置
			Log.d(TAG, "gps not opened");
			toggleGPS();
			String ret = getLocation();
			if (ret != null)
				function.onCallBack(ret);
			else {
				Log.d(TAG, "gps location is null");
				function.onCallBack("gps location is null,error may happen on native");
			}
		}
		

//		function.onCallBack(data.toUpperCase());
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
			locationManager
					.requestLocationUpdates(LocationManager.NETWORK_PROVIDER,
							1000, 0, locationListener);
			Location location = locationManager
					.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
			if (location != null) {
				// latitude = location1.getLatitude(); // 经度
				// longitude = location1.getLongitude(); // 纬度
			}
		}
	}

	private String getLocation() {
		Location location = locationManager
				.getLastKnownLocation(LocationManager.GPS_PROVIDER);
		if (location != null) {
			gpsResponseBean.setLatitude(String.valueOf(location.getLatitude()));
			gpsResponseBean.setLongitude(String.valueOf(location.getLongitude()));
			return JSON.toJSONString(gpsResponseBean);
		} else {
			locationManager.requestLocationUpdates(
					LocationManager.GPS_PROVIDER, 1000, 0, locationListener);
			return null;
		}
	}

	LocationListener locationListener = new LocationListener() {

		@Override
		public void onLocationChanged(Location location) {
			// TODO Auto-generated method stub

		}

		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {
			// TODO Auto-generated method stub

		}

		@Override
		public void onProviderEnabled(String provider) {
			// TODO Auto-generated method stub

		}

		@Override
		public void onProviderDisabled(String provider) {
			// TODO Auto-generated method stub

		}
	};

}
