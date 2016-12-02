package com.lht.cloudjob.util;

import android.content.Context;

import com.lht.cloudjob.R;
import com.lht.cloudjob.mvp.model.pojo.NavigationItem;

import java.util.ArrayList;
import java.util.List;

public class Utils {
    private static Utils mDatas;
    private List<NavigationItem> mListUnLogin;

    private List<NavigationItem> mListUnVerified;

    private List<NavigationItem> mListPersonalVerified;

    private List<NavigationItem> mListEnterpriseVerified;

    private Utils(Context context) {
        mListUnLogin = new ArrayList<>();
        mListUnLogin.add(new NavigationItem("个人资料", context.getResources().getDrawable(R.drawable.navigationicon_selector_personalinfo), Style.DISBALE));
        mListUnLogin.add(new NavigationItem("我的关注", context.getResources().getDrawable(R.drawable.navigationicon_selector_myattention), Style.DISBALE));
        mListUnLogin.add(new NavigationItem("实名认证", context.getResources().getDrawable(R.drawable.navigationicon_selector_peridentify), Style.DISBALE));
        mListUnLogin.add(new NavigationItem("企业认证", context.getResources().getDrawable(R.drawable.navigationicon_selector_entidentify), Style.DISBALE));
        mListUnLogin.add(new NavigationItem("设置", context.getResources().getDrawable(R.drawable.navigationicon_selector_setup), Style.DEFAULT));
        mListUnLogin.add(new NavigationItem("推荐给好友", context.getResources().getDrawable(R.drawable.navigationicon_selector_recommend), Style.DEFAULT));

        //

        mListUnVerified = new ArrayList<>();
        mListUnVerified.add(new NavigationItem("个人资料", context.getResources().getDrawable(R.drawable.navigationicon_selector_personalinfo), Style.DEFAULT));
        mListUnVerified.add(new NavigationItem("我的关注", context.getResources().getDrawable(R.drawable.navigationicon_selector_myattention), Style.DEFAULT));
        mListUnVerified.add(new NavigationItem("实名认证", context.getResources().getDrawable(R.drawable.navigationicon_selector_peridentify), Style.DEFAULT));
        mListUnVerified.add(new NavigationItem("企业认证", context.getResources().getDrawable(R.drawable.navigationicon_selector_entidentify), Style.DEFAULT));
        mListUnVerified.add(new NavigationItem("设置", context.getResources().getDrawable(R.drawable.navigationicon_selector_setup), Style.DEFAULT));
        mListUnVerified.add(new NavigationItem("推荐给好友", context.getResources().getDrawable(R.drawable.navigationicon_selector_recommend), Style.DEFAULT));

        //

        mListPersonalVerified = new ArrayList<>();
        mListPersonalVerified.add(new NavigationItem("个人资料", context.getResources().getDrawable(R.drawable.navigationicon_selector_personalinfo), Style.DEFAULT));
        mListPersonalVerified.add(new NavigationItem("我的关注", context.getResources().getDrawable(R.drawable.navigationicon_selector_myattention), Style.DEFAULT));
        mListPersonalVerified.add(new NavigationItem("实名认证", "(已认证)", context.getResources().getDrawable(R.drawable.navigationicon_selector_peridentify), Style.DEFAULT));
        mListPersonalVerified.add(new NavigationItem("企业认证", "(可升级到企业认证)", context.getResources().getDrawable(R.drawable.navigationicon_selector_entidentify), Style.DEFAULT));
        mListPersonalVerified.add(new NavigationItem("设置", context.getResources().getDrawable(R.drawable.navigationicon_selector_setup), Style.DEFAULT));
        mListPersonalVerified.add(new NavigationItem("推荐给好友", context.getResources().getDrawable(R.drawable.navigationicon_selector_recommend), Style.DEFAULT));

        //
        mListEnterpriseVerified = new ArrayList<>();
        mListEnterpriseVerified.add(new NavigationItem("个人资料", context.getResources().getDrawable(R.drawable.navigationicon_selector_personalinfo), Style.DEFAULT));
        mListEnterpriseVerified.add(new NavigationItem("我的关注", context.getResources().getDrawable(R.drawable.navigationicon_selector_myattention), Style.DEFAULT));
        mListEnterpriseVerified.add(new NavigationItem("企业认证", "(已认证)", context.getResources().getDrawable(R.drawable.navigationicon_selector_entidentify), Style.DEFAULT));
        mListEnterpriseVerified.add(new NavigationItem("设置", context.getResources().getDrawable(R.drawable.navigationicon_selector_setup), Style.DEFAULT));
        mListEnterpriseVerified.add(new NavigationItem("推荐给好友", context.getResources().getDrawable(R.drawable.navigationicon_selector_recommend), Style.DEFAULT));

    }

    public static Utils getInstance(Context context) {
        if (mDatas == null) {
            synchronized (Utils.class) {
                if (mDatas == null) {
                    mDatas = new Utils(context);
                }
            }
        }
        return mDatas;

    }


    public List<NavigationItem> getMenuUnlogin() {
        return new ArrayList<NavigationItem>(mListUnLogin);
    }

    public List<NavigationItem> getMenuUnverified() {
        return new ArrayList<NavigationItem>(mListUnVerified);
    }

    public List<NavigationItem> getMenuPersonalVerified() {
        return new ArrayList<NavigationItem>(mListPersonalVerified);
    }

    public List<NavigationItem> getMenuEnterpriseVerified() {
        return new ArrayList<NavigationItem>(mListEnterpriseVerified);
    }

    //滚动事件
    public enum ScrollDirection {
        UP,
        DOWN,
        SAME
    }

    public enum Style {
        DISBALE, DEFAULT, HASLINE, NO_ICON;
    }

}
