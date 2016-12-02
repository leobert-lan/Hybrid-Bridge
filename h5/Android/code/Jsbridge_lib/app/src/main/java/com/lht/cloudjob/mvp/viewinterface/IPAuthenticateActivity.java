package com.lht.cloudjob.mvp.viewinterface;

import android.app.DatePickerDialog;

import com.lht.cloudjob.customview.CustomPopupWindow;
import com.lht.cloudjob.mvp.model.bean.PAUModelBean;
import com.lht.customwidgetlib.actionsheet.OnActionSheetItemClickListener;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.viewinterface
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> IPAuthenticateActivity
 * <p><b>Description</b>: 个人认证
 * Created by leobert on 2016/8/8.
 */
public interface IPAuthenticateActivity extends IActivityAsyncProtected {

    void showErrorMsg(String msg);


    /**
     * 显示错误视图
     */
    void showErrorView();

    /**
     * 显示为可编辑视图
     */
    void showEditView();

    void showDateSelectDialog(long currentTimeInLong, DatePickerDialog.OnDateSetListener dateSetListener);

    void showValidityEndTime(String endTime);

    void showValidityBeginTime(String beginTime);

    void showOnCheckWaitView(PAUModelBean pauModelBean);

    void showCheckPassView(PAUModelBean pauModelBean);

    void showCheckRefuseView(PAUModelBean pauModelBean);

    void showValidityTimeSelectActionsheet(String[] data, OnActionSheetItemClickListener listener);

    void setHongkongArea();

    void setMacaoArea();

    void showPAuData(PAUModelBean pauModelBean);

    void showUnAuthView(boolean isInited);

    void showPicSelectActionsheet(String[] data, OnActionSheetItemClickListener listener);

    void showDialog(int contentResid, int positiveResid, CustomPopupWindow.OnPositiveClickListener
            onPositiveClickListener);

    void updateIDcardFrontPic(String imageFilePath);

    void updateIDcardBackPic(String imageFilePath);

    void updateHandIDcardPic(String imageFilePath);
}
