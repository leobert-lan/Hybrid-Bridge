package com.lht.jsbridge_lib.ApiUtil.Scan;

import android.content.Intent;
import android.view.SurfaceHolder.Callback;

import com.zbar.lib.CaptureActivity;

/**
 * Initial the camera
 */
public class MipcaActivityCapture extends CaptureActivity implements Callback {

	@Override
	public void handleDecode(String resultString) {
		super.handleDecode(resultString);
		if (resultString.equals("")) {
			// Toast.makeText(MipcaActivityCapture.this, "Scan failed!",
			// Toast.LENGTH_SHORT).show();
			Intent intent = new Intent();
			intent.setAction(BROADCAST_ACTION);
			intent.putExtra(RESULT_CODE, SCAN_FAILURE);
			intent.putExtra(RESULT, resultString);
			sendBroadcast(intent);
		} else {
			// TODO
			Intent intent = new Intent();
			intent.setAction(BROADCAST_ACTION);
			intent.putExtra(RESULT_CODE, SCAN_OK);
			intent.putExtra(RESULT, resultString);
			sendBroadcast(intent);
		}
		MipcaActivityCapture.this.finish();
	}

	@Override
	public void onBackPressed() {
		Intent intent = new Intent();
		intent.setAction(BROADCAST_ACTION);
		intent.putExtra(RESULT_CODE, SCAN_CANCEL);
		intent.putExtra(RESULT, "");
		sendBroadcast(intent);
		super.onBackPressed();

	}

	public static final String BROADCAST_ACTION = "com.lht.jsbridge.native.scan_result";

	public static final String RESULT = "scan_result";

	public static final String RESULT_CODE = "scan.resultcode";

	public static final int SCAN_OK = 1;

	public static final int SCAN_FAILURE = 2;

	public static final int SCAN_TIMEOUT = 3;

	public static final int SCAN_CANCEL = 4;

}