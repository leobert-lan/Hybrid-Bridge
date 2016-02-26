package com.lht.jsbridge_lib.business.impl;

import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;

/**
 * @ClassName: ThirdPartyLoginImpl
 * @Description: TODO
 * @date 2016年2月26日 下午5:10:41
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class ThirdPartyLoginImpl extends ABSLTRApiImpl implements
		API.ThirdPartyLoginHandler {
	
	//Attention activity向此处通信使用广播，

	@Override
	public void handler(String data, CallBackFunction function) {
		// TODO Auto-generated method stub
		// ThirdPartyLoginBean
	}

	@Override
	protected LTRHandler getLTRHandler() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected LTRExecutor getLTRExecutor() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected boolean isBeanError(Object o) {
		// TODO Auto-generated method stub
		// ThirdPartyLoginBean
		return false;
	}

}
