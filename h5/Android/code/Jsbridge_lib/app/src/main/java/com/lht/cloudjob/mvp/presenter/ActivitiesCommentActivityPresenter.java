package com.lht.cloudjob.mvp.presenter;

import android.content.Context;
import android.widget.EditText;
import android.widget.Toast;

import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.asyncprotected.AppCommentActivity;
import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.mvp.model.ApiModelCallback;
import com.lht.cloudjob.mvp.model.AppCommentModel;
import com.lht.cloudjob.mvp.model.TextWatcherModel;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.viewinterface.IAppCommentActivity;
import com.lht.cloudjob.util.internet.HttpUtil;
import com.lht.cloudjob.util.string.StringUtil;

import org.greenrobot.eventbus.EventBus;

/**
 * Created by chhyu on 2016/11/15.
 */
@TempVersion(TempVersionEnum.V1019)
public class ActivitiesCommentActivityPresenter implements IApiRequestPresenter {

    private final TextWatcherModel textWatcherModel;
    private IAppCommentActivity iAppCommentActivity;

    public ActivitiesCommentActivityPresenter(IAppCommentActivity iAppCommentActivity) {
        this.iAppCommentActivity = iAppCommentActivity;
        textWatcherModel = new TextWatcherModel(new AppCommentTextWaccherImpl());
    }

    @Override
    public void cancelRequestOnFinish(Context context) {
        HttpUtil.getInstance().onActivityDestroy(context);
    }

    /**
     * 提交评论
     *
     * @param commentContent
     */
    public void doCommitComment(String username, String commentContent) {
        if (StringUtil.isEmpty(commentContent)) {
            iAppCommentActivity.showMsg(iAppCommentActivity.getActivity().getString(R.string.v1019_actiivties_text_activities_toast_content_isempty));
            return;
        }
        iAppCommentActivity.showWaitView(true);
        AppCommentModel model = new AppCommentModel(username, commentContent, new AppCommentModelCallback());
        model.doRequest(iAppCommentActivity.getActivity());
    }

    public void watchInputLength(EditText etCommentContent, int maxLength) {
        textWatcherModel.doWatcher(etCommentContent, maxLength);
    }

    class AppCommentTextWaccherImpl implements TextWatcherModel.TextWatcherModelCallback {

        @Override
        public void onOverLength(int edittextId, int maxLength) {
            //当超过最大长度的时候调用
            iAppCommentActivity.notifyCommentTextLength();
        }

        @Override
        public void onChanged(int edittextId, int currentCount, int remains) {
            iAppCommentActivity.notifyCurrentTextCount(currentCount);
        }
    }


    class AppCommentModelCallback implements ApiModelCallback<BaseVsoApiResBean> {

        @Override
        public void onSuccess(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iAppCommentActivity.cancelWaitView();
            iAppCommentActivity.showMsg(iAppCommentActivity.getActivity().getString(R.string.v1019_actiivties_text_activities_toast_comment_success));
            EventBus.getDefault().post(new AppCommentActivity.AppCommentPostedEvent());
            iAppCommentActivity.getActivity().finish();
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iAppCommentActivity.cancelWaitView();
            iAppCommentActivity.showMsg(beanContainer.getData().getMessage());
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            iAppCommentActivity.cancelWaitView();
            // TODO: 2016/11/15 网络异常
        }
    }
}
