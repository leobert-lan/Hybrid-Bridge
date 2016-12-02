package com.lht.cloudjob.mvp.presenter;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.content.Context;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;
import android.widget.DatePicker;

import com.anthonycr.grant.PermissionsResultAction;
import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.activity.UMengActivity;
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
import com.lht.cloudjob.mvp.model.ImageCompressModel;
import com.lht.cloudjob.mvp.model.ImageCopyModel;
import com.lht.cloudjob.mvp.model.ImageGetterModel;
import com.lht.cloudjob.mvp.model.PAuthenticModel;
import com.lht.cloudjob.mvp.model.PAuthenticQueryModel;
import com.lht.cloudjob.mvp.model.UploadModel;
import com.lht.cloudjob.mvp.model.bean.BaseBeanContainer;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.model.bean.PAUModelBean;
import com.lht.cloudjob.mvp.model.bean.PAuthenticQueryResBean;
import com.lht.cloudjob.mvp.model.bean.UploadResBean;
import com.lht.cloudjob.mvp.viewinterface.IPAuthenticateActivity;
import com.lht.cloudjob.util.debug.DLog;
import com.lht.cloudjob.util.identify.IdentifyCardUtil;
import com.lht.cloudjob.util.internet.HttpUtil;
import com.lht.cloudjob.util.permission.Permissions;
import com.lht.cloudjob.util.time.TimeUtil;
import com.lht.customwidgetlib.actionsheet.OnActionSheetItemClickListener;
import com.litesuits.orm.LiteOrm;

import java.io.File;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.presenter
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> PAuthenticateActivityPresenter
 * <p><b>Description</b>: TODO
 * Created by leobert on 2016/8/8.
 */
public class PAuthenticateActivityPresenter implements IApiRequestPresenter {

    private IPAuthenticateActivity ipAuthenticateActivity;
    private boolean inited = false;
    private PAUModelBean pauModelBean;
    private String username;
    private LiteOrm liteOrm;
    private final ImageCopyModel imageCopyModel;

    public static final int INTENT_CODE_CAPTURE_FRONT = 1;
    public static final int INTENT_CODE_CAPTURE_BACK = 2;
    public static final int INTENT_CODE_CAPTURE_HAND = 3;

    public static final int INTENT_CODE_ALBUM_FRONT = 4;
    public static final int INTENT_CODE_ALBUM_BACK = 5;
    public static final int INTENT_CODE_ALBUM_HAND = 6;

    private final String KEY_FRONT = "frontPic";
    private final String KEY_BACK = "backPic";
    private final String KEY_HAND = "handPic";

    private HashMap<String, String> images2Upload;
    /**
     * 副本
     */
    private HashMap<String, String> dupImages2Upload;

    /**
     * 是否在重新认证，如果是，resume时不重新验证数据
     */
    private boolean isOnReAuth = false;

    public void setIsOnReAuth(boolean isOnReAuth) {
        this.isOnReAuth = isOnReAuth;
    }

    public PAuthenticateActivityPresenter(IPAuthenticateActivity ipAuthenticateActivity) {
        this.ipAuthenticateActivity = ipAuthenticateActivity;
        images2Upload = new HashMap<>();
        dupImages2Upload = new HashMap<>();
        pauModelBean = new PAUModelBean();
        imageGetterModel = new ImageGetterModel();
        imageCopyModel = new ImageCopyModel();
        liteOrm = LiteOrm.newSingleInstance(ipAuthenticateActivity.getActivity(),
                DBConfig.AuthenticateDb.DB_NAME);

    }

    public void callPAuthenticStateQuery(String username) {
        this.username = username;
        if (!isOnReAuth) {
            ipAuthenticateActivity.showWaitView(true);
            IApiRequestModel model = new PAuthenticQueryModel(username, new
                    PAuthenticQueryModelCallback());
            model.doRequest(ipAuthenticateActivity.getActivity());
        }
    }

    public void callSetValidityBegin() {
        ipAuthenticateActivity.showDateSelectDialog(TimeUtil.getCurrentTimeInLong(),
                beginDateSetListener);
    }

    @Override
    public void cancelRequestOnFinish(Context context) {
        HttpUtil.getInstance().onActivityDestroy(context);
    }

    public void callSetValidityEnd() {
        ipAuthenticateActivity.showDateSelectDialog(TimeUtil.getCurrentTimeInLong(),
                endDateSetListener);
    }

    /**
     * 判空
     *
     * @param s
     * @param toastText
     * @return
     */
    private boolean isComplete(String s, int toastText) {
        if (TextUtils.isEmpty(s)) {
            ipAuthenticateActivity.showErrorMsg(ipAuthenticateActivity.getActivity().getString
                    (toastText));
            return false;
        }
        return true;
    }

