package com.lht.cloudjob.mvp.model;

import android.content.Context;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
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
 * to see API at{@link IRestfulApi.AppCommentApi}
 */
@TempVersion(TempVersionEnum.V1019)
public class AppCommentModel implements IApiRequestModel {

    private ApiModelCallback<BaseVsoApiResBean> callback;
    private final HttpUtil httpUtil;
    private final IRestfulApi.AppCommentApi api;
    private RequestParams params;
    private RequestHandle handle;

    public AppCommentModel(String username, String commentContent, ApiModelCallback<BaseVsoApiResBean> callback) {
        this.callback = callback;
        this.httpUtil = HttpUtil.getInstance();
        api = new IRestfulApi.AppCommentApi();
        params = api.newRequestParams(username, commentContent);
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
