package com.lht.cloudjob.customview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.lht.cloudjob.MainApplication;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
import com.lht.cloudjob.mvp.model.bean.AppCommentResBean;
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
public class AppCommentItemView extends FrameLayout {
    private static final int MAX_LINE_IN_SUMMARYMODE = 2;

    public AppCommentItemView(Context context) {
        this(context, null);
    }


    public AppCommentItemView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public AppCommentItemView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private ViewHolder viewHolder;

    public ViewHolder getViewHolder() {
        return viewHolder;
    }

    private void init() {
        View view = inflate(getContext(), R.layout.view_item_appcomment, this);
        viewHolder = new ViewHolder();
        bindView(view, viewHolder);
        initEvent();
    }

    private void initEvent() {
        viewHolder.cbToggle.setChecked(false);
        viewHolder.cbToggle.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener
                () {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                toggle(isChecked);
            }
        });
    }

    private void toggle(boolean isOpenMore) {
        if (isOpenMore) {
            viewHolder.tvComment.setMaxLines(Integer.MAX_VALUE);
            viewHolder.cbToggle.setText(R.string.v1019_default_spa_cb_toggle_2);
        } else {
            viewHolder.tvComment.setMaxLines(MAX_LINE_IN_SUMMARYMODE);
            viewHolder.cbToggle.setText(R.string.v1019_default_spa_cb_toggle_1);
        }
    }

    private void bindView(View convertView, ViewHolder holder) {
        holder.tvRank = (TextView) convertView.findViewById(R.id.via_tv_rank);
        holder.avatar = (RoundImageView) convertView.findViewById(R.id.via_image_avatar);
        holder.nickname = (TextView) convertView.findViewById(R.id.via_tv_nickname);
        holder.time = (TextView) convertView.findViewById(R.id.via_tv_time);
        holder.tvCount = (TextView) convertView.findViewById(R.id.via_tv_count);
        holder.cbPraise = (CheckBox) convertView.findViewById(R.id.via_cb_praise);
        holder.tvComment = (TextView) convertView.findViewById(R.id.via_tv_comment);
        holder.cbToggle = (CheckBox) convertView.findViewById(R.id.via_cb_open);
    }

    public void setData(AppCommentResBean item) {
        viewHolder.tvRank.setText(item.getRanking()); // 不要调整顺序
        loadRankMadel(item.getRanking());
        loadAvatar(item.getAvatar(), viewHolder.avatar);

        viewHolder.nickname.setText(item.getNickname());
        viewHolder.time.setText(TimeUtil.getTime(item.getCreated_at(), TIME_FORMAT));

        viewHolder.tvCount.setText("(" + item.getZans() + ")"); //chase speed

        viewHolder.tvComment.setText(item.getContent());

        viewHolder.cbPraise.setChecked(item.getAlready_zan() == AppCommentResBean.ALREADY_ZAN);

        //展开键状态
        viewHolder.tvComment.getViewTreeObserver().removeOnGlobalLayoutListener(listener);
        viewHolder.tvComment.getViewTreeObserver().addOnGlobalLayoutListener(listener);

        int lineCount = viewHolder.tvComment.getLineCount();
        boolean b = lineCount > MAX_LINE_IN_SUMMARYMODE;
        if (b) {
            viewHolder.cbToggle.setVisibility(VISIBLE);
        } else {
            viewHolder.cbToggle.setVisibility(GONE);
        }
        viewHolder.cbToggle.setChecked(false);
        toggle(false);
    }

    private void loadRankMadel(String ranking) {
        ranking = ranking.trim();
        if (ranking.equals("1")) {
            viewHolder.tvRank.setText(null);
            viewHolder.tvRank.setBackgroundResource(R.drawable.v1019_drawable_rank_bg_1);
        } else if (ranking.equals("2")) {
            viewHolder.tvRank.setText(null);
            viewHolder.tvRank.setBackgroundResource(R.drawable.v1019_drawable_rank_bg_2);
        } else if (ranking.equals("3")) {
            viewHolder.tvRank.setText(null);
            viewHolder.tvRank.setBackgroundResource(R.drawable.v1019_drawable_rank_bg_3);
        } else {
            viewHolder.tvRank.setBackgroundResource(R.color.transparent);
        }
    }

    private void loadAvatar(String url, ImageView imageView) {
        Picasso.with(MainApplication.getOurInstance()).load(url)
                .diskCache(BaseActivity.getLocalImageCache())
                .placeholder(R.drawable.v1010_drawable_avatar_default)
                .error(R.drawable.v1010_drawable_avatar_default)
                .fit()
                .into(imageView);
    }

    public class ViewHolder {
        private TextView tvRank;
        private RoundImageView avatar;
        private TextView nickname;
        private TextView time;
        public CheckBox cbPraise;
        private TextView tvCount;
        private TextView tvComment;
        public CheckBox cbToggle;
    }

    private SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.CHINA);

    private ViewTreeObserver.OnGlobalLayoutListener listener = new ViewTreeObserver
            .OnGlobalLayoutListener() {

        @Override
        public void onGlobalLayout() {
            int lineCount = viewHolder.tvComment.getLineCount();
            if (lineCount > MAX_LINE_IN_SUMMARYMODE) {
                viewHolder.cbToggle.setVisibility(VISIBLE);
            } else {
                viewHolder.cbToggle.setVisibility(GONE);
            }
        }
    };
}
