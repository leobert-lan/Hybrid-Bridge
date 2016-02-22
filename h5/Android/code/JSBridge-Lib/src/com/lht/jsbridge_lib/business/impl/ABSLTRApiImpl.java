package com.lht.jsbridge_lib.business.impl;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

/**
 * @ClassName: ABSLTRApiImpl
 * @Description: 耗时任务需要开辟子线程执行逻辑，否则界面无响应，该类为耗时API的实现基类
 * @date 2016年2月22日 上午10:12:07
 * 
 * @author leobert.lan
 * @version 1.0
 */
@SuppressLint("HandlerLeak")
public abstract class ABSLTRApiImpl extends ABSApiImpl {
	
	protected final String TAG = "ABSLTRApiImpl";

	protected void execute(LTRExecutor executor) {
		new Thread(executor).start();
	}

	protected abstract LTRHandler getLTRHandler();
	
	protected abstract LTRExecutor getLTRExecutor();

	public abstract class LTRExecutor implements Runnable ,OnLTRJobExecuted{
		
		protected final LTRHandler mhHandler;

		public LTRExecutor(LTRHandler h) {
			this.mhHandler = h;
		}
		
		public void onJobExecuted(String data) {
			
			Log.d(TAG, "thread job over,send message");
			
			Bundle b = new Bundle();
			b.putString(LTRHandler.KEY_DATA, data);
			Message message = new Message();
			message.what = LTRHandler.MSG_JOBEXECUTED;
			message.setData(b);
			mhHandler.sendMessage(message);
		}

	}

	public abstract class LTRHandler extends Handler implements OnLTRJobExecuted{
		// public LTRHandler()
		public final static int MSG_JOBEXECUTED = 1;
		
		public final static String KEY_DATA = "DATA";

		@Override
		public void handleMessage(Message msg) {
			// TODO Auto-generated method stub
			super.handleMessage(msg);
			if (msg.what == MSG_JOBEXECUTED) {
				Log.d(TAG, "main get message,execute and do callback");
				onJobExecuted(msg.getData().getString(KEY_DATA));
			}
		}

	}
	
	interface OnLTRJobExecuted {
		void onJobExecuted(String data);
	}

}
