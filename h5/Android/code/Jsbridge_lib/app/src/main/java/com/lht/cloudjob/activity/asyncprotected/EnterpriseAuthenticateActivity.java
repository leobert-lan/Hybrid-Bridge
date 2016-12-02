package com.lht.cloudjob.activity.asyncprotected;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.View;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.clazz.OnCheckedChangeListenerImpl;
import com.lht.cloudjob.customview.CustomDialog;
import com.lht.cloudjob.customview.CustomPopupWindow;
import com.lht.cloudjob.customview.TitleBar;
import com.lht.cloudjob.fragment.FgEAuthenticPreview;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.mvp.model.bean.EAUModelBean;
import com.lht.cloudjob.mvp.model.bean.PAUModelBean;
import com.lht.cloudjob.mvp.presenter.EAuthenticateActivityPresenter;
import com.lht.cloudjob.mvp.viewinterface.IEnterpriseAuthenticateActivity;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.file.FileUtils;
import com.lht.cloudjob.util.string.StringUtil;
import com.lht.cloudjob.util.time.TimeUtil;
import com.lht.cloudjob.util.toast.ToastUtils;
import com.lht.customwidgetlib.actionsheet.ActionSheet;
import com.lht.customwidgetlib.actionsheet.OnActionSheetItemClickListener;
import com.squareup.picasso.Picasso;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

