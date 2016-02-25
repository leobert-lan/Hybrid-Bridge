package com.lht.jsbridge_lib.business.bean;
/** 
 * @ClassName: DemoBean 
 * @Description: API:Demo 业务起始参数
 * @date 2016年2月19日 下午4:27:31
 *  
 * @author leobert.lan
 * @version 1.0
 */
public class SendEmailBean {
	
	private String address;
	
	private String message;
	
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
