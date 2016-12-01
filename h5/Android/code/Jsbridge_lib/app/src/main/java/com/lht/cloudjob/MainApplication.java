package com.lht.cloudjob;

import android.app.Application;
import android.content.SharedPreferences;
import android.os.Environment;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.interfaces.keys.DBConfig;
import com.lht.cloudjob.interfaces.keys.SPConstants;
import com.lht.cloudjob.mvp.model.ApiModelCallback;
import com.lht.cloudjob.mvp.model.CategoryModel1;
import com.lht.cloudjob.mvp.model.IndustryCategoryDBModel;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.model.bean.CategoryResBean;
import com.lht.cloudjob.tplogin.QQConstants;
import com.lht.cloudjob.tplogin.WeChatConstants;
import com.lht.cloudjob.util.AppPreference;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.string.StringUtil;
import com.lht.cloudjob.util.time.TimeUtil;
import com.litesuits.orm.LiteOrm;
import com.litesuits.orm.db.assit.WhereBuilder;
import com.squareup.picasso.Picasso;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.tauth.Tencent;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

import java.io.File;
import java.util.ArrayList;

import cn.jpush.android.api.JPushInterface;



/**
 * MainApplication
 * Created by leobert on 2016/4/7.
 */
public class MainApplication extends Application {
    private static MainApplication ourInstance;

    private static Tencent mTencent;

    private static IWXAPI mWechat;

    public static Tencent getTencent() {
        if (mTencent == null) {
            mTencent = Tencent.createInstance(QQConstants.APP_ID, ourInstance); //你的id
        }
        return mTencent;
    }

    public static IWXAPI getWechat() {
        return mWechat;
    }


    @Override
    public void onCreate() {
        super.onCreate();
        DLog.i(getClass(), "[CloudJob] Debug-Mode:" + BuildConfig.DEBUG);
        if (ourInstance == null) {
            ourInstance = this;
        }
        //debug模式检测内存泄漏
//        if (BuildConfig.DEBUG) {
//            if (LeakCanary.isInAnalyzerProcess(this)) {
//                // This process is dedicated to LeakCanary for heap analysis.
//                // You should not init your app in this process.
//                return;
//            }
//            LeakCanary.install(this);
//        }

        Picasso.with(getOurInstance()).setLoggingEnabled(true);
        initUserInfo();
        //jpush
        {
            JPushInterface.setDebugMode(BuildConfig.DEBUG);
            JPushInterface.init(this);
        }

        //umeng
        {
//            MobclickAgent.setDebugMode(true);
//            DLog.d(getClass(), "device info:" + UMengTestHelpler.getDeviceInfo(getOurInstance()));
        }

        EventBus.getDefault().register(this);
        Picasso.setExtendDiskCacheFile(getDefaultPicassoCacheDir());


//        BridgeWebView.MY_DEBUG = BuildConfig.DEBUG;
        JSON.setArrayStrictMode(false);

        if (mWechat == null) {
            mWechat = WXAPIFactory.createWXAPI(this, WeChatConstants.APP_ID, false);
        }

        CategoryModel1 model = new CategoryModel1(new CategoryModelCallback());
        model.doRequest(getOurInstance());
    }

    private File getDefaultPicassoCacheDir() {
        String username = IVerifyHolder.mLoginInfo.getUsername();
        if (StringUtil.isEmpty(username)) {
            username = "default";
        }
        String tmp = Environment.getExternalStorageDirectory() + "/Vso/CloudJob/" + username
                + "/localImageCache";
        File file = new File(tmp);
        if (!file.exists()) {
            file.mkdirs();
        }
        return file;
    }

    private void initUserInfo() {
        SharedPreferences sp = getTokenSp();
        IVerifyHolder.mLoginInfo.setUsername(sp.getString(SPConstants.Token.KEY_USERNAME, ""));
        IVerifyHolder.mLoginInfo.setAccessToken(sp.getString(SPConstants.Token.KEY_ACCESS_TOKEN,
                ""));
    }

    public SharedPreferences getTokenSp() {
        return getSharedPreferences(SPConstants.Token.SP_TOKEN, MODE_PRIVATE);
    }

    @Subscribe
    public void onEventMainThread(AppEvent.LogoutEvent event) {
        finishAll();
    }

    public synchronized void finishAll() {
        DLog.d(getClass(), "finishAll");
        for (UMengActivity activity : activityList) {
            if (activity != null) {
                activity.finish();
            }
//            activityList.remove(activity);
        }
        activityList.clear();
    }

    @Override
    public void onTerminate() {
        EventBus.getDefault().unregister(this);
        super.onTerminate();
    }

    public AppPreference getAppPreference() {
        return AppPreference.getInstance(this);
    }

    public static MainApplication getOurInstance() {
        return ourInstance;
    }

    public static ArrayList<UMengActivity> activityList = new ArrayList<>();

    public static void addActivity(UMengActivity activity) {
        activityList.add(activity);
    }

    public static void removeActivity(UMengActivity activity) {
        activityList.remove(activity);
    }

    private class CategoryModelCallback implements ApiModelCallback<ArrayList<CategoryResBean>> {
        @Override
        public void onSuccess(BaseBeanContainer<ArrayList<CategoryResBean>> beanContainer) {
            ArrayList<CategoryResBean> temp = beanContainer.getData();
            if (temp != null && temp.size() > 0) {
                String s = JSON.toJSONString(temp);
                final IndustryCategoryDBModel model = new IndustryCategoryDBModel();
                model.setCreateTime(TimeUtil.getCurrentTimeInLong());
                model.setData(s);
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        LiteOrm liteOrm =
                                LiteOrm.newSingleInstance(getOurInstance(), DBConfig.BasicDb
                                        .DB_NAME);
                        //删除老数据
                        liteOrm.delete(new WhereBuilder(IndustryCategoryDBModel.class)
                                .lessThan("createTime", TimeUtil.getCurrentTimeInLong()));
                        //插入新数据
                        liteOrm.save(model);
                    }
                }).start();
            }
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            //empty
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            //empty
        }
    }
}
