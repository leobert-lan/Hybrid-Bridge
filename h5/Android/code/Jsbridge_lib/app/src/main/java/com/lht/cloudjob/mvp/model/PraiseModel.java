package com.lht.cloudjob.mvp.model;

import android.content.Context;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.interfaces.net.IApiRequestModel;
import com.lht.cloudjob.interfaces.net.IRestfulApi;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.util.internet.AsyncResponseHandlerComposite;
import com.lht.cloudjob.util.internet.HttpUtil;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestHandle;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;

/**
 * Created by chhyu on 2016/11/15.
 */

public class PraiseModel implements IApiRequestModel {

    private ApiModelCallback<BaseVsoApiResBean> callback;
    private HttpUtil httpUtil;
    private RequestHandle handle;
    private IRestfulApi.PraiseApi api;
    private RequestParams params;

    public PraiseModel(String username, String commentId, ApiModelCallback<BaseVsoApiResBean> callback) {
        this.callback = callback;
        this.httpUtil = HttpUtil.getInstance();
        api = new IRestfulApi.PraiseApi();
        params = api.newRequestParams(username, commentId);
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
                    callback.onSuccess(new BaseBeanContainer<>(bean));
                } else {
                    callback.onFailure(new BaseBeanContainer<>(bean));
                }
            }

            @Override
            public void onFailure(int i, Header[] headers, byte[] bytes, Throwable throwable) {
                callback.onHttpFailure(i);
            }
        });
        handle = httpUtil.postWithParams(context, url, params, composite);
    }

    @Override
    public void cancelRequestByContext(Context context) {
        if (handle != null) {
            handle.cancel(true);
        }
    }
}
