/*
 * Copyright (C) 2010 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package cn.itguy.zxingportrait.decode;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;

import android.app.Activity;

/**
 * Finishes an activity after a period of inactivity if the device is on battery
 * power.
 */
public final class InactivityTimer {

	private static final int INACTIVITY_DELAY_SECONDS = 30;

	private final ScheduledExecutorService inactivityTimer = Executors
			.newSingleThreadScheduledExecutor(new DaemonThreadFactory());
	private final Activity activity;
	private ScheduledFuture<?> inactivityFuture = null;

	public InactivityTimer(Activity activity) {
		this.activity = activity;
		finishListener = new FinishListener(activity);
		onActivity();
	}
	
	FinishListener finishListener;

	public void onActivity() {
		cancel();
//		finishListener = new FinishListener(activity);
		inactivityFuture = inactivityTimer.schedule(finishListener, INACTIVITY_DELAY_SECONDS,
				TimeUnit.SECONDS);
	}

	private void cancel() {
		if (inactivityFuture != null) {
			inactivityFuture.cancel(true);
			inactivityFuture = null;
		}
	}

	public void shutdown() {
		cancel();
		inactivityTimer.shutdown();
	}

	private static final class DaemonThreadFactory implements ThreadFactory {
		@Override
		public Thread newThread(Runnable runnable) {
			Thread thread = new Thread(runnable);
			thread.setDaemon(true);
			return thread;
		}
	}
	
	public void setOnShutDownListner(OnShutDownListener l) {
		finishListener.setOnShutDownListener(l);
	}


}
