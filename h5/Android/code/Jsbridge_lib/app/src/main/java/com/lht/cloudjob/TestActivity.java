package com.lht.cloudjob;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.DatePicker;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.activity.asyncprotected.AppCommentActivity;
import com.lht.cloudjob.activity.asyncprotected.AsyncProtectedActivity;
import com.lht.cloudjob.activity.asyncprotected.StaticPromoteActivity;
import com.lht.cloudjob.activity.others.SplashActivity;
import com.lht.cloudjob.customview.CustomProgressView;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.test.TestI18NActivity;
import com.lht.cloudjob.test.TestVideoActivity;
import com.lht.cloudjob.test.anim.TestAnimActivity;
import com.lht.cloudjob.test.codescan.TestScanActivity;
import com.lht.cloudjob.test.testbanner.TestBannerActivity;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.file.FileUtils;
import com.lht.cloudjob.util.time.TimeUtil;

import java.util.Locale;


public class TestActivity extends AsyncProtectedActivity implements View.OnClickListener {

    private LinearLayout ll;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test);
        ll = (LinearLayout) findViewById(R.id.test_ll);

        setOnClick2Child(ll);
    }

    @Override
    protected IApiRequestPresenter getApiRequestPresenter() {
        return null;
    }

    @Override
    protected String getPageName() {
        return "TestActivity";
    }

    @Override
    public UMengActivity getActivity() {
        return TestActivity.this;
    }

    @Override
    protected void initView() {

    }

    @Override
    protected void initVariable() {

    }

    @Override
    protected void initEvent() {

    }

    /**
     * @param viewGroup
     */
    private void setOnClick2Child(ViewGroup viewGroup) {
        int count = viewGroup.getChildCount();
        for (int i = 0; i < count; i++) {
            if (viewGroup.getChildAt(i) instanceof ViewGroup) {
                setOnClick2Child((ViewGroup) viewGroup.getChildAt(i));
            }
            //全部添加上
            viewGroup.getChildAt(i).setOnClickListener(this);
        }
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.test_main:
                start(SplashActivity.class);
//                intent = newDemandInfoTestIntent(testDemandId[0]);
//                startActivity(intent);
                break;
            case R.id.test_image_preview:
                break;
            case R.id.test_file_preview:
                break;
            case R.id.test_bwv:
//                start(TestBridgeWebviewActivity.class);
                break;
            case R.id.test_list:
                break;
            case R.id.test_ptr:
                start(AppCommentActivity.class);
                break;
            case R.id.test_banner:
                start(TestBannerActivity.class);
                break;
            case R.id.test_i18n:
                start(TestI18NActivity.class);
                break;
            case R.id.test_anim:
                start(TestAnimActivity.class);
                break;
            case R.id.test_scan:
                start(TestScanActivity.class);
                break;
            case R.id.test_video:
                start(TestVideoActivity.class);
                break;
            case R.id.test_pb:
//                testDateSelect();
                testPB();
                break;
            case R.id.test_promote:
                start(StaticPromoteActivity.class);
                break;
            default:
                break;
        }
    }

    private void testPB() {

        final String format = getString(R.string.v1020_dialog_preview_onmobile_toolarge);
        String s = String.format(Locale.ENGLISH, format, FileUtils.calcSize(2000));
        Toast.makeText(this, s, Toast.LENGTH_LONG).show();

        CustomProgressView customProgressView = new CustomProgressView(this);
        customProgressView.setProgress(10, 100);
        customProgressView.show();
    }

    private void testDateSelect() {
        DatePickerDialog.OnDateSetListener listener = new DatePickerDialog
                .OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                DLog.e(getClass(), "check date:" + String.format("%d-%d-%d", year, monthOfYear + 1,
                        dayOfMonth));
            }
        };

        DatePickerDialog dialog = TimeUtil.newDatePickerDialog(this, TimeUtil
                .getCurrentTimeInLong(), listener);
        dialog.show();
    }

//    private Intent newDemandInfoTestIntent(String demandId) {
//        Intent intent = new Intent(this, DemandInfoActivity.class);
//        DemandInfoActivityData data = new DemandInfoActivityData();
//        data.setDemandId(demandId);
//        data.setLoginInfo(IVerifyHolder.mLoginInfo);
//
//        intent.putExtra(DemandInfoActivity.KEY_DATA, JSON.toJSONString(data));
//        return intent;
//    }

    @Override
    public ProgressBar getProgressBar() {
        return null;
    }
}
