package com.lht.jsbridge_lib.business.impl;

import android.annotation.SuppressLint;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;

/** 
 * @ClassName: OpneGPSImpl 
 * @Description: TODO
 * @date 2016年2月19日 上午9:22:49
 *  
 * @author leobert.lan
 * @version 1.0
 */
public class OpenGPSImpl implements API.GPSHandler{

	@SuppressLint("DefaultLocale")
	@Override
	public void handler(String data, CallBackFunction function) {
		// TODO Auto-generated method stub
		function.onCallBack(data.toUpperCase());
	}

}
