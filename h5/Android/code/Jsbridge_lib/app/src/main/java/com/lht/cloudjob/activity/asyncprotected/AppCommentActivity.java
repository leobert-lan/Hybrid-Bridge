package com.lht.cloudjob.activity.asyncprotected;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
import com.lht.cloudjob.customview.CustomDialog;
import com.lht.cloudjob.customview.CustomPopupWindow;
import com.lht.cloudjob.customview.TitleBar;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.mvp.presenter.ActivitiesCommentActivityPresenter;
import com.lht.cloudjob.mvp.viewinterface.IAppCommentActivity;

@TempVersion(TempVersionEnum.V1019)
public class AppCommentActivity extends AsyncProtectedActivity implements IAppCommentActivity {

    private static final String PAGENAME = "AppCommentActivity";
    private EditText etCommentContent;
    private TextView tvRemind;
    private TextView tvRemindContent;
    private Button btnCommit;
    private ActivitiesCommentActivityPresenter presenter;
    //    private static final String username = "86911558";
    private ProgressBar progressBar;
    private TitleBar titleBar;
    private TextView tvCurrentCount;
    private static final int APP_COMMENT_MAXLENTH = 140;
    public static final String KEY_DATA = "_data_username";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_app_comment);
        initView();
        initVariable();
        initEvent();
    }

    private boolean hasLearned = false;


    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        if (!hasLearned) {
            showFriendAlert();
        }
    }

    private void showFriendAlert() {
        final CustomDialog dialog = new CustomDialog(this);
        dialog.setContent(R.string.v1019_dialog_ac_rule);
        dialog.setPositiveButton(R.string.permit);
        dialog.setPositiveClickListener(new CustomPopupWindow.OnPositiveClickListener() {
            @Override
            public void onPositiveClick() {
                dialog.dismiss();
            }
        });
        dialog.showSingle();
        hasLearned = true;
    }

    @Override
    protected void initView() {
        titleBar = (TitleBar) findViewById(R.id.titlebar);
        progressBar = (ProgressBar) findViewById(R.id.progressbar);
        etCommentContent = (EditText) findViewById(R.id.et_app_commentcontent);
        tvCurrentCount = (TextView) findViewById(R.id.tv_comment_currentcount);
        tvRemind = (TextView) findViewById(R.id.tv_app_remind);
        tvRemindContent = (TextView) findViewById(R.id.tv_app_remindcontent);
        btnCommit = (Button) findViewById(R.id.btn_app_commit);
        btnCommit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String commentContent = etCommentContent.getText().toString();
                presenter.doCommitComment(getUsername(), commentContent);
            }
        });

    }

    private String getUsername() {
        return getIntent().getStringExtra(KEY_DATA);
    }

    @Override
    protected void initVariable() {
        presenter = new ActivitiesCommentActivityPresenter(this);
    }

    @Override
    protected void initEvent() {
        titleBar.setDefaultOnBackListener(this);
        titleBar.setTitle(getString(R.string.v1019_actiivties_comment_title));
        tvRemindContent.setText("\t\t\t\t" + getString(R.string
                .v1019_actiivties_text_activities_remind_content));
        presenter.watchInputLength(etCommentContent, APP_COMMENT_MAXLENTH);
    }

    @Override
    protected String getPageName() {
        return PAGENAME;
    }

    @Override
    public UMengActivity getActivity() {
        return AppCommentActivity.this;
    }

    @Override
    protected IApiRequestPresenter getApiRequestPresenter() {
        return presenter;
    }

    @Override
    public ProgressBar getProgressBar() {
        return progressBar;
    }

    /**
     * 超过最大长度的时候
     */
    @Override
    public void notifyCommentTextLength() {
        Toast.makeText(this, R.string.v1019_actiivties_text_activities_toast_over_length, Toast
                .LENGTH_SHORT).show();
    }

    /**
     * 更新当前输入的字数
     *
     * @param currentCount
     */
    @Override
    public void notifyCurrentTextCount(int currentCount) {
        StringBuilder sb = new StringBuilder();
        sb.append(currentCount + "/" + APP_COMMENT_MAXLENTH);
        tvCurrentCount.setText(sb);
    }

    public static class AppCommentPostedEvent {}
}
