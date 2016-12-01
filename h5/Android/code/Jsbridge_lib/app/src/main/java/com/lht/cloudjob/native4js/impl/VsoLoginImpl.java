package com.lht.cloudjob.native4js.impl;

import android.content.Context;

import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.mvp.model.pojo.LoginInfo;
import com.lht.cloudjob.native4js.Native4JsExpandAPI;
import com.lht.lhtwebviewlib.base.Interface.CallBackFunction;
import com.lht.lhtwebviewlib.business.impl.ABSApiImpl;
import com.lht.lhtwebviewlib.business.impl.ABSLTRApiImpl;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

import java.lang.ref.WeakReference;

/**
 * <p><b>Package</b> com.lht.cloudjob.native4js.impl
 * <p><b>Project</b> Jsbridge_lib
 * <p><b>Classname</b> VsoLoginImpl
 * <p><b>Description</b>: TODO
 * <p>Created by leobert on 2016/12/1.
 */

public class VsoLoginImpl extends ABSApiImpl implements Native4JsExpandAPI.VsoLoginHandler,IVerifyHolder{
    private final WeakReference<Context> contextRef;
    public VsoLoginImpl(Context context) {
        contextRef = new WeakReference<>(context);
        EventBus.getDefault().register(this);
    }

    @Override
    @Subscribe
    public void onEventMainThread(AppEvent.LoginSuccessEvent event) {
        mLoginInfo.copy(event.getLoginInfo());

    }

    /**
     * desc: 未进行登录的事件订阅
     *
     * @param event 手动关闭登录页事件
     */
    @Override
    @Subscribe
    public void onEventMainThread(AppEvent.LoginCancelEvent event) {
        //empty
    }

    @Override
    public LoginInfo getLoginInfo() {
        return mLoginInfo;
    }

    @Override
    public void handler(String s, CallBackFunction callBackFunction) {

    }



    @Override
    protected boolean isBeanError(Object o) {
        return BEAN_IS_CORRECT;
    }

    @Override
    protected void finalize() throws Throwable {
        EventBus.getDefault().unregister(this);
        super.finalize();
    }
}
