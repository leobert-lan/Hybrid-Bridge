//package com.lht.cloudjob.test.bridgewbv;
//
//import android.app.Activity;
//import android.content.Context;
//import android.os.Environment;
//import android.os.Bundle;
//import android.view.View;
//import android.view.ViewGroup;
//import android.widget.Button;
//import android.widget.FrameLayout;
//
//import com.alibaba.fastjson.JSON;
//import com.alibaba.fastjson.JSONObject;
//import com.lht.cloudjob.R;
//import com.lht.cloudjob.native4js.Native4JsExtendAPI;
//import com.lht.cloudjob.native4js.impl.ScanCodeImpl;
//import com.lht.cloudjob.util.debug.DLog;
//import com.lht.jsbridge_lib.BridgeWebView;
//import com.lht.jsbridge_lib.DefaultHandler;
//import com.lht.jsbridge_lib.base.IMediaTransImpl;
//import com.lht.jsbridge_lib.base.Interface.BridgeHandler;
//import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
//import com.lht.jsbridge_lib.business.API.API;
//import com.lht.jsbridge_lib.business.API.NativeRet;
//import com.lht.jsbridge_lib.business.bean.BaseResponseBean;
//import com.lht.jsbridge_lib.business.impl.CallTelImpl;
//import com.lht.jsbridge_lib.business.impl.CopyToClipboardImpl;
//import com.lht.jsbridge_lib.business.impl.DemoImpl;
//import com.lht.jsbridge_lib.business.impl.SendEmailImpl;
//import com.lht.jsbridge_lib.business.impl.SendMessageImpl;
//import com.lht.jsbridge_lib.business.impl.TestLTRImpl;
//
//public class TestBridgeWebviewActivity extends Activity implements View.OnClickListener {
//
//    private final String TAG = "TestBridgeWebview";
//
//    BridgeWebView webView;
//
//    Button button;
//    Button btnMeida;
//    Button sinaLogin;
//
//    Context mContext;
//
////	private QQLogin mQQlogin;
//
//    private ViewGroup fullContainer;
//
//    private FrameLayout videoView;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_test_bridge_webview);
//
//        DLog.d(getClass(), "onCreate");
//
//        mContext = this;
//        String abs = Environment.getExternalStorageDirectory()
//                .getAbsolutePath();
//        DLog.d(getClass(), abs);
////		mQQlogin = new QQLogin(mContext);
//
//        webView = (BridgeWebView) findViewById(R.id.webView);
//
//        fullContainer = (ViewGroup) findViewById(R.id.full_container);
//        videoView = (FrameLayout) findViewById(R.id.video_fullView);
//
//        button = (Button) findViewById(R.id.button);
//        btnMeida = (Button) findViewById(R.id.testMedia);
//        sinaLogin = (Button) findViewById(R.id.sinaLogin);
//
//        button.setOnClickListener(this);
//        btnMeida.setOnClickListener(this);
//        sinaLogin.setOnClickListener(this);
//        findViewById(R.id.testVirClose).setOnClickListener(this);
//        findViewById(R.id.testModeSwitch).setOnClickListener(this);
//
//        webView.setDefaultHandler(new DefaultHandler());
//
//        // Test TODO
//        webView.setIMediaTrans(new IMediaTransImpl(this, videoView,
//                fullContainer));
//
//        // ===================================
//
//        String localTestUri2 = "file:///android_asset/ExampleApp.html";
//
//        webView.loadUrl(localTestUri2);
//
//        webView.registerHandler("submitFromWeb", new BridgeHandler() {
//
//            @Override
//            public void handler(String data, CallBackFunction function) {
//                DLog.i(getClass(), "handler = submitFromWeb, data from web = " + data);
//                function.onCallBack("submitFromWeb exe, response data 中文 from Java");
//            }
//
//        });
//
//        // test screen temp
//        webView.registerHandler(API.Demo.API_NAME, new DemoImpl(TestBridgeWebviewActivity.this));
//
////		webView.registerHandler(GPSHandler.API_NAME, new OpenGPSImpl(
////				TestBridgeWebviewActivity.this));
//
//        webView.registerHandler(API.TestLTRHandler.API_NAME, new TestLTRImpl());
//
//        webView.registerHandler(API.CallTelHandler.API_NAME, new CallTelImpl(
//                TestBridgeWebviewActivity.this));
//
//        webView.registerHandler(API.SendToClipBoardHandler.API_NAME,
//                new CopyToClipboardImpl(TestBridgeWebviewActivity.this));
//
//        // TODO
//        webView.registerHandler(API.GetClipBoardContentHandler.API_NAME,
//                new CopyToClipboardImpl(TestBridgeWebviewActivity.this));
//
//        // TODO
//        webView.registerHandler(API.SendEmailHandler.API_NAME, new SendEmailImpl(
//                TestBridgeWebviewActivity.this));
//
//        // TODO
//        webView.registerHandler(API.SendMessageHandler.API_NAME,
//                new SendMessageImpl(TestBridgeWebviewActivity.this));
//
//		webView.registerHandler(Native4JsExtendAPI.ScanCodeHandler.API_NAME, new ScanCodeImpl(
//                TestBridgeWebviewActivity.this));
//
////		webView.registerHandler(ThirdPartyLoginHandler.API_Name,
////				new ThirdPartyLoginImpl(TestBridgeWebviewActivity.this));
//
//        testCallJs();
//    }
//
//    @Override
//    public void onClick(View v) {
//
//        switch (v.getId()) {
//            case R.id.button:
//                if (button.equals(v)) {
//                    JSONObject jObj = new JSONObject();
//                    jObj.put("Nkey1", "Nvalue1");
//                    webView.callJsDemo(JSON.toJSONString(jObj),
//                            new CallBackFunction() {
//                                @Override
//                                public void onCallBack(String data) {
//                                    DLog.d(getClass(), "receive from js:" + data);
//                                }
//                            });
//                }
//                break;
//            case R.id.testMedia:
//
//                webView.loadUrl("http://172.16.7.140/MediaTest/test/test.html");
//
//                // mQQlogin.setQQLogin();
//                // mQQlogin.setCallback(new QQUserInfoCallBack() {
//                // @Override
//                // public void onSuccess(String info) {
//                // Toast.makeText(mContext, info.toString(),
//                // Toast.LENGTH_SHORT).show();
//                // BaseResponseBean bean = new BaseResponseBean();
//                // bean.setRet(NativeRet.RET_SUCCESS);
//                // bean.setMsg("OK");
//                // bean.setData("");
//                // webView.callJsThirdLogin(JSON.toJSONString(bean), new
//                // CallBackFunction() {
//                // @Override
//                // public void onCallBack(String data) {
//                // Log.i(TAG, data);
//                // }
//                // });
//                // }
//                // });
//                break;
//            case R.id.sinaLogin:
//                BaseResponseBean bean = new BaseResponseBean();
//                bean.setRet(NativeRet.RET_SUCCESS);
//                bean.setMsg("OK");
//                bean.setData("deprecate");
//                webView.callJsThirdLogin(JSON.toJSONString(bean),
//                        new CallBackFunction() {
//                            @Override
//                            public void onCallBack(String data) {
//                                DLog.i(getClass(), data);
//                            }
//                        });
//                break;
//
//            case R.id.testVirClose:
//                webView.callJsCloseVirtualAppSession();
//                break;
//            case R.id.testModeSwitch:
//                Object obj = v.getTag();
//                boolean b = obj == null ? true : false;
//                webView.callJsSetVirturlAppTouchDragMode(b);
//                v.setTag(!b);
//                break;
//            default:
//                break;
//        }
//    }
//
//
//    private void testCallJs() {
//        // User user = new User();
//        // Location location = new Location();
//        // location.address = "SDU";
//        // user.location = location;
//        // user.name = "大头鬼";
//        // webView.callHandler("functionInJs", new Gson().toJson(user),
//        // new CallBackFunction() {
//        // @Override
//        // public void onCallBack(String data) {
//        //
//        // }
//        // });
//        //
//        // webView.send("hello");
//    }
//
//    static class Location {
//        String address;
//    }
//
//    static class User {
//        String name;
//        Location location;
//        String testStr;
//    }
//}
