package com.lht.jsbridge_lib.business.API;

import com.lht.jsbridge_lib.base.Interface.BridgeHandler;

/**
 * @ClassName: API
 * @Description: TODO
 * @date 2016年2月17日 下午3:40:49
 * 
 * @author leobert.lan
 * @version 1.0
 */
public interface API {

	interface Demo extends BridgeHandler {
		/**
		 * API_NAME:测试
		 */
		public static String API_NAME = "NATIVE_FUNCTION_DEMO";
	}

	@Deprecated
	interface openFile extends BridgeHandler {
		/**
		 * API_NAME:TODO 测试打开文件 
		 */
		public static String API_NAME = "openFile";
	}

	interface GPSHandler extends BridgeHandler {
		/**
		 * API_NAME:定位，优先GPS 
		 */
		public static String API_NAME = "NATIVE_FUNCTION_OPENGPS";
	}

	interface TestLTRHandler extends BridgeHandler {
		/**
		 * API_NAME:TODO 耗时任务测试接口
		 */
		public static String API_NAME = "NATIVE_FUNCTION_LTDEMO";
	}

	interface CallTelHandler extends BridgeHandler {

		/**
		 * API_NAME:拨号
		 */
		public static String API_NAME = "NATIVE_FUNCTION_CALLTEL";
	}

	interface SendToClipBoardHandler extends BridgeHandler {
		/**
		 * API_NAME:发送内容到剪切板
		 */
		public static String API_NAME = "NATIVE_FUNCTION_SENDTOCLIPBOARD";
	}

	interface GetClipBoardContentHandler extends BridgeHandler {
		/**
		 * API_NAME:获取剪切板内容
		 */
		public static String API_NAME = "NATIVE_FUNCTION_GETFROMCLIPBOARD";
	}
	
	interface SendMessageHandler extends BridgeHandler {
		/**
		 * API_NAME:发送短息
		 */
		public static String API_NAME = "NATIVE_FUNCTION_SENDMESSAGE";
	}
	
	interface SendEmailHandler extends BridgeHandler {
		/**
		 * API_NAME:发送邮件
		 */
		public static String API_NAME = "NATIVE_FUNCTION_SENDEMAIL";
	}

	interface ScanCodeHandler extends BridgeHandler {
		/**
		 * API_NAME:扫码
		 */
		public static String API_NAME = "NATIVE_FUNCTION_OPENCAMERA_SCAN";
	}
	
	interface ThirdPartyLoginHandler extends BridgeHandler {
		/**
		 * API_Name:调用第三方登录
		 */
		public static String API_Name = "NATIVE_FUNCTION_THIRDPARTYLOGIN";
	}
}
