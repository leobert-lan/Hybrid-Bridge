package com.lht.cloudjob.mvp.viewinterface;

import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
import com.lht.cloudjob.mvp.model.bean.AppCommentPeriodResBean;
import com.lht.cloudjob.mvp.model.bean.AppCommentResBean;
import com.lht.cloudjob.mvp.model.bean.MyAppCommentResBean;

import java.util.ArrayList;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.viewinterface
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> IStaticPromoteActivity
 * <p><b>Description</b>: TODO
 * <p>Created by leobert on 2016/11/14.
 */
@TempVersion(TempVersionEnum.V1019)
public interface IStaticPromoteActivity extends IActivityAsyncProtected {
    /**
     * 显示评论入口
     */
    void enableCommentAccess();

    /**
     * 隐藏评论入口
     */
    void disableCommentAccess();

    void finishRefresh();

    void showEmptyView();

    void setListData(ArrayList<AppCommentResBean> data);

    void hideEmptyView();

    void addListData(ArrayList<AppCommentResBean> data);

    void showMyComment(MyAppCommentResBean myAppCommentResBean);

    void jumpToAppcomment();

    void refreshListData();

    void updatePeriod(AppCommentPeriodResBean periodResBean);
}
