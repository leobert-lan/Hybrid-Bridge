package com.lht.cloudjob.fragment;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.activity.asyncprotected.EnterpriseAuthenticateActivity;
import com.lht.cloudjob.mvp.model.bean.PAUModelBean;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.string.StringUtil;
import com.lht.cloudjob.util.time.TimeUtil;
import com.squareup.picasso.Picasso;

import org.greenrobot.eventbus.EventBus;

/**
 * A simple {@link Fragment} subclass.
 * 实名认证的预览视图
 */
public class FgAuthenticPreview extends BaseFragment {

    private static final String PAGENAME = "FgPAuthenticPreview";

    private TextView tvRegion, tvName, tvIdentify, tvValidity, tvMessage;

    private ImageView imgCover;

    private ImageView imgIdentifyCard1, imgIdentifyCard2, imgIdentifyCard3;

    private Button btnEdit;


    public FgAuthenticPreview() {
        // Required empty public constructor
    }


    @Override
    protected void initView(View contentView) {
        tvRegion = (TextView) contentView.findViewById(R.id.authpreview_tv_region);
        tvName = (TextView) contentView.findViewById(R.id.authpreview_tv_name);
        tvIdentify = (TextView) contentView.findViewById(R.id.authpreview_tv_identify);
        tvValidity = (TextView) contentView.findViewById(R.id.authpreview_tv_validity);
        tvMessage = (TextView) contentView.findViewById(R.id.authpreview_tv_msg);

        imgCover = (ImageView) contentView.findViewById(R.id.authpreview_img);

        imgIdentifyCard1 = (ImageView) contentView.findViewById(R.id.authpreview_img_pic1);
        imgIdentifyCard2 = (ImageView) contentView.findViewById(R.id.authpreview_img_pic2);
        imgIdentifyCard3 = (ImageView) contentView.findViewById(R.id.authpreview_img_pic3);

        btnEdit = (Button) contentView.findViewById(R.id.authpreview_btn_edit);
    }

    @Override
    protected void initVariable() {

    }

    @Override
    protected void initEvent() {

    }

    @Override
    protected String getPageName() {
        return PAGENAME;
    }

    private View contentView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        contentView = inflater.inflate(R.layout.fg_authentic_preview, container, false);

        initView(contentView);
        initVariable();
        initEvent();