    public void callSubmit(String username, String realname, String idCard) {
        this.username = username;
        if (!isComplete(username, R.string.v1010_default_eau_username_isempty)) {
            return;
        }
        if (!isComplete(realname, R.string.v1010_default_pau_realname_isempty)) {
            return;
        }
        if (!isComplete(idCard, R.string.v1010_default_pau_idcard_isempty)) {
            return;
        }

        if (images2Upload.size() < 3) {
            ipAuthenticateActivity.showErrorMsg(ipAuthenticateActivity.getActivity().getString(R
                    .string.v1010_default_pau_select_certificate_pic));
            return;
        }

        if (pauModelBean.getAreaCode() == PAUModelBean.AREA_ML) {
            // TODO: 2016/9/19 检验时间？

            //校验大陆身份证合法性
            if (!IdentifyCardUtil.isMainLandIdNo(idCard)) {
                ipAuthenticateActivity.showErrorMsg(ipAuthenticateActivity.getActivity().getString(R
                        .string.v1010_default_pau_idcard_error));
                return;
            }
        } else if (pauModelBean.getAreaCode() == PAUModelBean.AREA_TW) {
            //empty
        } else if (pauModelBean.getAreaCode() == PAUModelBean.AREA_NULL) {
            ipAuthenticateActivity.showErrorMsg(ipAuthenticateActivity.getActivity().getString(R
                    .string.v1010_default_pau_select_location));
            return;
        }

        ipAuthenticateActivity.showWaitView(true);
        pauModelBean.setUsername(username);
        pauModelBean.setRealName(realname);
        pauModelBean.setIdCard(idCard);

        dupImages2Upload.putAll(images2Upload);

        Iterator<String> iterator = dupImages2Upload.keySet().iterator();
        String key = iterator.next();
        doUpload(key, images2Upload.get(key));
    }

    private void doAuth() {
        ipAuthenticateActivity.showWaitView(true);
        //统计 提交个人认证 - 计数
        ipAuthenticateActivity.reportCountEvent(IUmengEventKey.KEY_AUTH_PERSONAL);

        IApiRequestModel model = new PAuthenticModel(pauModelBean, new PAuthenticModelCallback());
        model.doRequest(ipAuthenticateActivity.getActivity());
    }

    public void setArea(int areaCode) {
        pauModelBean.setAreaCode(areaCode);
    }

    private final class PAuthenticModelCallback implements ApiModelCallback<BaseVsoApiResBean> {

        @Override
        public void onSuccess(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            ipAuthenticateActivity.cancelWaitView();
            ipAuthenticateActivity.showMsg(ipAuthenticateActivity
                    .getActivity().getString(R.string.v1010_default_pau_to_authenticate_success));
            isOnReAuth = false;
            callPAuthenticStateQuery(username);
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            ipAuthenticateActivity.cancelWaitView();
            ipAuthenticateActivity.showErrorMsg(beanContainer.getData().getMessage());
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            ipAuthenticateActivity.cancelWaitView();

            // TODO: 2016/8/8   
        }
    }

    private final class PAuthenticQueryModelCallback implements
            ApiModelCallback<PAuthenticQueryResBean> {

        @Override
        public void onSuccess(BaseBeanContainer<PAuthenticQueryResBean> beanContainer) {
            ipAuthenticateActivity.cancelWaitView();
            PAuthenticQueryResBean bean = beanContainer.getData();

//            ////////////////////////////////////////////////
//            // TODO: 2016/9/21 test
//                bean = DummyData.genPauthRefuseData();
//            ////////////////////////////////////////////////

            PAUModelBean pauModelBean = new PAUModelBean();
            pauModelBean.copy(bean);
            if (bean.getAuth_status() == PAuthenticQueryResBean.STATE_WAIT) {
                //等待认证
                ipAuthenticateActivity.showOnCheckWaitView(pauModelBean);
            } else if (bean.getAuth_status() == PAuthenticQueryResBean.STATE_PASS) {
                //认证通过
                ipAuthenticateActivity.showCheckPassView(pauModelBean);
            } else {
                //认证不通过(被拒绝)
                ipAuthenticateActivity.showCheckRefuseView(pauModelBean);
            }
        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            if (beanContainer.getData().getRet() == PAuthenticQueryResBean.RET_UNSUBMIT) {
                //没有提交过认证的逻辑
                ipAuthenticateActivity.cancelWaitView();
                ipAuthenticateActivity.showEditView();

            } else {
                ipAuthenticateActivity.cancelWaitView();
                ipAuthenticateActivity.showErrorMsg(beanContainer.getData().getMessage());
            }
            ipAuthenticateActivity.showUnAuthView(inited);
            inited = true;
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            // TODO: 2016/8/8 显示错误视图的逻辑
            ipAuthenticateActivity.cancelWaitView();
            ipAuthenticateActivity.showErrorView();
            inited = false;
        }
    }

