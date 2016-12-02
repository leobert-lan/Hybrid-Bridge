package com.lht.cloudjob.test.testbanner;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.ImageView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.lht.cloudjob.R;
import com.lht.customwidgetlib.banner.AutoLooperBanner;
import com.lht.customwidgetlib.banner.IBannerUpdate;
import com.lht.customwidgetlib.banner.ImgRes;

import java.util.ArrayList;
import java.util.List;

public class TestBannerActivity extends AppCompatActivity implements IBannerUpdate {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test_banner);

        AutoLooperBanner bannerLayout = (AutoLooperBanner) findViewById(R.id.banner);
        AutoLooperBanner bannerLayout2 = (AutoLooperBanner) findViewById(R.id.banner2);

        bannerLayout.setIBannerUpdate(this);
        bannerLayout2.setIBannerUpdate(this);

        final List<String> urls = new ArrayList<>();
        urls.add("http://img3.imgtn.bdimg.com/it/u=2674591031,2960331950&fm=23&gp=0.jpg");
        urls.add("http://img5.imgtn.bdimg.com/it/u=3639664762,1380171059&fm=23&gp=0.jpg");
        urls.add("http://img0.imgtn.bdimg.com/it/u=1095909580,3513610062&fm=23&gp=0.jpg");
        urls.add("http://img4.imgtn.bdimg.com/it/u=1030604573,1579640549&fm=23&gp=0.jpg");
        urls.add("http://img5.imgtn.bdimg.com/it/u=2583054979,2860372508&fm=23&gp=0.jpg");
        bannerLayout.setViewUrls(urls);

        //添加监听事件
        bannerLayout.setOnBannerItemClickListener(new AutoLooperBanner.OnBannerItemClickListener() {
            @Override
            public void onItemClick(int position) {
                Toast.makeText(TestBannerActivity.this, String.valueOf(position), Toast.LENGTH_SHORT).show();
            }
        });

        //低于三张
        final List<String> urls2 = new ArrayList<>();
        urls2.add("http://img3.imgtn.bdimg.com/it/u=2674591031,2960331950&fm=23&gp=0.jpg");
        urls2.add("http://img5.imgtn.bdimg.com/it/u=3639664762,1380171059&fm=23&gp=0.jpg");
        bannerLayout2.setViewUrls(urls2);
    }

    @Override
    public void UpdateImage(ImgRes<?> res, ImageView imageView) {
        if (res.getRes() instanceof Integer) {
            Glide.with(imageView.getContext()).load(res.getRes()).centerCrop().into(imageView);
        } else if (res.getRes() instanceof String) {
            if (res.isDefaultExist()) {
                Glide.with(imageView.getContext()).load(res.getRes()).placeholder(res.getDefaultUrlRes()).centerCrop().into(imageView);
            } else {
                Glide.with(imageView.getContext()).load(res.getRes()).centerCrop().into(imageView);
            }
        } else {

        }
    }
}
