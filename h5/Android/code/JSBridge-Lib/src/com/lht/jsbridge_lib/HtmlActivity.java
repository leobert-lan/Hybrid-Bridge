package com.lht.jsbridge_lib;

import com.lht.jsbridge_lib.base.Interface.BridgeHandler;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.demo.BaseActivity;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.ProgressBar;

public class HtmlActivity extends BaseActivity implements OnClickListener {
	
	Button btnBack;
	BridgeWebView virtualPage;
	ProgressBar progress;
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
				WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.activity_html);
		
		btnBack = (Button) findViewById(R.id.back);
		progress = (ProgressBar) findViewById(R.id.progressBar);
		virtualPage = (BridgeWebView) findViewById(R.id.virtualPage);
		btnBack.setOnClickListener(this);
		
		virtualPage.setDefaultHandler(new DefaultHandler());
		String localTestUri2 = "http://www.baidu.com";
		virtualPage.loadUrl(localTestUri2);
		
		virtualPage.setProgressBar(progress);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.back:
			this.finish();
			break;
		default:
			break;
		}
	}
	
	@Override
	public void onBackPressed() {
		if (virtualPage.canGoBack()) {
			virtualPage.goBack();
		} else
			super.onBackPressed();
	}

}
