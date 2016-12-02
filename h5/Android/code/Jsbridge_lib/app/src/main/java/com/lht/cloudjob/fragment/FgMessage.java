package com.lht.cloudjob.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.asyncprotected.NotifyListActivity;
import com.lht.cloudjob.activity.asyncprotected.SysMsgListActivity;
import com.lht.cloudjob.customview.FgMessageTitleBar;
import com.lht.cloudjob.customview.MaskView;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.mvp.model.bean.UnreadMsgResBean;
import com.lht.cloudjob.mvp.model.pojo.LoginInfo;
import com.lht.cloudjob.mvp.presenter.MessageFragmentPresenter;
import com.lht.cloudjob.mvp.viewinterface.IMessageFragment;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.string.StringUtil;
import com.lht.cloudjob.util.time.TimeUtil;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

public class FgMessage extends AvatarBarFragment implements View.OnClickListener,
        IVerifyHolder, IMessageFragment {

    private static final String PAGENAME = "FgMessage";

    private FgMessageTitleBar titleBar;

    private MaskView maskView;

    private TextView tvSysmsgCount;

    private TextView tvNotifyCount;

    private TextView tvSysSummary;

    private TextView tvNotifySummary;

    private TextView tvSysTime;

    private TextView tvNotifyTime;

    private MessageFragmentPresenter presenter;


    public FgMessage() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EventBus.getDefault().register(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle
            savedInstanceState) {
        View view = inflater.inflate(R.layout.fg_message, container, false);

        initView(view);
        initVariable();
        initEvent();


        return view;
    }

    @Override
    protected ImageView getAvatarView() {
        if (titleBar == null)
            return null;
        return titleBar.getAvatarView();
    }

    @Override
    public void onResume() {
        super.onResume();
        checkLoginState();
    }

    private void checkLoginState() {
        if (maskView == null) {
            //可能视图还未被创建
            return;
        }
        if (isLogin()) {
            maskView.hide();
            refreshData();
        } else {
            maskView.showAsUnlogin(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    presenter.callLogin();
                }
            });
        }
    }

    private void refreshData() {
        presenter.callGetMessage(mLoginInfo.getUsername());
    }

    private boolean isLogin() {
        return !StringUtil.isEmpty(mLoginInfo.getUsername());
    }

    @Override
    protected void initView(View view) {
        titleBar = (FgMessageTitleBar) view.findViewById(R.id.titlebar);
        view.findViewById(R.id.row1).setOnClickListener(this);
        view.findViewById(R.id.row2).setOnClickListener(this);
        tvNotifyCount = (TextView) view.findViewById(R.id.message_tv_notifycount);
        tvSysmsgCount = (TextView) view.findViewById(R.id.message_tv_syscount);
        tvSysSummary = (TextView) view.findViewById(R.id.message_tv_syssummary);
        tvNotifySummary = (TextView) view.findViewById(R.id.message_tv_notifysummary);
        tvNotifyTime = (TextView) view.findViewById(R.id.message_tv_notifytime);
        tvSysTime = (TextView) view.findViewById(R.id.message_tv_systime);
        maskView = (MaskView) view.findViewById(R.id.mask);
    }

    @Override
    protected void initVariable() {
        presenter = new MessageFragmentPresenter(this);
    }

    @Override
    protected void initEvent() {
        titleBar.setOnToggleListener(this);
        String path = getFragmentInteractionListener().onPreAvatarLoad();
        loadAvatar(path);
    }

    @Override
    public void onDestroy() {
        EventBus.getDefault().unregister(this);
        presenter.cancelRequestOnFinish(getActivity());
        super.onDestroy();
    }

    @Override
    protected String getPageName() {
        return PAGENAME;
    }


    @Override
    public void onPause() {
        DLog.e(getClass(), "onPause" + getClass().getName());
        super.onPause();
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.row1:
                intent = new Intent(getActivity(), SysMsgListActivity.class);
                intent.putExtra(SysMsgListActivity.KEY_DATA, mLoginInfo.getUsername());
                startActivity(intent);
                break;
            case R.id.row2:
                intent = new Intent(getActivity(), NotifyListActivity.class);
                intent.putExtra(NotifyListActivity.KEY_DATA, mLoginInfo.getUsername());
                startActivity(intent);
                break;
            default:
                break;
        }
    }

    public void updateLoginInfo(LoginInfo loginInfo) {
        this.mLoginInfo.copy(loginInfo);
        if (presenter != null) {
            presenter.setLoginStatus(!StringUtil.isEmpty(mLoginInfo.getUsername()));
        }
        checkLoginState();
    }

    @Override
    @Subscribe
    public void onEventMainThread(AppEvent.LoginSuccessEvent event) {
        LoginInfo info = event.getLoginInfo();
        updateLoginInfo(info);
        presenter.identifyTrigger(event.getTrigger());
    }

    /**
     * desc: 未进行登录的事件订阅
     *
     * @param event 手动关闭登录页事件
     */
    @Override
    @Subscribe
    public void onEventMainThread(AppEvent.LoginCancelEvent event) {
        //empty
    }

    @Override
    public LoginInfo getLoginInfo() {
        return mLoginInfo;
    }

    @Override
    public void updateMessage(UnreadMsgResBean bean) {
        if (bean == null)
            return;
        if (bean.getSystem() != null) {
            updateSysMsg(bean.getSystem());
        }

        if (bean.getAppmsg() != null) {
            updateNotify(bean.getAppmsg());
        }
    }

    private void updateNotify(UnreadMsgResBean.MsgGroup appmsg) {
        showCount(tvNotifyCount, appmsg);
        showSummary(tvNotifySummary, appmsg);
        showTime(tvNotifyTime, appmsg);
    }

    private void updateSysMsg(UnreadMsgResBean.MsgGroup system) {
        showCount(tvSysmsgCount, system);
        showSummary(tvSysSummary, system);
        showTime(tvSysTime, system);
    }

    /**
     * 处理通知时间
     *
     * @param tv       显示控件
     * @param msgGroup 数据模型
     */
    private void showTime(TextView tv, UnreadMsgResBean.MsgGroup msgGroup) {
        if (msgGroup.getMessage() != null && msgGroup.getMessage().length > 0) {
            UnreadMsgResBean.VsoMessage vsoMessage = msgGroup.getMessage()[0];
            long ts;
            if (vsoMessage != null) {
                ts = vsoMessage.getOn_time();
            } else {
//                tv.setText(null); 保留之前的内容
                return;
            }
            long todayBeginning = TimeUtil.getTodayBeginning();
            if (ts >= todayBeginning) {
                int hour = TimeUtil.getHour(ts);
                int minute = TimeUtil.getMinute(ts);
                String format = String.format("%d:%d", hour, minute);
                tv.setText(format);
            } else {
                TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer(vsoMessage
                        .getOn_time());
                tv.setText(transformer.getDefaultFormat());
            }
        }
    }

    /**
     * 处理最后消息概述
     *
     * @param tv       显示控件
     * @param msgGroup 数据模型
     */
    private void showSummary(TextView tv, UnreadMsgResBean.MsgGroup msgGroup) {
        if (msgGroup.getMessage() != null && msgGroup.getMessage().length > 0) {
            UnreadMsgResBean.VsoMessage vsoMessage = msgGroup.getMessage()[0];
            if (vsoMessage != null) {
                tv.setText(Html.fromHtml(vsoMessage.getContent()).toString());
            } else {
//                tv.setText(null);  保留之前的内容
                return;
            }
        }
    }

    /**
     * 处理未读数量
     *
     * @param tv       显示控件
     * @param msgGroup 数据模型
     */
    private void showCount(TextView tv, UnreadMsgResBean.MsgGroup msgGroup) {
        if (msgGroup == null) {
            tv.setVisibility(View.GONE);
        } else if (msgGroup.getCount() > 0) {
            tv.setText(String.valueOf(msgGroup.getCount()));
            tv.setVisibility(View.VISIBLE);
        } else {
            tv.setVisibility(View.GONE);
        }
    }
}