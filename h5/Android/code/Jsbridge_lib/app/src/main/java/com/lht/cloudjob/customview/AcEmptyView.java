package com.lht.cloudjob.customview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;

import com.lht.cloudjob.R;

/**
 * Created by chhyu on 2016/11/16.
 */

public class AcEmptyView extends FrameLayout {

    private View view;

    public AcEmptyView(Context context) {
        super(context);
        init();
    }

    public AcEmptyView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public AcEmptyView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        view = inflate(getContext(), R.layout.ac_empty_view, this);
    }

    /**
     * 空视图
     */
    public void showAsEmpty() {
        setVisibility(VISIBLE);
        bringToFront();
    }
}
