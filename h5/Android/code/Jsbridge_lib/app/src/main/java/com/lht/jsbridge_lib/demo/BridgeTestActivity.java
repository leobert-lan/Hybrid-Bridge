package com.lht.jsbridge_lib.demo;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.Switch;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.BuildConfig;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.native4js.impl.DownloadImpl;
import com.lht.cloudjob.native4js.impl.VsoAuthInfoImpl;
import com.lht.cloudjob.native4js.impl.VsoLoginImpl;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.customwidgetlib.nestedscroll.AttachUtil;
import com.lht.customwidgetlib.nestedscroll.NestedScrollLayout;
import com.lht.lhtwebviewapi.business.API.API;
import com.lht.lhtwebviewapi.business.API.API.Demo;
import com.lht.lhtwebviewapi.business.API.API.GetClipBoardContentHandler;
import com.lht.lhtwebviewapi.business.API.API.SendEmailHandler;
import com.lht.lhtwebviewapi.business.API.API.SendMessageHandler;
import com.lht.lhtwebviewapi.business.API.API.SendToClipBoardHandler;
import com.lht.lhtwebviewapi.business.API.API.TestLTRHandler;
import com.lht.lhtwebviewapi.business.impl.CopyToClipboardImpl;
import com.lht.lhtwebviewapi.business.impl.DemoImpl;
import com.lht.lhtwebviewapi.business.impl.MakePhoneCallImpl;
import com.lht.lhtwebviewapi.business.impl.ScanCodeImpl;
import com.lht.lhtwebviewapi.business.impl.SendEmailImpl;
import com.lht.lhtwebviewapi.business.impl.SendMessageImpl;
import com.lht.lhtwebviewapi.business.impl.TestLTRImpl;
import com.lht.lhtwebviewlib.BridgeWebView;
import com.lht.lhtwebviewlib.DefaultHandler;
import com.lht.lhtwebviewlib.FileChooseBridgeWebChromeClient;
import com.lht.lhtwebviewlib.base.Interface.CallBackFunction;
import com.lht.lhtwebviewlib.base.Interface.IFileChooseSupport;
import com.lht.lhtwebviewlib.base.LhtWebViewNFLoader;

public class BridgeTestActivity extends BaseActivity implements OnClickListener {

    private final String TAG = "BridgeTestActivity";

    private static final String DEF_TEST = "http://m.vsochina.com:8080/bridge/test/";

    BridgeWebView webView;

    private EditText etUrl;
    Button btnGoto;
    Button btnLoadDefault;

    Context mContext;

    private NestedScrollLayout nestedScrollLayout;

    private IFileChooseSupport.DefaultFileChooseSupportImpl defaultFileChooseSupport;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test_bridge);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        Log.d(TAG, "onCreate,debug mode:" + BuildConfig.DEBUG);
        mContext = this;
//        String abs = Environment.getExternalStorageDirectory()
//                .getAbsolutePath();
//        Log.d(TAG, abs);
        defaultFileChooseSupport = new IFileChooseSupport.DefaultFileChooseSupportImpl(this);

        BridgeWebView.setDebugMode(BuildConfig.DEBUG);
        etUrl = (EditText) findViewById(R.id.et_url);
        webView = (BridgeWebView) findViewById(R.id.webView);

        btnGoto = (Button) findViewById(R.id.button);
        btnLoadDefault = (Button) findViewById(R.id.btn_def);
        nestedScrollLayout = (NestedScrollLayout) findViewById(R.id.nsl);

        btnGoto.setOnClickListener(this);
        btnLoadDefault.setOnClickListener(this);

        webView.setDefaultHandler(new DefaultHandler());
        webView.setWebChromeClient(new FileChooseBridgeWebChromeClient(defaultFileChooseSupport));


        // Test TODO
//		webView.setIMediaTrans(new IMediaTransImpl(this, videoView,
//				fullContainer));
        // ===================================

        Switch debugModeSwitcher = (Switch) findViewById(R.id.switch_debug);
        debugModeSwitcher.setChecked(true);
        debugModeSwitcher.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                BridgeWebView.setDebugMode(isChecked);
            }
        });

        webView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                boolean isTop = AttachUtil.isWebViewAttach(webView);
                nestedScrollLayout.setTouchMode(isTop);
                return false;
            }
        });
        initEvent();


    }

    private void regist() {

        // test screen temp
        webView.registerHandler(Demo.API_NAME, new DemoImpl(BridgeTestActivity.this));

        LhtWebViewNFLoader.with(webView)
                .equip(VsoAuthInfoImpl.newInstance())//Auth信息
                .equip(VsoLoginImpl.newInstance(BridgeTestActivity.this))//Vso登录
                .equip(MakePhoneCallImpl.newInstance(BridgeTestActivity.this))//makePhoneCall
                .load();

        webView.registerHandler(TestLTRHandler.API_NAME, new TestLTRImpl());


        webView.registerHandler(SendToClipBoardHandler.API_NAME,
                new CopyToClipboardImpl(BridgeTestActivity.this));

        webView.registerHandler(GetClipBoardContentHandler.API_NAME,
                new CopyToClipboardImpl(BridgeTestActivity.this));

        webView.registerHandler(SendEmailHandler.API_NAME, new SendEmailImpl(
                BridgeTestActivity.this));

        webView.registerHandler(SendMessageHandler.API_NAME,
                new SendMessageImpl(BridgeTestActivity.this));

        webView.registerHandler(API.ScanCodeHandler.API_NAME, new ScanCodeImpl(
                BridgeTestActivity.this));

        webView.registerHandler(API.DownloadHandler.API_NAME,
                new DownloadImpl(BridgeTestActivity.this));
    }

    @Override
    protected void onPause() {
        super.onPause();
        webView.onPause();
    }

    @Override
    protected String getPageName() {
        return "BridgeTestActivity";
    }

    @Override
    public UMengActivity getActivity() {
        return BridgeTestActivity.this;
    }

    @Override
    protected void initView() {

    }

    @Override
    protected void initVariable() {

    }

    @Override
    protected void initEvent() {
        regist();
        webView.loadUrl(DEF_TEST);
        findViewById(R.id.test_search).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                testSearch();
            }
        });
    }

    private void testSearch() {
        WebSearchReqBean bean = new WebSearchReqBean();
        bean.setDirection("ASC");
        bean.setKeyword("3d");
        bean.setPno(0);
        bean.setOrder("sub_end_time");
        webView.callHandler(WebSearchReqBean.API_NAME, JSON.toJSONString(bean), new CallBackFunction() {
            @Override
            public void onCallBack(String s) {
                DLog.d(BridgeTestActivity.class,"call web search,response\r"+s);
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        webView.onResume();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        defaultFileChooseSupport.onActivityResult(requestCode, resultCode, data);
        super.onActivityResult(requestCode, resultCode, data);
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

}
