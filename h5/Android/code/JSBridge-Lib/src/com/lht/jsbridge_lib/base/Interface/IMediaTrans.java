package com.lht.jsbridge_lib.base.Interface;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient.CustomViewCallback;

/**
 * @ClassName: IMediaTrans
 * @Description: TODO
 * @date 2016年3月9日 下午3:57:38
 * 
 * @author leobert.lan
 * @version 1.0
 */
public interface IMediaTrans {

	Activity getActivity();

	ViewGroup getFullViewContainer();

	void onHideCustomView();

	void onShowCustomView(View view, CustomViewCallback callback);

	public String AUTOLAYOUT_JS = "<script type=\"text/javascript\">"
			+ "var tables = document.getElementsByTagName('video');" + // 找到video标签
			"for(var i = 0; i<tables.length; i++){" + // 逐个改变
			"tables[i].style.width = '100%';" + // 宽度改为100%
			"tables[i].style.height = 'auto';" + "}" + "</script>";

}
