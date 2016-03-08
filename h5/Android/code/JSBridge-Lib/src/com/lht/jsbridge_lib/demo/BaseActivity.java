package com.lht.jsbridge_lib.demo;

import android.app.Activity;
import android.os.Bundle;

import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.sso.SinaSsoHandler;

/** 
 * @ClassName: BaseActivity 
 * @Description: TODO
 * @date 2016年3月3日 上午9:39:18
 * @author zhangbin
 * @version 1.0
 */
public class BaseActivity extends Activity{
	
	protected static UMSocialService mController;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		if (mController == null) {
			mController = UMServiceFactory.getUMSocialService("com.umeng.login");
		}
		
		mController.getConfig().setSsoHandler(new SinaSsoHandler());
	}

}
