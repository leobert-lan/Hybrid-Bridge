package com.lht.cloudjob.mvp.model;

import android.content.Context;
import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.customview.FilterSheet;
import com.lht.cloudjob.customview.SortSheet;
import com.lht.cloudjob.interfaces.net.IApiRequestModel;
import com.lht.cloudjob.interfaces.net.IRestfulApi;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.model.bean.CategoryResBean;
import com.lht.cloudjob.mvp.model.bean.SearchResBean;
import com.lht.cloudjob.util.internet.AsyncResponseHandlerComposite;
import com.lht.cloudjob.util.internet.HttpUtil;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestHandle;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;

import java.util.ArrayList;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.model
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> SearchModel
 * <p><b>Description</b>: TODO
 * <p> Create by Leobert on 2016/8/29
 *
 * to see API at{@link IRestfulApi.SearchTaskApi}
 * to see ResBean at{@link SearchResBean}
 */
public class SearchModel implements IApiRequestModel {
    private final ApiModelCallback<ArrayList<SearchResBean>> modelCallback;

    private final HttpUtil mHttpUtil;

    private IRestfulApi.SearchTaskApi api;

    private RequestParams params;

    private RequestHandle handle;


    public SearchModel(ApiModelCallback<ArrayList<SearchResBean>> modelCallback) {
        this.modelCallback = modelCallback;
        mHttpUtil = HttpUtil.getInstance();
        api = new IRestfulApi.SearchTaskApi();
    }

    public void setParams(String keyword, CategoryResBean industry,
                          FilterSheet.FilterSelectedItems filters, SortSheet
                                  .SortRules sortRules, int offset)  {
        params = api.newRequestParams(keyword, industry, filters, sortRules, offset);
    }


    /**
     * 执行请求
     * TODO: 合理的处理请求失败情况，
     * 当前的接口出现非200都是网络状态问题，没有赋予特殊含义。
     * 有三层可以处理失败情况：
     * 1.model层内部处理，实质是在Composite中的default实现中处理
     * 2.回调接口的缺省适配器，暂未实现之
     * 3.回调接口实现类单独处理。
     *
     * @param context 发起请求的对象的上下文
     */
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
                    ArrayList<SearchResBean> data =
                            (ArrayList<SearchResBean>) JSON.parseArray(bean.getData(),
                                    SearchResBean.class);
                    modelCallback.onSuccess(new BaseBeanContainer<>(data));
                } else {
                    modelCallback.onFailure(new BaseBeanContainer<>(bean));
                }
            }

            @Override
            public void onFailure(int i, Header[] headers, byte[] bytes, Throwable throwable) {
                modelCallback.onHttpFailure(i);
            }
        });
        handle = mHttpUtil.postWithParams(context, url, params, composite);
    }

    @Override
    public void cancelRequestByContext(Context context) {
        if (handle != null) {
            handle.cancel(true);
        }
    }
}