public class EnterpriseAuthenticateActivity extends AsyncProtectedActivity implements
        IEnterpriseAuthenticateActivity, View.OnClickListener {


    private static final String PAGENAME = "EnterpriseAuthenticateActivity";

    private TitleBar titleBar;

    private ImageView indicator1, indicator2, indicator3;

    /**
     * 港澳地区的区分显示
     */
    private TextView tvRegion;
    private TextView tvRegion2, tvValidity;
    private RelativeLayout rlErrorView;
    private EditText etInc, etName, etCode, etField;
    /**
     * 详细地址 大陆、台湾
     */
    private EditText etLocation;
    private String username;
    private LinearLayout llValidity;
    public static final String KEY_DATA = "_data_username";
    private View line1, line3, line6, line7, line8, line9;
    private EAuthenticateActivityPresenter presenter;
    private TextView tvStartTime;
    private TextView tvEndTime;
    private Button btnSubmit;
    private ProgressBar progressBar;
    private FgEAuthenticPreview fgEAuthenticPreview;
    private FrameLayout viewFragment;
    private ScrollView svEditContent;
    private LinearLayout llTabs;
    private LinearLayout llLicensePic;
    private ImageView ivLicensePic;

    private RadioButton tab1;
    private RadioButton tab2;
    private RadioButton tab3;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_enterprise_authenticate);
        username = getIntent().getStringExtra(KEY_DATA);
        fgEAuthenticPreview = new FgEAuthenticPreview();
        EventBus.getDefault().register(this);
        initView();
        initVariable();
        initEvent();
    }

    @Override
    protected String getPageName() {
        return EnterpriseAuthenticateActivity.PAGENAME;
    }

    @Override
    public UMengActivity getActivity() {
        return EnterpriseAuthenticateActivity.this;
    }

    @Override
    protected void initView() {
        titleBar = (TitleBar) findViewById(R.id.titlebar);
        rlErrorView = (RelativeLayout) findViewById(R.id.empty_view_content);
        progressBar = (ProgressBar) findViewById(R.id.progressbar);

        indicator1 = (ImageView) findViewById(R.id.pau_indicator1);
        indicator2 = (ImageView) findViewById(R.id.pau_indicator2);
        indicator3 = (ImageView) findViewById(R.id.pau_indicator3);

        tvRegion = (TextView) findViewById(R.id.eau_region);
        etInc = (EditText) findViewById(R.id.eau_et_inc);
        etName = (EditText) findViewById(R.id.eau_et_name);
        etCode = (EditText) findViewById(R.id.eau_et_code);
        etField = (EditText) findViewById(R.id.eau_et_field);
        tvRegion2 = (TextView) findViewById(R.id.eau_tv_region);
        etLocation = (EditText) findViewById(R.id.eau_et_destination);
        tvValidity = (TextView) findViewById(R.id.eau_tv_validity);
        llValidity = (LinearLayout) findViewById(R.id.eau_ll_validity);
        line1 = findViewById(R.id.line1);
        line3 = findViewById(R.id.line3);
        line6 = findViewById(R.id.line6);
        line7 = findViewById(R.id.line7);
        line8 = findViewById(R.id.line8);
        line9 = findViewById(R.id.line9);

        tab1 = (RadioButton) findViewById(R.id.perauth_tab1);
        tab2 = (RadioButton) findViewById(R.id.perauth_tab2);
        tab3 = (RadioButton) findViewById(R.id.perauth_tab3);

        llTabs = (LinearLayout) findViewById(R.id.perauth_tabs);
        viewFragment = (FrameLayout) findViewById(R.id.eau_fl_fragment);
        svEditContent = (ScrollView) findViewById(R.id.eau_sv_content);

        tvStartTime = (TextView) findViewById(R.id.eau_tv_starttime);
        tvEndTime = (TextView) findViewById(R.id.eau_tv_endtime);
        btnSubmit = (Button) findViewById(R.id.eau_btn_submit);

        llLicensePic = (LinearLayout) findViewById(R.id.eau_ll_license_pic);
        ivLicensePic = (ImageView) findViewById(R.id.eau_iv_license_pic);

        ArrayList<RadioButton> temp = new ArrayList<>();
        temp.add(tab1);
        temp.add(tab2);
        temp.add(tab3);

        init(temp);

    }

    @Override
    protected void initVariable() {
        presenter = new EAuthenticateActivityPresenter(this);
    }

    @Override
    protected void initEvent() {
        titleBar.setDefaultOnBackListener(getActivity());
        titleBar.setTitle(R.string.title_activity_enterpriseauthenticate);

        rlErrorView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                presenter.callEAuthenticStateQuery(username);
            }
        });

        tvRegion.setOnClickListener(this);
        tvRegion2.setOnClickListener(this);
        tvValidity.setOnClickListener(this);
        tvStartTime.setOnClickListener(this);
        tvEndTime.setOnClickListener(this);
        btnSubmit.setOnClickListener(this);

        llLicensePic.setOnClickListener(this);

        tab1.performClick();
    }

    String location;

    /**
     * 选择省市区的回调
     *
     * @param event
     */
    @Subscribe
    public void onEventMainThread(AppEvent.LocationPickedEvent event) {
        DLog.d(getClass(), "check location:" + JSON.toJSONString(event));
        if (event.isEmpty()) {
            //不处理
            return;
        }

        if (!StringUtil.isEmpty(event.getArea())) {
            String format = "%s-%s-%s";
            location = String.format(format, event.getProvince(), event.getCity(), event.getArea());
            presenter.updateProvince(event.getProvince());
            presenter.updateCity(event.getCity());
            presenter.updateArea(event.getArea());
        } else {
            String format = "%s-%s";
            location = String.format(format, event.getProvince(), event.getCity());
            presenter.updateProvince(event.getProvince());
            presenter.updateCity(event.getCity());
            presenter.updateArea("");
        }
        tvRegion2.setText(location);
    }

    /**
     * 重新认证事件回调
     *
     * @param event
     */
    @Subscribe
    public void onEventMainThread(AppEvent.ReEAuthEvent event) {
        presenter.setIsOnReAuth(true);
        hideFgPreview();
        showEditView();
        showUnAuthView(false);
    }

    @Subscribe
    public void onEventMainThread(AppEvent.ImageGetEvent event) {
        //处理照片获取并复制后的后续事件 压缩、显示...
        presenter.callResolveEvent(event);
    }

    @Override
    public ProgressBar getProgressBar() {
        return progressBar;
    }

    @Override
    protected IApiRequestPresenter getApiRequestPresenter() {
        return presenter;
    }

    private void init(ArrayList<RadioButton> temp) {
        HashMap<RadioButton, CompoundButton.OnCheckedChangeListener> map = new HashMap<>();
        for (RadioButton rb : temp) {
            map.put(rb, l);
        }
        View.OnClickListener listener = new OnCheckedChangeListenerImpl(map);
        for (RadioButton rb : temp) {
            rb.setOnClickListener(listener);
        }
    }

    CompoundButton.OnCheckedChangeListener l = new CompoundButton.OnCheckedChangeListener() {
        @Override
        public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
            switch (buttonView.getId()) {
                case R.id.perauth_tab1:
                    freshIndicator(indicator1, isChecked);
                    if (isChecked) {
                        switch2ML();
                    }
                    setData(EAUModelBean.AREA_ML, isChecked);
                    break;
                case R.id.perauth_tab2:
                    freshIndicator(indicator2, isChecked);
                    if (isChecked) {
                        switch2GA();
                    }
                    //初始化为未选取
                    setData(EAUModelBean.AREA_NULL, isChecked);
                    break;
                case R.id.perauth_tab3:
                    freshIndicator(indicator3, isChecked);
                    if (isChecked) {
                        switch2TW();
                    }
                    setData(EAUModelBean.AREA_TW, isChecked);
                    break;
                default:
                    break;
            }
        }
    };

    private void setData(int areaCode, boolean isChecked) {
        if (isChecked) {
            presenter.setArea(areaCode);
        }
    }

    private void switch2GA() {
        tvRegion.setVisibility(View.VISIBLE);
        line1.setVisibility(View.VISIBLE);
        etName.setVisibility(View.GONE);
        line3.setVisibility(View.GONE);
        etLocation.setVisibility(View.GONE);
        line6.setVisibility(View.GONE);
        tvRegion2.setVisibility(View.GONE);
        line7.setVisibility(View.GONE);
        tvValidity.setVisibility(View.GONE);
        line8.setVisibility(View.GONE);
        llValidity.setVisibility(View.GONE);
        line9.setVisibility(View.GONE);
    }

    private void switch2ML() {
        tvRegion.setVisibility(View.GONE);
        line1.setVisibility(View.GONE);
        etName.setVisibility(View.VISIBLE);
        line3.setVisibility(View.VISIBLE);
        etLocation.setVisibility(View.VISIBLE);
        line6.setVisibility(View.VISIBLE);
        tvRegion2.setVisibility(View.VISIBLE);
        line7.setVisibility(View.VISIBLE);
        tvValidity.setVisibility(View.VISIBLE);
        line8.setVisibility(View.VISIBLE);

        line9.setVisibility(View.VISIBLE);
        if (!StringUtil.isEmpty(tvValidity.getText()) && tvValidity.getText().equals("短期")) {
            llValidity.setVisibility(View.VISIBLE);
        }
    }

    private void switch2TW() {
        tvRegion.setVisibility(View.GONE);
        line1.setVisibility(View.GONE);
        etName.setVisibility(View.VISIBLE);
        line3.setVisibility(View.VISIBLE);
        etLocation.setVisibility(View.VISIBLE);
        line6.setVisibility(View.VISIBLE);
        tvRegion2.setVisibility(View.VISIBLE);
        line7.setVisibility(View.VISIBLE);
        tvValidity.setVisibility(View.GONE);
        line8.setVisibility(View.GONE);
        llValidity.setVisibility(View.GONE);
        line9.setVisibility(View.GONE);
    }

    private void freshIndicator(View v, boolean b) {
        if (b) {
            v.setVisibility(View.VISIBLE);
        } else {
            v.setVisibility(View.INVISIBLE);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        presenter.callEAuthenticStateQuery(username);
    }


    @Override
    public void showErrorMsg(String msg) {
        Toast.makeText(getActivity(), msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    public String getRegion() {
        return tvRegion.getText().toString().trim();
    }

    /**
     * 显示错误视图
     * 网络连接错误
     */
    @Override
    public void showErrorView() {
        rlErrorView.setVisibility(View.VISIBLE);
        rlErrorView.bringToFront();

        setOperatable(false);
    }

    private void setOperatable(boolean isOperatable) {

        tvRegion.setEnabled(isOperatable);
        etInc.setEnabled(isOperatable);
        etName.setEnabled(isOperatable);
        etCode.setEnabled(isOperatable);
        etField.setEnabled(isOperatable);
        tvRegion2.setEnabled(isOperatable);
        etLocation.setEnabled(isOperatable);
        tvValidity.setEnabled(isOperatable);
        tvStartTime.setEnabled(isOperatable);
        tvEndTime.setEnabled(isOperatable);
    }

    @Override
    public void showEditView() {
        rlErrorView.setVisibility(View.GONE);
        llTabs.setVisibility(View.VISIBLE);
        svEditContent.setVisibility(View.VISIBLE);
        setOperatable(true);//true use false to test
        TimeUtil.DateTransformer dateTransformer = TimeUtil.newDateTransformer();
        String format = "%d-%d-%d";
        String s = String.format(format, dateTransformer.getYear(),
                dateTransformer.getMonth(), dateTransformer.getDay());
        showValidityBeginTime(s);
        showValidityEndTime(s);
    }

    @Override
    public void showValidityTimeSelectActionsheet(String[] data, OnActionSheetItemClickListener
            listener) {
        ActionSheet actionSheet = new ActionSheet(getActivity());
        actionSheet.setDatasForDefaultAdapter(data);
        actionSheet.setOnActionSheetItemClickListener(listener);
        actionSheet.enableBrokenButton();
        actionSheet.show();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.eau_region:
                //选择香港/澳门
                presenter.doChooseRegion();
                break;
            case R.id.eau_tv_region:
                //选择省市区
                presenter.doChooseRegion2();
                break;
            case R.id.eau_tv_validity:
                presenter.doChooseValidityTime();
                break;
            case R.id.eau_tv_starttime:
                presenter.callSetStartTime();
                break;
            case R.id.eau_tv_endtime:
                presenter.callSetEndTime();
                break;
            case R.id.eau_ll_license_pic:
                //选取营业执照
                presenter.callChooseLicensePic();
                break;
            case R.id.eau_btn_submit:
                String companyName = etInc.getText().toString().trim();
                String incLegalPersonName = etName.getText().toString().trim();
                String incCode = etCode.getText().toString().trim();
                String incField = etField.getText().toString().trim();

                //详细地址
                String incLocation = etLocation.getText().toString().trim();
                //大陆、台湾 注册所在地区 仅用于判空
                String region2 = tvRegion2.getText().toString().trim();

                presenter.callSubmitAuthenticate(username, companyName, incLegalPersonName,
                        incCode, incField, region2, incLocation);
                break;
            default:
                break;
        }
    }

    /**
     * 设置认证企业的有效期限(长期)
     * <p/>
     * 长期即为永久
     */
    @Override
    public void setLongValidityTime() {
        tvValidity.setText(getString(R.string.v1010_default_eau_long_validity));
        llValidity.setVisibility(View.GONE);
    }

    /**
     * 设置认证企业的有效期限(短期)
     * <p/>
     * 设置为短期的时候需要选择开始期限和结束期限，llValidity可见
     */
    @Override
    public void setShortValidityTime() {
        tvValidity.setText(getString(R.string.v1010_default_eau_short_validity));
        llValidity.setVisibility(View.VISIBLE);
    }

    @Override
    public void showDateSelectDialog(long currentTimeInLong, DatePickerDialog.OnDateSetListener
            dateSetListener) {
        DatePickerDialog dialog = TimeUtil.newDatePickerDialog(getActivity(), currentTimeInLong,
                dateSetListener);
        dialog.show();
    }

    @Override
    public void showValidityEndTime(String endTime) {
        tvEndTime.setText(endTime);
    }

    @Override
    public void showValidityBeginTime(String beginTime) {
        tvStartTime.setText(beginTime);
    }

    /**
     * 等待认证
     *
     * @param eauModelBean
     */
    @Override
    public void showOnCheckWaitView(EAUModelBean eauModelBean) {
        hideSoftInputPanel();
        llTabs.setVisibility(View.GONE);
//        line.setVisibility(View.GONE);
        svEditContent.setVisibility(View.GONE);
        showFgPreview();
        fgEAuthenticPreview.showAsOnCheckWait(eauModelBean);
    }

    private void showFgPreview() {
        viewFragment.setVisibility(View.VISIBLE);
        viewFragment.bringToFront();
        bindFgPreview();
    }

    private void hideFgPreview() {
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.hide(fgEAuthenticPreview).commit();
        viewFragment.setVisibility(View.GONE);
    }

    private void bindFgPreview() {
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        if (!fgEAuthenticPreview.isAdded()) {    // 先判断是否被add过
            ft.add(viewFragment.getId(), fgEAuthenticPreview).show(fgEAuthenticPreview).commit();
        } else {
            ft.show(fgEAuthenticPreview).commit();
        }
        getSupportFragmentManager().executePendingTransactions();
    }

    /**
     * 认证通过
     *
     * @param eauModelBean
     */
    @Override
    public void showCheckPassView(EAUModelBean eauModelBean) {
        hideSoftInputPanel();
        llTabs.setVisibility(View.GONE);
//        line.setVisibility(View.GONE);
        svEditContent.setVisibility(View.GONE);
        showFgPreview();
        fgEAuthenticPreview.showAsOnCheckPass(eauModelBean);
    }

    /**
     * 认证不通过
     *
     * @param eauModelBean
     */
    @Override
    public void showCheckRefauseView(EAUModelBean eauModelBean) {
        hideSoftInputPanel();
        llTabs.setVisibility(View.GONE);
//        line.setVisibility(View.GONE);
        svEditContent.setVisibility(View.GONE);
        showFgPreview();
        fgEAuthenticPreview.showAsOnCheckRefuse(eauModelBean);
    }

    /**
     * 未提交认证的情况下，通过获取持久化数据填充视图
     */
    @Override
    public void showUnAuthView(boolean isInited) {
        if (!isInited) {
            presenter.initEAuData();
        }
    }

    @Override
    public void setHongkongArea() {
        tvRegion.setText(getString(R.string.v1010_default_eau_text_Hongkong));
        presenter.setArea(EAUModelBean.AREA_HK);
    }

    @Override
    public void setMacaoArea() {
        tvRegion.setText(getString(R.string.v1010_default_eau_text_Macao));
        presenter.setArea(EAUModelBean.AREA_MC);
    }

    @Override
    protected void onDestroy() {
        EventBus.getDefault().unregister(this);
        super.onDestroy();
    }


    /**
     * 当Activity onStop的时候将数据存到数据库
     */
    @Override
    protected void onStop() {
        super.onStop();
        String region = tvRegion.getText().toString().trim();
        String companyName = etInc.getText().toString().trim();
        String legalPersonName = etName.getText().toString().trim();
        String registerCode = etCode.getText().toString().trim();
        String turnover = etField.getText().toString().trim();
        String detailLocation = etLocation.getText().toString().trim();

        presenter.EAuSaveData(region, companyName, legalPersonName, registerCode, turnover,
                detailLocation);
    }

    /**
     * @param eauModelBean
     */
    @Override
    public void showEAuData(EAUModelBean eauModelBean) {
        tvRegion.setText(eauModelBean.getValidityRegion());
        etInc.setText(eauModelBean.getCompanyName());
        etName.setText(eauModelBean.getLegalPerson());
        etCode.setText(eauModelBean.getLicenNum());
        etField.setText(eauModelBean.getTurnOver());

        location = eauModelBean.getFormatLocation();
        tvRegion2.setText(location);


        etLocation.setText(eauModelBean.getLicenAddress());

        if (eauModelBean.getPeriodCode() == EAUModelBean.PERIOD_SHORT) {
            llValidity.setVisibility(View.VISIBLE);

            TimeUtil.DateTransformer transformer1 = TimeUtil.newDateTransformer(eauModelBean
                    .getStartTime());
            tvStartTime.setText(transformer1.getDefaultFormat());

            TimeUtil.DateTransformer transformer2 = TimeUtil.newDateTransformer(eauModelBean
                    .getEndTime());
            tvEndTime.setText(transformer2.getDefaultFormat());
            tvValidity.setText(getString(R.string.v1010_default_eau_short_validity));
        } else if (eauModelBean.getPeriodCode() == EAUModelBean.PERIOD_LONG) {
            tvValidity.setText(getString(R.string.v1010_default_eau_long_validity));
        }

        int areaCode = eauModelBean.getAuthArea();
        DLog.e(getClass(), "areacode:" + areaCode);
        if (areaCode == PAUModelBean.AREA_ML) {
            tab1.performClick();
        } else if (areaCode == PAUModelBean.AREA_TW) {
            tab3.performClick();
        } else {
            tab2.performClick();
            presenter.setArea(areaCode);
        }


    }

    @Override
    public void showLicensePicSelectActionsheet(String[] data, OnActionSheetItemClickListener
            onActionSheetItemClickListener) {
        ActionSheet actionSheet = new ActionSheet(getActivity());
        actionSheet.setDatasForDefaultAdapter(data);
        actionSheet.setOnActionSheetItemClickListener(onActionSheetItemClickListener);
        actionSheet.enableBrokenButton();
        actionSheet.show();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case EAuthenticateActivityPresenter.INTENT_CODE_ALBUM:
                if (resultCode == RESULT_OK) {
                    String path = FileUtils.queryImageByUri(data.getData(), getContentResolver());
                    if (!StringUtil.isEmpty(path)) {
                        presenter.callTransAlbum(path);
                    } else {
                        ToastUtils.show(getActivity(), R.string
                                .v1010_toast_error_album_private, ToastUtils.Duration.s);
                    }
                } else {
                    //相册 未获取图片
                }
                break;
            case EAuthenticateActivityPresenter.INTENT_CODE_CAPTURE:
                if (resultCode == RESULT_OK) {
                    //相机 获取图片并进一步处理
                    presenter.callTransCapture();
                } else {
                    //相机 未获取图片
                }
                break;
            default:
                break;
        }
    }

    @Override
    public void showDialog(int contentResid, int positiveResid, CustomPopupWindow
            .OnPositiveClickListener onPositiveClickListener) {
        CustomDialog dialog = new CustomDialog(this);
        dialog.changeView2Single();
        dialog.setContent(contentResid);
        dialog.setPositiveButton(positiveResid);
        dialog.setPositiveClickListener(onPositiveClickListener);
        dialog.show();
    }

    @Override
    public void updateLocalPic(String imageFilePath) {
        DLog.e(getClass(), "本地图片路径：" + imageFilePath);

        if (!StringUtil.isEmpty(imageFilePath)) {
            Picasso.with(this).load(new File(imageFilePath)).fit().into(ivLicensePic);
        }
    }
}
