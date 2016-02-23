package com.lht.jsbridge_lib.demo;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.lht.jsbridge_lib.BridgeWebView;
import com.lht.jsbridge_lib.DefaultHandler;
import com.lht.jsbridge_lib.R;
import com.lht.jsbridge_lib.base.Interface.BridgeHandler;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.impl.CallTelImpl;
import com.lht.jsbridge_lib.business.impl.CopyToClipboardImpl;
import com.lht.jsbridge_lib.business.impl.DemoImpl;
import com.lht.jsbridge_lib.business.impl.OpenGPSImpl;
import com.lht.jsbridge_lib.business.impl.TestLTRImpl;

public class MainActivity extends Activity implements OnClickListener {

	private final String TAG = "MainActivity";

	BridgeWebView webView;

	Button button;

	// int RESULT_CODE = 0;
	//
	// ValueCallback<Uri> mUploadMessage;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		webView = (BridgeWebView) findViewById(R.id.webView);

		button = (Button) findViewById(R.id.button);

		button.setOnClickListener(this);

		webView.setDefaultHandler(new DefaultHandler());

		// webView.setWebChromeClient(new WebChromeClient() {
		//
		//
		// @SuppressWarnings("unused")
		// public void openFileChooser(ValueCallback<Uri> uploadMsg,
		// String AcceptType, String capture) {
		// this.openFileChooser(uploadMsg);
		// }
		//
		// @SuppressWarnings("unused")
		// public void openFileChooser(ValueCallback<Uri> uploadMsg,
		// String AcceptType) {
		// this.openFileChooser(uploadMsg);
		// }
		//
		// public void openFileChooser(ValueCallback<Uri> uploadMsg) {
		// mUploadMessage = uploadMsg;
		// pickFile();
		// }
		// });

		String webTestUrl = "http://172.16.7.140/JsBridgeTest/demo.html";

		String localTestUri = "file:///android_asset/demo.html";

		String localTestUri2 = "file:///android_asset/ExampleApp.html";

		webView.loadUrl(localTestUri2);

		webView.registerHandler("submitFromWeb", new BridgeHandler() {

			@Override
			public void handler(String data, CallBackFunction function) {
				Log.i(TAG, "handler = submitFromWeb, data from web = " + data);
				function.onCallBack("submitFromWeb exe, response data 中文 from Java");
			}

		});

		webView.registerHandler(DemoImpl.API_NAME, new DemoImpl());

		webView.registerHandler(OpenGPSImpl.API_NAME, new OpenGPSImpl(MainActivity.this));
		
		webView.registerHandler(TestLTRImpl.API_NAME, new TestLTRImpl());

		webView.registerHandler(CallTelImpl.API_NAME, new CallTelImpl(MainActivity.this));
		
		webView.registerHandler(CopyToClipboardImpl.API_NAME, new CopyToClipboardImpl(MainActivity.this));
		
		testCallJs();
	}

	// public void pickFile() {
	//
	// Log.d(TAG, "pick file called");
	//
	// Intent chooserIntent = new Intent(Intent.ACTION_GET_CONTENT);
	// chooserIntent.setType("image/*");
	// startActivityForResult(chooserIntent, RESULT_CODE);
	//
	// }

	// @Override
	// protected void onActivityResult(int requestCode, int resultCode,
	// Intent intent) {
	// if (requestCode == RESULT_CODE) {
	// if (null == mUploadMessage) {
	// return;
	// }
	// Uri result = intent == null || resultCode != RESULT_OK ? null
	// : intent.getData();
	// mUploadMessage.onReceiveValue(result);
	// mUploadMessage = null;
	// }
	// }

	@Override
	public void onClick(View v) {
		if (button.equals(v)) {
			JSONObject jObj = new JSONObject();
			jObj.put("Nkey1", "Nvalue1");
			
			webView.callJsDemo(JSON.toJSONString(jObj), new CallBackFunction() {
				
				@Override
				public void onCallBack(String data) {
					// TODO Auto-generated method stub
					Log.d(TAG, "receive from js:"+data);
				}
			});
		}

	}

	private void testCallJs() {
		// User user = new User();
		// Location location = new Location();
		// location.address = "SDU";
		// user.location = location;
		// user.name = "大头鬼";
		// webView.callHandler("functionInJs", new Gson().toJson(user),
		// new CallBackFunction() {
		// @Override
		// public void onCallBack(String data) {
		//
		// }
		// });
		//
		// webView.send("hello");
	}

	static class Location {
		String address;
	}

	static class User {
		String name;
		Location location;
		String testStr;
	}

}
