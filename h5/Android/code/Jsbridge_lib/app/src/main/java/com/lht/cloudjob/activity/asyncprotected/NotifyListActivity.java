package com.lht.cloudjob.activity.asyncprotected;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;

import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.activity.innerweb.MessageInfoActivity;
import com.lht.cloudjob.adapter.ListAdapter2;
import com.lht.cloudjob.adapter.viewprovider.MessageItemViewProviderImpl;
import com.lht.cloudjob.customview.CustomDialog;
import com.lht.cloudjob.customview.CustomPopupWindow;
import com.lht.cloudjob.customview.MaskView;
import com.lht.cloudjob.customview.TitleBarModify;
import com.lht.cloudjob.interfaces.IPublicConst;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.interfaces.net.IRestfulApi;
import com.lht.cloudjob.mvp.model.bean.MessageListItemResBean;
import com.lht.cloudjob.mvp.presenter.MessageListActivityPresenter;
import com.lht.cloudjob.mvp.viewinterface.IMessageListActivity;
import com.lht.ptrlib.library.PullToRefreshBase;
import com.lht.ptrlib.library.PullToRefreshListView;
import com.lht.ptrlib.library.PullToRefreshUtil;

import java.util.ArrayList;

public class NotifyListActivity extends AsyncProtectedActivity implements IMessageListActivity,
        ListAdapter2.ICustomizeListItem2<MessageListItemResBean, MessageItemViewProviderImpl
                .ViewHolder>, View.OnClickListener {

    private static final String PAGENAME = "NotifyListActivity";

    public static final String KEY_DATA = "_data_username";
    /**
     * 详情页面
     */
    private static final String URL_FORMAT = IPublicConst.MSGINFO_URL_FORMAT;
    private ProgressBar progressBar;
    private TitleBarModify titleBar;
    private MessageListActivityPresenter presenter;

    private PullToRefreshListView pullToRefreshListView;

    private ListAdapter2<MessageListItemResBean> listAdapter;

    private MessageItemViewProviderImpl itemViewProvider;

    private LinearLayout llBottomBar;

    private Button btnMarkRead;

    private Button btnDelete;

    private MaskView maskView;
    private String username;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notify_list);
        username = getIntent().getStringExtra(KEY_DATA);
        initView();
        initVariable();
        initEvent();
    }

    @Override
    protected String getPageName() {
        return NotifyListActivity.PAGENAME;
    }

    @Override
    public UMengActivity getActivity() {
        return NotifyListActivity.this;
    }

    @Override
    protected void initView() {
        progressBar = (ProgressBar) findViewById(R.id.progressbar);
        titleBar = (TitleBarModify) findViewById(R.id.titlebar);

        pullToRefreshListView = (PullToRefreshListView) findViewById(R.id.message_list);
        llBottomBar = (LinearLayout) findViewById(R.id.buttom_bar);

        btnMarkRead = (Button) findViewById(R.id.message_btn_markbread);
        btnDelete = (Button) findViewById(R.id.message_btn_delete);

        maskView = (MaskView) findViewById(R.id.mask);
    }

    @Override
    protected void initVariable() {
        String username = getIntent().getStringExtra(KEY_DATA);
        presenter = new MessageListActivityPresenter(username, this);
        itemViewProvider = new MessageItemViewProviderImpl(getLayoutInflater(), this);
        listAdapter = new ListAdapter2<>(new ArrayList<MessageListItemResBean>(), itemViewProvider);
        pullToRefreshListView.getRefreshableView().setAdapter(listAdapter);
    }

    @Override
    protected void initEvent() {
        titleBar.setDefaultOnBackListener(getActivity());
        titleBar.setTitle(R.string.title_activity_notifylist);
        pullToRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        pullToRefreshListView.setOnRefreshListener(refreshListener);

        titleBar.setRightOnToggleListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                //模式切换

                itemViewProvider.setModifyModeEnable(isChecked);
                listAdapter.notifyDataSetChanged();
                if (isChecked) {
                    llBottomBar.setVisibility(View.VISIBLE);
                } else {
                    llBottomBar.setVisibility(View.GONE);
                    deselectAll();
                }
            }
        });

        titleBar.setLeftOnToggleListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                //全选
                ArrayList<MessageListItemResBean> data = listAdapter.getAll();
                if (data == null) {
                    data = new ArrayList<>();
                }
                for (MessageListItemResBean bean : data) {
                    bean.setIsSelected(true);
                }
                listAdapter.setLiData(data);
            }
        });

        btnDelete.setOnClickListener(this);
        btnMarkRead.setOnClickListener(this);

        presenter.callRefreshMessages(IRestfulApi.MessageListApi.MessageType.NOTIFY);
    }

    private PullToRefreshBase.OnRefreshListener2<ListView> refreshListener = new
            PullToRefreshBase.OnRefreshListener2<ListView>() {
                @Override
                public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
                    PullToRefreshUtil.updateLastFreshTime(getActivity(), refreshView);
                    presenter.callRefreshMessages(IRestfulApi.MessageListApi.MessageType.NOTIFY);
                }

                @Override
                public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
                    PullToRefreshUtil.updateLastFreshTime(getActivity(), refreshView);
                    presenter.callAddMessages(listAdapter.getCount(),
                            IRestfulApi.MessageListApi.MessageType.NOTIFY);
                }
            };

    @Override
    protected IApiRequestPresenter getApiRequestPresenter() {
        return presenter;
    }

    @Override
    public ProgressBar getProgressBar() {
        return progressBar;
    }

    @Override
    public void setMessageListData(ArrayList<MessageListItemResBean> data) {
        maskView.hide();
        listAdapter.setLiData(data);
    }

    @Override
    public void addMessageListData(ArrayList<MessageListItemResBean> data) {
        maskView.hide();
        listAdapter.addLiData(data);
    }

    @Override
    public void showErrorMsg(String msg) {
        showMsg(msg);
    }

    @Override
    public void showEmptyView() {
        titleBar.setHideRightToggle();
        maskView.showAsEmpty(getString(R.string.v1010_mask_empty_msg));
    }

    @Override
    public void finishModify() {
        titleBar.finishModify();
        deselectAll();
    }

    @Override
    public void showRetryView(View.OnClickListener listener) {
        maskView.showAsNetErrorRetry(listener);
    }

    @Override
    public IRestfulApi.MessageListApi.MessageType askMessageType() {
        return IRestfulApi.MessageListApi.MessageType.NOTIFY;
    }

    /**
     * 显示删除询问
     *
     * @param positiveClickListener 确认时的回掉
     */
    @Override
    public void showDeleteAlert(CustomPopupWindow.OnPositiveClickListener positiveClickListener) {
        CustomDialog dialog = new CustomDialog(this);
        dialog.setContent(R.string.v1010_dialog_message_content_delete);
        dialog.setNegativeButton(R.string.cancel);
        dialog.setPositiveButton(R.string.permit);
        dialog.setPositiveClickListener(positiveClickListener);
        dialog.show();
    }

    @Override
    public void finishRefresh() {
        PullToRefreshUtil.updateLastFreshTime(this, pullToRefreshListView);
        pullToRefreshListView.onRefreshComplete();
    }


    @Override
    public void customize(final int position, final MessageListItemResBean data, View
            convertView, final MessageItemViewProviderImpl.ViewHolder viewHolder) {
        viewHolder.cbSelect.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener
                () {

            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                data.setIsSelected(isChecked);
                listAdapter.replaceData(position, data);

                if (isChecked) {
                    viewHolder.rlRoot.setBackgroundResource(R.color.h6_divider);
                    viewHolder.line.setVisibility(View.INVISIBLE);
                } else {
                    viewHolder.rlRoot.setBackgroundResource(R.color.bg_white);
                    viewHolder.line.setVisibility(View.VISIBLE);
                }
            }
        });
        viewHolder.rlRoot.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!itemViewProvider.isModifyMode()) {
                    String auth_token = IVerifyHolder.mLoginInfo.getAccessToken();
                    String url = String.format(URL_FORMAT, data.getMsg_id(), auth_token, username);
                    data.setView_status(MessageListItemResBean.STATUS_READ);
                    listAdapter.notifyDataSetChanged();
                    start(MessageInfoActivity.class, MessageInfoActivity.KEY_DATA, url);
                }
            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.message_btn_delete:
                callDelete();
                break;
            case R.id.message_btn_markbread:
                callMarkRead();
                break;
            default:
                break;
        }
    }

    private void deselectAll() {
        ArrayList<MessageListItemResBean> data = listAdapter.getAll();
        for (MessageListItemResBean bean : data) {
            bean.setIsSelected(false);
        }
        listAdapter.setLiData(data);
    }

    private void callDelete() {
        ArrayList<MessageListItemResBean> data = listAdapter.getAll();
        ArrayList<String> ids = new ArrayList<>();
        for (MessageListItemResBean bean : data) {
            if (bean.isSelected()) {
                ids.add(bean.getMsg_id());
            }
        }
        presenter.callDeleteMsg(ids);

    }

    private void callMarkRead() {
        ArrayList<MessageListItemResBean> data = listAdapter.getAll();
        ArrayList<String> ids = new ArrayList<>();
        for (MessageListItemResBean bean : data) {
            if (bean.isSelected()) {
                ids.add(bean.getMsg_id());
            }
        }
        presenter.callMarkMsgRead(ids);
    }

    /**
     * 显示右边的编辑按钮
     */
    @Override
    public void showCompiletoggle() {
        titleBar.setShowRightToggle();
    }
}
