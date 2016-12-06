package com.lht.cloudjob.native4js.impl;

import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.service.DownloadFileService;
import com.lht.lhtwebviewapi.business.API.API;
import com.lht.lhtwebviewapi.business.API.NativeRet;
import com.lht.cloudjob.native4js.expandresbean.DownloadBean;
import com.lht.lhtwebviewlib.base.Interface.CallBackFunction;
import com.lht.lhtwebviewlib.business.bean.BaseResponseBean;
import com.lht.lhtwebviewlib.business.impl.ABSApiImpl;

import org.greenrobot.eventbus.Subscribe;

import java.io.File;

/**
 * Created by chhyu on 2016/12/6.
 */

public class DownloadImpl extends ABSApiImpl implements API.DownloadHandler {

    private final Context mContext;
    private CallBackFunction mFunction;
    private static String MSG_ERROR;

    public DownloadImpl(Context ctx) {
        this.mContext = ctx;
    }

    @Override
    public void handler(String s, CallBackFunction callBackFunction) {
        this.mFunction = callBackFunction;
        DownloadBean downloadBean = JSON.parseObject(s, DownloadBean.class);
        boolean bool = isBeanError(downloadBean);

        if (!bool) {
            //启动service 去下载
            Intent intentService = new Intent(mContext, DownloadFileService.class);
            String data = JSON.toJSONString(downloadBean);
            intentService.putExtra(DownloadFileService.DOWNLOAD_INFO, data);
            mContext.startService(intentService);

        } else {
            BaseResponseBean bean = new BaseResponseBean();
            bean.setMsg(MSG_ERROR);
            bean.setData("");
            mFunction.onCallBack(JSON.toJSONString(bean));
        }
    }

    @Subscribe
    public void onDownloadSuccess(AppEvent.DownloadSuccessEvent event) {
        File file = event.getFile();
        if (file == null) {
            return;
        }
        BaseResponseBean bean = new BaseResponseBean();
        bean.setRet(NativeRet.RET_SUCCESS);
        bean.setMsg("OK");
        bean.setData("");
        mFunction.onCallBack(JSON.toJSONString(bean));
    }

    @Override
    protected boolean isBeanError(Object o) {
        if (o instanceof DownloadBean) {
            DownloadBean bean = (DownloadBean) o;
            if (TextUtils.isEmpty(bean.getFileName())) {
                MSG_ERROR = "您要下载的文件名为空";
//                mFunction.onCallBack(MSG_ERROR);
                return BEAN_IS_ERROR;
            }
            if (TextUtils.isEmpty(bean.getFileUrl())) {
                MSG_ERROR = "您要下载的文件地址为空";
//                mFunction.onCallBack(MSG_ERROR);
                return BEAN_IS_ERROR;
            }

            return BEAN_IS_CORRECT;
        } else {
            Log.wtf(API_NAME, "check you code,bean not match because your error");
            return BEAN_IS_ERROR;
        }
    }
}
