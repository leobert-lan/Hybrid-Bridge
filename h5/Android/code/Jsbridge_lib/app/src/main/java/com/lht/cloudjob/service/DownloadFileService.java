package com.lht.cloudjob.service;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
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
        NF_DownloadReqBean bean = JSON.parseObject(downloadInfo, NF_DownloadReqBean.class);
        DownloadEntity entity = DownloadEntity.copyFromDownloadBean(bean);
        DownloadModel model = new DownloadModel(entity, BaseActivity.getPublicDownloadDir(),
                new DownloadFileCallback(bean, entity));
        model.doRequest(this);
    }

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
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_ERROR,
                    0, getApplicationContext().getString(R.string.v1010_toast_net_exception));
            postEvent(event);
        }

        @Override
        public void onMobileNet() {
            Log.e("lmsg", "移动网络状态");
            Toast.makeText(getApplicationContext(), R.string.v1020_dialog_preview_onmobile_toolarge, Toast.LENGTH_SHORT).show();
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_DEFAULT,
                    0, getApplicationContext().getString(R.string.v1020_versionupdate_dialog_onmobile_remind));
            postEvent(event);
        }

        @Override
        public void onFileNotFoundOnServer() {
            Log.e("lmsg", "文件不存在");
            Toast.makeText(getApplicationContext(), R.string.v1020_toast_download_onnotfound, Toast.LENGTH_SHORT).show();
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_ERROR,
                    0, getApplicationContext().getString(R.string.v1020_toast_download_onnotfound));
            postEvent(event);
        }

        @Override
        public void onDownloadStart(DownloadEntity entity) {
            Log.e("lmsg", "开始下载");
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_ONSTART, 0, "开始下载");
            postEvent(event);
        }

        @Override
        public void onDownloadCancel() {
            Log.e("lmsg", "取消下载");
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_CANCEL, 0, "取消下载");
            postEvent(event);
        }

        @Override
        public void onDownloadSuccess(DownloadEntity entity, File file) {
            Log.e("lmsg", "下载成功");
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_SUCCESS,
                    entity.getFileSize(), "下载成功");
            event.setFile(file);
            postEvent(event);
        }

        @Override
        public void onDownloading(DownloadEntity entity, long current, long total) {
            Log.e("lmsg", "正在下载");
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_DOWNLOADING,
                    current, "正在下载");

            postEvent(event);
        }

        @Override
        public void onNoEnoughSpace() {
            Log.e("lmsg", "下载失败");
            Toast.makeText(getApplicationContext(), R.string.v1020_toast_download_onnoenoughspace, Toast.LENGTH_SHORT).show();
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_ERROR,
                    0, getApplicationContext().getString(R.string.v1020_toast_download_onnoenoughspace));
            postEvent(event);
        }

        @Override
        public void downloadFailure() {
            Log.e("lmsg", "下载失败");
            Toast.makeText(getApplicationContext(), R.string.v1020_versionupdate_text_download_fuilure, Toast.LENGTH_SHORT).show();
            DownloadImpl.VsoBridgeDownloadEvent event = setDownloadInfo(DownloadImpl.VsoBridgeDownloadEvent.STATUS_ERROR,
                    0, getApplicationContext().getString(R.string.v1020_versionupdate_text_download_fuilure));
            postEvent(event);
        }

        private void postEvent(DownloadImpl.VsoBridgeDownloadEvent event) {
            EventBus.getDefault().post(event);
        }

        private DownloadImpl.VsoBridgeDownloadEvent setDownloadInfo(int status, long currentSize, String msg) {
            DownloadImpl.VsoBridgeDownloadEvent event = new DownloadImpl.VsoBridgeDownloadEvent();
            event.setStatus(status);
            event.setDownloadEntity(downloadEntity);
            event.setCurrentSize(currentSize);
            event.setTotalSize(downloadEntity.getFileSize());
            event.setUniqueTag(nfDownloadReqBean.getUrl_download());
            return event;
        }
    }
}
