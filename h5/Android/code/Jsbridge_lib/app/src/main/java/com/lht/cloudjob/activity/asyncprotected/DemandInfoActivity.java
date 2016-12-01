package com.lht.cloudjob.activity.asyncprotected;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.activity.innerweb.SignAgreementActivity;
import com.lht.cloudjob.clazz.OnCheckedChangeListenerImpl;
import com.lht.cloudjob.customview.CustomDialog;
import com.lht.cloudjob.customview.CustomDialog3;
import com.lht.cloudjob.customview.CustomPopupWindow;
import com.lht.cloudjob.customview.CustomProgressView;
import com.lht.cloudjob.customview.DemandInfoOperateBottomBar;
import com.lht.cloudjob.customview.DemandProgress;
import com.lht.cloudjob.customview.TPSPWCreater;
import com.lht.cloudjob.customview.ThirdPartyShareItemClickListenerImpl;
import com.lht.cloudjob.customview.ThirdPartySharePopWins;
import com.lht.cloudjob.customview.TitleBar;
import com.lht.cloudjob.fragment.FgDemandRequire;
import com.lht.cloudjob.fragment.FgDemandWorks;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.interfaces.umeng.IUmengEventKey;
import com.lht.cloudjob.mvp.model.bean.BasicInfoResBean;
import com.lht.cloudjob.mvp.model.bean.DemandInfoResBean;
import com.lht.cloudjob.mvp.model.pojo.CommentActivityData;
import com.lht.cloudjob.mvp.model.pojo.DemandInfoActivityData;
import com.lht.cloudjob.mvp.model.pojo.LoginInfo;
import com.lht.cloudjob.mvp.presenter.DemandInfoActivityPresenter;
import com.lht.cloudjob.mvp.viewinterface.IDemandInfoActivity;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.string.StringUtil;
import com.lht.customwidgetlib.nestedscroll.NestedScrollLayout;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

import java.util.ArrayList;
import java.util.HashMap;