        return contentView;
    }

    private void loadImage(ImageView target, String url, int holder) {
        Picasso.with(getActivity()).load(StringUtil.nullStrToDummyUrl(url))
                .diskCache(BaseActivity.getLocalImageCache())
                .placeholder(holder).error(holder)
                .into(target);

    }

    /**
     * 实名认证---等待认证
     *
     * @param pauModelBean
     */
    public void showAsOnCheckWait(PAUModelBean pauModelBean) {

        initView(contentView);
        initVariable();
        initEvent();

        DLog.d(getClass(), "bean:" + JSON.toJSONString(pauModelBean));

        imgCover.setImageResource(R.drawable.v1011_drawable_mask_waiting_auth);
        tvMessage.setText(getString(R.string.v1010_default_pau_text_wait));

        String region = PAUModelBean.getRegionString(pauModelBean.getAreaCode());
        tvRegion.setText(getString(R.string.v1010_default_pau_text_area) + region);
        tvName.setText(getString(R.string.v1010_default_pau_text_name) + pauModelBean.getRealName());


        if (pauModelBean.getAreaCode() != PAUModelBean.AREA_TW) {
            //非台湾地区显示身份证号有效时间
            tvValidity.setText(formatValidity(pauModelBean.getValidityBegin(),
                    pauModelBean.getValidityEnd()));
            tvValidity.setVisibility(View.VISIBLE);
        } else {
            tvValidity.setVisibility(View.GONE);
        }

        tvIdentify.setText(getString(R.string.v1010_default_pau_id_card) + pauModelBean.getIdCard());

        loadImage(imgIdentifyCard1, pauModelBean.getIdPicOne(),
                R.drawable.v1010_drawable_identifycard_front_default);
        loadImage(imgIdentifyCard2, pauModelBean.getIdPicTwo(),
                R.drawable.v1010_drawable_identifycard_back_default);
        loadImage(imgIdentifyCard3, pauModelBean.getIdPicThree(),
                R.drawable.v1010_drawable_identifycard_inhand_default);

        btnEdit.setVisibility(View.GONE);
    }

    /**
     * 实名认证---认证通过
     *
     * @param pauModelBean
     */
    public void showAsOnCheckPass(final PAUModelBean pauModelBean) {
        initView(contentView);
        initVariable();
        initEvent();

        imgCover.setImageResource(R.drawable.v1011_drawable_mask_success);
        tvMessage.setText(getString(R.string.v1010_default_pau_text_pass));
        btnEdit.setText(getString(R.string.v1010_default_pau_text_update_to_eau));

        String region = PAUModelBean.getRegionString(pauModelBean.getAreaCode());
        tvRegion.setText(getString(R.string.v1010_default_pau_text_area) + region);
        tvName.setText(getString(R.string.v1010_default_pau_text_name) + pauModelBean.getRealName());

        if (pauModelBean.getAreaCode() != PAUModelBean.AREA_TW) {
            //非台湾地区显示身份证号有效时间
            tvValidity.setText(formatValidity(pauModelBean.getValidityBegin(),
                    pauModelBean.getValidityEnd()));
            tvValidity.setVisibility(View.VISIBLE);
        } else {
            tvValidity.setVisibility(View.GONE);
        }

        tvIdentify.setText(getString(R.string.v1010_default_pau_id_card) + pauModelBean.getIdCard());

        loadImage(imgIdentifyCard1, pauModelBean.getIdPicOne(),
                R.drawable.v1010_drawable_identifycard_front_default);
        loadImage(imgIdentifyCard2, pauModelBean.getIdPicTwo(),
                R.drawable.v1010_drawable_identifycard_back_default);
        loadImage(imgIdentifyCard3, pauModelBean.getIdPicThree(),
                R.drawable.v1010_drawable_identifycard_inhand_default);

        btnEdit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), EnterpriseAuthenticateActivity.class);
                intent.putExtra(EnterpriseAuthenticateActivity.KEY_DATA, pauModelBean.getUsername());
                startActivity(intent);
                getActivity().finish();
            }
        });
    }

    /**
     * 实名认证---认证不通过
     *
     * @param pauModelBean
     */
    public void showAsOnCheckRefuse(PAUModelBean pauModelBean) {
        initView(contentView);
        initVariable();
        initEvent();

        imgCover.setImageResource(R.drawable.v1011_drawable_mask_refuse);
        tvMessage.setText(getString(R.string.v1010_default_pau_text_refuse));
        btnEdit.setText(getString(R.string.v1010_default_pau_text_authentic_again));

        String region = PAUModelBean.getRegionString(pauModelBean.getAreaCode());
        tvRegion.setText(getString(R.string.v1010_default_pau_text_area) + region);
        tvName.setText(getString(R.string.v1010_default_pau_text_name) + pauModelBean.getRealName());

        if (pauModelBean.getAreaCode() != PAUModelBean.AREA_TW) {
            //非台湾地区显示身份证号有效时间
            tvValidity.setText(formatValidity(pauModelBean.getValidityBegin(),
                    pauModelBean.getValidityEnd()));
            tvValidity.setVisibility(View.VISIBLE);
        } else {
            tvValidity.setVisibility(View.GONE);
        }

        tvIdentify.setText(getString(R.string.v1010_default_pau_id_card) + pauModelBean.getIdCard());

        loadImage(imgIdentifyCard1, pauModelBean.getIdPicOne(),
                R.drawable.v1010_drawable_identifycard_front_default);
        loadImage(imgIdentifyCard2, pauModelBean.getIdPicTwo(),
                R.drawable.v1010_drawable_identifycard_back_default);
        loadImage(imgIdentifyCard3, pauModelBean.getIdPicThree(),
                R.drawable.v1010_drawable_identifycard_inhand_default);

        btnEdit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EventBus.getDefault().post(new AppEvent.RePAuthEvent());
            }
        });
    }

    private String formatValidity(long validityBegin, long validityEnd) {
        StringBuilder builder = new StringBuilder();
        builder.append(getString(R.string.v1010_default_pau_text_validity) + "：");

        if (validityBegin == 0) { //老数据，不显示时间
            builder.append(getString(R.string.v1010_default_pau_text_unset));
        } else {
            TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer(validityBegin);
            builder.append(transformer.getDefaultFormat());
        }

        builder.append(getString(R.string.v1010_default_pau_text_to));

        if (validityEnd == 0) { //老数据 不显示时间
            builder.append(getString(R.string.v1010_default_pau_text_unset));
        } else {
            TimeUtil.DateTransformer transformer2 = TimeUtil.newDateTransformer(validityEnd);
            builder.append(transformer2.getDefaultFormat());
        }
        return builder.toString();
    }

}
