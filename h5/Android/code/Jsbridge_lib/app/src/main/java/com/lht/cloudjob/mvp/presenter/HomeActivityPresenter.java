package com.lht.cloudjob.mvp.presenter;

import android.content.Context;

import com.lht.cloudjob.MainApplication;
import com.lht.cloudjob.R;
import com.lht.cloudjob.customview.ThirdPartyShareItemClickListenerImpl;
import com.lht.cloudjob.interfaces.IPublicConst;
import com.lht.cloudjob.interfaces.ITriggerCompare;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.mvp.model.CheckVersionUpdateModel;
import com.lht.cloudjob.mvp.model.pojo.LoginType;
import com.lht.cloudjob.mvp.viewinterface.IHomeActivity;
import com.lht.cloudjob.util.VersionUtil;
import com.lht.cloudjob.util.internet.HttpUtil;

import java.io.Serializable;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.presenter
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> HomeActivityPresenter
 * <p><b>Description</b>: TODO
 * Created by leobert on 2016/7/11.
 */
public class HomeActivityPresenter extends ABSVerifyNeedPresenter implements IApiRequestPresenter {

    private IHomeActivity iHomeActivity;

    public HomeActivityPresenter(IHomeActivity iHomeActivity) {
        this.iHomeActivity = iHomeActivity;
    }

    @Override
    public void identifyTrigger(ITriggerCompare trigger) {
        //TODO
    }

    @Override
    protected boolean isLogin() {
        return false;
    }

    @Override
    public void setLoginStatus(boolean isLogin) {

    }


    public boolean onDrawerItemSelect(LoginType type, int position) {
        if (type == LoginType.Unlogin) {
            onUnloginMenuSelect(position);
        } else if (type == LoginType.UnVerified) {
            onUnverifyMenuSelect(position);
        } else if (type == LoginType.PersonalVerified) {
            onPerMenuSelect(position);
        } else {
            onEntMenuSelect(position);
        }

        return false;
    }


    /**
     * 未登录的菜单情况
     *
     * @param position
     */
    private void onUnloginMenuSelect(int position) {
        this.onUnverifyMenuSelect(position);
    }

    /**
     * 未认证的菜单情况
     *
     * @param position
     */
    private void onUnverifyMenuSelect(int position) {
        switch (position) {
            case 0: //个人资料
                iHomeActivity.jumpPersonalInfo();
                break;
            case 1: //我的关注
                iHomeActivity.jumpMineAttention();
                break;
            case 2: //实名认证
                iHomeActivity.jumpPersonalAuthenticate();
                break;
            case 3: //企业认证
                iHomeActivity.jumpEnterpriseAuthenticate();
                break;
            case 4: //设置
                iHomeActivity.jumpSetting();
                break;
            case 5: //推荐给好友
                callShare();
                break;
            default:
                break;
        }
    }

    private void callShare() {
        ThirdPartyShareItemClickListenerImpl l =
                new ThirdPartyShareItemClickListenerImpl(iHomeActivity.getActivity());
        l.setTitle(iHomeActivity.getAppResource().getString(R.string.share_title));
        l.setSummary(iHomeActivity.getAppResource()
                .getString(R.string.share_app_content));

        iHomeActivity.showSharePopwins(IPublicConst.SHARE_APP_LINK, l);
    }

    /**
     * 个人认证的菜单情况
     *
     * @param position
     */
    private void onPerMenuSelect(int position) {
        this.onUnverifyMenuSelect(position);
    }

    /**
     * 企业认证的菜单情况
     *
     * @param position
     */
    private void onEntMenuSelect(int position) {
        switch (position) {
            case 0: //个人资料
                iHomeActivity.jumpPersonalInfo();
                break;
            case 1: //我的关注
                iHomeActivity.jumpMineAttention();
                break;
            case 2: //企业认证
                iHomeActivity.jumpEnterpriseAuthenticate();
                break;
            case 3: //设置
                iHomeActivity.jumpSetting();
                break;
            case 4: //推荐给好友
                callShare();
                break;
            default:
                break;
        }
    }

    @Override
    public void cancelRequestOnFinish(Context context) {
        HttpUtil.getInstance().onActivityDestroy(context);
    }

    public enum LoginTrigger implements ITriggerCompare {
        SidebarBtnLogin(1), B(2);

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

    /**
     * 检查版本更新
     */
    public void checkVersionUpdate() {
        Context context = MainApplication.getOurInstance();
        CheckVersionUpdateModel model = new CheckVersionUpdateModel(
                VersionUtil.getVersion(context), new VersionUtil.VersionCheckCallback(context));
        model.doRequest(iHomeActivity.getActivity());
    }
}