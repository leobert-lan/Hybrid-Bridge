package com.lht.cloudjob.mvp.model;

import android.content.Context;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.interfaces.net.IApiRequestModel;
import com.lht.cloudjob.interfaces.net.IRestfulApi;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.model.bean.MyAppCommentResBean;
import com.lht.cloudjob.util.internet.AsyncResponseHandlerComposite;
import com.lht.cloudjob.util.internet.HttpUtil;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestHandle;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;

/**
 * Created by chhyu on 2016/11/15.
 * <<<<<<< HEAD
 * //
 * =======
 * >>>>>>> 78c6d6988a57983162334c2bd08ec46beb0a3d07
 */

public class QueryUserIsCommentModel implements IApiRequestModel {

    private ApiModelCallback<MyAppCommentResBean> callback;
    private HttpUtil httpUtil;
    private IRestfulApi.UserIsCommentApi api;
    private RequestParams params;
    private RequestHandle handle;

    public QueryUserIsCommentModel(String username, ApiModelCallback<MyAppCommentResBean>
            callback) {
        this.callback = callback;
        this.httpUtil = HttpUtil.getInstance();
        api = new IRestfulApi.UserIsCommentApi();
        params = api.newRequestParams(username);
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
                    MyAppCommentResBean data = JSON.parseObject(bean.getData(),
                            MyAppCommentResBean.class);
                    callback.onSuccess(new BaseBeanContainer<>(data));
                } else {
                    callback.onFailure(new BaseBeanContainer<>(bean));
                }
            }

            @Override
            public void onFailure(int i, Header[] headers, byte[] bytes, Throwable throwable) {
                callback.onHttpFailure(i);
            }
        });
        handle = httpUtil.getWithParams(context, url, params, composite);
    }

    @Override
    public void cancelRequestByContext(Context context) {
        if (handle != null) {
            handle.cancel(true);
        }
    }
}