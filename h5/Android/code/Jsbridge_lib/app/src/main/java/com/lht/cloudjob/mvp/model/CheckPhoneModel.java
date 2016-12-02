package com.lht.cloudjob.mvp.model;

import android.content.Context;
import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.interfaces.net.IApiRequestModel;
import com.lht.cloudjob.interfaces.net.IRestfulApi;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.internet.AsyncResponseHandlerComposite;
import com.lht.cloudjob.util.internet.HttpUtil;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestHandle;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.model
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> CheckPhoneModel
 * <p><b>Description</b>: 注册时，检验手机号是否合法，
 * Created by leobert on 2016/7/22.
 *  to see API at{@link IRestfulApi.CheckPhoneApi}
 *   to see ResBean at{@link BaseVsoApiResBean}
 */
public class CheckPhoneModel implements IApiRequestModel {
    private final ApiModelCallback<BaseVsoApiResBean> modelCallback;

    private final HttpUtil mHttpUtil;

    private IRestfulApi.CheckPhoneApi api;

    private RequestParams params;

    private RequestHandle handle;


    public CheckPhoneModel(String phone, ApiModelCallback<BaseVsoApiResBean> modelCallback) {
        this.modelCallback = modelCallback;
        mHttpUtil = HttpUtil.getInstance();
        api = new IRestfulApi.CheckPhoneApi();
        params = api.newRequestParams(phone);
    }


    @Override
    public void cancelRequestByContext(Context context) {
        if (handle != null) {
            handle.cancel(true);
        }
    }

    @Override
    public void doRequest(Context context) {
        String url = api.formatUrl(null);
        AsyncResponseHandlerComposite composite = new AsyncResponseHandlerComposite(url, params);
        composite.addHandler(new AsyncHttpResponseHandler() {
            @Override
            public void onSuccess(int i, Header[] headers, byte[] bytes) {
                if (bytes == null || bytes.length < 1) {
                    return;
                }
                String res = new String(bytes);
                BaseVsoApiResBean bean = JSON.parseObject(res, BaseVsoApiResBean.class);
                if (bean.isSuccess()) {
                    modelCallback.onSuccess(new BaseBeanContainer<>(bean));
                } else {
                    modelCallback.onFailure(new BaseBeanContainer<>(bean));
                }
                DLog.e(getClass(), "check2:\r\n" + JSON.toJSONString(bean));
            }

            @Override
            public void onFailure(int i, Header[] headers, byte[] bytes, Throwable throwable) {
                modelCallback.onHttpFailure(i);
            }
        });
        handle = mHttpUtil.getWithParams(context, url, params, composite);
    }
}
