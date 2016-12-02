package com.lht.cloudjob.customview;

import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.lht.cloudjob.R;
import com.lht.cloudjob.interfaces.custompopupwins.IPopupHolder;
import com.lht.cloudjob.util.DisplayUtils;

import java.util.Locale;

/**
 * @author leobert.lan
 * @version 1.0
 * @ClassName: CustomDialog
 * @Description: 自定义的进度控件
 * @date 2016年1月6日 上午9:50:10
 */
public class CustomActivitiesRules extends CustomPopupWindow {

    private View contentView;
    private ImageView ivCancel;

    private TextView tvPeriod;


    public CustomActivitiesRules(IPopupHolder iPopupHolder) {
        super(iPopupHolder);
    }

    protected void init() {

        int offset = DisplayUtils.convertDpToPx(getmActivity(), 70);
        this.setHeight(mActivity.getWindowManager().getDefaultDisplay().getHeight() * 9 / 10 -
                offset);
        this.setWidth(mActivity.getWindowManager().getDefaultDisplay()
                .getWidth() * 3 / 4 + 100);

        setyOffset(offset / 2);

        this.setFocusable(false);
        this.setOutsideTouchable(false);
        this.setAnimationStyle(R.style.iOSActionSheet);
//        this.setBackgroundDrawable(null);

        LayoutInflater inflater = LayoutInflater.from(mActivity);
        contentView = inflater.inflate(R.layout.popup_activities_rules, null);
        setContentView(contentView);

        ivCancel = (ImageView) contentView.findViewById(R.id.iv_activities_rule_cancel);
        ivCancel.bringToFront();
        tvPeriod = (TextView) contentView.findViewById(R.id.tv_period);

        ivCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
    }

    public void updatePeriod(String period) {
        tvPeriod.setText(period);
    }


    /**
     * @Title: cancel
     * @Description: 相当于点击取消
     * @author: leobert.lan
     */
    public void cancel() {
        dismiss();
    }

    @Override
    public void setOnDismissListener(OnDismissListener onDismissListener) {
        throw new IllegalAccessError("never use this method");
    }


}

