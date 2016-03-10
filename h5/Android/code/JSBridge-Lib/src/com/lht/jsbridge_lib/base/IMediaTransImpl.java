package com.lht.jsbridge_lib.base;

import java.util.ArrayList;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebChromeClient.CustomViewCallback;
import android.widget.FrameLayout;

import com.lht.jsbridge_lib.base.Interface.IMediaTrans;

/**
 * @ClassName: IMediaTransImpl
 * @Description: TODO
 * @date 2016年3月9日 下午4:02:20
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class IMediaTransImpl implements IMediaTrans {

	private final Activity mActivity;

	private View xCustomView;

	private final FrameLayout mVideoFullView;

	private CustomViewCallback xCustomViewCallback;

	private final ViewGroup mFullViewContainer;

	private int mOriginalOrientation = 1;

	public IMediaTransImpl(Activity activity, FrameLayout videoFullView,
			ViewGroup fullContainer) {
		this.mActivity = activity;
		this.mVideoFullView = videoFullView;
		this.mFullViewContainer = fullContainer;
	}

	@Override
	public Activity getActivity() {
		return mActivity;
	}

	@Override
	public ViewGroup getFullViewContainer() {
		return mFullViewContainer;
	}

	private ArrayList<View> inVisibleViews = new ArrayList<View>();

	private ArrayList<View> visibleViews = new ArrayList<View>();

	@Override
	public void onHideCustomView() {
		// 需要回到正常视图

		if (xCustomView == null)// 不是全屏播放状态
			return;

		change2Normal();
		getActivity().setRequestedOrientation(mOriginalOrientation);
		xCustomView.setVisibility(View.GONE);
		mVideoFullView.removeView(xCustomView);
		xCustomView = null;
		mVideoFullView.setVisibility(View.GONE);
		xCustomViewCallback.onCustomViewHidden();

		for (int i = 0; i < inVisibleViews.size(); i++) {
			inVisibleViews.get(i).setVisibility(View.INVISIBLE);
		}

		for (int j = 0; j < visibleViews.size(); j++) {
			visibleViews.get(j).setVisibility(View.VISIBLE);
		}

		getFullViewContainer().requestLayout();
	}

	@Override
	public void onShowCustomView(View view, CustomViewCallback callback) {
		// 需要显示自定义视图，全屏横屏
		if (xCustomView != null) {
			callback.onCustomViewHidden();
			return;
		}

		// 保存屏幕方向

		mOriginalOrientation = getActivity().getRequestedOrientation();

		defaultLayoutParams = getActivity().getWindow().getAttributes();
		//保存actionbar状态
		defaultTitleBarVisibility = getActivity().getActionBar().isShowing();

		change2Full();

		getActivity().setRequestedOrientation(
				ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
		int count = getFullViewContainer().getChildCount();

		for (int i = 0; i < count; i++) {
			View v = getFullViewContainer().getChildAt(i);
			if (v.getVisibility() == View.VISIBLE)
				visibleViews.add(v);
			else if (v.getVisibility() == View.INVISIBLE)
				inVisibleViews.add(v);
			v.setVisibility(View.GONE);
		}

		getFullViewContainer().addView(view);
		xCustomView = view;
		xCustomViewCallback = callback;
		getFullViewContainer().setVisibility(View.VISIBLE);

		getFullViewContainer().requestLayout();
	}

	private void change2Full() {
		WindowManager.LayoutParams params = getActivity().getWindow()
				.getAttributes();
		params.flags |= WindowManager.LayoutParams.FLAG_FULLSCREEN;
		getActivity().getWindow().setAttributes(params);
		getActivity().getWindow().addFlags(
				WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
		
		getActivity().getActionBar().hide();
	}

	private WindowManager.LayoutParams defaultLayoutParams;

	private boolean defaultTitleBarVisibility = true;

	private void change2Normal() {
		getActivity().getWindow().setAttributes(defaultLayoutParams);
		getActivity().getWindow().clearFlags(
				WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);

		if (defaultTitleBarVisibility) {
			getActivity().getActionBar().show();
		}
	}

}
