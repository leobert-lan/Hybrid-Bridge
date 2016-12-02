package com.lht.cloudjob.mvp.presenter;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;
import android.widget.DatePicker;

import com.alibaba.fastjson.JSON;
import com.anthonycr.grant.PermissionsResultAction;
import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.activity.asyncprotected.LocationPickerActivity;
import com.lht.cloudjob.customview.CustomDialog;
import com.lht.cloudjob.customview.CustomPopupWindow;
import com.lht.cloudjob.interfaces.ITriggerCompare;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.interfaces.keys.DBConfig;
import com.lht.cloudjob.interfaces.net.IApiRequestModel;
import com.lht.cloudjob.interfaces.net.IApiRequestPresenter;
import com.lht.cloudjob.interfaces.net.IRestfulApi;
import com.lht.cloudjob.interfaces.umeng.IUmengEventKey;
import com.lht.cloudjob.mvp.model.ApiModelCallback;
import com.lht.cloudjob.mvp.model.DbCURDModel;
import com.lht.cloudjob.mvp.model.EAuthenticModel;
import com.lht.cloudjob.mvp.model.EAuthenticQueryModel;
import com.lht.cloudjob.mvp.model.ImageCompressModel;
import com.lht.cloudjob.mvp.model.ImageCopyModel;
import com.lht.cloudjob.mvp.model.ImageGetterModel;
import com.lht.cloudjob.mvp.model.UploadModel;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.model.bean.EAUModelBean;
import com.lht.cloudjob.mvp.model.bean.EAuthenticQueryResBean;
import com.lht.cloudjob.mvp.model.bean.UploadResBean;
import com.lht.cloudjob.mvp.viewinterface.IEnterpriseAuthenticateActivity;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.permission.Permissions;
import com.lht.cloudjob.util.time.TimeUtil;
import com.lht.customwidgetlib.actionsheet.OnActionSheetItemClickListener;
import com.litesuits.orm.LiteOrm;

import java.io.File;
import java.io.Serializable;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.presenter
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> EAuthenticateActivityPresenter
 * <p><b>Description</b>: TODO
 * <p>Created by Administrator on 2016/9/5.
 */

public class EAuthenticateActivityPresenter implements IApiRequestPresenter {

    private final IEnterpriseAuthenticateActivity iEnterpriseAuthenticateActivity;
    private EAUModelBean eauModelBean;
    private String username;
    private LiteOrm liteOrm;
    public static final int INTENT_CODE_CAPTURE = 1;
    public static final int INTENT_CODE_ALBUM = 2;
    private final ImageGetterModel imageGetterModel;
    private String licensePic2Upload;

    /**
     * 是否在重新认证，如果是，resume时不重新验证数据
     */
    private boolean isOnReAuth = false;

    public void setIsOnReAuth(boolean isOnReAuth) {
        this.isOnReAuth = isOnReAuth;
    }

    public EAuthenticateActivityPresenter(IEnterpriseAuthenticateActivity
                                                  iEnterpriseAuthenticateActivity) {
        this.iEnterpriseAuthenticateActivity = iEnterpriseAuthenticateActivity;
        eauModelBean = new EAUModelBean();
        imageGetterModel = new ImageGetterModel();
        imageCopyModel = new ImageCopyModel();
        liteOrm = LiteOrm.newSingleInstance(iEnterpriseAuthenticateActivity.getActivity(),
                DBConfig.AuthenticateDb.DB_NAME);
    }

    @Override
    public void cancelRequestOnFinish(Context context) {

    }

    /**
     * 判空
     */
    public boolean isComplete(String s, int toastText) {
        if (TextUtils.isEmpty(s)) {
            iEnterpriseAuthenticateActivity.showErrorMsg(iEnterpriseAuthenticateActivity
                    .getAppResource().getString(toastText));
            return false;
        }
        return true;
    }

