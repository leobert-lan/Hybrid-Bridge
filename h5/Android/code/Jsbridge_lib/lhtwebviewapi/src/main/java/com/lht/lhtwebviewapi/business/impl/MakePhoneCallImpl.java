package com.lht.lhtwebviewapi.business.impl;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.google.zxing.common.StringUtils;
import com.lht.lhtwebviewapi.business.API.API;
import com.lht.lhtwebviewapi.business.API.NativeRet;
import com.lht.lhtwebviewapi.business.bean.PhoneNumBean;
import com.lht.lhtwebviewlib.base.Interface.CallBackFunction;
import com.lht.lhtwebviewlib.base.model.BridgeNativeFunction;
import com.lht.lhtwebviewlib.business.bean.BaseResponseBean;
import com.lht.lhtwebviewlib.business.impl.ABSApiImpl;

import java.lang.ref.WeakReference;

/**
 * @author leobert.lan
 * @version 1.0
 * @ClassName: DemoImpl
 * @Description: TODO
 * @date 2016年2月19日 下午4:11:26
 */
public class MakePhoneCallImpl extends ABSApiImpl implements API.CallTelHandler {

    private final WeakReference<Context> contextRef;

    private CallBackFunction mFunction;

    private static final String CALL_SUCCESS = "call_ok";
    private static final String CALL_FAILURE = "call_failure";
    private static final int CALL_FAILURE_RET = 0;

    public MakePhoneCallImpl(Context mContext) {
        contextRef = new WeakReference<>(mContext);
    }

    @Override
    public void handler(String data, CallBackFunction function) {
        mFunction = function;
        Context context = contextRef.get();
        if (context == null) {
            // TODO: 2016/12/2  log and callback
            BaseResponseBean<String> bean = newFailureResBean(CALL_FAILURE_RET, CALL_FAILURE);
            mFunction.onCallBack(JSON.toJSONString(bean));
            return;
        }
        PhoneNumBean phoneNumBean = JSON.parseObject(data, PhoneNumBean.class);

        if (!isBeanError(phoneNumBean)) {
            String number = phoneNumBean.getTelphone();
            Intent intent = new Intent();
            intent.setAction(Intent.ACTION_DIAL);
            intent.setData(Uri.parse("tel:" + number));
            context.startActivity(intent);

            BaseResponseBean<String> bean = newSuccessResBean();
            mFunction.onCallBack(JSON.toJSONString(bean));
        } else {
            //TODO 完善逻辑
            BaseResponseBean<String> bean = newFailureResBean(CALL_FAILURE_RET, CALL_FAILURE);
            mFunction.onCallBack(JSON.toJSONString(bean));
        }
    }

    @Override
    protected boolean isBeanError(Object o) {
        if (o instanceof PhoneNumBean) {
            PhoneNumBean bean = (PhoneNumBean) o;
            if (TextUtils.isEmpty(bean.getTelphone())) {
                Log.wtf(API_NAME,
                        "30001:data error,check bean:" + JSON.toJSONString(bean));
                return BEAN_IS_ERROR;
            }
            if (!bean.getTelphone().matches("[0-9]+")) {
                Log.wtf(API_NAME,
                        "30002:data error,check bean:" + JSON.toJSONString(bean));
                return BEAN_IS_ERROR;
            }
            return BEAN_IS_CORRECT;
        } else {
            Log.wtf(API_NAME,
                    "check you code,bean not match because your error");
            return BEAN_IS_ERROR;
        }
    }

    /*for test*/
//    public
    private BaseResponseBean<String> newSuccessResBean() {
        BaseResponseBean<String> bean = new BaseResponseBean<>();
        bean.setStatus(BaseResponseBean.STATUS_SUCCESS);
        bean.setMsg(CALL_SUCCESS);
        bean.setData(null);
        return bean;
    }

    /*for test*/
//    public
    private BaseResponseBean<String> newFailureResBean(int ret, String msg) {
        BaseResponseBean<String> bean = new BaseResponseBean<>();
        bean.setStatus(BaseResponseBean.STATUS_FAILURE);
        bean.setRet(ret);
        bean.setMsg(msg);
        return bean;
    }

    public static BridgeNativeFunction newInstance(Context context) {
        return new BridgeNativeFunction(API_NAME, new MakePhoneCallImpl(context));
    }

}
