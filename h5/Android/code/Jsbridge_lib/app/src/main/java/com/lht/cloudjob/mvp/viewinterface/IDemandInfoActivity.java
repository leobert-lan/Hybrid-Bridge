package com.lht.cloudjob.mvp.viewinterface;

import com.lht.cloudjob.customview.ThirdPartyShareItemClickListenerImpl;
import com.lht.cloudjob.mvp.model.bean.DemandInfoResBean;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.viewinterface
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> IDemandInfoActivity
 * <p><b>Description</b>: TODO
 * <p> Create by Leobert on 2016/8/22
 */
public interface IDemandInfoActivity extends IActivityAsyncProtected {
    void showErrorMsg(String msg);

    void updateView(DemandInfoResBean bean);

    /**
     * to set the state of the checkbox which shows whether user collected the task;
     * @param isCollected ture if the task is collected by the user,false otherwise;
     */
    void setTaskCollected(boolean isCollected);

    void jump2SignAgreement(DemandInfoResBean demandInfoResBean);

    void jump2Evaluate(DemandInfoResBean demandInfoResBean);

    void jump2UndertakeReward(String task_bn);

    void jump2UndertakeHideBid(String task_bn);

    void jump2UndertakeOpenBid(String task_bn);

    void showEAuthenticaDialog();

    void showPAuthenticaDialog();

    void showBindPhoneDialog();

    void showSharePopwins(String content,ThirdPartyShareItemClickListenerImpl itemClickListener);

    void updateCount(int count);

    void showPorEAuthenticDialog();
}