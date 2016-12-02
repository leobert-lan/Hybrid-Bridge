package com.lht.cloudjob.mvp.presenter;

import android.content.Context;

import com.lht.cloudjob.R;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.mvp.model.ApiModelCallback;
import com.lht.cloudjob.mvp.model.SignAgreementModel;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.viewinterface.ISignAgreementActivity;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.presenter
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> SignAgreementPresenter
 * <p><b>Description</b>: TODO
 * <p>Created by Administrator on 2016/9/20.
 */

public class SignAgreementPresenter implements IApiRequestPresenter {

    private final ISignAgreementActivity iSignAgreementActivity;
    //是否同意协议
    private boolean isProtocolAgreed = false;

    public SignAgreementPresenter(ISignAgreementActivity iSignAgreementActivity) {
        this.iSignAgreementActivity = iSignAgreementActivity;
    }

    @Override
    public void cancelRequestOnFinish(Context context) {

    }

    public void setIsProtocolAgreed(boolean isProtocolAgreed) {
        this.isProtocolAgreed = isProtocolAgreed;
    }

//    /**
//     * 不同意签署协议
//     *  可以不阅读和同意《蓝海创意云用户服务协议》
//     */
//    public void callNotAgreeSignagreement() {
//
//    }

    /**
     * 签署协议
     *
     * @param task_bn
     * @param username
     * @param flag_agree 是否同意签署协议
     */
    public void callAgreeSignagreement(String task_bn, String username, boolean flag_agree) {
        if (flag_agree) {
            if (isProtocolAgreed) {
                doSignAgreement(task_bn, username, flag_agree);
            } else {
                iSignAgreementActivity.showErrorMsg(iSignAgreementActivity
                        .getAppResource().getString(R.string.v1010_default_sign_agreement_toast_read_agreement));
                return;
            }
        } else {
            doSignAgreement(task_bn, username, flag_agree);
        }
    }

    private void doSignAgreement(String task_bn, String username, boolean flag_agree) {
        SignAgreementModel model = new SignAgreementModel(task_bn, username, flag_agree, new SignAgreementModelCallback());
        model.doRequest(iSignAgreementActivity.getActivity());
    }

    class SignAgreementModelCallback implements ApiModelCallback<BaseVsoApiResBean> {

        @Override
        public void onSuccess(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iSignAgreementActivity.cancelWaitView();
            iSignAgreementActivity.showMsg(iSignAgreementActivity.getActivity().getString(R.string.v1010_default_sign_agreement_success));
            iSignAgreementActivity.finishActivity();
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iSignAgreementActivity.cancelWaitView();
            iSignAgreementActivity.showErrorMsg(iSignAgreementActivity.getActivity().getString(R.string.v1010_default_sign_agreement_failure));
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            iSignAgreementActivity.cancelWaitView();
            // TODO: 2016/9/21

        }
    }
}
