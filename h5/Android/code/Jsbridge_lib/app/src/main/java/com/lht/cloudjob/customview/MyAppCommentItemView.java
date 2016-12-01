package com.lht.cloudjob.customview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.lht.cloudjob.MainApplication;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.mvp.model.bean.MyAppCommentResBean;
import com.lht.cloudjob.util.time.TimeUtil;
import com.squareup.picasso.Picasso;

import java.text.SimpleDateFormat;
import java.util.Locale;

/**
 * <p><b>Package</b> com.lht.cloudjob.customview
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> AppCommentItemView
 * <p><b>Description</b>: TODO
 * <p>Created by leobert on 2016/11/15.
 */
@TempVersion(TempVersionEnum.V1019)
public class MyAppCommentItemView extends FrameLayout {
//    private static final int MAX_LINE_IN_SUMMARYMODE = 2;
    private final int CHECK_WAIT = 0;
    private final int CHECK_PASS = 1;
    private final int CHECK_REFUSE = 2;

    public MyAppCommentItemView(Context context) {
        this(context, null);
    }

    public MyAppCommentItemView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public MyAppCommentItemView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private ViewHolder viewHolder;

    public ViewHolder getViewHolder() {
        return viewHolder;
    }

    private void init() {
        View view = inflate(getContext(), R.layout.view_item_my_appcomment, this);
        viewHolder = new ViewHolder();
        bindView(view, viewHolder);
        initEvent();
    }

    private void bindView(View view, ViewHolder holder) {
        holder.ivAvatar = (ImageView) view.findViewById(R.id.via_my_image_avatar);
        holder.tvUsername = (TextView) view.findViewById(R.id.via_tv_my_nickname);
        holder.tvTime = (TextView) view.findViewById(R.id.via_tv_my_time);
        holder.ivWait = (ImageView) view.findViewById(R.id.iv_my_comment_wait);
        holder.tvWaitRemind = (TextView) view.findViewById(R.id.tv_my_comment_wait_remind);
        holder.tvMyComment = (TextView) view.findViewById(R.id.via_tv_my_comment);
//        holder.cbToggle = (CheckBox) view.findViewById(R.id.via_cb_open);
    }

    private void initEvent() {
//        viewHolder.cbToggle.setChecked(false);
//        viewHolder.cbToggle.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
//            @Override
//            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
//                toggle(isChecked);
//            }
//        });
    }

    /**
     * @param isOpenMore
     */
    private void toggle(boolean isOpenMore) {
//        if (isOpenMore) {
//            viewHolder.tvMyComment.setMaxLines(Integer.MAX_VALUE);
//            viewHolder.cbToggle.setText(R.string.v1010_default_demandinfo_cb_less);
//        } else {
//            viewHolder.tvMyComment.setMaxLines(MAX_LINE_IN_SUMMARYMODE);
//            viewHolder.cbToggle.setText(R.string.v1010_default_demandinfo_cb_more);
//        }
    }

    public class ViewHolder {
        private ImageView ivAvatar;
        private TextView tvUsername;
        private TextView tvTime;
        private ImageView ivWait;
        private TextView tvWaitRemind;
        private TextView tvMyComment;
//        private CheckBox cbToggle;
    }

    public void setData(MyAppCommentResBean item) {
        loadAvatar(item.getAvatar(), viewHolder.ivAvatar);
        viewHolder.tvUsername.setText(IVerifyHolder.mLoginInfo.getNickname());
        viewHolder.tvTime.setText(TimeUtil.getTime(item.getCreated_at(), TIME_FORMAT));
        viewHolder.tvMyComment.setText(item.getContent());
        //展开键状态
//        viewHolder.tvMyComment.getViewTreeObserver().removeOnGlobalLayoutListener(listener);
//        viewHolder.tvMyComment.getViewTreeObserver().addOnGlobalLayoutListener(listener);
//        int lineCount = viewHolder.tvMyComment.getLineCount();
//        boolean b = lineCount > MAX_LINE_IN_SUMMARYMODE;
//        if (b) {
//            viewHolder.cbToggle.setVisibility(VISIBLE);
//        } else {
//            viewHolder.cbToggle.setVisibility(GONE);
//        }
//        viewHolder.cbToggle.setChecked(false);
//        toggle(false);

        switch (item.getStatus()) {
            case CHECK_WAIT:
                viewHolder.ivWait.setVisibility(VISIBLE);
                viewHolder.tvWaitRemind.setText("内容审核中");
                break;
            case CHECK_PASS:
                viewHolder.ivWait.setVisibility(GONE);
                viewHolder.tvWaitRemind.setText("当前排名：" + "(" + item.getRanking() + ")");
                break;
            case CHECK_REFUSE:

                viewHolder.ivWait.setVisibility(VISIBLE);
                viewHolder.tvWaitRemind.setText("驳回");
                break;
            default:
                break;
        }
    }

    private SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.CHINA);

    private void loadAvatar(String avatarPath, ImageView ivAvatar) {
        Picasso.with(MainApplication.getOurInstance()).load(avatarPath)
                .diskCache(BaseActivity.getLocalImageCache())
                .placeholder(R.drawable.v1010_drawable_avatar_default)
                .error(R.drawable.v1010_drawable_avatar_default)
                .fit()
                .into(ivAvatar);
    }

//    private ViewTreeObserver.OnGlobalLayoutListener listener = new ViewTreeObserver
//            .OnGlobalLayoutListener() {
//
//        @Override
//        public void onGlobalLayout() {
//            int lineCount = viewHolder.tvMyComment.getLineCount();
//            if (lineCount > MAX_LINE_IN_SUMMARYMODE) {
//                viewHolder.cbToggle.setVisibility(VISIBLE);
//            } else {
//                viewHolder.cbToggle.setVisibility(GONE);
//            }
//        }
//    };
}
