package com.lht.cloudjob.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.Event.AppEvent;
import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.mvp.model.DownloadModel;
import com.lht.cloudjob.mvp.model.interfaces.IFileDownloadCallbacks;
import com.lht.cloudjob.mvp.model.pojo.DownloadEntity;
import com.lht.cloudjob.native4js.expandresbean.DownloadBean;

import org.greenrobot.eventbus.EventBus;

import java.io.File;

public class DownloadFileService extends Service {

    public static String DOWNLOAD_INFO = "download_info";

    @Override
    public void onCreate() {
        super.onCreate();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }

    @Override
    public IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String downloadInfo = intent.getStringExtra(DOWNLOAD_INFO);
        DownloadBean bean = (DownloadBean) JSON.parse(downloadInfo);
        DownloadEntity entity = DownloadEntity.copyFromDownloadBean(bean);
        DownloadModel model = new DownloadModel(entity, BaseActivity.getPublicDownloadDir(), new DownloadFileCallback());
        return super.onStartCommand(intent, flags, startId);
    }

    class DownloadFileCallback implements IFileDownloadCallbacks {
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

        }

        @Override
        public void onDownloadCancel() {

        }

        @Override
        public void onDownloadSuccess(DownloadEntity entity, File file) {
            EventBus.getDefault().post(file);
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
    }
}
