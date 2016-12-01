package com.lht.cloudjob.test;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.lht.cloudjob.R;
import com.lht.cloudjob.activity.BaseActivity;
import com.lht.cloudjob.activity.UMengActivity;
import com.lht.cloudjob.adapter.ExampleListAdapter;
import com.lht.cloudjob.adapter.viewprovider.ExampleViewProviderImpl;
import com.lht.cloudjob.interfaces.adapter.ICustomizeListItem;

import java.util.ArrayList;

public class TestExampleListActivity extends BaseActivity implements ICustomizeListItem<ExampleViewProviderImpl.ViewHolder> {

    private static final String PageName = "ExampleListActivity";

    private ListView mListView;

    private LayoutInflater layoutInflater;

    private ExampleListAdapter mAdapter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test_example_list);

         initView();
         initVariable();
         initEvent();
    }

    @Override
    protected String getPageName() {
        return PageName;
    }

    @Override
    public UMengActivity getActivity() {
        return TestExampleListActivity.this;
    }

    @Override
    protected void initView() {
        mListView = (ListView) findViewById(R.id.ela_lv);
    }

    @Override
    protected void initVariable() {
        ArrayList<String> data = new ArrayList<>();
        for (int i=0;i<5;i++) {
            data.add("test:"+i);
        }
        layoutInflater = LayoutInflater.from(TestExampleListActivity.this);
        mAdapter = new ExampleListAdapter(data,new ExampleViewProviderImpl(layoutInflater,this) );
    }

    @Override
    protected void initEvent() {
        mListView.setAdapter(mAdapter);
    }

    @Override
    public void customize(int position, View convertView, ExampleViewProviderImpl.ViewHolder viewHolder) {
        viewHolder.tv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getActivity(),((TextView)v).getText().toString(),Toast.LENGTH_SHORT).show();
            }
        });
    }
}
