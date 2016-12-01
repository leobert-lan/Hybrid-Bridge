package com.lht.cloudjob.fragment;

import android.os.Bundle;
import android.util.Log;
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
import com.lht.cloudjob.mvp.model.bean.EAUModelBean;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.string.StringUtil;
import com.lht.cloudjob.util.time.TimeUtil;
import com.squareup.picasso.Picasso;

import org.greenrobot.eventbus.EventBus;

/**
 * <p><b>Package</b> com.lht.cloudjob.fragment
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> FgEAuthenticPreview
 * <p><b>Description</b>: 企业认证预览模板
 * <p>Created by Administrator on 2016/9/12.
 */

public class FgEAuthenticPreview extends BaseFragment {

    private static final String PAGENAME = "FgEAuthenticPreview";

    private ImageView imageReview;
    private TextView tvMsg;
    private TextView tvCompanyName;
    private TextView tvLegalPersonName;
    private TextView tvRegisterCode;
    private TextView tvTurnOver;
    private TextView tvRegisterArea;
    private TextView tvValidity;
    /**
     * license display area
     */
    private ImageView imgLicense;
    /**
     * logo display area ,current version 1.0.10:hidden
     */
    private ImageView imgLogo;
    private Button btnEdit;
    private View contentView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        contentView = inflater.inflate(R.layout.fg_eauthentic_preview, container, false);

        initView(contentView);
        initVariable();
        initEvent();