    public boolean isComplete(long l, int toastText) {
        if (l <= 0) {
            iEnterpriseAuthenticateActivity.showErrorMsg(iEnterpriseAuthenticateActivity
                    .getAppResource().getString(toastText));
            return false;
        }
        return true;
    }

    /**
     * 选择有限期限
     */
    public void doChooseValidityTime() {
        String[] data = new String[]{"长期", "短期"};
        iEnterpriseAuthenticateActivity.showValidityTimeSelectActionsheet(data, new
                OnActionSheetItemClickListener() {
                    @Override
                    public void onActionSheetItemClick(int position) {
                        if (position == 0) {
                            iEnterpriseAuthenticateActivity.setLongValidityTime();
                            eauModelBean.setPeriodCode(EAUModelBean.PERIOD_LONG);
                        } else if (position == 1) {
                            iEnterpriseAuthenticateActivity.setShortValidityTime();
                            eauModelBean.setPeriodCode(EAUModelBean.PERIOD_SHORT);
                        }
                    }
                });
    }

    /**
     * 选择地区 （香港、澳门）
     */
    public void doChooseRegion() {
        String[] data = new String[]{"香港", "澳门"};
        iEnterpriseAuthenticateActivity.showValidityTimeSelectActionsheet(data, new
                OnActionSheetItemClickListener() {
                    @Override
                    public void onActionSheetItemClick(int position) {
                        if (position == 0) {
                            iEnterpriseAuthenticateActivity.setHongkongArea();
                        } else if (position == 1) {
                            iEnterpriseAuthenticateActivity.setMacaoArea();
                        }
                    }
                });
    }

    /**
     * 选择省市区
     */
    public void doChooseRegion2() {
        Intent intent = new Intent(iEnterpriseAuthenticateActivity.getActivity(),
                LocationPickerActivity.class);
        iEnterpriseAuthenticateActivity.getActivity().startActivity(intent);
    }

    /**
     * 设置企业认证的开始时间
     */
    public void callSetStartTime() {
        iEnterpriseAuthenticateActivity.showDateSelectDialog(TimeUtil.getCurrentTimeInLong(),
                beginDateSetListener);
    }

    /**
     * 设置企业认证的结束时间
     */
    public void callSetEndTime() {
        iEnterpriseAuthenticateActivity.showDateSelectDialog(TimeUtil.getCurrentTimeInLong(),
                endDateSetListener);
    }

