package com.lht.cloudjob.mvp.viewinterface;

import android.app.DatePickerDialog;

import com.lht.cloudjob.customview.CustomPopupWindow;
import com.lht.cloudjob.mvp.model.bean.BasicInfoResBean;
import com.lht.cloudjob.mvp.model.bean.EAUModelBean;
import com.lht.cloudjob.mvp.model.bean.PAUModelBean;
import com.lht.customwidgetlib.actionsheet.OnActionSheetItemClickListener;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.viewinterface
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> IEnterpriseAuthenticateActivity
 * <p><b>Description</b>: TODO
 * <p>Created by Administrator on 2016/9/5.
 */

public interface IEnterpriseAuthenticateActivity extends IActivityAsyncProtected {


    void showErrorMsg(String msg);

    String getRegion();

    /**
     * 显示错误视图
     */
    void showErrorView();

    /**
     * 显示为可编辑视图
     */
    void showEditView();

    /**
     * 显示认证企业有效期
     *
     * @param data
     * @param listener
     */
    void showValidityTimeSelectActionsheet(String[] data, OnActionSheetItemClickListener listener);

    /**
     * 设置认证企业的有效期限(长期)
     */
    void setLongValidityTime();

    /**
     * 设置认证企业的有效期限(短期)
     */
    void setShortValidityTime();

    void showDateSelectDialog(long currentTimeInLong, DatePickerDialog.OnDateSetListener dateSetListener);

    void showValidityEndTime(String endTime);

    void showValidityBeginTime(String beginTime);

    void showOnCheckWaitView(EAUModelBean eauModelBean);

    void showCheckPassView(EAUModelBean eauModelBean);

    void showCheckRefauseView(EAUModelBean eauModelBean);

    /**
     * 未提交认证的情况下，通过获取持久化数据填充视图
     * @param isInited    是否已经获取持久化数据并填充
     */
    void showUnAuthView(boolean isInited);

    void setHongkongArea();

    void setMacaoArea();

    void showEAuData(EAUModelBean eauModelBean);

    /**
     * 显示上传营业执照
     * @param data
     * @param onActionSheetItemClickListener
     */
    void showLicensePicSelectActionsheet(String[] data, OnActionSheetItemClickListener onActionSheetItemClickListener);

    void showDialog(int contentResid, int positiveResid, CustomPopupWindow.OnPositiveClickListener
            onPositiveClickListener);

    /**
     * 更新本地图片
     * @param imageFilePath
     */
    void updateLocalPic(String imageFilePath);
}
