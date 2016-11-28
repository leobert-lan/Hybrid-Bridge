package com.zbar.lib.decode;

import com.lht.jsbridge_lib.ApiUtil.Scan.MipcaActivityCapture;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;

/** 
 * @ClassName: FinishListener 
 * @Description: TODO
 * @date 2016年3月11日 上午10:52:47
 *  
 * @author leobert.lan
 * @version 1.0 
 * @since JDK 1.6 
 */
public final class FinishListener implements DialogInterface.OnClickListener,
		DialogInterface.OnCancelListener, Runnable {

	private final Activity activityToFinish;

	public FinishListener(Activity activityToFinish) {
		this.activityToFinish = activityToFinish;
	}

	@Override
	public void onCancel(DialogInterface dialogInterface) {
		run();
	}

	@Override
	public void onClick(DialogInterface dialogInterface, int i) {
		run();
	}

	@Override
	public void run() {
		Intent intent = new Intent();
		intent.setAction(MipcaActivityCapture.BROADCAST_ACTION);
		intent.putExtra(MipcaActivityCapture.RESULT_CODE,
				MipcaActivityCapture.SCAN_TIMEOUT);
		intent.putExtra(MipcaActivityCapture.RESULT, "");
		activityToFinish.finish();
	}

}
