package com.lht.cloudjob.service;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.MainApplication;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.mvp.model.DownloadModel;
import com.lht.cloudjob.mvp.model.interfaces.IFileDownloadCallbacks;
import com.lht.cloudjob.mvp.model.pojo.DownloadEntity;
import com.lht.cloudjob.native4js.expandresbean.NF_DownloadReqBean;
import com.lht.cloudjob.native4js.impl.DownloadImpl;

import org.greenrobot.eventbus.EventBus;

import java.io.File;

public class DownloadFileService extends IntentService {

    public static String DOWNLOAD_INFO = "download_info";

    public DownloadFileService() {
        super(DownloadFileService.class.getName());
    }


    @Override
    protected void onHandleIntent(Intent intent) {
        String downloadInfo = intent.getStringExtra(DOWNLOAD_INFO);
        NF_DownloadReqBean bean = (NF_DownloadReqBean) JSON.parse(downloadInfo);
        DownloadEntity entity = DownloadEntity.copyFromDownloadBean(bean);
        DownloadModel model = new DownloadModel(entity, BaseActivity.getPublicDownloadDir(),
                new DownloadFileCallback(bean, entity));
        model.doRequest(this);
    }

//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//
//        return super.onStartCommand(intent, flags, startId);
//    }

    static class DownloadFileCallback implements IFileDownloadCallbacks {
        private final NF_DownloadReqBean nfDownloadReqBean;
        private final DownloadEntity downloadEntity;

        DownloadFileCallback(NF_DownloadReqBean nfDownloadReqBean, DownloadEntity downloadEntity) {
            this.nfDownloadReqBean = nfDownloadReqBean;
            this.downloadEntity = downloadEntity;
        }

        private Context getApplicationContext() {
            return MainApplication.getOurInstance();
        }

        @Override
        public void onNoInternet() {
            Toast.makeText(getApplicationContext(), R.string.v1010_toast_net_exception, Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onMobileNet() {
            Toast.makeText(getApplicationContext(), R.string.v1020_versionupdate_dialog_onmobile_remind, Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onFileNotFoundOnServer() {
            Toast.makeText(getApplicationContext(), R.string.v1020_toast_download_onnotfound, Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onDownloadStart(DownloadEntity entity) {
            DownloadImpl.VsoBridgeDownloadEvent event = new DownloadImpl.VsoBridgeDownloadEvent();
            event.setStatus(DownloadImpl.VsoBridgeDownloadEvent.STATUS_ONSTART);
            event.setDownloadEntity(entity);
            event.setCurrentSize(0);
            event.setTotalSize(downloadEntity.getFileSize());
            event.setUniqueTag(nfDownloadReqBean.getUrl_download());
            postEvent(event);
        }

        @Override
        public void onDownloadCancel() {

        }

        @Override
        public void onDownloadSuccess(DownloadEntity entity, File file) {

        }

        @Override
        public void onDownloading(DownloadEntity entity, long current, long total) {

        }

        @Override
        public void onNoEnoughSpace() {
            Toast.makeText(getApplicationContext(), R.string.v1020_toast_download_onnoenoughspace, Toast.LENGTH_SHORT).show();
        }

        @Override
        public void downloadFailure() {
            Toast.makeText(getApplicationContext(), R.string.v1020_versionupdate_text_download_fuilure, Toast.LENGTH_SHORT).show();
        }

        private void postEvent(DownloadImpl.VsoBridgeDownloadEvent event) {
            EventBus.getDefault().post(event);
        }
    }
}