    private DatePickerDialog.OnDateSetListener beginDateSetListener = new DatePickerDialog
            .OnDateSetListener() {
        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
            String format = "%d-%d-%d";
            String s = String.format(format, year, monthOfYear + 1, dayOfMonth);
            iEnterpriseAuthenticateActivity.showValidityBeginTime(s);

            TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer(year, monthOfYear,
                    dayOfMonth);
            eauModelBean.setStartTime(transformer.getMillisInLong());

        }
    };
    private DatePickerDialog.OnDateSetListener endDateSetListener = new DatePickerDialog
            .OnDateSetListener() {
        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
            String format = "%d-%d-%d";
            String s = String.format(format, year, monthOfYear + 1, dayOfMonth);
            iEnterpriseAuthenticateActivity.showValidityEndTime(s);

            TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer(year, monthOfYear,
                    dayOfMonth);

            eauModelBean.setEndTime(transformer.getMillisInLong());
        }
    };

    /**
     * 提交认证
     */
    public void callSubmitAuthenticate(String userName, String companyName, String
            incLegalPersonName, String incCode, String incField, String region2, String
                                               incLocation) {


        if (!isComplete(userName, R.string.v1010_default_eau_username_isempty)) {
            return;
        }

        if (!isComplete(companyName, R.string.v1010_default_eau_hint_inc)) {
            return;
        }

        if (!isComplete(incCode, R.string.v1010_default_eau_hint_code)) {
            return;
        }

        if (!isComplete(incField, R.string.v1010_default_eau_hint_field)) {
            return;
        }

        //大陆、台湾地区需要检验法人
        if (eauModelBean.getAuthArea() == EAUModelBean.AREA_ML
                || eauModelBean.getAuthArea() == EAUModelBean.AREA_TW) {
            if (!isComplete(incLegalPersonName, R.string.v1010_default_eau_hint_name)) {
                return;
            }
        }

        //大陆、台湾地区需要检验地区 省市区
        if (eauModelBean.getAuthArea() == EAUModelBean.AREA_ML
                || eauModelBean.getAuthArea() == EAUModelBean.AREA_TW) {
            if (!isComplete(region2, R.string.v1010_default_eau_hint_region)) {
                return;
            }
        }

        //大陆、台湾地区需要检验地区 具体位置
        if (eauModelBean.getAuthArea() == EAUModelBean.AREA_ML
                || eauModelBean.getAuthArea() == EAUModelBean.AREA_TW) {
            if (!isComplete(incLocation, R.string.v1010_default_eau_hint_destination)) {
                return;
            }
        }

        //大陆地区需要检验证件有效期
        if (eauModelBean.getAuthArea() == EAUModelBean.AREA_ML) {
            if (eauModelBean.getPeriodCode() == 0) { // 未设置有效期 长/短
                iEnterpriseAuthenticateActivity.showErrorMsg(iEnterpriseAuthenticateActivity
                        .getAppResource().getString(R.string.v1010_default_eau_hint_validity));
                return;
            } else if (eauModelBean.getPeriodCode() == EAUModelBean.PERIOD_SHORT) {
                //检验时间是否设置
                if (!isComplete(eauModelBean.getStartTime(), R.string
                        .v1010_toast_eau_error_validity)
                        || !isComplete(eauModelBean.getEndTime(), R.string
                        .v1010_toast_eau_error_validity)) {
                    return;
                }
            }
        }

        if (!isComplete(licensePic2Upload, R.string.v1010_default_eau_license_pic)) {
            return;
        }

        eauModelBean.setUserName(userName);
        eauModelBean.setCompanyName(companyName);
        eauModelBean.setLicenNum(incCode);
        eauModelBean.setLegalPerson(incLegalPersonName);
        eauModelBean.setTurnOver(incField);
        eauModelBean.setLicenAddress(incLocation);
        doUpload(licensePic2Upload);
    }

    /**
     * 必须上传成功之后才能调用！
     */
    private void doAuth() {
        iEnterpriseAuthenticateActivity.showWaitView(true);

        //提交企业认证 - 计数
        iEnterpriseAuthenticateActivity.reportCountEvent(IUmengEventKey.KEY_AUTH_ENTERPRISE);

        IApiRequestModel model = new EAuthenticModel(eauModelBean,
                new EAuthenticateModelCallback());
        model.doRequest(iEnterpriseAuthenticateActivity.getActivity());
    }

    public void setArea(int areaCode) {
        eauModelBean.setAuthArea(areaCode);
    }

    public void updateProvince(String province) {
        eauModelBean.setProvince(province);
    }

    public void updateCity(String city) {
        eauModelBean.setCity(city);
    }

    public void updateArea(String area) {
        eauModelBean.setDistrict(area);
    }

    private final class EAuthenticateModelCallback implements ApiModelCallback<BaseVsoApiResBean> {

        @Override
        public void onSuccess(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iEnterpriseAuthenticateActivity.cancelWaitView();
            iEnterpriseAuthenticateActivity.showMsg(iEnterpriseAuthenticateActivity
                    .getActivity().getString(R.string.v1010_default_pau_to_authenticate_success));

            setIsOnReAuth(false);
            callEAuthenticStateQuery(username);

        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iEnterpriseAuthenticateActivity.cancelWaitView();
            iEnterpriseAuthenticateActivity.showErrorMsg(beanContainer.getData().getMessage());
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            iEnterpriseAuthenticateActivity.cancelWaitView();
        }
    }

    private boolean inited = false;

    public void callEAuthenticStateQuery(String userName) {
        this.username = userName;
        if (!isOnReAuth) {
            iEnterpriseAuthenticateActivity.showWaitView(true);
            IApiRequestModel model = new EAuthenticQueryModel(username, new
                    EAuthenticQueryModelCallback());
            model.doRequest(iEnterpriseAuthenticateActivity.getActivity());
        }
    }

    private final class EAuthenticQueryModelCallback implements
            ApiModelCallback<EAuthenticQueryResBean> {

        @Override
        public void onSuccess(BaseBeanContainer<EAuthenticQueryResBean> beanContainer) {
            EAuthenticQueryResBean bean = beanContainer.getData();

//            // TODO: 2016/9/20 test ////////
//            bean = DummyData.genEauthRefuseData();
//            ////////////////////////////////

            EAUModelBean eauModelBean = new EAUModelBean();

            iEnterpriseAuthenticateActivity.showErrorMsg(iEnterpriseAuthenticateActivity
                    .getActivity().getString(R.string
                            .v1010_default_pau_to_query_authenticate_success));
            eauModelBean.copy(bean);

            if (bean.getAuth_status() == EAuthenticQueryResBean.STATE_WAIT) {
                //等待认证
                iEnterpriseAuthenticateActivity.showOnCheckWaitView(eauModelBean);
            } else if (bean.getAuth_status() == EAuthenticQueryResBean.STATE_PASS) {
                //认证通过
                iEnterpriseAuthenticateActivity.showCheckPassView(eauModelBean);
            } else {
                //认证不通过
                iEnterpriseAuthenticateActivity.showCheckRefauseView(eauModelBean);
            }
            inited = true;
            iEnterpriseAuthenticateActivity.cancelWaitView();
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {

            if (beanContainer.getData().getRet() == EAuthenticQueryResBean.RET_UNSUBMIT) {
                //没有提交过认证的逻辑
                iEnterpriseAuthenticateActivity.cancelWaitView();
                iEnterpriseAuthenticateActivity.showEditView();
            } else {
                iEnterpriseAuthenticateActivity.cancelWaitView();
                iEnterpriseAuthenticateActivity.showErrorMsg(beanContainer.getData().getMessage());
            }
            iEnterpriseAuthenticateActivity.showUnAuthView(inited);
            inited = true;
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            iEnterpriseAuthenticateActivity.cancelWaitView();
            iEnterpriseAuthenticateActivity.showErrorView();
            inited = false;
        }
    }

    /**
     * 保存数据到数据库
     *
     * @param region          地区（香港、澳门）
     * @param companyName     公司名称
     * @param legalPersonName 法人姓名
     * @param registerCode    注册码
     * @param turnover        主营范围
     * @param detailLocation  详细地址
     */
    public void EAuSaveData(String region, String companyName, String legalPersonName,
                            String registerCode, String turnover, String detailLocation) {
        DbCURDModel<EAUModelBean> saveDataModel = new DbCURDModel<>(new SaveDbModelCallback(region,
                companyName, legalPersonName, registerCode, turnover, detailLocation));
        saveDataModel.doRequest();
    }

    private class SaveDbModelCallback implements DbCURDModel.IDbCURD<EAUModelBean> {

        private final String region;
        private final String companyName;
        private final String legalPersonName;
        private final String registerCode;
        private final String turnover;
        private final String detailLocation;


        public SaveDbModelCallback(String region, String companyName, String legalPersonName,
                                   String registerCode, String turnover, String detailLocation) {
            this.region = region;
            this.companyName = companyName;
            this.legalPersonName = legalPersonName;
            this.registerCode = registerCode;
            this.turnover = turnover;
            this.detailLocation = detailLocation;
        }


        @Override
        public EAUModelBean doCURDRequest() {
            eauModelBean.setValidityRegion(region);
            eauModelBean.setUserName(username);
            eauModelBean.setValidityRegion(iEnterpriseAuthenticateActivity.getRegion());
            eauModelBean.setCompanyName(companyName);
            eauModelBean.setLegalPerson(legalPersonName);
            eauModelBean.setLicenNum(registerCode);
            eauModelBean.setTurnOver(turnover);
            eauModelBean.setLicenAddress(detailLocation);

            liteOrm.save(eauModelBean);
            return null;
        }

        @Override
        public void onCURDFinish(EAUModelBean bean) {
            //empty 时候的回调
        }
    }

    /**
     * 未提交认证情况下，获取持久化数据并填充
     */
    public void initEAuData() {
        DbCURDModel<EAUModelBean> queryDataModel = new DbCURDModel<>(new QueryDbModelCallback());
        queryDataModel.doRequest();
    }

    private class QueryDbModelCallback implements DbCURDModel.IDbCURD<EAUModelBean> {
        @Override
        public EAUModelBean doCURDRequest() {

            return liteOrm.queryById(username, EAUModelBean.class);
        }

        @Override
        public void onCURDFinish(EAUModelBean bean) {
            if (bean == null) {
                return;
            } else {
                eauModelBean = bean;
                iEnterpriseAuthenticateActivity.showEAuData(eauModelBean);
            }
        }
    }

    /**
     * 选择营业执照
     */
    public void callChooseLicensePic() {
        String[] data = new String[]{"拍照", "从相册中选择"};
        iEnterpriseAuthenticateActivity.showLicensePicSelectActionsheet(data, new
                OnActionSheetItemClickListener() {
                    @Override
                    public void onActionSheetItemClick(int position) {
                        switch (position) {
                            case 0:
                                callCaptureForImage(iEnterpriseAuthenticateActivity.getActivity());
                                break;
                            case 1:
                                callAlbumForImage(iEnterpriseAuthenticateActivity.getActivity());
                                break;
                            default:
                                break;
                        }
                    }
                });
    }

    /**
     * 拍照
     *
     * @param activity
     */
    private void callCaptureForImage(UMengActivity activity) {

        boolean hasPermission = iEnterpriseAuthenticateActivity.getActivity().checkCameraPermission();
        if (hasPermission) {
            Uri mImageUri = getTempUri();
            imageGetterModel.startCapture(activity, INTENT_CODE_CAPTURE, mImageUri);
        } else {
            iEnterpriseAuthenticateActivity.getActivity().grantCameraPermission(new PermissionsResultAction() {
                @Override
                public void onGranted() {
                    Uri mImageUri = getTempUri();
                    imageGetterModel.startCapture(iEnterpriseAuthenticateActivity.getActivity(),
                            INTENT_CODE_CAPTURE, mImageUri);
                }

                @Override
                public void onDenied(String permission) {
                    iEnterpriseAuthenticateActivity.showMsg("缺少相机权限，无法调用相机");
                    CustomDialog dialog = Permissions.CAMERA.newPermissionGrantReqAlert(iEnterpriseAuthenticateActivity.getActivity());
                    dialog.show();
                }
            });
        }
    }

    /**
     * 从相册中选择
     *
     * @param activity
     */
    private void callAlbumForImage(Activity activity) {
        imageGetterModel.startSelect(activity, INTENT_CODE_ALBUM);
    }

    private Uri getTempUri() {
        return Uri.fromFile(new File(BaseActivity.getLocalImageCachePath(), "temp.jpg"));
    }

    private String getUsername() {
        return IVerifyHolder.mLoginInfo.getUsername();
    }

    /**
     * 选择相册图片后调用转换
     *
     * @param path 图片路径
     */
    private static final String UPLOAD_IMAGE_ATTEMPT = "licensepic";
    private final ImageCopyModel imageCopyModel;

    public void callTransAlbum(String path) {
        File f1 = new File(path);
        String filename = ImageGetterModel.NameUtils.generateName(getUsername(),
                UPLOAD_IMAGE_ATTEMPT)
                .replaceAll("\r|\n", "");
        String path2Copy = BaseActivity.getLocalImageCachePath() + "/" + filename;
        File f2 = new File(path2Copy);
        imageCopyModel.doCopy(f1, f2, ImageGetTrigger.Album);
    }

    public enum ImageGetTrigger implements ITriggerCompare {
        Capture(1), Album(2);
        private final int tag;

        ImageGetTrigger(int i) {
            tag = i;
        }

        @Override
        public boolean equals(ITriggerCompare compare) {
            boolean b1 = compare.getClass().getName().equals(getClass().getName());
            boolean b2 = compare.getTag().equals(getTag());
            return b1 & b2;
        }

        @Override
        public Object getTag() {
            return tag;
        }

        @Override
        public Serializable getSerializable() {
            return this;
        }
    }

    public void callTransCapture() {
        File f1 = new File(getTempUri().getPath());
        String filename = ImageGetterModel.NameUtils.generateName(getUsername(),
                UPLOAD_IMAGE_ATTEMPT)
                .replaceAll("\r|\n", "");
        String path2Copy = BaseActivity.getLocalImageCachePath() + "/" + filename;
        File f2 = new File(path2Copy);
        imageCopyModel.doCopy(f1, f2, ImageGetTrigger.Capture);
    }

    /**
     * 处理图片获取后(copy)的事件
     *
     * @param event 图片本地处理完成事件
     */
    public void callResolveEvent(AppEvent.ImageGetEvent event) {
        ITriggerCompare compare = event.getTrigger();
        if (ImageGetTrigger.Capture.equals(compare) || ImageGetTrigger.Album.equals(compare)) {
            iEnterpriseAuthenticateActivity.showWaitView(true);
            handleAfterImageCopy(event);
        }
    }

    /**
     * 处理图片
     * - 压缩
     *
     * @param event 图片本地处理完成事件
     */
    private void handleAfterImageCopy(AppEvent.ImageGetEvent event) {
        if (event.isSuccess()) {
            ImageCompressModel model = new ImageCompressModel(new ImageCompressModel
                    .IImageCompressCallback() {
                @Override
                public void onCompressed(String imageFilePath) {
                    iEnterpriseAuthenticateActivity.cancelWaitView();
                    licensePic2Upload = imageFilePath;
                    iEnterpriseAuthenticateActivity.updateLocalPic(imageFilePath);
                }
            });
            model.doCompress(new File(event.getPath()));
        } else {
            // TODO: 2016/9/20
            DLog.e(getClass(), "copy image failure");
            iEnterpriseAuthenticateActivity.showErrorMsg("copy image failure");
            iEnterpriseAuthenticateActivity.cancelWaitView();
        }
    }

    private void doUpload(String path) {
        iEnterpriseAuthenticateActivity.showWaitView(true);
        IApiRequestModel uploadModel = new UploadModel(getUsername(), path, IRestfulApi.UploadApi
                .VALUE_TYPE_DEFAULT,
                new UploadModelCallback(path));
        uploadModel.doRequest(iEnterpriseAuthenticateActivity.getActivity());
    }

    private class UploadModelCallback implements ApiModelCallback<UploadResBean> {
        private final String path;

        UploadModelCallback(String path) {
            this.path = path;
        }

        @Override
        public void onSuccess(BaseBeanContainer<UploadResBean> beanContainer) {
            iEnterpriseAuthenticateActivity.showMsg(iEnterpriseAuthenticateActivity.getActivity()
                    .getString(R.string.v1010_default_eau_text_file_upload_success));
            eauModelBean.setLicenPic(beanContainer.getData().getFile_url());
            doAuth();
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            iEnterpriseAuthenticateActivity.cancelWaitView();
            iEnterpriseAuthenticateActivity.showDialog(R.string
                            .v1010_dialog_feedback_content_error_upload,
                    R.string.v1010_dialog_feedback_positive_reupload,
                    new CustomPopupWindow.OnPositiveClickListener() {
                        @Override
                        public void onPositiveClick() {
                            doUpload(path);
                        }
                    });
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            iEnterpriseAuthenticateActivity.cancelWaitView();
        }
    }
}
