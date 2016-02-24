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
	
	int RET_SUCCESS = 10000;
	
	//...
	
	interface NativeGpsRet extends NativeRet{
		public int RET_FAILURE = 21000;
		
		//...
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
}