    private DatePickerDialog.OnDateSetListener beginDateSetListener = new DatePickerDialog
            .OnDateSetListener() {
        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
            String format = "%d-%d-%d";
            String s = String.format(format, year, monthOfYear + 1, dayOfMonth);
            ipAuthenticateActivity.showValidityBeginTime(s);


            TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer(year, monthOfYear,
                    dayOfMonth);
            pauModelBean.setValidityBegin(transformer.getMillisInLong());
//            // TODO: 2016/10/9 debug
//            Log.i("tmsg","pau:set begin time stamp:"+transformer.getMillisInLong()+"\r\n format as:"+s);
        }
    };
    private DatePickerDialog.OnDateSetListener endDateSetListener = new DatePickerDialog
            .OnDateSetListener() {
        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
            String format = "%d-%d-%d";
            String s = String.format(format, year, monthOfYear + 1, dayOfMonth);
            ipAuthenticateActivity.showValidityEndTime(s);

            TimeUtil.DateTransformer transformer = TimeUtil.newDateTransformer(year, monthOfYear,
                    dayOfMonth);
            pauModelBean.setValidityEnd(transformer.getMillisInLong());
//            // TODO: 2016/10/9 debug
//            Log.i("tmsg", "pau:set end time stamp:" + transformer.getMillisInLong()+"\r\n format as:"+s);
        }
    };

    /**
     * 选择地区 （香港、澳门）
     */
    public void doChooseRegion() {
        String[] data = new String[]{"香港", "澳门"};
        ipAuthenticateActivity.showValidityTimeSelectActionsheet(data, new
                OnActionSheetItemClickListener() {
                    @Override
                    public void onActionSheetItemClick(int position) {
                        if (position == 0) {
                            ipAuthenticateActivity.setHongkongArea();
                        } else if (position == 1) {
                            ipAuthenticateActivity.setMacaoArea();
                        }
                    }
                });
    }

    /**
     * 将用户填入的数据存到数据库（存）
     *
     * @param realName 真实姓名
     * @param idCard   身份证号
     * @param region   地区
     */
    public void callSaveData(final String realName, final String idCard, final String region) {
        DbCURDModel<PAUModelBean> saveDataModel = new DbCURDModel<>(new SaveDbModelCallback
                (realName, idCard, region));
        saveDataModel.doRequest();
    }


    private class SaveDbModelCallback implements DbCURDModel.IDbCURD<PAUModelBean> {
        private final String realName;
        private final String idCard;
        private final String region;

        public SaveDbModelCallback(String realName, String idCard, String region) {
            this.realName = realName;
            this.idCard = idCard;
            this.region = region;
        }

        @Override
        public PAUModelBean doCURDRequest() {
            pauModelBean.setUsername(username);
            pauModelBean.setRealName(realName);
            pauModelBean.setIdCard(idCard);
            pauModelBean.setValidityRegion(region);

            liteOrm.save(pauModelBean);
            return null;
        }

        @Override
        public void onCURDFinish(PAUModelBean pauModelBean) {
            //empty
        }
    }

    /**
     * 初始化数据库（取）
     */
    public void initPAuData() {
        DbCURDModel<PAUModelBean> queryDataModel = new DbCURDModel<>(new QueryDbModelCallback());
        queryDataModel.doRequest();
    }

    private class QueryDbModelCallback implements DbCURDModel.IDbCURD<PAUModelBean> {
        @Override
        public PAUModelBean doCURDRequest() {
            return liteOrm.queryById(username, PAUModelBean.class);
        }

        @Override
        public void onCURDFinish(PAUModelBean bean) {
            if (bean == null) {
                return;
            } else {
                pauModelBean = bean;
                ipAuthenticateActivity.showPAuData(pauModelBean);
            }
        }
    }

    public void doGetFrontPic() {
        String[] data = new String[]{"拍照", "从相册中选择"};
        ipAuthenticateActivity.showPicSelectActionsheet(data, new OnActionSheetItemClickListener() {
            @Override
            public void onActionSheetItemClick(int position) {
                switch (position) {
                    case 0:
                        callCaptureForImage(ipAuthenticateActivity.getActivity(),
                                PAuthenticateActivityPresenter.INTENT_CODE_CAPTURE_FRONT);
                        break;
                    case 1:
                        callAlbumForImage(ipAuthenticateActivity.getActivity(),
                                PAuthenticateActivityPresenter.INTENT_CODE_ALBUM_FRONT);
                        break;
                    default:
                        break;
                }
            }
        });
    }

    public void doGetBackPic() {
        String[] data = new String[]{"拍照", "从相册中选择"};
        ipAuthenticateActivity.showPicSelectActionsheet(data, new OnActionSheetItemClickListener() {
            @Override
            public void onActionSheetItemClick(int position) {
                switch (position) {
                    case 0:
                        callCaptureForImage(ipAuthenticateActivity.getActivity(),
                                PAuthenticateActivityPresenter.INTENT_CODE_CAPTURE_BACK);
                        break;
                    case 1:
                        callAlbumForImage(ipAuthenticateActivity.getActivity(),
                                PAuthenticateActivityPresenter.INTENT_CODE_ALBUM_BACK);
                        break;
                    default:
                        break;
                }
            }
        });
    }

    public void doGetHandPic() {
        String[] data = new String[]{"拍照", "从相册中选择"};
        ipAuthenticateActivity.showPicSelectActionsheet(data, new OnActionSheetItemClickListener() {
            @Override
            public void onActionSheetItemClick(int position) {
                switch (position) {
                    case 0:
                        callCaptureForImage(ipAuthenticateActivity.getActivity(),
                                PAuthenticateActivityPresenter.INTENT_CODE_CAPTURE_HAND);
                        break;
                    case 1:
                        callAlbumForImage(ipAuthenticateActivity.getActivity(),
                                PAuthenticateActivityPresenter.INTENT_CODE_ALBUM_HAND);
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
    private final ImageGetterModel imageGetterModel;

    private void callCaptureForImage(final UMengActivity activity, final int code) {

        boolean hasPermission = ipAuthenticateActivity.getActivity().checkCameraPermission();
        if (hasPermission) {
            Uri mImageUri = getTempUri();
            imageGetterModel.startCapture(activity, code, mImageUri);
        } else {
            ipAuthenticateActivity.getActivity().grantCameraPermission(new PermissionsResultAction() {
                @Override
                public void onGranted() {
                    Uri mImageUri = getTempUri();
                    imageGetterModel.startCapture(ipAuthenticateActivity.getActivity(), code, mImageUri);
                }

                @Override
                public void onDenied(String permission) {
                    ipAuthenticateActivity.showMsg("缺少相机权限，无法调用相机");
                    CustomDialog dialog = Permissions.CAMERA.newPermissionGrantReqAlert(ipAuthenticateActivity.getActivity());
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
    private void callAlbumForImage(Activity activity, int code) {
        imageGetterModel.startSelect(activity, code);
    }

    private Uri getTempUri() {
        return Uri.fromFile(new File(BaseActivity.getLocalImageCachePath(), "temp.jpg"));
    }

    /**
     * 处理图片获取后(copy)的事件
     *
     * @param event 图片本地处理完成事件
     */
    public void callResolveEvent(AppEvent.ImageGetEvent event) {
        ITriggerCompare compare = event.getTrigger();
        if (ImageGetTrigger.Capture_front.equals(compare) || ImageGetTrigger.Album_front.equals
                (compare)
                || ImageGetTrigger.Capture_back.equals(compare) || ImageGetTrigger.Album_back
                .equals(compare)
                || ImageGetTrigger.Capture_hand.equals(compare) || ImageGetTrigger.Album_hand
                .equals(compare)) {
            ipAuthenticateActivity.showWaitView(true);
            handleAfterImageCopy(event);
        }
    }

    public enum ImageGetTrigger implements ITriggerCompare {
        Capture_front(1), Capture_back(2), Capture_hand(3), Album_front(4), Album_back(5),
        Album_hand(6);
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

    /**
     * 处理图片
     * - 压缩
     *
     * @param event 图片本地处理完成事件
     */

    private void handleAfterImageCopy(AppEvent.ImageGetEvent event) {
        ImageCompressModel.IImageCompressCallback callback = null;
        if (event.getTrigger().equals(ImageGetTrigger.Capture_front)
                || event.getTrigger().equals(ImageGetTrigger.Album_front)) {
            callback = new ImageCompressModel.IImageCompressCallback() {
                @Override
                public void onCompressed(String imageFilePath) {
                    ipAuthenticateActivity.cancelWaitView();
                    images2Upload.put(KEY_FRONT, imageFilePath);
                    ipAuthenticateActivity.updateIDcardFrontPic(imageFilePath);
                }
            };
        } else if (event.getTrigger().equals(ImageGetTrigger.Capture_back)
                || event.getTrigger().equals(ImageGetTrigger.Album_back)) {
            callback = new ImageCompressModel.IImageCompressCallback() {
                @Override
                public void onCompressed(String imageFilePath) {
                    ipAuthenticateActivity.cancelWaitView();
                    images2Upload.put(KEY_BACK, imageFilePath);
                    ipAuthenticateActivity.updateIDcardBackPic(imageFilePath);
                }
            };
        } else if (event.getTrigger().equals(ImageGetTrigger.Capture_hand)
                || event.getTrigger().equals(ImageGetTrigger.Album_hand)) {
            callback = new ImageCompressModel.IImageCompressCallback() {
                @Override
                public void onCompressed(String imageFilePath) {
                    ipAuthenticateActivity.cancelWaitView();
                    images2Upload.put(KEY_HAND, imageFilePath);
                    ipAuthenticateActivity.updateHandIDcardPic(imageFilePath);
                }
            };
        }

        if (event.isSuccess()) {
            ImageCompressModel model = new ImageCompressModel(callback);
            model.doCompress(new File(event.getPath()));
        } else {
            DLog.e(getClass(), new DLog.LogLocation(), "image get event failure");
            ipAuthenticateActivity.showErrorMsg(ipAuthenticateActivity.getActivity().getString(R
                    .string.v1010_default_pau_getpic_failure));
        }
    }


    private void doUpload(String key, String path) {
        IApiRequestModel uploadModel = new UploadModel(getUsername(), path, IRestfulApi.UploadApi
                .VALUE_TYPE_DEFAULT,
                new UploadModelCallback(key, path));
        uploadModel.doRequest(ipAuthenticateActivity.getActivity());
    }

    private String getUsername() {
        return IVerifyHolder.mLoginInfo.getUsername();
    }

    /**
     * 选择相册图片后调用转换
     *
     * @param path 图片路径
     */
    private static final String UPLOAD_IMAGE_ATTEMPT = "PAuthenticate";

    public void callTransAlbum(String path, ImageGetTrigger trigger) {
        File f1 = new File(path);
        String filename = ImageGetterModel.NameUtils.generateName(getUsername(),
                UPLOAD_IMAGE_ATTEMPT)
                .replaceAll("\r|\n", "");
        String path2Copy = BaseActivity.getLocalImageCachePath() + "/" + filename;
        File f2 = new File(path2Copy);
        imageCopyModel.doCopy(f1, f2, trigger);
    }

    public void callTransCapture(PAuthenticateActivityPresenter.ImageGetTrigger trigger) {
        File f1 = new File(getTempUri().getPath());
        String filename = ImageGetterModel.NameUtils.generateName(getUsername(),
                UPLOAD_IMAGE_ATTEMPT)
                .replaceAll("\r|\n", "");
        String path2Copy = BaseActivity.getLocalImageCachePath() + "/" + filename;
        File f2 = new File(path2Copy);
        imageCopyModel.doCopy(f1, f2, trigger);
    }

    private class UploadModelCallback implements ApiModelCallback<UploadResBean> {
        private final String path;
        private final String key;

        UploadModelCallback(String key, String path) {
            this.key = key;
            this.path = path;
        }

        @Override
        public void onSuccess(BaseBeanContainer<UploadResBean> beanContainer) {
            dupImages2Upload.remove(key);
            String file_url = beanContainer.getData().getFile_url();
            if (key.equals(KEY_FRONT)) {
                pauModelBean.setIdPicOne(file_url);
            } else if (key.equals(KEY_BACK)) {
                pauModelBean.setIdPicTwo(file_url);
            } else {
                pauModelBean.setIdPicThree(file_url);
            }

            if (!dupImages2Upload.isEmpty()) {
                Iterator<String> iterator = dupImages2Upload.keySet().iterator();
                String key = iterator.next();
                doUpload(key, dupImages2Upload.get(key));
            } else {
                //all uploaded,do auth create;
                doAuth();
            }

        }

        @Override
        public void onFailure(BaseBeanContainer<BaseVsoApiResBean> beanContainer) {
            ipAuthenticateActivity.cancelWaitView();
            ipAuthenticateActivity.showDialog(R.string.v1010_dialog_feedback_content_error_upload,
                    R.string.v1010_dialog_feedback_positive_reupload,
                    new CustomPopupWindow.OnPositiveClickListener() {
                        @Override
                        public void onPositiveClick() {
                            doUpload(key, path);
                        }
                    });
        }

        @Override
        public void onHttpFailure(int httpStatus) {
            // TODO: 2016/9/13
            ipAuthenticateActivity.cancelWaitView();

        }
    }

}
