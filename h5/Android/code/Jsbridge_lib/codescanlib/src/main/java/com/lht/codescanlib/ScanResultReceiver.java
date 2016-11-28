package com.lht.codescanlib;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/**
 * @ClassName: ScanResultReceiver
 * @Description: 接收扫描结果
 * @date 2016年3月15日 下午1:47:39
 * 
 * @author leobert.lan
 * @version 1.0
 */
public class ScanResultReceiver extends BroadcastReceiver {

	@Override
	public void onReceive(Context context, Intent intent) {
		if (intent.getAction().equals(ScanActivity.BROADCAST_ACTION)) {
			// 处理情况
			int scanResultCode = intent.getIntExtra(ScanActivity.RESULT_CODE,
					ScanActivity.SCAN_FAILURE);
			String data = intent.getStringExtra(ScanActivity.RESULT);
			switch (scanResultCode) {
			case ScanActivity.SCAN_OK:
				getHandler().onSuccess(data);
				break;
			case ScanActivity.SCAN_FAILURE:
				getHandler().onFailure();
				break;
			case ScanActivity.SCAN_TIMEOUT:
				getHandler().onTimeout();
				break;
			case ScanActivity.SCAN_CANCEL:
				getHandler().onCancel();
			default:
				break;
			}
		}
	}

	private IScanResultHandler getHandler() {
		IScanResultHandler handler = ScanProps.getScanResultHandler();

		return handler == null ? new DefaultScanResultHandlerImpl() : handler;
	}

}
