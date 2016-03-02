package com.lht.jsbridge_lib.demo;

import java.util.Map;
import java.util.Set;

import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.UMAuthListener;
import com.umeng.socialize.controller.listener.SocializeListeners.UMDataListener;
import com.umeng.socialize.exception.SocializeException;
import com.umeng.socialize.sso.SinaSsoHandler;

/**
 * @ClassName: QQLogin
 * @Description: TODO
 * @date 2016年2月29日 下午3:45:17
 * 
 * @author zhangbin
 * @version 1.0
 */
public class SinaLogin {
	
	UMSocialService mController;
	private Context mContext;

	public SinaLogin(Context mContext) {
		super();
		this.mContext = mContext;
		mController = UMServiceFactory
				.getUMSocialService("com.umeng.login");
		configPlatforms();
	}
	public void configPlatforms() {
		// 设置新浪SSO handler
		mController.getConfig().setSsoHandler(new SinaSsoHandler());
	}

	public void startSinaLogin() {
		mController.doOauthVerify(mContext, SHARE_MEDIA.SINA,
				new UMAuthListener() {
					@Override
					public void onError(SocializeException e,
							SHARE_MEDIA platform) {
						Toast.makeText(mContext, "授权失败.",
								Toast.LENGTH_SHORT).show();
					}

					@Override
					public void onComplete(Bundle value, SHARE_MEDIA platform) {
						mController.getPlatformInfo(mContext,
								SHARE_MEDIA.SINA, new UMDataListener() {
									@Override
									public void onStart() {
										Toast.makeText(mContext,
												"获取平台数据开始...",
												Toast.LENGTH_SHORT).show();
									}

									@Override
									public void onComplete(int status,
											Map<String, Object> info) {
										if (status == 200 && info != null) {
											Toast.makeText(mContext,
													info.toString(),
													Toast.LENGTH_SHORT).show();
											StringBuilder sb = new StringBuilder();
											Set<String> keys = info.keySet();
											for (String key : keys) {
												sb.append(key
														+ "="
														+ info.get(key)
																.toString()
														+ "\r\n");
											}
											Log.d("TestData", sb.toString());
										} else {
											Log.d("TestData", "发生错误：" + status);
										}
									}
								});
						if (value != null
								&& !TextUtils.isEmpty(value.getString("uid"))) {
							Toast.makeText(mContext, "授权成功.",
									Toast.LENGTH_SHORT).show();
						} else {
							Toast.makeText(mContext, "授权失败",
									Toast.LENGTH_SHORT).show();
						}
					}
					@Override
					public void onCancel(SHARE_MEDIA platform) {
						Toast.makeText(mContext, "授权取消.",
								Toast.LENGTH_SHORT).show();
					}
					@Override
					public void onStart(SHARE_MEDIA platform) {
						Toast.makeText(mContext, "授权开始.",
								Toast.LENGTH_SHORT).show();
					}
				});

	}
	
	private SinaUserInfoCallBack sinaUserInfoCallBack = null;
	
	public void setCallback(SinaUserInfoCallBack sinaUserInfoCallBack) {
		this.sinaUserInfoCallBack = sinaUserInfoCallBack;
	}
	
	public interface SinaUserInfoCallBack{
		void onSuccess(String info);
	}
}
