package com.lht.cloudjob.activity.asyncprotected;

import android.os.Bundle;
import android.view.View;
import android.widget.AbsListView;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.adapter.ListAdapter2;
import com.lht.cloudjob.adapter.viewprovider.AppCommentItemViewProvider;
import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
import com.lht.cloudjob.customview.AcEmptyView;
import com.lht.cloudjob.customview.AppCommentItemView;
import com.lht.cloudjob.customview.CustomActivitiesRules;
import com.lht.cloudjob.customview.MyAppCommentItemView;
import com.lht.cloudjob.customview.TitleBar;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.mvp.model.bean.AppCommentPeriodResBean;
import com.lht.cloudjob.mvp.model.bean.AppCommentResBean;
import com.lht.cloudjob.mvp.model.bean.MyAppCommentResBean;
import com.lht.cloudjob.mvp.model.pojo.LoginInfo;
import com.lht.cloudjob.mvp.presenter.StaticPromoteActivityPresenter;
import com.lht.cloudjob.mvp.viewinterface.IStaticPromoteActivity;
import com.lht.cloudjob.util.toast.ToastUtils;
import com.lht.customwidgetlib.nestedscroll.AttachUtil;
import com.lht.ptrlib.library.PullToRefreshBase;
import com.lht.ptrlib.library.PullToRefreshListView;
import com.lht.ptrlib.library.PullToRefreshUtil;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;

import java.util.ArrayList;

