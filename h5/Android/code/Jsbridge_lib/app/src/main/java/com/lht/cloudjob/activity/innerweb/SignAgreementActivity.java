package com.lht.cloudjob.activity.innerweb;

import android.content.res.Resources;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.daimajia.androidanimations.library.Techniques;
import com.daimajia.androidanimations.library.YoYo;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.interfaces.IPublicConst;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.mvp.presenter.SignAgreementPresenter;
import com.lht.cloudjob.mvp.viewinterface.ISignAgreementActivity;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.customwidgetlib.text.DrawableCenterTextView;


public class SignAgreementActivity extends InnerWebActivity implements View.OnClickListener, ISignAgreementActivity {

    private static final String PAGENAME = "SignAgreementActivity";
    public static final String KEY_TASK_BN = "task_bn";

    public static final String KEY_CANREFUSE = "can_refuse";

//    public static final String KEY_USERNAME = "username";
    private ProgressBar progressBar;
    private CheckBox cbProtocol;

//    @Deprecated
//    private TextView tvProtocol;

    private Button btnNotAgree;
    private DrawableCenterTextView dctvAgree;
    private String task_bn;
    private String username;
    private SignAgreementPresenter presenter;
    private boolean needDispatch = true;
    private String auth_token;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_delivery_agreement);

        initView();
        initVariable();
        initEvent();
        load();
    }

    private boolean canRefuse() {
        return getIntent().getBooleanExtra(KEY_CANREFUSE,false);
    }

    @Override
    protected void initView() {
        progressBar = (ProgressBar) findViewById(R.id.progressbar);
        cbProtocol = (CheckBox) findViewById(R.id.sign_agreement_cb_protocol);
//        tvProtocol = (TextView) findViewById(R.id.sign_agreement_tv_protocol);
        btnNotAgree = (Button) findViewById(R.id.btn_notagree_sign_agreement);
        dctvAgree = (DrawableCenterTextView) findViewById(R.id.dctv_agree_sign_agreement);

        super.initView();
    }

    @Override
    protected void initEvent() {
        super.initEvent();

        cbProtocol.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                YoYo.with(Techniques.Pulse).duration(300).playOn(cbProtocol);
                presenter.setIsProtocolAgreed(isChecked);
            }
        });

//        tvProtocol.setOnClickListener(this);
        if(canRefuse()) {
            btnNotAgree.setVisibility(View.VISIBLE);
            btnNotAgree.setOnClickListener(this);
        } else {
            btnNotAgree.setVisibility(View.GONE);
        }
        dctvAgree.setOnClickListener(this);

    }

    @Override
    protected WebView provideWebView() {
        WebView webSignAgreement = (WebView) findViewById(R.id.sign_agreement_webview);
        return webSignAgreement;
    }

    @Override
    protected ProgressBar provideProgressBar() {
        return progressBar;
    }

    private static final String MODEL_URL = IPublicConst.AGREEMENT_MODEL_URL;

    @Override
    protected String getUrl() {
// TODO: 2016/9/23
        DLog.d(getClass(), "task_bn:" + task_bn);
        DLog.d(getClass(), "username:" + username);
        DLog.d(getClass(), "auth_token:" + auth_token);

        return String.format(MODEL_URL, task_bn, auth_token, username);
//        return String.format(MODEL_URL, "9895615281537","ac8b064297755bd1a78d91c3b72ef015", "86170769");
    }

    @Override
    protected int getMyTitle() {
        return R.string.title_activity_sign_agreement;
    }

    @Override
    protected String getPageName() {
        return SignAgreementActivity.PAGENAME;
    }

    @Override
    public UMengActivity getActivity() {
        return SignAgreementActivity.this;
    }

    @Override
    protected void initVariable() {
        presenter = new SignAgreementPresenter(this);
        task_bn = getIntent().getStringExtra(KEY_TASK_BN);
        username = IVerifyHolder.mLoginInfo.getUsername();
        auth_token = IVerifyHolder.mLoginInfo.getAccessToken();

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
//            case R.id.sign_agreement_tv_protocol:
//                //用户协议
//                start(UserAgreementActivity.class);
//                break;
            case R.id.btn_notagree_sign_agreement:
                //不同意签署协议
                presenter.callAgreeSignagreement(task_bn, username, false);
                break;
            case R.id.dctv_agree_sign_agreement:
                //同意签署协议
                presenter.callAgreeSignagreement(task_bn, username, true);
                break;
            default:
                break;
        }
    }


    @Override
    public void showErrorMsg(String message) {
        showMsg(message);
    }

    @Override
    public void finishActivity() {
        finish();
    }

    @Override
    public ProgressBar getProgressBar() {
        return progressBar;
    }

    @Override
    public void setActiveStateOfDispatchOnTouch(boolean b) {
        needDispatch = b;
    }

    @Override
    public void showWaitView(boolean isProtectNeed) {
        getProgressBar().setVisibility(View.VISIBLE);
        getProgressBar().bringToFront();
        if (isProtectNeed)
            setActiveStateOfDispatchOnTouch(false);
    }

    @Override
    public void cancelWaitView() {
        getProgressBar().setVisibility(View.GONE);
        setActiveStateOfDispatchOnTouch(true);
    }

    @Override
    public Resources getAppResource() {
        return getResources();
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        if (needDispatch)
            return super.dispatchTouchEvent(ev);
        else
            return false;
    }

    @Override
    public void showMsg(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }
}