        return contentView;
    }

    @Override
    protected void initView(View contentView) {
        imageReview = (ImageView) contentView.findViewById(R.id.authpreview_img);
        tvMsg = (TextView) contentView.findViewById(R.id.authpreview_tv_msg);
        tvCompanyName = (TextView) contentView.findViewById(R.id.authpreview_tv_companyname);
        tvLegalPersonName = (TextView) contentView.findViewById(R.id.authpreview_tv_name);
        tvRegisterCode = (TextView) contentView.findViewById(R.id.authpreview_tv_registercode);
        tvTurnOver = (TextView) contentView.findViewById(R.id.authpreview_tv_turnover);
        tvRegisterArea = (TextView) contentView.findViewById(R.id.authpreview_tv_registerarea);
        tvValidity = (TextView) contentView.findViewById(R.id.authpreview_tv_validity);

        imgLicense = (ImageView) contentView.findViewById(R.id.authpreview_img_license);
        imgLogo = (ImageView) contentView.findViewById(R.id.authpreview_img_logo);
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

    private void loadImage(ImageView target, String url, int holder) {
        Picasso.with(getActivity()).load(url)
                .diskCache(BaseActivity.getLocalImageCache())
                .placeholder(holder).error(holder)
                .into(target);
    }

    /**
     * 等待认证
     *
     * @param eauModelBean 元数据
     */
    public void showAsOnCheckWait(EAUModelBean eauModelBean) {
        DLog.d(getClass(), "checkdata on_chech_wait:" + JSON.toJSONString(eauModelBean));

        initView(contentView);
        initVariable();
        initEvent();

        imageReview.setImageResource(R.drawable.v1011_drawable_mask_waiting_auth);
        tvMsg.setText(getString(R.string.v1010_default_pau_text_wait));

        fillTemplateByData(eauModelBean);

        btnEdit.setVisibility(View.GONE);
    }

    private void fillTemplateByData(EAUModelBean eauModelBean) {
        //企业名称
        tvCompanyName.setText(getString(R.string.v1010_default_eau_text_company_name) +
                eauModelBean.getCompanyName());

        if (eauModelBean.getAuthArea() == EAUModelBean.AREA_ML
                || eauModelBean.getAuthArea() == EAUModelBean.AREA_TW) {
            //大陆、台湾地区显示法人
            tvLegalPersonName.setVisibility(View.VISIBLE);
            tvLegalPersonName.setText(getString(R.string.v1010_default_eau_text_legalperson_name) +
                    eauModelBean.getLegalPerson());

            //大陆、台湾地区显示详细地址
            tvRegisterArea.setVisibility(View.VISIBLE);
            if (StringUtil.isEmpty(eauModelBean.getDistrict())) {
                tvRegisterArea.setText(getString(R.string.v1010_default_eau_text_register_area) +
                        eauModelBean.getProvince() + eauModelBean.getCity() + eauModelBean.getLicenAddress());
            } else {
                tvRegisterArea.setText(getString(R.string.v1010_default_eau_text_register_area) +
                        eauModelBean.getProvince() + eauModelBean.getCity() + eauModelBean
                        .getDistrict() + eauModelBean.getLicenAddress());
            }
        } else {
            tvLegalPersonName.setVisibility(View.GONE);
            tvRegisterArea.setVisibility(View.GONE);
        }

        //注册号码
        tvRegisterCode.setText(getString(R.string.v1010_default_eau_text_register_code) +
                eauModelBean.getLicenNum());

        //经营范围
        tvTurnOver.setText(getString(R.string.v1010_default_eau_text_main_turnover) +
                eauModelBean.getTurnOver());

        showValidPeriod(eauModelBean);

        loadImage(imgLicense, StringUtil.nullStrToDummyUrl(eauModelBean.getLicenPic()),
                R.drawable.v1010_drawable_license_default);
//        loadImage(imgPic2, eauModelBean.getLicenPic(),
//                R.drawable.v1010_drawable_identifycard_front_default);
    }

    private void showValidPeriod(EAUModelBean eauModelBean) {
        Log.e("lmsg","check eaudata:\r\n"+JSON.toJSONString(eauModelBean));
        //大陆地区显示时间
        if (eauModelBean.getAuthArea() == EAUModelBean.AREA_ML) {
            if (eauModelBean.getPeriodCode() == 1) {
                StringBuilder builder = new StringBuilder();
                builder.append(getString(R.string.v1010_default_eau_text_validity2)).append("：")
                        .append(getString(R.string.v1010_default_eau_long_validity));
                tvValidity.setText(builder);
            } else {
                tvValidity.setText(formatValidity(eauModelBean.getStartTime(), eauModelBean.getEndTime()));
            }
            tvValidity.setVisibility(View.VISIBLE);
        } else {
            tvValidity.setVisibility(View.GONE);
        }
    }

    /**
     * 认证通过
     *
     * @param eauModelBean 元数据
     */
    public void showAsOnCheckPass(EAUModelBean eauModelBean) {
        initView(contentView);
        initVariable();
        initEvent();

        DLog.d(getClass(), "bean:" + JSON.toJSONString(eauModelBean));
        imageReview.setImageResource(R.drawable.v1011_drawable_mask_success);
        tvMsg.setText(getString(R.string.v1010_default_pau_text_pass));
        btnEdit.setVisibility(View.GONE);

        fillTemplateByData(eauModelBean);
    }

    /**
     * 认证不通过
     *
     * @param eauModelBean 元数据
     */
    public void showAsOnCheckRefuse(EAUModelBean eauModelBean) {
        initView(contentView);
        initVariable();
        initEvent();

        imageReview.setImageResource(R.drawable.v1011_drawable_mask_refuse);
        tvMsg.setText(getString(R.string.v1010_default_pau_text_refuse));

        btnEdit.setVisibility(View.VISIBLE);
        btnEdit.setText(getString(R.string.v1010_default_pau_text_authentic_again));

        fillTemplateByData(eauModelBean);
        btnEdit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EventBus.getDefault().post(new AppEvent.ReEAuthEvent());
            }
        });

    }

    private String formatValidity(long validityBegin, long validityEnd) {
        StringBuilder builder = new StringBuilder();
        builder.append(getString(R.string.v1010_default_eau_text_validity2)).append("：");

        TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer(validityBegin);
        builder.append(transformer.getDefaultFormat());

        builder.append(getString(R.string.v1010_default_pau_text_to));
        TimeUtil.DateTransformer transformer2 = TimeUtil.newDateTransformer(validityEnd);
        builder.append(transformer2.getDefaultFormat());
        return builder.toString();
    }

}
