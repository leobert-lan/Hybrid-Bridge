package com.lht.cloudjob.mvp.viewinterface;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.viewinterface
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> IResetPwdVerifyActivity
 * <p><b>Description</b>: TODO
 * Created by leobert on 2016/7/25.
 */
public interface IResetPwdVerifyActivity extends IActivityAsyncProtected {

    void showErrorMsg(String msg);

    void jump2SetPwd(String account);

    /**
     * 重新初始化验证码获取按钮
     * @param resid 字符串资源
     */
    void initVCGetter(int resid);

    void showCDRemaining(String formatTime);

    /**
     * @param isEnabled 是否可点
     */
    void setVCGetterActiveStatus(boolean isEnabled);
}