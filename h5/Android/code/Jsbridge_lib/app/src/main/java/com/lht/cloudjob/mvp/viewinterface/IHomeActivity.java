package com.lht.cloudjob.mvp.viewinterface;

import com.lht.cloudjob.customview.ThirdPartyShareItemClickListenerImpl;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.viewinterface
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> IHomeActivity
 * <p><b>Description</b>: TODO
 * Created by leobert on 2016/7/11.
 */
public interface IHomeActivity extends IActivityAsyncProtected {

    void jumpPersonalInfo();

    void jumpMineAttention();

    void jumpPersonalAuthenticate();

    void jumpEnterpriseAuthenticate();

    void jumpSetting();

    /**
     * TODO 数据和回调作为参数
     */
    void showRecomendActionSheet();

    void showSharePopwins(String content,
                          ThirdPartyShareItemClickListenerImpl itemClickListener);
}
