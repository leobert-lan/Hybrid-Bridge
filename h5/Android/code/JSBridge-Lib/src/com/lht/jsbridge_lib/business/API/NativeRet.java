package com.lht.jsbridge_lib.business.API;

/**
 * @ClassName: NativeRet
 * @Description: TODO
 * @date 2016年2月23日 上午10:17:01
 * 
 * @author leobert.lan
 * @version 1.0
 */
public interface NativeRet {

	/**
	 * RET_SUCCESS:调用成功
	 */
	int RET_SUCCESS = 10000;
	
	/**
	 * RET_ERROR_FUNCTION_NOTFOUND:未注册的方法
	 */
	int RET_ERROR_FUNCTION_NOTFOUND = 11001;
	
	/**
	 * RET_ERROR_ESSENTIALARGUEMENT_MISS:必须参数缺失
	 */
	int RET_ERROR_ESSENTIALARGUEMENT_MISS = 12001;
	
	/**
	 * RET_ERROR_JSONSTRUCTURE:json结构错误
	 */
	int RET_ERROR_JSONSTRUCTURE = 12002;

	// ...

	interface NativeGpsRet extends NativeRet {

		public int RET_FAILURE = 21000;
		// ...
	}

	interface NativeCallTelRet extends NativeRet {
		public int RET_FAILURE_PERMISSION = 26001;
	}

	interface NativeCopyToClipBorad extends NativeRet {
		public int RET_FAILURE = 21000;
	}

	interface NativeGetClipBoard extends NativeRet {
		public int RET_FAILURE = 21000;
	}

	interface NativeSendMessage extends NativeRet {
		public int RET_FAILURE = 21000;
	}

	interface NativeSendEmail extends NativeRet {
		public int RET_FAILURE = 21000;
	}

	interface NativeScanCodeRet extends NativeRet {

		/**
		 * RET_UNSUPPORT:不支持的码型
		 */
		public int RET_UNSUPPORT = 50001;

		/**
		 * ret_timeout:扫描超时
		 */
		public int RET_TIMEOUT = 50002;

	}
}
