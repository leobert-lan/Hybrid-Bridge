package com.lht.cloudjob.util.phonebasic;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.provider.Settings;

import com.litesuits.orm.db.annotation.NotNull;

/**
 * <p><b>Package</b> com.lht.cloudjob.util.phonebasic
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> SettingUtil
 * <p><b>Description</b>: TODO
 * <p>Created by leobert on 2016/11/22.
 */

public class SettingUtil {
    /**
     * 启动应用的设置页
     *
     * @param context not null
     */
    public static void startAppSettings(Context context) {
        final String PACKAGE_URL_SCHEME = "package:"; // 方案
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.parse(PACKAGE_URL_SCHEME + context.getPackageName()));
        context.startActivity(intent);
    }
}
