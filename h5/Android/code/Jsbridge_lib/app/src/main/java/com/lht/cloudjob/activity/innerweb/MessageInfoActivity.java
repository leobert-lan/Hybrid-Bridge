package com.lht.cloudjob.activity.innerweb;

import android.os.Bundle;
import android.webkit.WebView;
import android.widget.ProgressBar;

import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;

public class MessageInfoActivity extends InnerWebActivity {

    public static final String KEY_DATA = "_key_url";
    private static final String PAGENAME= "MessageInfoActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initView();
        initVariable();
        initEvent();
        load();
    }

    @Override
    protected String getPageName() {
        return MessageInfoActivity.PAGENAME;
    }

    @Override
    public UMengActivity getActivity() {
        return MessageInfoActivity.this;
    }

    @Override
    protected void initVariable() {

    }

    @Override
    protected WebView provideWebView() {
        return null;
    }

    @Override
    protected ProgressBar provideProgressBar() {
        return null;
    }

    @Override
    protected String getUrl() {
        return getIntent().getStringExtra(KEY_DATA);
    }

    @Override
    protected int getMyTitle() {
        return R.string.title_activity_messageinfo;
    }
}