@TempVersion(TempVersionEnum.V1019)
public class StaticPromoteActivity extends AsyncProtectedActivity implements
        IStaticPromoteActivity, IVerifyHolder, ListAdapter2.ICustomizeListItem2
        <AppCommentResBean, AppCommentItemViewProvider.ViewHolder> {

    private static final String PAGENAME = "StaticPromoteActivity";

    private TitleBar titleBar;

    private PullToRefreshListView mCommentListView;

    private ProgressBar progressBar;

    private StaticPromoteActivityPresenter presenter;

    private ListAdapter2<AppCommentResBean> listAdapter;

    private MyAppCommentItemView myAppCommentItemView;

    private Button btnAccess;
    private AcEmptyView acEmptyView;
    private View headerView;

    private TextView tvPeriod;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_static_promote);
        EventBus.getDefault().register(this);
        initView();
        initVariable();
        initEvent();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Override
    protected String getPageName() {
        return StaticPromoteActivity.PAGENAME;
    }

    @Override
    public UMengActivity getActivity() {
        return StaticPromoteActivity.this;
    }

    @Override
    protected void initView() {
        titleBar = (TitleBar) findViewById(R.id.titlebar);
        progressBar = (ProgressBar) findViewById(R.id.progressbar);
        mCommentListView = (PullToRefreshListView) findViewById(R.id.promote_ptr_list);

        //headerview...
        headerView = View.inflate(this, R.layout.ac_rank_header_view, null);

        tvPeriod = (TextView) headerView.findViewById(R.id.tv_header_ac_period);

        mCommentListView.getRefreshableView().addHeaderView(headerView, null, false);
        //底部悬浮view
        myAppCommentItemView = (MyAppCommentItemView) findViewById(R.id.promote_suspended_appcomment);
        btnAccess = (Button) findViewById(R.id.promote_btn_access);

        //emptyview
        acEmptyView = new AcEmptyView(getActivity());
        mCommentListView.getRefreshableView().addHeaderView(acEmptyView, null, false);
        TextView tvRule = (TextView) headerView.findViewById(R.id.tv_header_ac_rules);
        tvRule.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CustomActivitiesRules rules = new CustomActivitiesRules(getActivity());
                String period = "";
                if (presenter != null) {
                    period = presenter.getPeriod();
                }
                rules.updatePeriod(period);
                rules.show();
            }
        });
    }

    @Override
    protected void initVariable() {
        presenter = new StaticPromoteActivityPresenter(this);
        listAdapter = new ListAdapter2<>(new ArrayList<AppCommentResBean>(), new AppCommentItemViewProvider
                (getLayoutInflater(), this));
    }

    @Override
    protected void initEvent() {
        mCommentListView.getRefreshableView().setHeaderDividersEnabled(false);
        myAppCommentItemView.setVisibility(View.GONE);
//        tvPeriod.setText(presenter.getPeriod());  //
        titleBar.setDefaultOnBackListener(getActivity());
        titleBar.setTitle(getString(R.string.v1019_activities_trank_title));
        mCommentListView.setAdapter(listAdapter);
        mCommentListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
        mCommentListView.setOnRefreshListener(refreshListener);

        mCommentListView.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
//                if (scrollState == SCROLL_STATE_IDLE) {
                    judgeListAttach();
//                }
            }

            @Override
            public void onScroll(AbsListView listView, int firstVisibleItem, int
                    visibleItemCount, int totalItemCount) {
//                judgeListAttach();

            }
        });


        btnAccess.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                presenter.callAccessPromoteActivity();
            }
        });

        presenter.callRefreshListData(getLoginInfo().getUsername());
        presenter.queryPeriod();
    }

    @Override
    protected void onResume() {
        super.onResume();
        presenter.queryMyComment(getLoginInfo().getUsername());
    }

    private void judgeListAttach() {
        boolean b = AttachUtil.isAdapterViewAttach(mCommentListView.getRefreshableView());
        if (b) {
            if (presenter.hasCommented()) {
                myAppCommentItemView.setData(presenter.getMyAppCommentResBean());
                myAppCommentItemView.setVisibility(View.VISIBLE);
                myAppCommentItemView.bringToFront();
            } else {
                myAppCommentItemView.setVisibility(View.GONE);
            }
        } else {
            myAppCommentItemView.setVisibility(View.GONE);
        }
    }

    @Override
    protected IApiRequestPresenter getApiRequestPresenter() {
        return presenter;
    }

    @Override
    public ProgressBar getProgressBar() {
        return progressBar;
    }

    private PullToRefreshBase.OnRefreshListener2 refreshListener = new PullToRefreshBase
            .OnRefreshListener2() {
        @Override
        public void onPullDownToRefresh(PullToRefreshBase refreshView) {
            presenter.callRefreshListData(getLoginInfo().getUsername());
            presenter.queryPeriod();
        }

        @Override
        public void onPullUpToRefresh(PullToRefreshBase refreshView) {
            presenter.callAddListData(getLoginInfo().getUsername(), listAdapter
                    .getDefaultPagedOffset());
            presenter.queryPeriod();
        }
    };


    /**
     * 显示评论入口
     */
    @Override
    public void enableCommentAccess() {
        myAppCommentItemView.setVisibility(View.GONE);
        btnAccess.setVisibility(View.VISIBLE);
    }

    /**
     * 隐藏评论入口
     */
    @Override
    public void disableCommentAccess() {
        btnAccess.setVisibility(View.GONE);
    }

    @Override
    public void finishRefresh() {
        cancelWaitView();
        mCommentListView.onRefreshComplete();
        PullToRefreshUtil.updateLastFreshTime(getActivity(), mCommentListView);
    }

    @Override
    public void showEmptyView() {
        mCommentListView.setMode(PullToRefreshBase.Mode.PULL_FROM_START);
        acEmptyView.setVisibility(View.VISIBLE);
        acEmptyView.showAsEmpty();
        mCommentListView.setAdapter(null);
        mCommentListView.getRefreshableView().removeHeaderView(acEmptyView);
        mCommentListView.getRefreshableView().removeHeaderView(headerView);
        mCommentListView.getRefreshableView().addHeaderView(headerView, null, false);
        mCommentListView.getRefreshableView().addHeaderView(acEmptyView, null, false);
        mCommentListView.setAdapter(listAdapter);
        listAdapter.notifyDataSetChanged();
    }

    @Override
    public void setListData(ArrayList<AppCommentResBean> data) {
        listAdapter.setLiData(data);
    }

    @Override
    public void hideEmptyView() {
        mCommentListView.setMode(PullToRefreshBase.Mode.BOTH);
        mCommentListView.setAdapter(null);
        mCommentListView.getRefreshableView().removeHeaderView(acEmptyView);
        mCommentListView.getRefreshableView().removeHeaderView(headerView);
        mCommentListView.getRefreshableView().addHeaderView(headerView, null, false);
        mCommentListView.setAdapter(listAdapter);
        acEmptyView.setVisibility(View.GONE);
        listAdapter.notifyDataSetChanged();
    }

    @Override
    public void addListData(ArrayList<AppCommentResBean> data) {
        listAdapter.addLiData(data);
    }

    @Override
    public void showMyComment(MyAppCommentResBean myAppCommentResBean) {
        judgeListAttach();
    }

    @Override
    public void jumpToAppcomment() {
        start(AppCommentActivity.class, AppCommentActivity.KEY_DATA, getLoginInfo().getUsername());
    }

    @Override
    public void refreshListData() {
        listAdapter.notifyDataSetChanged();
    }

    @Override
    public void updatePeriod(AppCommentPeriodResBean periodResBean) {
        tvPeriod.setText(periodResBean.getFormatPeriod());
        if (pw != null && pw instanceof CustomActivitiesRules) {
            ((CustomActivitiesRules) pw).updatePeriod(periodResBean.getFormatPeriod());
        }
    }

    @Override
    @Subscribe
    public void onEventMainThread(AppEvent.LoginSuccessEvent event) {
        mLoginInfo.copy(event.getLoginInfo());
        presenter.identifyTrigger(event.getTrigger());
    }

    @Override
    @Subscribe
    public void onEventMainThread(AppEvent.LoginCancelEvent event) {
        // empty
    }

    @Subscribe
    public void onEventMainThread(AppCommentActivity.AppCommentPostedEvent event) {
        myAppCommentItemView.setData(presenter.getMyAppCommentResBean());
        myAppCommentItemView.setVisibility(View.VISIBLE);
        myAppCommentItemView.bringToFront();
    }

    @Override
    public LoginInfo getLoginInfo() {
        return mLoginInfo; // never be null
    }

    @Override
    public void customize(int position, final AppCommentResBean data, View view,
                          AppCommentItemViewProvider.ViewHolder viewHolder) {
        AppCommentItemView appCommentItemView = viewHolder.appCommentItemView;
        final AppCommentItemView.ViewHolder holder = appCommentItemView.getViewHolder();
        holder.cbPraise.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                holder.cbPraise.setChecked(true);
                if (data.getAlready_zan() == AppCommentResBean.ALREADY_ZAN) {
                    ToastUtils.show(getActivity(), R.string.v1019_actiivties_cancelzan_cannot,
                            ToastUtils.Duration.s);
                    return;
                }
                presenter.callZan(data);
            }
        });
    }
}
