package com.lht.cloudjob.test;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.mvp.model.bean.BaseVsoApiResBean;
import com.lht.cloudjob.mvp.model.bean.EAuthenticQueryResBean;
import com.lht.cloudjob.mvp.model.bean.PAuthenticQueryResBean;
import com.lht.cloudjob.mvp.model.pojo.PreviewImage;

import java.util.ArrayList;

/**
 * <p><b>Package</b> com.lht.cloudjob.test
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> TestEAuthenticateActicity
 * <p><b>Description</b>: TODO
 * <p>Created by Administrator on 2016/9/13.
 */

public class DummyData {

    public static EAuthenticQueryResBean genEauthOnWaitData() {
        EAuthenticQueryResBean bean = new EAuthenticQueryResBean();
        bean.setUsername("test_username");
        bean.setAuth_status(0);
        bean.setCompany("t_company");
        bean.setLegal("test_legal");
        bean.setLegal_id_card("3211");
        bean.setLicen_num("000");
        bean.setLicen_pic("http://static.vsochina.com/data/avatar/000/01/03/52_avatar_middle.jpg");
        bean.setTurnover("test_turnover");
        bean.setTelephone("400-0000-0000");
        bean.setArea_prov("province");
        bean.setArea_city("city");
        bean.setArea_dist("dist");
        bean.setEnt_start_time(System.currentTimeMillis());
        bean.setEnt_end_time(System.currentTimeMillis());

        bean.setResidency("test_residency");
        bean.setIndus_pid(1);


        return bean;
    }

    public static EAuthenticQueryResBean genEauthPassData() {
        EAuthenticQueryResBean bean = genEauthOnWaitData();
        bean.setAuth_status(1);
        return bean;
    }

    public static EAuthenticQueryResBean genEauthRefuseData() {
        EAuthenticQueryResBean bean = genEauthOnWaitData();
        bean.setAuth_status(2);
        return bean;
    }

    //------------------------------------------------------------------------//
    //************** 实名认证 *************************************************//
    //------------------------------------------------------------------------//

    public static PAuthenticQueryResBean genPauthOnWaitData() {

        PAuthenticQueryResBean bean = new PAuthenticQueryResBean();
        bean.setUsername("test_username");
        bean.setAuth_status(0);
        bean.setId_card("321101XXXXXXXXXXXX");
        bean.setId_pic("http://static.vsochina.com/data/avatar/000/01/03/52_avatar_middle.jpg");
        bean.setId_pic_2("http://static.vsochina.com/data/avatar/000/01/03/52_avatar_middle.jpg");
        bean.setId_pic_3("http://static.vsochina.com/data/avatar/000/01/03/52_avatar_middle.jpg");
        bean.setRealname("real-name");
        bean.setStart_time("1444420517");
        bean.setAuth_area(2);

        bean.setValidity_s_time(System.currentTimeMillis() - 1000 * 24 * 3600);
        bean.setValidity_e_time(System.currentTimeMillis());
        bean.setNopass_des("too young too naive");
        return bean;
    }

    public static PAuthenticQueryResBean genPauthPassData() {
        PAuthenticQueryResBean bean = genPauthOnWaitData();
        bean.setAuth_status(1);
        return bean;
    }

    public static PAuthenticQueryResBean genPauthRefuseData() {
        PAuthenticQueryResBean bean = genPauthOnWaitData();
        bean.setAuth_status(2);
        return bean;
    }

    //------------------------------------------------------------------------//
    //************** auth-error *************************************************//
    //------------------------------------------------------------------------//
    public static String genAuthErrorData(int code) {
        BaseVsoApiResBean bean = new BaseVsoApiResBean();
        bean.setRet(code);
        bean.setMessage("-------test data-----by leobert");
        return JSON.toJSONString(bean);
    }

    private final static String[] imageThumbUrls = new String[]{
            "http://172.16.23.100:3000/test/images/test.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406383166_2224.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406382789_7174.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406382789_5170.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406382789_4118.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406382788_9532.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406382767_3184.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406382767_4772.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406382766_4924.jpg",
            "http://img.my.csdn.net/uploads/201407/26/1406382766_5762.jpg",
            "http://img.newyx.net/news_img/201306/20/1371714170_1812223777.gif",
            "http://cdn.duitang.com/uploads/item/201301/26/20130126223743_KsNwM.thumb.600_0.gif",
            "http://img.my.csdn.net/uploads/201407/26/1406382765_7341.jpg"
    };

//    public static ArrayList<PreviewImage> getPreviewImages() {
//        ArrayList<PreviewImage> previewImages = new ArrayList<>();
//        for (String s : imageThumbUrls) {
//            PreviewImage image = new PreviewImage();
//            image.setPreviewUrl(s);
//            previewImages.add(image);
//        }
//        return previewImages;
//    }


}
