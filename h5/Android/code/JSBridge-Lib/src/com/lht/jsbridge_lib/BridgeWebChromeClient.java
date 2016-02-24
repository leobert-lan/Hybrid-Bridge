package com.lht.jsbridge_lib;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.DialogInterface.OnClickListener;
import android.content.DialogInterface.OnKeyListener;
import android.util.Log;
import android.view.KeyEvent;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebView;

/**
 * @ClassName: BridgeWebChoreClient
 * @Description: TODO
 * @date 2016年2月23日 下午4:21:49
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class BridgeWebChromeClient extends WebChromeClient {

	/**
	 * 覆盖默认的window.alert展示界面
	 */
	public boolean onJsAlert(WebView view, String url, String message,
			final JsResult result) {
		JSAlertDialog dialog = new JSAlertDialog(view.getContext(), result);
		dialog.fixContent(message);
		dialog.show();
		return true;
	}

	public boolean onJsBeforeUnload(WebView view, String url, String message,
			JsResult result) {
		return super.onJsBeforeUnload(view, url, message, result);
	}

	/**
	 * 覆盖默认的window.confirm展示界面
	 */
	public boolean onJsConfirm(WebView view, String url, String message,
			final JsResult result) {
		JSConfirmDialog dialog = new JSConfirmDialog(view.getContext(), result);
		dialog.fixContent(message);
		dialog.show();
		
		return true;
	}

}
