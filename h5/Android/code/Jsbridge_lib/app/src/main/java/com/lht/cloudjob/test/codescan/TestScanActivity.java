package com.lht.cloudjob.test.codescan;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;

import com.lht.cloudjob.R;
import com.lht.qrcode.scan.IScanResultHandler;
import com.lht.qrcode.scan.ScanActivity;
import com.lht.qrcode.scan.ScanProps;

public class TestScanActivity extends AppCompatActivity {

    private TextView txtResult;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test_scan);
        txtResult = (TextView) findViewById(R.id.test_result);

        findViewById(R.id.test_open).setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                Intent i = new Intent(TestScanActivity.this, ScanActivity.class);
                startActivity(i);
            }
        });

        ScanProps.addScanResultHandler(getClass().getName(),new IScanResultHandler() {

            @Override
            public void onTimeout() {
                txtResult.setText("扫描超时");
            }

            @Override
            public void onSuccess(String result) {
                txtResult.setText("扫描结果：" + result);
            }

            @Override
            public void onFailure() {
                txtResult.setText("扫描失败");
            }

            @Override
            public void onCancel() {
                txtResult.setText("扫描取消");
            }
        });

    }
}
