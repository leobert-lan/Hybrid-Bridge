package com.lht.cloudjob.mvp.presenter;

import android.content.Context;
import android.content.Intent;

import com.lht.cloudjob.R;
import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
import com.lht.cloudjob.clazz.LoginIntentFactory;
import com.lht.cloudjob.interfaces.ITriggerCompare;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.mvp.model.APPCommentTimeQueryModel;
import com.lht.cloudjob.mvp.model.ApiModelCallback;
import com.lht.cloudjob.mvp.model.AppCommentListModel;
import com.lht.cloudjob.mvp.model.PraiseModel;
import com.lht.cloudjob.mvp.model.QueryUserIsCommentModel;
import com.lht.cloudjob.mvp.model.bean.AppCommentPeriodResBean;
import com.lht.cloudjob.mvp.model.bean.AppCommentResBean;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.model.bean.MyAppCommentResBean;
import com.lht.cloudjob.mvp.viewinterface.IStaticPromoteActivity;
import com.lht.cloudjob.util.internet.HttpUtil;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.presenter
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> StaticPromoteActivityPresenter
 * <p><b>Description</b>: TODO
 * <p> Create by Leobert on 2016/11/14
 */
@TempVersion(TempVersionEnum.V1019)
public class StaticPromoteActivityPresenter extends ABSVerifyNeedPresenter implements
        IApiRequestPresenter {

    private IStaticPromoteActivity iStaticPromoteActivity;

    public StaticPromoteActivityPresenter(IStaticPromoteActivity iStaticPromoteActivity) {
        this.iStaticPromoteActivity = iStaticPromoteActivity;
        periodResBean = new AppCommentPeriodResBean();
    }

    private AppCommentPeriodResBean periodResBean;

    public String getPeriod() {
        return periodResBean.getFormatPeriod();
    }

    public void queryPeriod() {
        APPCommentTimeQueryModel model = new APPCommentTimeQueryModel(new ApiModelCallback<AppCommentPeriodResBean>() {
            @Override
            public void onSuccess(BaseBeanContainer<AppCommentPeriodResBean> beanContainer) {
                periodResBean = beanContainer.getData();
                iStaticPromoteActivity.updatePeriod(periodResBean);
            }

            @Override
            public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            }

            @Override
            public void onHttpFailure(int httpStatus) {
            }
        });
        model.doRequest(iStaticPromoteActivity.getActivity());
    }

    /**
     * 页面结束时取消所有相关的回调
     *
     * @param context
     */
    @Override
    public void cancelRequestOnFinish(Context context) {
        HttpUtil.getInstance().onActivityDestroy(context);
    }

    /**
     * desc: 页面接收到订阅事件后，调用presenter#identifyTrigger，执行逻辑，需要区分触发事件是不是登录事件
     *
     * @param trigger an interface to identify trigger,use equal(ITriggerCompare compare)
     */
    @Override
    public void identifyTrigger(ITriggerCompare trigger) {
        queryMyComment(IVerifyHolder.mLoginInfo.getUsername());

        //ignore any trigger event,just let him/her re-trig manually
    }

    /**
     * desc: check if login
     *
     * @return true while login,false otherwise
     */
    @Override
    protected boolean isLogin() {
        return IVerifyHolder.mLoginInfo.isLogin();
    }

    /**
     * desc: update status,implement the method with an appropriate design
     *
     * @param isLogin
     */
    @Override
    public void setLoginStatus(boolean isLogin) {
//ignore
    }

    private boolean isRefreshOperate;

    public void callRefreshListData(String usr) {
        iStaticPromoteActivity.showWaitView(true);
        isRefreshOperate = true;
        AppCommentListModel model = new AppCommentListModel(new AppCommentListModelCallback());
        model.setParams(usr, 0);
        model.doRequest(iStaticPromoteActivity.getActivity());
    }

    public void callAddListData(String usr, int offset) {
        iStaticPromoteActivity.showWaitView(true);
        isRefreshOperate = false;
        AppCommentListModel model = new AppCommentListModel(new AppCommentListModelCallback());
        model.setParams(usr, offset);
        model.doRequest(iStaticPromoteActivity.getActivity());
    }

    public void queryMyComment(String usr) {
        if (!isLogin()) {
            hasCommented = false;
            iStaticPromoteActivity.enableCommentAccess();
            return;
        }
        iStaticPromoteActivity.showWaitView(true);
        QueryUserIsCommentModel model = new QueryUserIsCommentModel(usr, new
                QueryUserIsCommentModelCallback());
        model.doRequest(iStaticPromoteActivity.getActivity());
    }

    public void callAccessPromoteActivity() {
        if (!isLogin()) {
            Intent loginIntent = LoginIntentFactory.create(iStaticPromoteActivity.getActivity(),
                    LoginTrigger.BtnAccess);
            iStaticPromoteActivity.getActivity().startActivity(loginIntent);
            return;
        }
        iStaticPromoteActivity.jumpToAppcomment();
    }

    public void callZan(AppCommentResBean bean) {
        if (!isLogin()) {
            Intent loginIntent = LoginIntentFactory.create(iStaticPromoteActivity.getActivity(),
                    LoginTrigger.ListZan);
            iStaticPromoteActivity.getActivity().startActivity(loginIntent);
            return;
        }
        doZan(bean);
    }

    private void doZan(AppCommentResBean bean) {
        iStaticPromoteActivity.showWaitView(true);
        PraiseModel model = new PraiseModel(IVerifyHolder.mLoginInfo.getUsername(), bean.getId(),
                new PraiseCallback(bean));
        model.doRequest(iStaticPromoteActivity.getActivity());
    }

    private final class AppCommentListModelCallback implements
            ApiModelCallback<ArrayList<AppCommentResBean>> {

        @Override
        public void onSuccess(BaseBeanContainer<ArrayList<AppCommentResBean>> beanContainer) {
            // TODO: 2016/11/15
            ArrayList<AppCommentResBean> data = beanContainer.getData();
            if (data == null || data.isEmpty()) {
                iStaticPromoteActivity.showEmptyView();
            } else {
                if (isRefreshOperate) {
                    iStaticPromoteActivity.hideEmptyView();
                    iStaticPromoteActivity.setListData(data);
                } else {
                    iStaticPromoteActivity.addListData(data);
                }

            }
            iStaticPromoteActivity.cancelWaitView();
            iStaticPromoteActivity.finishRefresh();
            queryMyComment(IVerifyHolder.mLoginInfo.getUsername());
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iStaticPromoteActivity.cancelWaitView();

            if (isRefreshOperate) {
                //将列表数据清空
                iStaticPromoteActivity.setListData(new ArrayList<AppCommentResBean>());
                //显示空视图布局
                iStaticPromoteActivity.showEmptyView();
            } else {
                //已经到底了
                iStaticPromoteActivity.showMsg(iStaticPromoteActivity.getActivity().getString(R
                        .string.v1010_toast_list_all_data_added));
            }
            iStaticPromoteActivity.finishRefresh();
            queryMyComment(IVerifyHolder.mLoginInfo.getUsername());
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            iStaticPromoteActivity.cancelWaitView();
            iStaticPromoteActivity.finishRefresh();
            queryMyComment(IVerifyHolder.mLoginInfo.getUsername());
        }
    }

    private boolean hasCommented = false;

    public boolean hasCommented() {
        return hasCommented;
    }

    private MyAppCommentResBean myAppCommentResBean;

    public MyAppCommentResBean getMyAppCommentResBean() {
        return myAppCommentResBean;
    }

    private final class QueryUserIsCommentModelCallback implements
            ApiModelCallback<MyAppCommentResBean> {


        @Override
        public void onSuccess(BaseBeanContainer<MyAppCommentResBean> beanContainer) {
            hasCommented = true;
            myAppCommentResBean = beanContainer.getData();
            iStaticPromoteActivity.showMyComment(beanContainer.getData());
            iStaticPromoteActivity.disableCommentAccess();
            iStaticPromoteActivity.cancelWaitView();
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            hasCommented = false;
            myAppCommentResBean = null;
            iStaticPromoteActivity.cancelWaitView();
            iStaticPromoteActivity.enableCommentAccess();

        }

        @Override
        public void onHttpFailure(int httpStatus) {
            hasCommented = false;
            myAppCommentResBean = null;
            iStaticPromoteActivity.cancelWaitView();
            iStaticPromoteActivity.enableCommentAccess();
        }
    }

    /**
     * 点赞
     */
    private final class PraiseCallback implements ApiModelCallback<BaseVsoApiResBean> {

        private AppCommentResBean bean;

        public PraiseCallback(AppCommentResBean bean) {
            this.bean = bean;
        }

        @Override
        public void onSuccess(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            long l = bean.getZans() + 1;
            bean.setZans(l);
            bean.setAlready_zan(AppCommentResBean.ALREADY_ZAN);
            iStaticPromoteActivity.refreshListData();
            iStaticPromoteActivity.cancelWaitView();
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iStaticPromoteActivity.cancelWaitView();
            iStaticPromoteActivity.showMsg(beanContainer.getData().getMessage());
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            iStaticPromoteActivity.cancelWaitView();
        }
    }

    /**
     * 活动页登录触发
     */
    public enum LoginTrigger implements ITriggerCompare {
        BtnAccess(1), ListZan(2);

        private final int tag;

        LoginTrigger(int i) {
            tag = i;
        }

        @Override
        public boolean equals(ITriggerCompare compare) {
            boolean b1 = compare.getClass().getName().equals(getClass().getName());
            boolean b2 = compare.getTag().equals(getTag());
            return b1 & b2;
        }

        @Override
        public Object getTag() {
            return tag;
        }

        @Override
        public Serializable getSerializable() {
            return this;
        }

    }

}
