package com.lht.jsbridge_lib.base.model;

import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.lht.jsbridge_lib.base.Interface.CallBackFunction;
import com.lht.jsbridge_lib.business.API.API;
import com.lht.jsbridge_lib.business.bean.DemoBean;
import com.lht.jsbridge_lib.business.bean.DemoResponseBean;
import com.lht.jsbridge_lib.business.impl.ABSApiImpl;

/**
 * @ClassName: DemoImpl
 * @Description: TODO
 * @date 2016年2月19日 下午4:11:26
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class DemoImpl extends ABSApiImpl implements API.Demo {

	@Override
	public void handler(String data, CallBackFunction function) {
		// TODO Auto-generated method stub
		DemoBean demoBean = JSON.parseObject(data, DemoBean.class);
		boolean b = isBeanError(demoBean);
		if (b)
			return;
		// 业务逻辑
		// ....

		// 模拟一个返回数据
		DemoResponseBean responseBean = new DemoResponseBean();
		responseBean.setDemoKeyOne("value for key1");
		responseBean.setDemoKeyTwo("value for key2");
		responseBean.setDemoKeyThree("value for key3");

		// 返回序列化的数据
		function.onCallBack(JSON.toJSONString(responseBean));

	}

	@Override
	protected boolean isBeanError(Object o) {
		if (o instanceof DemoBean) {
			DemoBean bean = (DemoBean) o;
			// 数据完整性、合法性 校验 example：
			if (TextUtils.isEmpty(bean.getJsKeyOne())) {
				Log.wtf(API_NAME,
						"501,data error,check bean:" + JSON.toJSONString(bean));
				// I am so merciful,never crash it
				// throw new IllegalArgumentException(
				// "501,data error,check bean:"+JSON.toJSONString(bean));
				return BEAN_IS_ERROR;
			}
			return BEAN_IS_CORRECT;

		} else {
			Log.wtf(API_NAME,
					"check you code,bean not match because your error");
			// I am so merciful,never crash it
			// throw new IllegalArgumentException(
			// "check you code,bean not match because your error");
			return BEAN_IS_ERROR;
		}
	}

}
