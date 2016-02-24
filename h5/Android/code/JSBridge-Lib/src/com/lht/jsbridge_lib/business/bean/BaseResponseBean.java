package com.lht.jsbridge_lib.business.bean;

/**
 * @ClassName: BaseResponseBean
 * @Description: Native返回JS的基本数据结构
 * @date 2016年2月23日 上午9:16:47
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class BaseResponseBean {

	/**
	 * ret:返回码
	 */
	private int ret;

	/**
	 * msg:扩展消息
	 */
	private String msg;

	/**
	 * data:业务处理结果
	 */
	private String data;

	public int getRet() {
		return ret;
	}

	public void setRet(int ret) {
		this.ret = ret;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

}
