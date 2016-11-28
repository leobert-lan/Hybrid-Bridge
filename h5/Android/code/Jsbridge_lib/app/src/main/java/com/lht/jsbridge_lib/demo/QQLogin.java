//package com.lht.jsbridge_lib.demo;
//
//import java.util.Map;
//import java.util.Set;
//
//import android.app.Activity;
//import android.content.Context;
//import android.os.Bundle;
//import android.util.Log;
//import android.widget.Toast;
//
//import com.alibaba.fastjson.JSON;
//import com.umeng.socialize.bean.SHARE_MEDIA;
//import com.umeng.socialize.controller.UMServiceFactory;
//import com.umeng.socialize.controller.UMSocialService;
//import com.umeng.socialize.controller.listener.SocializeListeners.UMAuthListener;
//import com.umeng.socialize.controller.listener.SocializeListeners.UMDataListener;
//import com.umeng.socialize.exception.SocializeException;
//import com.umeng.socialize.sso.SinaSsoHandler;
//import com.umeng.socialize.sso.UMQQSsoHandler;
//
///**
// * @ClassName: QQLogin
// * @Description: TODO
// * @date 2016年2月29日 下午3:45:17
// *
// * @author zhangbin
// * @version 1.0
// */
//public class QQLogin {
//
//	UMSocialService mController;
//	private Context mContext;
//
//	public QQLogin(Context mContext) {
//		super();
//		this.mContext = mContext;
//		mController = UMServiceFactory
//				.getUMSocialService("com.umeng.login");
//		configPlatforms();
////		setQQLogin();
//	}
//
//	public void configPlatforms() {
//		// 设置qq Hanlder
//		UMQQSsoHandler qqSsoHandler = new UMQQSsoHandler((Activity) mContext,
//				"1105206364", "TpTmgufFXV82D7QE");
//		qqSsoHandler.addToSocialSDK();
//
//		// 设置新浪SSO handler
//		mController.getConfig().setSsoHandler(new SinaSsoHandler());
//
//	}
//
//	public void setQQLogin() {
//		mController.doOauthVerify(mContext, SHARE_MEDIA.QQ,
//				new UMAuthListener() {
//					@Override
//					public void onStart(SHARE_MEDIA platform) {
//						Toast.makeText(mContext, "授权开始", Toast.LENGTH_SHORT)
//								.show();
//					}
//
//					@Override
//					public void onError(SocializeException e,
//							SHARE_MEDIA platform) {
//						Toast.makeText(mContext, "授权错误", Toast.LENGTH_SHORT)
//								.show();
//					}
//
//					@Override
//					public void onComplete(Bundle value, SHARE_MEDIA platform) {
//						Toast.makeText(mContext, "授权完成", Toast.LENGTH_SHORT)
//								.show();
//						// 获取相关授权信息
//						mController.getPlatformInfo(mContext, SHARE_MEDIA.QQ,
//								new UMDataListener() {
//
//									@Override
//									public void onStart() {
//										Toast.makeText(mContext, "获取平台数据开始...",
//												Toast.LENGTH_SHORT).show();
//									}
//
//									@Override
//									public void onComplete(int status,
//											Map<String, Object> info) {
//										if (status == 200 && info != null) {
//											Toast.makeText(mContext,
//													info.toString(),
//													Toast.LENGTH_SHORT).show();
//											StringBuilder sb = new StringBuilder();
//											Set<String> keys = info.keySet();
//											for (String key : keys) {
//												sb.append(key
//														+ "="
//														+ info.get(key)
//																.toString()
//														+ "\r\n");
//											}
//											qqUserInfo.onSuccess(sb.toString());
//											Log.i("zhang", JSON.toJSONString(info));
//										} else {
//											Log.d("TestData", "发生错误：" + status);
//										}
//									}
//								});
//					}
//
//					@Override
//					public void onCancel(SHARE_MEDIA platform) {
//						Toast.makeText(mContext, "授权取消", Toast.LENGTH_SHORT)
//								.show();
//					}
//				});
//
//	}
//
//	private QQUserInfoCallBack qqUserInfo = null;
//
//	public void setCallback(QQUserInfoCallBack qqUserInfo) {
//		this.qqUserInfo = qqUserInfo;
//	}
//
//	public interface QQUserInfoCallBack{
//		void onSuccess(String info);
//	}
//}
