package com.lht.cloudjob.adapter.viewprovider;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;

import com.lht.cloudjob.mvp.model.bean.IndustryApiResBean;
import com.lht.customwidgetlib.actionsheet.IActionSheetItemViewProvider;
import com.lht.customwidgetlib.actionsheet.OnActionSheetItemClickListener;

/**
 * <p><b>Package</b> com.lht.customwidgetlib.actionsheet
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> MActionsheetItemViewProvider
 * <p><b>Description</b>: TODO
 * Created by leobert on 2016/7/5.
 */
public class MActionsheetItemViewProvider implements IActionSheetItemViewProvider<IndustryApiResBean> {

    private LayoutInflater inflater;

    private OnActionSheetItemClickListener itemClickListener;
    private int currentIndustry;

    public MActionsheetItemViewProvider(LayoutInflater inflater, int industry,
                                        OnActionSheetItemClickListener itemClickListener) {
        this.inflater = inflater;
        this.currentIndustry = industry;
        this.itemClickListener = itemClickListener;
    }

    @Override
    public View getView(final int position, final IndustryApiResBean item, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView != null && convertView.getTag() instanceof ViewHolder) {
            holder = (ViewHolder) convertView.getTag();
        } else {
            holder = new ViewHolder();
            convertView = inflater.inflate(com.lht.cloudjob.R.layout.view_actionsheet_item, parent, false);
            holder.cb = (CheckBox) convertView.findViewById(com.lht.cloudjob.R.id.vas_item_text);
            convertView.setTag(holder);
        }

        item.setIsSelected(currentIndustry == item.getIndus_pid());
        holder.cb.setText(item.getIndus_name());
        holder.cb.setChecked(item.isSelected());

//        convertView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                if (itemClickListener != null) {
//                    itemClickListener.onActionSheetItemClick(position);
//                }
//                item.setIsSelected(true);
//            }
//        });

        holder.cb.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (itemClickListener != null) {
                    itemClickListener.onActionSheetItemClick(position);
                }
                item.setIsSelected(true);
            }
        });
        return convertView;
    }

    private class ViewHolder {
        CheckBox cb;
    }
}
