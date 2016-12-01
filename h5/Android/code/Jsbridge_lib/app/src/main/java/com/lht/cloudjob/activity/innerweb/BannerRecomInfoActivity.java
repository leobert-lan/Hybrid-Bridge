package com.lht.cloudjob.activity.innerweb;

import android.os.Bundle;
import android.webkit.WebView;
import android.widget.ProgressBar;

import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;

public class BannerRecomInfoActivity extends InnerWebActivity {

    public static final String KEY_DATA = "_key_url";

    private static final String PAGENAME= "BannerRecomInfoActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initView();
        initVariable();
        initEvent();
        load();
    }

    /**
     * desc: 获取页面名称
     *
     * @return String
     */
    @Override
    protected String getPageName() {
        return BannerRecomInfoActivity.PAGENAME;
    }

    /**
     * desc: 获取activity
     */
    @Override
    public UMengActivity getActivity() {
        return BannerRecomInfoActivity.this;
    }

    /**
     * desc: 实例化必要的参数，以防止initEvent需要的参数空指针
     */
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
        return R.string.title_activity_banner_info;
    }
}
