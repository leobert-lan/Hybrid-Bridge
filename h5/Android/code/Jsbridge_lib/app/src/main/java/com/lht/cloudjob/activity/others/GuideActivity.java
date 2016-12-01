package com.lht.cloudjob.activity.others;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.activity.asyncprotected.LoginActivity;
import com.lht.cloudjob.activity.asyncprotected.RegisterActivity;
import com.lht.cloudjob.adapter.ViewPagerAdapter;
import com.lht.cloudjob.interfaces.ITriggerCompare;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class GuideActivity extends BaseActivity implements
        ViewPager.OnPageChangeListener, View.OnClickListener {

    private static final String mPageName = "guideActivity";

    private ViewPager viewPager;
    private ViewPagerAdapter viewPagerAdapter;
    private List<View> views;

    // 小圆点图片
    private ImageView[] viewPagerDots;

    // 当前小圆点选中时的位置
    private int currentIndex;

    private Button btnRegister;

    private Button btnLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_guide);

        initView();
        initVariable();
        initEvent();
    }

    /**
     * desc: 实例化View
     */
    @Override
    protected void initView() {
        LayoutInflater inflater = getLayoutInflater();

        views = new ArrayList<>();

        views.add(inflater.inflate(R.layout.view_guide_one, null, false));
        views.add(inflater.inflate(R.layout.view_guide_two, null, false));
        View page3 = inflater.inflate(R.layout.view_guide_three, null, false);
        views.add(page3);

        btnLogin = (Button) page3.findViewById(R.id.guide_btn_login);
        btnRegister = (Button) page3.findViewById(R.id.guide_btn_register);

        viewPager = (ViewPager) findViewById(R.id.viewPager);
        initDots();
    }

    /**
     * desc: 实例化必要的参数，以防止initEvent需要的参数空指针
     */
    @Override
    protected void initVariable() {
        viewPagerAdapter = new ViewPagerAdapter(views, this);

    }

    /**
     * desc: 监听器设置、adapter设置等
     */
    @Override
    protected void initEvent() {
        viewPager.setAdapter(viewPagerAdapter);
        viewPager.addOnPageChangeListener(this);
        viewPagerDots[0].setEnabled(true);

        btnRegister.setOnClickListener(this);
        btnLogin.setOnClickListener(this);
    }

    private LinearLayout llIndicator;

    private void initDots() {
        llIndicator = (LinearLayout) findViewById(R.id.guide_ll);

        viewPagerDots = new ImageView[views.size()];

        // 循环取得小圆点图片和默认图片
        for (int i = 0; i < views.size(); i++) {
            if (llIndicator.getChildAt(i) != null) {
                viewPagerDots[i] = (ImageView) llIndicator.getChildAt(i);
                viewPagerDots[i].setEnabled(false);
            }
        }

        currentIndex = 0;
        // 选中状态的颜色
        viewPagerDots[currentIndex].setEnabled(false);
    }

    private void setCurrentDot(int position) {
        if (position < 0 || position > views.size() - 1
                || currentIndex == position) {
            return;
        }

        viewPagerDots[position].setEnabled(true);
        viewPagerDots[currentIndex].setEnabled(false);

        currentIndex = position;
    }

    // 当前页面滑动时调用
    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    // 当前页面选中时调用
    @Override
    public void onPageSelected(int position) {
        if (position == 2) {
            llIndicator.setVisibility(View.GONE);
        } else {
            llIndicator.setVisibility(View.VISIBLE);
        }
        setCurrentDot(position);
    }

    // 滑动状态改变时调用
    @Override
    public void onPageScrollStateChanged(int state) {
    }


    @Override
    protected String getPageName() {
        return GuideActivity.mPageName;
    }

    @Override
    public UMengActivity getActivity() {
        return GuideActivity.this;
    }

    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.guide_btn_login:
                Intent intent = new Intent(getActivity(), LoginActivity.class);
                intent.putExtra(LoginActivity.KEY_START_HOME_ON_FINISH, true);
                intent.putExtra(LoginActivity.TRIGGERKEY, LoginTrigger.GuideAccess);
                startActivity(intent);
                finish();
                break;
            case R.id.guide_btn_register:
                Intent intent1 = new Intent(getActivity(), RegisterActivity.class);
                intent1.putExtra(RegisterActivity.KEY_ISGUIDEIN, true);
                intent1.putExtra(LoginActivity.TRIGGERKEY, LoginTrigger.GuideAccess);
                startActivity(intent1);
                finish();
                break;
            default:
                break;
        }
    }

    /**
     * splash页面登录触发
     */
    public enum LoginTrigger implements ITriggerCompare {
        GuideAccess(1);

        private final int tag;

        LoginTrigger(int i) {
            tag = i;
        }

        @Override
        public boolean equals(ITriggerCompare compare) {
            if (compare == null) {
                return false;
            }
            boolean b1 = compare.getClass().getName().equals(getClass().getName());
            boolean b2 = compare.getTag().equals(getTag());
            return b1 & b2;
        }

        @Override
        public Object getTag() {
            return tag;
        }

        @Override
        public Serializable getSerializable() {
            return this;
        }

    }

    @Override
    public void onBackPressed() {
//        super.onBackPressed(); shield back key press
    }
}
