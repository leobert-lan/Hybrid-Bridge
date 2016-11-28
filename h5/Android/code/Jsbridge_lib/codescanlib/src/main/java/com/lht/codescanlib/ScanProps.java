package com.lht.codescanlib;

import android.util.Log;

import com.zbar.lib.decode.InactivityTimer;

/** 
 * @ClassName: ScanProps 
 * @Description: 关键配置
 * @date 2016年3月15日 下午1:28:12
 *  
 * @author leobert.lan
 * @version 1.0
 */
public class ScanProps {
	
	private static final String tag  = "ScanProps";
	
	private static int scanMaxSeconds = -1;
	
//	private static String appKey = "";
	
	private static IScanResultHandler scanResultHandler = null;

	public static int getScanMaxSeconds() {
		return scanMaxSeconds;
	}

	public static void setScanMaxSeconds(int scanMaxSeconds) {
		if (scanMaxSeconds > 0) {
			ScanProps.scanMaxSeconds = scanMaxSeconds;
			InactivityTimer.getIScanMaxSecondsSetListener().onScanMaxSecondsSet(scanMaxSeconds);
		} else {
			Log.e(tag, "you should give a int larger than zero");
		}
		
	}

	public static IScanResultHandler getScanResultHandler() {
		return scanResultHandler;
	}

	public static void setScanResultHandler(IScanResultHandler scanResultHandler) {
		ScanProps.scanResultHandler = scanResultHandler;
	}

//	public static String getAppKey() {
//		return appKey;
//	}
//
//	public static void setAppKey(String appKey) {
//		ScanProps.appKey = appKey;
//	}
	
	

}
