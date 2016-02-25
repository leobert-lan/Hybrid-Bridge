package com.lht.jsbridge_lib.ApiUtil.Scan;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.SurfaceHolder.Callback;
import cn.itguy.zxingportrait.CaptureActivity;
import cn.itguy.zxingportrait.decode.OnShutDownListener;

import com.google.zxing.Result;

/**
 * Initial the camera
 */
public class MipcaActivityCapture extends CaptureActivity implements Callback {

	public static final String BROADCAST_ACTION = "com.lht.jsbridge.native.scan_result";

	public static final String RESULT = "scan_result";

	public static final String RESULT_CODE = "scan.resultcode";

	public static final int SCAN_OK = 1;

	public static final int SCAN_FAILURE = 2;

	public static final int SCAN_TIMEOUT = 3;
	
	public static final int SCAN_CANCEL = 4;

	@Override
	public void onCreate(Bundle icicle) {
		// TODO Auto-generated method stub
		super.onCreate(icicle);
		provideOnShutDownListener(new OnShutDownListener() {
			
			@Override
			public void onShutDown() {
				Intent intent = new Intent();
				intent.setAction(BROADCAST_ACTION);
				intent.putExtra(RESULT_CODE, SCAN_TIMEOUT);
				intent.putExtra(RESULT, "");
				sendBroadcast(intent);
			}
		});
	}

	@Override
	public void handleDecode(Result rawResult, Bitmap barcode, float scaleFactor) {
		// TODO Auto-generated method stub
		super.handleDecode(rawResult, barcode, scaleFactor);
		String resultString = rawResult.getText();
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

}