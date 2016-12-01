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

import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.clazz.OnCheckedChangeListenerImpl;
import com.lht.cloudjob.customview.CustomDialog;
import com.lht.cloudjob.customview.CustomPopupWindow;
import com.lht.cloudjob.customview.TitleBar;
import com.lht.cloudjob.fragment.FgAuthenticPreview;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.mvp.model.bean.PAUModelBean;
import com.lht.cloudjob.mvp.presenter.PAuthenticateActivityPresenter;
import com.lht.cloudjob.mvp.viewinterface.IPAuthenticateActivity;
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

public class PersonalAuthenticateActivity extends AsyncProtectedActivity
        implements IPAuthenticateActivity, View.OnClickListener,
        CompoundButton.OnCheckedChangeListener {

    private static final String PAGENAME = "PersonalAuthenticateActivity";

    private TitleBar titleBar;
    private ImageView indicator1, indicator2, indicator3;

    private RadioButton tab1;
    private RadioButton tab2;
    private RadioButton tab3;

    private TextView tvRegion, tvValidityBegin, tvValidityEnd;

    private EditText etName, etIdentifyCode;

    private LinearLayout llValidity;

    private PAuthenticateActivityPresenter presenter;

    public static final String KEY_DATA = "_data";

    private String username;

    private ProgressBar progressBar;

    private RelativeLayout rlErrorView;

    private ScrollView svEditContent;

    private Button btnSubmit;

    private LinearLayout llTabs;

    private FrameLayout viewFragment;

    private View line;

    private FgAuthenticPreview fgAuthenticPreview;
    private LinearLayout llIDcardFront;
    private LinearLayout llIDcardBack;
    private LinearLayout llHandIDcard;
    private ImageView ivIDcardFront;
    private ImageView ivIDcardBack;
    private ImageView ivHandIDcard;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_personal_authenticate);
        username = getIntent().getStringExtra(KEY_DATA);
        fgAuthenticPreview = new FgAuthenticPreview();
        EventBus.getDefault().register(this);
        initView();
        initVariable();
        initEvent();
    }

    @Override
    protected IApiRequestPresenter getApiRequestPresenter() {
        return presenter;
    }

    @Override
    protected String getPageName() {
        return PersonalAuthenticateActivity.PAGENAME;
    }

    @Override
    public UMengActivity getActivity() {
        return PersonalAuthenticateActivity.this;
    }


    @Override
    protected void initView() {

        titleBar = (TitleBar) findViewById(R.id.titlebar);
        indicator1 = (ImageView) findViewById(R.id.pau_indicator1);
        indicator2 = (ImageView) findViewById(R.id.pau_indicator2);
        indicator3 = (ImageView) findViewById(R.id.pau_indicator3);

        tvRegion = (TextView) findViewById(R.id.pau_region);
        llValidity = (LinearLayout) findViewById(R.id.pau_ll_validity);

        tab1 = (RadioButton) findViewById(R.id.perauth_tab1);
        tab2 = (RadioButton) findViewById(R.id.perauth_tab2);
        tab3 = (RadioButton) findViewById(R.id.perauth_tab3);

        llTabs = (LinearLayout) findViewById(R.id.perauth_tabs);
        svEditContent = (ScrollView) findViewById(R.id.pau_sv_content);
        viewFragment = (FrameLayout) findViewById(R.id.fragment);
        line = findViewById(R.id.line1);

        llIDcardFront = (LinearLayout) findViewById(R.id.pau_ll_idcard_front);
        llIDcardBack = (LinearLayout) findViewById(R.id.pau_ll_idcard_back);
        llHandIDcard = (LinearLayout) findViewById(R.id.pau_ll_hand_idcard);
        ivIDcardFront = (ImageView) findViewById(R.id.pau_iv_idcard_front);
        ivIDcardBack = (ImageView) findViewById(R.id.pau_iv_idcard_back);
        ivHandIDcard = (ImageView) findViewById(R.id.pau_iv_hand_idcard);

        ArrayList<RadioButton> temp = new ArrayList<>();
        temp.add(tab1);
        temp.add(tab2);
        temp.add(tab3);

        init(temp);

        progressBar = (ProgressBar) findViewById(R.id.progressbar);
        rlErrorView = (RelativeLayout) findViewById(R.id.empty_view_content);
        tvValidityBegin = (TextView) findViewById(R.id.pau_tv_begin);
        tvValidityEnd = (TextView) findViewById(R.id.pau_tv_end);
        etName = (EditText) findViewById(R.id.pau_et_name);
        etIdentifyCode = (EditText) findViewById(R.id.pau_et_identifycode);
        btnSubmit = (Button) findViewById(R.id.pau_btn_submit);

        bindFgPreview();
    }


    @Override
    protected void initVariable() {
        presenter = new PAuthenticateActivityPresenter(this);
    }

    @Override
    protected void initEvent() {
        titleBar.setDefaultOnBackListener(getActivity());
        titleBar.setTitle(R.string.title_activity_personalauthenticate);

        rlErrorView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                presenter.callPAuthenticStateQuery(username);
            }
        });

        tvValidityBegin.setOnClickListener(this);
        tvValidityEnd.setOnClickListener(this);
        btnSubmit.setOnClickListener(this);
        tvRegion.setOnClickListener(this);
        llIDcardFront.setOnClickListener(this);
        llIDcardBack.setOnClickListener(this);
        llHandIDcard.setOnClickListener(this);

        tab1.performClick();
    }

    @Override
    public ProgressBar getProgressBar() {
        return progressBar;
    }


    private void init(ArrayList<RadioButton> temp) {
        HashMap<RadioButton, CompoundButton.OnCheckedChangeListener> map = new HashMap<>();
        for (RadioButton rb : temp) {
            map.put(rb, this);
        }
        View.OnClickListener listener = new OnCheckedChangeListenerImpl(map);
        for (RadioButton rb : temp) {
            rb.setOnClickListener(listener);
        }
    }


    private void setValidityVisible(boolean b) {
        if (b) {
            llValidity.setVisibility(View.VISIBLE);
        } else {
            llValidity.setVisibility(View.GONE);
        }
    }

    private void setRegionVisible(boolean b) {
        if (b) {
            tvRegion.setVisibility(View.VISIBLE);
        } else {
            tvRegion.setVisibility(View.GONE);
        }
    }

    private void freshIndicator(View v, boolean b) {
        if (b) {
            v.setVisibility(View.VISIBLE);
        } else {
            v.setVisibility(View.INVISIBLE);
        }
    }

    @Override
    public void showErrorMsg(String msg) {
        Toast.makeText(getActivity(), msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void showErrorView() {
        rlErrorView.setVisibility(View.VISIBLE);
        rlErrorView.bringToFront();
        // TODO: 2016/8/8 hide others?

        setOperatable(false);
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

    private void setOperatable(boolean isOperatable) {
        tvRegion.setEnabled(isOperatable);
        etIdentifyCode.setEnabled(isOperatable);
        etName.setEnabled(isOperatable);
        tvValidityBegin.setEnabled(isOperatable);
        tvValidityEnd.setEnabled(isOperatable);
        btnSubmit.setEnabled(isOperatable);
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
        tvValidityEnd.setText(endTime);
    }

    @Override
    public void showValidityBeginTime(String beginTime) {
        tvValidityBegin.setText(beginTime);
    }

    /**
     * 等待认证
     *
     * @param pauModelBean 元数据
     */
    @Override
    public void showOnCheckWaitView(PAUModelBean pauModelBean) {
        // TODO: 2016/8/9
        hideSoftInputPanel();
        llTabs.setVisibility(View.GONE);
        line.setVisibility(View.GONE);
        svEditContent.setVisibility(View.GONE);

        showFgPreview();
        fgAuthenticPreview.showAsOnCheckWait(pauModelBean);
    }

    private void showFgPreview() {
        viewFragment.setVisibility(View.VISIBLE);
        viewFragment.bringToFront();
        bindFgPreview();
    }

    private void bindFgPreview() {
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        if (!fgAuthenticPreview.isAdded()) {    // 先判断是否被add过
            ft.add(viewFragment.getId(), fgAuthenticPreview).show(fgAuthenticPreview).commit();
        } else {
            ft.show(fgAuthenticPreview).commit();
        }
        getSupportFragmentManager().executePendingTransactions();
    }

    private void hideFgPreview() {
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.hide(fgAuthenticPreview).commit();
        viewFragment.setVisibility(View.GONE);
    }

    /**
     * 认证通过
     *
     * @param pauModelBean 元数据
     */
    @Override
    public void showCheckPassView(PAUModelBean pauModelBean) {
        hideSoftInputPanel();
        llTabs.setVisibility(View.GONE);
        line.setVisibility(View.GONE);
        svEditContent.setVisibility(View.GONE);

        showFgPreview();
        fgAuthenticPreview.showAsOnCheckPass(pauModelBean);
    }

    /**
     * 认证失败
     *
     * @param pauModelBean 元数据
     */
    @Override
    public void showCheckRefuseView(PAUModelBean pauModelBean) {
        hideSoftInputPanel();
        llTabs.setVisibility(View.GONE);
        line.setVisibility(View.GONE);
        svEditContent.setVisibility(View.GONE);

        showFgPreview();
        fgAuthenticPreview.showAsOnCheckRefuse(pauModelBean);
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
    public void setHongkongArea() {
        tvRegion.setText(getString(R.string.v1010_default_eau_text_Hongkong));
        presenter.setArea(PAUModelBean.AREA_HK);
    }

    @Override
    public void setMacaoArea() {
        tvRegion.setText(getString(R.string.v1010_default_eau_text_Macao));
        presenter.setArea(PAUModelBean.AREA_MC);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.pau_region:
                //选择香港/澳门
                presenter.doChooseRegion();
                break;
            case R.id.pau_tv_begin:
                presenter.callSetValidityBegin();
                break;
            case R.id.pau_tv_end:
                presenter.callSetValidityEnd();
                break;
            case R.id.pau_ll_idcard_front:
                presenter.doGetFrontPic();
                break;
            case R.id.pau_ll_idcard_back:
                presenter.doGetBackPic();
                break;
            case R.id.pau_ll_hand_idcard:
                presenter.doGetHandPic();
                break;
            case R.id.pau_btn_submit:
                presenter.callSubmit(username, etName.getText().toString(), etIdentifyCode
                        .getText().toString());
                break;
            default:
                break;
        }
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        switch (buttonView.getId()) {
            case R.id.perauth_tab1: {
                freshIndicator(indicator1, isChecked);
                if (isChecked) {
                    setRegionVisible(false);
                    setValidityVisible(true);
                }
                setData(PAUModelBean.AREA_ML, isChecked);
            }
            break;
            case R.id.perauth_tab2: {
                freshIndicator(indicator2, isChecked);
                if (isChecked) {
                    setRegionVisible(true);
                    setValidityVisible(true);
                }
                //初始化为未选取
                setData(PAUModelBean.AREA_NULL, isChecked);
            }
            break;
            case R.id.perauth_tab3: {
                freshIndicator(indicator3, isChecked);
                if (isChecked) {
                    setRegionVisible(false);
                    setValidityVisible(false);
                }
                setData(PAUModelBean.AREA_TW, isChecked);
            }
            break;
            default:
                break;
        }
    }

    private void setData(int areaCode, boolean isChecked) {
        if (isChecked) {
            presenter.setArea(areaCode);
        }
    }

    /**
     * 未提交认证的情况下，通过获取持久化数据填充视图
     */
    @Override
    public void showUnAuthView(boolean isInited) {
        if (!isInited) {
            presenter.initPAuData();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        presenter.callPAuthenticStateQuery(username);
    }

    /**
     * 当Activity onStop的时候将数据存到数据库
     */
    @Override
    protected void onStop() {
        super.onStop();
        String realName = etName.getText().toString().trim();
        String idCard = etIdentifyCode.getText().toString().trim();
        String region = tvRegion.getText().toString().trim();
        presenter.callSaveData(realName, idCard, region);
    }

    @Override
    protected void onDestroy() {
        EventBus.getDefault().unregister(this);
        super.onDestroy();
    }


    @Override
    public void showPAuData(PAUModelBean pauModelBean) {

        etName.setText(pauModelBean.getRealName());
        etIdentifyCode.setText(pauModelBean.getIdCard());
        tvRegion.setText(pauModelBean.getValidityRegion());
        if (pauModelBean.getValidityBegin() > 0) {
            TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer(pauModelBean
                    .getValidityBegin());
            tvValidityBegin.setText(transformer.getDefaultFormat());
        } else {
            TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer();
            tvValidityBegin.setText(transformer.getDefaultFormat());
        }

        if (pauModelBean.getValidityEnd() > 0) {
            TimeUtil.DateTransformer transformer2 = TimeUtil.newDateTransformer(pauModelBean
                    .getValidityEnd());
            tvValidityEnd.setText(transformer2.getDefaultFormat());
        } else {
            TimeUtil.DateTransformer transformer2 = TimeUtil.newDateTransformer();
            tvValidityEnd.setText(transformer2.getDefaultFormat());
        }

        int areaCode = pauModelBean.getAreaCode();
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
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case PAuthenticateActivityPresenter.INTENT_CODE_ALBUM_FRONT:
                handleGetFromAlbum(resultCode, data, PAuthenticateActivityPresenter
                        .ImageGetTrigger.Album_front);
                break;
            case PAuthenticateActivityPresenter.INTENT_CODE_ALBUM_BACK:
                handleGetFromAlbum(resultCode, data, PAuthenticateActivityPresenter
                        .ImageGetTrigger.Album_back);
                break;
            case PAuthenticateActivityPresenter.INTENT_CODE_ALBUM_HAND:
                handleGetFromAlbum(resultCode, data, PAuthenticateActivityPresenter
                        .ImageGetTrigger.Album_hand);
                break;
            case PAuthenticateActivityPresenter.INTENT_CODE_CAPTURE_FRONT:
                handleGetFromCapture(resultCode, PAuthenticateActivityPresenter.ImageGetTrigger
                        .Capture_front);
                break;
            case PAuthenticateActivityPresenter.INTENT_CODE_CAPTURE_BACK:
                handleGetFromCapture(resultCode, PAuthenticateActivityPresenter.ImageGetTrigger
                        .Capture_back);
                break;
            case PAuthenticateActivityPresenter.INTENT_CODE_CAPTURE_HAND:
                handleGetFromCapture(resultCode, PAuthenticateActivityPresenter.ImageGetTrigger
                        .Capture_hand);
                break;
            default:
                break;
        }
    }

    private void handleGetFromCapture(int resultCode, PAuthenticateActivityPresenter
            .ImageGetTrigger trigger) {
        if (resultCode == RESULT_OK) {
            //相机 获取图片并进一步处理
            presenter.callTransCapture(trigger);
        } else {
            //相机 未获取图片
        }
    }

    private void handleGetFromAlbum(int resultCode, Intent data, PAuthenticateActivityPresenter
            .ImageGetTrigger trigger) {
        if (resultCode == RESULT_OK) {
            String path = FileUtils.queryImageByUri(data.getData(), getContentResolver());
            if (!StringUtil.isEmpty(path)) {
                presenter.callTransAlbum(path, trigger);
            } else {
                ToastUtils.show(getActivity(), R.string
                        .v1010_toast_error_album_private, ToastUtils.Duration.s);
            }
        } else {
            //相册 未获取图片
        }
    }

    /**
     * 上传图片
     */
    @Subscribe
    public void onEventMainThread(AppEvent.ImageGetEvent event) {
        //处理照片获取并复制后的后续事件 压缩、显示...
        presenter.callResolveEvent(event);
    }

    /**
     * 重新认证事件回调
     * @param event
     */
    @Subscribe
    public void onEventMainThread(AppEvent.RePAuthEvent event) {
        presenter.setIsOnReAuth(true);
        hideFgPreview();
        showEditView();
        showUnAuthView(false);
    }

    @Override
    public void showPicSelectActionsheet(String[] data, OnActionSheetItemClickListener listener) {
        ActionSheet actionSheet = new ActionSheet(getActivity());
        actionSheet.setDatasForDefaultAdapter(data);
        actionSheet.setOnActionSheetItemClickListener(listener);
        actionSheet.enableBrokenButton();
        actionSheet.transparent();
        actionSheet.show();
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
    public void updateIDcardFrontPic(String imageFilePath) {
        if (!StringUtil.isEmpty(imageFilePath)) {
            Picasso.with(this).load(new File(imageFilePath)).fit().into(ivIDcardFront);
        } else {
            DLog.e(getClass(), "update pic path null");
        }
    }

    @Override
    public void updateIDcardBackPic(String imageFilePath) {
        if (!StringUtil.isEmpty(imageFilePath)) {
            Picasso.with(this).load(new File(imageFilePath)).fit().into(ivIDcardBack);
        } else {
            DLog.e(getClass(), "update pic path null");
        }
    }

    @Override
    public void updateHandIDcardPic(String imageFilePath) {
        if (!StringUtil.isEmpty(imageFilePath)) {
            Picasso.with(this).load(new File(imageFilePath)).fit().into(ivHandIDcard);
        } else {
            DLog.e(getClass(), "update pic path null");
        }
    }
}
