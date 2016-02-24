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
		public static String API_NAME = "NATIVE_FUNCTION_DEMO";
	}

	interface openFile extends BridgeHandler {
		public static String API_NAME = "openFile";
	}

	interface GPSHandler extends BridgeHandler {
		public static String API_NAME = "NATIVE_FUNCTION_OPENGPS";
	}

	interface TestLTRHandler extends BridgeHandler {
		/**
		 * API_NAME:耗时任务测试接口
		 */
		public static String API_NAME = "NATIVE_FUNCTION_LTDEMO";
	}

	interface CallTelHandler extends BridgeHandler {

		public static String API_NAME = "NATIVE_FUNCTION_CALLTEL";
	}

	interface CopyHandler extends BridgeHandler {
		public static String API_NAME = "NATIVE_FUNCTION_SENDTOCLIPBOARD";
	}

	interface GetClipBoardHandler extends BridgeHandler {
		public static String API_NAME = "NATIVE_FUNCTION_GETFROMCLIPBOARD";
	}
	
	interface SendMessageHandler extends BridgeHandler {
		public static String API_NAME = "NATIVE_FUNCTION_SENDMESSAGE";
	}
	
	interface SendEmailHandler extends BridgeHandler {
		public static String API_NAME = "NATIVE_FUNCTION_SENDEMAIL";
	}
	interface GetClipBoardContentHandler extends BridgeHandler {
		public static String API_NAME = "NATIVE_FUNCTION_GETFROMCLIPBOARD";
	}


	interface ScanCodeHandler extends BridgeHandler {
		/**
		 * API_NAME:扫码
		 */
		public static String API_NAME = "NATIVE_FUNCTION_OPENCAMERA_SCAN";
	}
}
