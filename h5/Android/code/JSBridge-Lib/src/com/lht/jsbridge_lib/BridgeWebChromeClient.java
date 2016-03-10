package com.lht.jsbridge_lib;

import android.view.View;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.ProgressBar;

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
	final BridgeWebView mWebView;

	public BridgeWebChromeClient(BridgeWebView webView) {
		mWebView = webView;
	}

	@Override
	public boolean onJsAlert(WebView view, String url, String message,
			final JsResult result) {
		JSAlertDialog dialog = new JSAlertDialog(view.getContext(), result);
		dialog.fixContent(message);
		dialog.show();
		return true;
	}

	@Override
	public void onProgressChanged(WebView view, int newProgress) {
		super.onProgressChanged(view, newProgress);

		ProgressBar pBar = mWebView.getProgressBar();
		if (null != pBar) {
			if (newProgress == 100) {
				pBar.setVisibility(View.INVISIBLE);
			} else {
				if (View.INVISIBLE == pBar.getVisibility()) {
					pBar.setVisibility(View.VISIBLE);
				}
				pBar.setProgress(newProgress);
			}
		}
	}

	@Override
	public boolean onJsBeforeUnload(WebView view, String url, String message,
			JsResult result) {
		return super.onJsBeforeUnload(view, url, message, result);
	}

	/**
	 * 覆盖默认的window.confirm展示界面
	 */
	@Override
	public boolean onJsConfirm(WebView view, String url, String message,
			final JsResult result) {
		JSConfirmDialog dialog = new JSConfirmDialog(view.getContext(), result);
		dialog.fixContent(message);
		dialog.show();

		return true;
	}

}