public class DemandInfoActivity extends AsyncProtectedActivity implements IDemandInfoActivity,
        IVerifyHolder, DemandInfoOperateBottomBar.OnOperateListener {

    private DemandProgress demandProgress;

    private static final String PAGENAME = "DemandInfoActivity";

    private ProgressBar progressBar;

    private TitleBar titleBar;

    private DemandInfoActivityPresenter presenter;

    private DemandInfoActivityData intentData;

    public static final String KEY_DATA = "_data";
    private NestedScrollLayout nestedScrollLayout;


    ////////////////////////////////////////////////////////////////////////////////////////////////
    //UI 定义区
    ////////////////////////////////////////////////////////////////////////////////////////////////
    private TextView tvName;
    private TextView tvPrice;
    private TextView tvType;
    private TextView tvDelegate;
    private TextView tvStatus;
    private TextView tvRemainTime;

    /**
     * 承诺选稿
     */
    private TextView tvPromiss;

    private RadioButton tbRequire, tbBid;

    private ImageView indicator1, indicator2;
    private DemandInfoOperateBottomBar bottomBar;


    private FgDemandRequire fgDemandRequire;

    private FgDemandWorks fgDemandWorks;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_demand_info);
        EventBus.getDefault().register(this);
        initView();
        initVariable();
        initEvent();
    }

    private DemandInfoActivityData getIntentData() {
        if (intentData == null) {
            String _d = getIntent().getStringExtra(KEY_DATA);
            intentData = JSON.parseObject(_d, DemandInfoActivityData.class);
        }
        if (intentData == null) {
            intentData = new DemandInfoActivityData();
        }
        return intentData;
    }

    /**
     * desc: 获取页面名称
     *
     * @return String
     */
    @Override
    protected String getPageName() {
        return DemandInfoActivity.PAGENAME;
    }

    /**
     * desc: 获取activity
     */
    @Override
    public UMengActivity getActivity() {
        return DemandInfoActivity.this;
    }

    /**
     * desc: 实例化View
     */
    @Override
    protected void initView() {
        demandProgress = (DemandProgress) findViewById(R.id.demandinfo_progress);
        titleBar = (TitleBar) findViewById(R.id.titlebar);
        progressBar = (ProgressBar) findViewById(R.id.progressbar);

        nestedScrollLayout = (NestedScrollLayout) findViewById(R.id.demandinfo_nsl);

        tvName = (TextView) findViewById(R.id.demandinfo_tv_demandname);
        tvPrice = (TextView) findViewById(R.id.demandinfo_tv_price);
        tvType = (TextView) findViewById(R.id.demandinfo_tv_type);
        tvDelegate = (TextView) findViewById(R.id.demandinfo_tv_delegate);
        tvStatus = (TextView) findViewById(R.id.demandinfo_tv_status);
        tvRemainTime = (TextView) findViewById(R.id.demandinfo_tv_remaintime);
        tvPromiss = (TextView) findViewById(R.id.demandinfo_tv_promiss);

        tbRequire = (RadioButton) findViewById(R.id.demandnfo_tab_require);
        tbBid = (RadioButton) findViewById(R.id.demandnfo_tab_bid);
        indicator1 = (ImageView) findViewById(R.id.indicator1);
        indicator2 = (ImageView) findViewById(R.id.indicator2);
        bottomBar = (DemandInfoOperateBottomBar) findViewById(R.id.bottom_bar);

        fgDemandRequire = new FgDemandRequire();
        fgDemandWorks = new FgDemandWorks();
    }

    /**
     * desc: 实例化必要的参数，以防止initEvent需要的参数空指针
     */
    @Override
    protected void initVariable() {
        presenter = new DemandInfoActivityPresenter(this);

    }

    private String[] steps;

    /**
     * desc: 监听器设置、adapter设置等
     */
    @Override
    protected void initEvent() {
        //统计 查看详情页-计数
        reportCountEvent(IUmengEventKey.KEY_VIEW_TASKDETAIL);

        mLoginInfo.copy(getIntentData().getLoginInfo());
        titleBar.setDefaultOnBackListener(getActivity());
        titleBar.setTitle(R.string.title_activity_demandinfo);

        ArrayList<RadioButton> temp = new ArrayList<>();
        temp.add(tbRequire);
        temp.add(tbBid);
        init(temp);

        tbRequire.performClick();

        steps = getResources().getStringArray(R.array.v1010_demand_steps);
        demandProgress.setData(steps, 0);
        presenter.callGetDemandInfo(getIntentData().getDemandId(), mLoginInfo.getUsername());
        presenter.setLoginStatus(!StringUtil.isEmpty(mLoginInfo.getUsername()));
    }

    @Override
    protected void onResume() {
        super.onResume();
        presenter.callSafePageRefresh();
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
                case R.id.demandnfo_tab_require:
                    freshIndicator(indicator1, isChecked);
                    if (isChecked) {
                        switch2Requirements();
                    }
                    break;
                case R.id.demandnfo_tab_bid:
                    freshIndicator(indicator2, isChecked);
                    if (isChecked) {
                        switch2Works();
                    }
                    break;
                default:
                    break;
            }
        }
    };

    private void switch2Works() {
        switchFragment(R.id.demandinfo_fragment, fgDemandWorks);
    }

    private void switch2Requirements() {
        switchFragment(R.id.demandinfo_fragment, fgDemandRequire);
    }

    private void freshIndicator(View v, boolean b) {
        if (b) {
            v.setVisibility(View.VISIBLE);
        } else {
            v.setVisibility(View.INVISIBLE);
        }
    }

    @Override
    protected IApiRequestPresenter getApiRequestPresenter() {
        return presenter;
    }


    /**
     * desc: 提供等待窗
     *
     * @return 一个progressBar实例
     */
    @Override
    public ProgressBar getProgressBar() {
        return progressBar;
    }

    /**
     * desc: 主线程回调登录成功
     * 需要处理：成员对象的更新、界面的更新
     *
     * @param event 登录成功事件，包含信息
     */
    @Override
    @Subscribe
    public void onEventMainThread(AppEvent.LoginSuccessEvent event) {
        mLoginInfo.copy(event.getLoginInfo());
        presenter.setLoginStatus(true);
        presenter.identifyTrigger(event.getTrigger());
        presenter.callGetDemandInfo(getIntentData().getDemandId(), mLoginInfo.getUsername());
    }

    @Override
    @Subscribe
    public void onEventMainThread(AppEvent.LoginCancelEvent event) {
        presenter.identifyCanceledTrigger(event.getTrigger());
    }

    @Subscribe
    public void onEventMainThread(AppEvent.NestedContentScrollEvent event) {
        nestedScrollLayout.setTouchMode(event.isTopArrived());
    }

    @Override
    public LoginInfo getLoginInfo() {
        return mLoginInfo;
    }

    @Override
    public void showErrorMsg(String msg) {
        showMsg(msg);
    }

    @Override
    public void updateView(DemandInfoResBean bean) {
        if (bean == null) {
            return;
        }
        tvName.setText(bean.getTitle());
        tvPrice.setText(bean.getPriceString());
        tvType.setText(bean.getModel_name());
        tvDelegate.setText(bean.getDelegateString());
        tvStatus.setText(DemandInfoResBean.trans2StepAlias(bean.getStep()));
        tvRemainTime.setText(bean.getSub_end_time_alias());
        demandProgress.setData(steps, bean.getStep() - 1);

        if (bean.getIs_select() == 1) { //承诺选稿
            tvPromiss.setVisibility(View.VISIBLE);
        } else {
            tvPromiss.setVisibility(View.GONE);
        }

        updateCount(bean.getTotal_bids());

        DemandInfoResBean.Favored favored = bean.getFavored();
        if (favored == null) {
            favored = new DemandInfoResBean.Favored();
        }
        setTaskCollected(favored.isTask());
        bottomBar.setOperateAndRefresh(bean.getOperate());

        bottomBar.setOnShareClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                presenter.call2Share();
            }
        });
        bottomBar.setOnCollectClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //说明，为了防止设置check的时候触发回调，使用onclick来触发，首先check状态会发生变化，
                // 所以是反的。举例：已收藏的点击，应该执行取消收藏，点击后回调被调用时其check状态已成为false
                if (!bottomBar.isCollectChecked()) {

                    presenter.callDiscollectTask(mLoginInfo.getUsername(), getIntentData()
                            .getDemandId());

                } else {

                    presenter.callCollectTask(mLoginInfo.getUsername(), getIntentData()
                            .getDemandId());
                }
            }
        });
        bottomBar.setOnOperateListener(this);

        fgDemandRequire.setDemandInfoResBean(bean);
        fgDemandWorks.setDemandInfoResBean(bean);
    }

    /**
     * to set the state of the checkbox which shows whether user collected the task;
     *
     * @param isCollected ture if the task is collected by the user,false otherwise;
     */
    @Override
    public void setTaskCollected(boolean isCollected) {
        bottomBar.setTaskCollected(isCollected);
    }

    /**
     * 签署协议
     *
     * @param demandInfoResBean 元数据
     */
    @Override
    public void jump2SignAgreement(DemandInfoResBean demandInfoResBean) {
        Intent intent = new Intent(this, SignAgreementActivity.class);
        intent.putExtra(SignAgreementActivity.KEY_TASK_BN, demandInfoResBean.getTask_bn());
        intent.putExtra(SignAgreementActivity.KEY_CANREFUSE, demandInfoResBean.getModel() == 2);
//        intent.putExtra(SignAgreementActivity.KEY_USERNAME, demandInfoResBean.getUsername());
        startActivity(intent);
    }

    /**
     * 评价
     *
     * @param demandInfoResBean 元数据
     */
    @Override
    public void jump2Evaluate(DemandInfoResBean demandInfoResBean) {
        String username = mLoginInfo.getUsername();
        String task_bn = demandInfoResBean.getTask_bn();
        DemandInfoResBean.Publisher publisher = demandInfoResBean.getPublisher();
        if (publisher == null) {
            publisher = new DemandInfoResBean.Publisher();
        }
        CommentActivityData data = new CommentActivityData(username, task_bn, publisher);
        String s = JSON.toJSONString(data);
        start(CommentActivity.class, CommentActivity.KEY_DATA, s);
    }

    @Override
    public void jump2UndertakeReward(String task_bn) {
        start(UndertakeRewardActivity.class, UndertakeRewardActivity.TASK_BN, task_bn);
    }

    @Override
    public void jump2UndertakeHideBid(String task_bn) {
        start(UndertakeHideBidActivity.class, UndertakeHideBidActivity.TASK_BN, task_bn);
    }

    @Override
    public void jump2UndertakeOpenBid(String task_bn) {
        start(UndertakeOpenBidActivity.class, UndertakeOpenBidActivity.TASK_BN, task_bn);
    }


    @Override
    public void showEAuthenticaDialog() {
        CustomDialog dialog = new CustomDialog(this);

        dialog.setContent(R.string.v1010_default_demandinfo_text_eauthenticate);
        dialog.setPositiveButton(R.string.v1010_default_pau_to_authenticate);
        dialog.setNegativeButton(R.string.cancel);

        dialog.setPositiveClickListener(new CustomPopupWindow.OnPositiveClickListener() {
            @Override
            public void onPositiveClick() {
                //跳转到企业认证
                start(EnterpriseAuthenticateActivity.class, EnterpriseAuthenticateActivity
                        .KEY_DATA, mLoginInfo.getUsername());
            }
        });


        dialog.show();
    }

    @Override
    public void showPAuthenticaDialog() {
        final CustomDialog dialog = new CustomDialog(this);

        dialog.setContent(R.string.v1010_default_demandinfo_text_pauthenticate);
        dialog.setPositiveButton(R.string.v1010_default_pau_to_pauthenticate);
        dialog.setNegativeButton(R.string.cancel);

        dialog.setPositiveClickListener(new CustomPopupWindow.OnPositiveClickListener() {
            @Override
            public void onPositiveClick() {
                //跳转到个人认证
                start(PersonalAuthenticateActivity.class, PersonalAuthenticateActivity.KEY_DATA,
                        mLoginInfo.getUsername());
            }
        });
        dialog.setNegativeClickListener(new CustomPopupWindow.OnNegativeClickListener() {
            @Override
            public void onNegativeClick() {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    @Override
    public void showBindPhoneDialog() {
        CustomDialog dialog = new CustomDialog(this);

        dialog.setContent(R.string.v1010_default_demandinfo_text_bindphone);
        dialog.setPositiveButton(R.string.v1010_default_bindphone_to_bindphone);
        dialog.setNegativeButton(R.string.cancel);

        dialog.setPositiveClickListener(new CustomPopupWindow.OnPositiveClickListener() {
            @Override
            public void onPositiveClick() {
                BasicInfoResBean bean = new BasicInfoResBean();
                bean.setUsername(getLoginInfo().getUsername());
                start(BindPhoneActivity.class, BindPhoneActivity.KEY_DATA, JSON.toJSONString(bean));
            }
        });

        dialog.show();
    }


    private Fragment saveFg;

    protected void switchFragment(final int rid, Fragment to) {
        if (to == null) {
            // may throw you a IllegalArgumentException be better
            return;
        }
        if (saveFg != to) {
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            if (!to.isAdded()) {    // 先判断是否被add过
                if (saveFg != null) {
                    ft.hide(saveFg);
                }
                ft.add(rid, to).show(to).commit(); // 隐藏当前的fragment，add下一个到Activity中
            } else {
                if (saveFg != null) {
                    ft.hide(saveFg);
                }
                ft.show(to).commit(); // 隐藏当前的fragment，显示下一个
            }
            saveFg = to;
        }

    }

    @Override
    protected void onDestroy() {
        EventBus.getDefault().unregister(this);
        super.onDestroy();
    }

    @Override
    public void onOperate(int operateCode) {
//        presenter.callSignAgreement();
        switch (operateCode) {
            case DemandInfoOperateBottomBar.OPERATE_CODE_CALL:
                presenter.callPublisher();
                break;
            case DemandInfoOperateBottomBar.OPERATE_CODE_CONTRIBUTE:
                presenter.callCheckUndertakePermission(mLoginInfo.getUsername());
                break;
            case DemandInfoOperateBottomBar.OPERATE_CODE_CONTRIBUTE2:
                presenter.callCheckUndertakePermission(mLoginInfo.getUsername());
                break;
            case DemandInfoOperateBottomBar.OPERATE_CODE_EVALUATE:
                //评价
                presenter.callEvaluate();
                break;
//            case DemandInfoOperateBottomBar.OPERATE_CODE_FINDSAME:
//                //该操作已被隐藏
//                break;
            case DemandInfoOperateBottomBar.OPERATE_CODE_SIGN:
                //签署协议
                presenter.callSignAgreement();
                break;
            default:
                DLog.e(getClass(), new DLog.LogLocation(), "operateCode 未识别：" + operateCode);
                break;
        }
    }

    @Override
    public void showSharePopwins(String content, ThirdPartyShareItemClickListenerImpl
            itemClickListener) {
        ThirdPartySharePopWins wins = TPSPWCreater.create(getActivity());
        wins.setShareContent(content);
        wins.removeItem(wins.getItemCount() - 1);
        wins.setOnThirdPartyShareItemClickListener(itemClickListener);
        wins.show();
    }

    @Override
    public void updateCount(int count) {
        String bids = String.format("所有投稿(%d)", count);
        tbBid.setText(bids);
    }

    @Override
    public void showPorEAuthenticDialog() {
        final CustomDialog3 dialog = new CustomDialog3(this);

        dialog.setContent(R.string.v1010_default_demandinfo_text_authenticateinfo);
        dialog.setPositiveButton(R.string.v1010_default_pau_to_pauthenticate);
        dialog.setMiddleButton(R.string.title_activity_enterpriseauthenticate);
        dialog.setNegativeButton(R.string.cancel);

        dialog.setPositiveClickListener(new CustomPopupWindow.OnPositiveClickListener() {
            @Override
            public void onPositiveClick() {
                //跳转到个人认证
                start(PersonalAuthenticateActivity.class, PersonalAuthenticateActivity.KEY_DATA,
                        mLoginInfo.getUsername());
            }
        });
        dialog.setOnMiddleClickListener(new CustomDialog3.OnMiddleClickListener() {
            @Override
            public void onMiddleClick() {
                //跳转到企业认证
                start(EnterpriseAuthenticateActivity.class, EnterpriseAuthenticateActivity
                        .KEY_DATA, mLoginInfo.getUsername());
            }
        });
        dialog.setNegativeClickListener(new CustomPopupWindow.OnNegativeClickListener() {
            @Override
            public void onNegativeClick() {
                dialog.dismiss();
            }
        });

        dialog.show();
    }

    @Override
    protected void closePopupWindow() {
        if (pw instanceof CustomProgressView) {
            pw.dismiss();
            if (fgDemandRequire != null) {
                fgDemandRequire.cancelPreview();
            }
            if (fgDemandWorks != null) {
                fgDemandWorks.cancelPreview();
            }
            return;
        }
        super.closePopupWindow();
    }
}
