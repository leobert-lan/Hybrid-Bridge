package com.lht.jsbridge_lib.ApiUtil.Scan;

import java.io.IOException;
import java.util.Vector;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.Result;
import com.lht.jsbridge_lib.R;
import com.mining.app.zxing.camera.CameraManager;
import com.mining.app.zxing.decoding.CaptureActivityHandler;
import com.mining.app.zxing.decoding.InactivityTimer;
import com.mining.app.zxing.view.ViewfinderView;

/**
 * Initial the camera
 */
public class MipcaActivityCapture extends Activity implements Callback {
	
	public static final String BROADCAST_ACTION = "com.lht.jsbridge.native.scan_result";
	
	public static final String RESULT = "scan_result";
	
	public static final String RESULT_CODE = "scan.resultcode";
	
	public static final int SCAN_OK = 1;
	
	public static final int SCAN_FAILURE = 2;
	
	public static final int SCAN_TIMEOUT = 3;

	private CaptureActivityHandler handler;
	private ViewfinderView viewfinderView;
	private boolean hasSurface;
	private Vector<BarcodeFormat> decodeFormats;
	private String characterSet;
	private InactivityTimer inactivityTimer;

	private ImageView mBack;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_capture);
		CameraManager.init(getApplication());
		viewfinderView = (ViewfinderView) findViewById(R.id.viewfinder_view);
		hasSurface = false;
		inactivityTimer = new InactivityTimer(this);

		mBack = (ImageView) findViewById(R.id.scansearch_back);
		mBack.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				//TODO 
				MipcaActivityCapture.this.finish();
			}
		});
	}

	@Override
	protected void onResume() {
		super.onResume();
		SurfaceView surfaceView = (SurfaceView) findViewById(R.id.preview_view);
		SurfaceHolder surfaceHolder = surfaceView.getHolder();
		if (hasSurface) {
			initCamera(surfaceHolder);
		} else {
			surfaceHolder.addCallback(this);
			surfaceHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
		}
		decodeFormats = null;
		characterSet = null;

	}

	@Override
	protected void onPause() {
		super.onPause();
		if (handler != null) {
			handler.quitSynchronously();
			handler = null;
		}
		CameraManager.get().closeDriver();
	}

	@Override
	protected void onDestroy() {
		inactivityTimer.shutdown();
		super.onDestroy();
	}

	/**
	 * 
	 * @param result
	 * @param barcode
	 */
	public void handleDecode(Result result, Bitmap barcode) {
		inactivityTimer.onActivity();
		String resultString = result.getText();
		if (resultString.equals("")) {
//			Toast.makeText(MipcaActivityCapture.this, "Scan failed!",
//					Toast.LENGTH_SHORT).show();
			Intent intent = new Intent();  
			intent.setAction(BROADCAST_ACTION); 
			intent.putExtra(RESULT_CODE, SCAN_FAILURE);
			intent.putExtra(RESULT, resultString);  
			sendBroadcast(intent); 
		} else {
			//TODO 
			Intent intent = new Intent();  
			intent.setAction(BROADCAST_ACTION); 
			intent.putExtra(RESULT_CODE, SCAN_OK);
			intent.putExtra(RESULT, resultString);  
			sendBroadcast(intent); 
		}
		MipcaActivityCapture.this.finish();
	}

	private void initCamera(SurfaceHolder surfaceHolder) {
		try {
			CameraManager.get().openDriver(surfaceHolder);
		} catch (IOException ioe) {
			return;
		} catch (RuntimeException e) {
			return;
		}
		if (handler == null) {
			handler = new CaptureActivityHandler(this, decodeFormats,
					characterSet);
		}
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width,
			int height) {

	}

	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		if (!hasSurface) {
			hasSurface = true;
			initCamera(holder);
		}

	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		hasSurface = false;

	}

	public ViewfinderView getViewfinderView() {
		return viewfinderView;
	}

	public Handler getHandler() {
		return handler;
	}

	public void drawViewfinder() {
		viewfinderView.drawViewfinder();

	}

}