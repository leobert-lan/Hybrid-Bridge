package com.lht.cloudjob.test;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.lht.cloudjob.R;
import com.lht.cloudjob.adapter.ExampleListAdapter;
import com.lht.cloudjob.adapter.viewprovider.ExampleViewProviderImpl;
import com.lht.cloudjob.interfaces.adapter.ICustomizeListItem;
import com.lht.ptrlib.library.PullToRefreshBase;
import com.lht.ptrlib.library.PullToRefreshListView;

import java.util.ArrayList;

public class TestPtrListActivity extends AppCompatActivity implements ICustomizeListItem<ExampleViewProviderImpl.ViewHolder> {
    
    private PullToRefreshListView mPullToRefreshListView;

    private LayoutInflater layoutInflater;

    private ExampleListAdapter mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test_ptr_list);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG).setAction("Action", null).show();
            }
        });
   
        mPullToRefreshListView = (PullToRefreshListView) findViewById(R.id.test_ptr_list);
        
        mPullToRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        
        init();
    }

    private void init() {
        layoutInflater = LayoutInflater.from(TestPtrListActivity.this);
        mAdapter = new ExampleListAdapter(generateData(),new ExampleViewProviderImpl(layoutInflater,this) );
        
        mPullToRefreshListView.setOnRefreshListener(new PullToRefreshBase.OnRefreshListener2<ListView>() {
            @Override
            public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
//                refreshView.getOnRefreshListener2().
            }

            @Override
            public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {

            }
        });
        
        mPullToRefreshListView.setAdapter(mAdapter);
    }
    
    private ArrayList<String> generateData() {
        ArrayList<String> data = new ArrayList<>();
        for (int i=0;i<5;i++) {
            data.add("test:"+i);
        }
        return data;
    }

    @Override
    public void customize(int position, View convertView, ExampleViewProviderImpl.ViewHolder viewHolder) {
        viewHolder.tv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(TestPtrListActivity.this, ((TextView) v).getText().toString(), Toast.LENGTH_SHORT).show();
            }
        });
    }
}
