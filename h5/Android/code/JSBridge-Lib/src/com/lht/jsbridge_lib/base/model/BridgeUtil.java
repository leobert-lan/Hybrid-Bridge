package com.lht.jsbridge_lib.base.model;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import android.content.Context;
import android.util.Log;
import android.webkit.WebView;

public class BridgeUtil {
	private static final String TAG = "BridgeUtil";
	
	public final static String YY_OVERRIDE_SCHEMA = "yy://";
	public final static String YY_RETURN_DATA = YY_OVERRIDE_SCHEMA + "return/";
	// 格式为
	// yy://return/{function}/returncontent
	public final static String YY_FETCH_QUEUE = YY_RETURN_DATA + "_fetchQueue/";
	public final static String EMPTY_STR = "";
	public final static String UNDERLINE_STR = "_";
	public final static String SPLIT_MARK = "/";

	public final static String CALLBACK_ID_FORMAT = "JAVA_CB_%s";
	
	/**
	 * JS_HANDLE_MESSAGE_FROM_JAVA:格式化格式，作用：
	 * DOM中已经有一个注册过的方法
	 * 将string格式的json 作为对象写入这个方法，本质是修改DOM
	 * 然后Native再调用该方法，使得数据被加载
	 */
	public final static String JS_HANDLE_MESSAGE_FROM_JAVA = "javascript:WebViewJavascriptBridge._handleMessageFromNative('%s');";
	
	public final static String JS_FETCH_QUEUE_FROM_JAVA = "javascript:WebViewJavascriptBridge._fetchQueue();";
	
	public final static String JAVASCRIPT_STR = "javascript:";

	public static String parseFunctionName(String jsUrl) {
		return jsUrl.replace("javascript:WebViewJavascriptBridge.", "")
				.replaceAll("\\(.*\\);", "");
	}

	public static String getDataFromReturnUrl(String url) {
		if (url.startsWith(YY_FETCH_QUEUE)) {
			return url.replace(YY_FETCH_QUEUE, EMPTY_STR);
		}

		String temp = url.replace(YY_RETURN_DATA, EMPTY_STR);
		String[] functionAndData = temp.split(SPLIT_MARK);

		if (functionAndData.length >= 2) {
			StringBuilder sb = new StringBuilder();
			for (int i = 1; i < functionAndData.length; i++) {
				sb.append(functionAndData[i]);
			}
			return sb.toString();
		}
		return null;
	}

	public static String getFunctionFromReturnUrl(String url) {
		String temp = url.replace(YY_RETURN_DATA, EMPTY_STR);
		Log.d(TAG,"formated url to get functionname:\r\n"+temp);
		String[] functionAndData = temp.split(SPLIT_MARK);
		if (functionAndData.length >= 1) {
			Log.d(TAG,"check function:"+functionAndData[0]);
			
			return functionAndData[0];
		}
		return null;
	}

	/**
	 * js 文件将注入为第一个script引用
	 * 
	 * @param view
	 * @param url
	 */
	public static void webViewLoadJs(WebView view, String url) {
		String js = "var newscript = document.createElement(\"script\");";
		js += "newscript.src=\"" + url + "\";";
		js += "document.scripts[0].parentNode.insertBefore(newscript,document.scripts[0]);";
		view.loadUrl("javascript:" + js);
	}

	public static void webViewLoadLocalJs(WebView view, String path) {
		String jsContent = assetFile2Str(view.getContext(), path);
		view.loadUrl("javascript:" + jsContent);
	}

	/** 
	 * @Title: assetFile2Str 
	 * @Description: 将assets文本资源转为string
	 * @author: leobert.lan
	 * @param c
	 * 				上下文
	 * @param urlStr
	 * 				String格式的（assets目录下）文件路径
	 * @return    
	 */
	public static String assetFile2Str(Context c, String urlStr) {
		InputStream in = null;
		try {
			in = c.getAssets().open(urlStr);
			BufferedReader bufferedReader = new BufferedReader(
					new InputStreamReader(in));
			String line = null;
			StringBuilder sb = new StringBuilder();
			do {
				line = bufferedReader.readLine();
				if (line != null && !line.matches("^\\s*\\/\\/.*")) {
					sb.append(line);
				}
			} while (line != null);

			bufferedReader.close();
			in.close();

			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
				}
			}
		}
		return null;
	}
}
