package com.lht.cloudjob.adapter.viewprovider;

import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.daimajia.androidanimations.library.Techniques;
import com.daimajia.androidanimations.library.YoYo;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.adapter.ListAdapter2;
import com.lht.cloudjob.customview.RoundImageView;
import com.lht.cloudjob.interfaces.adapter.IListItemViewProvider;
import com.lht.cloudjob.mvp.model.bean.MessageListItemResBean;
import com.lht.cloudjob.util.time.TimeUtil;
import com.squareup.picasso.Picasso;

import java.text.SimpleDateFormat;

/**
 * <p><b>Package</b> com.lht.cloudjob.adapter.viewprovider
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> MessageItemViewProviderImpl
 * <p><b>Description</b>: TODO
 * <p> Create by Leobert on 2016/8/19
 */
public class MessageItemViewProviderImpl implements IListItemViewProvider<MessageListItemResBean> {

    private final LayoutInflater mInflater;

    private final ListAdapter2.ICustomizeListItem2<MessageListItemResBean, ViewHolder>
            iSetCallbackForListItem;

    private SimpleDateFormat format;

    public MessageItemViewProviderImpl(
            LayoutInflater inflater,
            ListAdapter2.ICustomizeListItem2<MessageListItemResBean, ViewHolder>
                    iSetCallbackForListItem) {

        this.mInflater = inflater;
        this.iSetCallbackForListItem = iSetCallbackForListItem;
        format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    }

    /**
     * desc: 提供每个item的View
     *
     * @param position    位置
     * @param item        原始数据,泛化数据模型
     * @param convertView 复用视图
     * @param parent      parent
     * @return item视图
     */
    @Override
    public View getView(int position, MessageListItemResBean item, View convertView, ViewGroup
            parent) {
        ViewHolder holder;
        if (convertView != null && convertView.getTag() != null) {
            holder = (ViewHolder) convertView.getTag();
        } else {
            holder = new ViewHolder();
            convertView = mInflater.inflate(R.layout.item_list_message, null);
            holder.imgAvatar = (RoundImageView) convertView.findViewById(R.id.message_item_img);
            holder.unreadTag = (ImageView) convertView.findViewById(R.id.message_item_unreadtag);
            holder.rlRoot = (RelativeLayout) convertView.findViewById(R.id.message_item_rl_root);
            holder.cbSelect = (CheckBox) convertView.findViewById(R.id.message_cb_select);
            holder.tvTitle = (TextView) convertView.findViewById(R.id.message_item_tv_title);
            holder.tvTime = (TextView) convertView.findViewById(R.id.message_item_tv_time);
            holder.tvContent = (TextView) convertView.findViewById(R.id.message_item_tv_content);
            holder.line = convertView.findViewById(R.id.line);
            holder.tvSeeDetail = (TextView) convertView.findViewById(R.id.message_item_seedetail);
            convertView.setTag(holder);
        }

        if (isModifyMode) {
            holder.cbSelect.setVisibility(View.VISIBLE);
            YoYo.with(Techniques.FadeIn).duration(300).playOn(holder.cbSelect);
        } else {
            holder.cbSelect.setVisibility(View.GONE);
            YoYo.with(Techniques.FadeOut).duration(300).playOn(holder.cbSelect);
        }

        holder.cbSelect.setOnCheckedChangeListener(null);
        holder.cbSelect.setChecked(item.isSelected());

        if (item.isSelected()) {
            holder.rlRoot.setBackgroundResource(R.color.h6_divider);
            holder.line.setVisibility(View.INVISIBLE);
        } else {
            holder.rlRoot.setBackgroundResource(R.color.bg_white);
            holder.line.setVisibility(View.VISIBLE);
        }

        holder.tvTitle.setText(item.getTitle());
        holder.tvContent.setText(Html.fromHtml(item.getContent()).toString());
        holder.tvTime.setText(TimeUtil.getTime(item.getOn_time(), format));

        if (iSetCallbackForListItem != null)
            iSetCallbackForListItem.customize(position, item, convertView, holder);

        //头像处理
        Picasso.with(parent.getContext()).load(item.getAvatar()).diskCache(BaseActivity
                .getLocalImageCache()).placeholder(R.drawable.v1010_drawable_avatar_default)
                .error(R.drawable.v1010_drawable_avatar_default).fit().into(holder.imgAvatar);

        //read or unread
        if (item.getView_status() == MessageListItemResBean.STATUS_READ) {
            holder.unreadTag.setVisibility(View.INVISIBLE);
        } else {
            holder.unreadTag.setVisibility(View.VISIBLE);
        }

        return convertView;
    }

    private boolean isModifyMode;

    public void setModifyModeEnable(boolean enabled) {
        isModifyMode = enabled;
    }

    public boolean isModifyMode() {
        return isModifyMode;
    }

    public class ViewHolder {
        public RelativeLayout rlRoot;
        public CheckBox cbSelect;
        ImageView unreadTag;
        TextView tvTitle;
        TextView tvTime;
        TextView tvContent;
        public View line;
        RoundImageView imgAvatar;
        public TextView tvSeeDetail;
    }
}
