package com.lht.cloudjob.adapter.viewprovider;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.lht.cloudjob.R;
import com.lht.cloudjob.adapter.ListAdapter2;
import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;
import com.lht.cloudjob.customview.AppCommentItemView;
import com.lht.cloudjob.interfaces.adapter.IListItemViewProvider;
import com.lht.cloudjob.mvp.model.bean.AppCommentResBean;

/**
 * <p><b>Package</b> com.lht.cloudjob.adapter.viewprovider
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> AppCommentItemViewProvider
 * <p><b>Description</b>: TODO
 * <p>Created by leobert on 2016/11/15.
 */
@TempVersion(TempVersionEnum.V1019)
public class AppCommentItemViewProvider implements IListItemViewProvider<AppCommentResBean> {

    private final LayoutInflater mInflater;

    private final ListAdapter2.ICustomizeListItem2<AppCommentResBean, ViewHolder> iCustomizeListItem;

    public AppCommentItemViewProvider(LayoutInflater inflater,
                                      ListAdapter2.ICustomizeListItem2<AppCommentResBean, ViewHolder> iCustomizeListItem) {

        this.mInflater = inflater;
        this.iCustomizeListItem = iCustomizeListItem;
    }

    @Override
    public View getView(int position, AppCommentResBean item, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView != null && convertView.getTag() != null) {
            holder = (ViewHolder) convertView.getTag();
        } else {
            holder = new ViewHolder();
            convertView = mInflater.inflate(R.layout.item_list_appcomment, null);
            holder.appCommentItemView = (AppCommentItemView) convertView.findViewById(R.id.acl_item);
            convertView.setTag(holder);
        }
        //手动修改排名保证不漏
        item.setRanking(String.valueOf(position+1));

        holder.appCommentItemView.setData(item);


        if (iCustomizeListItem != null)
            iCustomizeListItem.customize(position, item, convertView, holder);
        return convertView;
    }

    public class ViewHolder {
        public AppCommentItemView appCommentItemView;
    }


}
