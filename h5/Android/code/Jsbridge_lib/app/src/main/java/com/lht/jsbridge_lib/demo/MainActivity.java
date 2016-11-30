package com.lht.jsbridge_lib.demo;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

import com.lht.jsbridge_lib.BuildConfig;
import com.lht.jsbridge_lib.R;
import com.lht.lhtwebviewlib.BridgeWebView;
import com.lht.lhtwebviewlib.DefaultHandler;
import com.lht.lhtwebviewlib.base.Interface.BridgeHandler;
import com.lht.lhtwebviewlib.base.Interface.CallBackFunction;
import com.lht.lhtwebviewapi.business.API.API;
import com.lht.lhtwebviewapi.business.API.API.CallTelHandler;
import com.lht.lhtwebviewapi.business.API.API.Demo;
import com.lht.lhtwebviewapi.business.API.API.GetClipBoardContentHandler;
import com.lht.lhtwebviewapi.business.API.API.SendEmailHandler;
import com.lht.lhtwebviewapi.business.API.API.SendMessageHandler;
import com.lht.lhtwebviewapi.business.API.API.SendToClipBoardHandler;
import com.lht.lhtwebviewapi.business.API.API.TestLTRHandler;
import com.lht.lhtwebviewapi.business.impl.CallTelImpl;
import com.lht.lhtwebviewapi.business.impl.CopyToClipboardImpl;
import com.lht.lhtwebviewapi.business.impl.DemoImpl;
import com.lht.lhtwebviewapi.business.impl.SendEmailImpl;
import com.lht.lhtwebviewapi.business.impl.SendMessageImpl;
import com.lht.lhtwebviewapi.business.impl.TestLTRImpl;

import com.lht.lhtwebviewapi.business.impl.ScanCodeImpl;

public class MainActivity extends Activity implements OnClickListener {

    private final String TAG = "MainActivity";

    private static final String DEF_TEST = "http://app.vsochina.com/test/";

    BridgeWebView webView;

    private EditText etUrl;
    Button btnGoto;
    Button btnLoadDefault;

    Context mContext;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Log.d(TAG, "onCreate,debug mode:"+BuildConfig.DEBUG);

        mContext = this;
        String abs = Environment.getExternalStorageDirectory()
                .getAbsolutePath();
        Log.d(TAG, abs);

        BridgeWebView.setDebugMode(BuildConfig.DEBUG);

        etUrl = (EditText) findViewById(R.id.et_url);

        webView = (BridgeWebView) findViewById(R.id.webView);

        btnGoto = (Button) findViewById(R.id.button);
        btnLoadDefault = (Button) findViewById(R.id.btn_def);

        btnGoto.setOnClickListener(this);
        btnLoadDefault.setOnClickListener(this);

        webView.setDefaultHandler(new DefaultHandler());


        // Test TODO
//		webView.setIMediaTrans(new IMediaTransImpl(this, videoView,
//				fullContainer));

        // ===================================


        webView.loadUrl(DEF_TEST);

        webView.registerHandler("submitFromWeb", new BridgeHandler() {

            @Override
            public void handler(String data, CallBackFunction function) {
                Log.i(TAG, "handler = submitFromWeb, data from web = " + data);
                function.onCallBack("submitFromWeb exe, response data 中文 from Java");
            }

        });

        // test screen temp
        webView.registerHandler(Demo.API_NAME, new DemoImpl(MainActivity.this));

//		webView.registerHandler(GPSHandler.API_NAME, new OpenGPSImpl(
//				MainActivity.this));

        webView.registerHandler(TestLTRHandler.API_NAME, new TestLTRImpl());

        webView.registerHandler(CallTelHandler.API_NAME, new CallTelImpl(
                MainActivity.this));

        webView.registerHandler(SendToClipBoardHandler.API_NAME,
                new CopyToClipboardImpl(MainActivity.this));

        // TODO
        webView.registerHandler(GetClipBoardContentHandler.API_NAME,
                new CopyToClipboardImpl(MainActivity.this));

        // TODO
        webView.registerHandler(SendEmailHandler.API_NAME, new SendEmailImpl(
                MainActivity.this));

        // TODO
        webView.registerHandler(SendMessageHandler.API_NAME,
                new SendMessageImpl(MainActivity.this));

        webView.registerHandler(API.ScanCodeHandler.API_NAME, new ScanCodeImpl(
                MainActivity.this));

//		webView.registerHandler(ThirdPartyLoginHandler.API_Name,
//				new ThirdPartyLoginImpl(MainActivity.this));

        testCallJs();

    }

    @Override
    protected void onPause() {
        // TODO Auto-generated method stub
        super.onPause();
        webView.onPause();
    }

    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        webView.onResume();
    }


    @Override
    public void onClick(View v) {

        switch (v.getId()) {
            case R.id.button:
                webView.loadUrl(etUrl.getText().toString());
                break;
            case R.id.btn_def:
                webView.loadUrl(DEF_TEST);
                break;
            default:
                break;
        }
    }


    private void testCallJs() {
    }


}
