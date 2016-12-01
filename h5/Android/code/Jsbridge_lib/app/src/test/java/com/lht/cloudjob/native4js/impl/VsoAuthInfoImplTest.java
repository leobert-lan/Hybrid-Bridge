package com.lht.cloudjob.native4js.impl;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.interfaces.IVerifyHolder;
import com.lht.cloudjob.mvp.model.pojo.LoginInfo;
import com.lht.cloudjob.native4js.expandresbean.NF_VsoAuthInfoResBean;
import com.lht.cloudjob.util.string.StringUtil;
import com.lht.lhtwebviewlib.base.Interface.CallBackFunction;
import com.lht.lhtwebviewlib.business.bean.BaseResponseBean;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * <p><b>Package</b> com.lht.cloudjob.native4js.impl
 * <p><b>Project</b> Jsbridge_lib
 * <p><b>Classname</b> VsoAuthInfoImplTest
 * <p><b>Description</b>: TODO
 * <p>Created by leobert on 2016/12/1.
 */
public class VsoAuthInfoImplTest {
    private VsoAuthInfoImpl vsoAuthInfoImpl;

    private CallBackFunction testSuccess;

    private CallBackFunction testFailure;

    @Before
    public void setUp() throws Exception {
        vsoAuthInfoImpl = new VsoAuthInfoImpl();

        testSuccess = new CallBackFunction() {
            @Override
            public void onCallBack(String s) {
                BaseResponseBean responseBean = JSON.parseObject(s,BaseResponseBean.class);
                assertEquals(1,responseBean.getStatus());
                assertData(responseBean.getData());
            }
        };

        testFailure = new CallBackFunction() {
            @Override
            public void onCallBack(String s) {
                BaseResponseBean responseBean = JSON.parseObject(s,BaseResponseBean.class);
                assertEquals(0,responseBean.getStatus());
            }
        };
    }

    @Test
    public void handler() throws Exception {
        LoginInfo info = new LoginInfo();
        info.setAccessToken("test_token");
        info.setUsername("test_username");
        IVerifyHolder.mLoginInfo.copy(info);
        vsoAuthInfoImpl.handler(null,testSuccess);

        IVerifyHolder.mLoginInfo.copy(new LoginInfo());
        vsoAuthInfoImpl.handler(null,testFailure);

    }

    @Test
    public void responseSuccess() throws Exception {
        LoginInfo info = new LoginInfo();
        info.setAccessToken("test_token");
        info.setUsername("test_username");
        IVerifyHolder.mLoginInfo.copy(info);

        NF_VsoAuthInfoResBean bean = new NF_VsoAuthInfoResBean();
        bean.setAuth_username(IVerifyHolder.mLoginInfo.getUsername());
        bean.setAuth_token(IVerifyHolder.mLoginInfo.getAccessToken());

        BaseResponseBean responseBean = vsoAuthInfoImpl.newSuccessResBean(bean);

        assertEquals(1,responseBean.getStatus());
        assertData(responseBean.getData());

    }

    private void assertData(String s) {
        NF_VsoAuthInfoResBean data = JSON.parseObject(s,NF_VsoAuthInfoResBean.class);
        assertEquals("test_token",data.getAuth_token());
        assertEquals("test_username",data.getAuth_username());
    }

    @Test
    public void responseFailure() throws Exception {
        IVerifyHolder.mLoginInfo.copy(new LoginInfo());

        BaseResponseBean responseBean = vsoAuthInfoImpl.newFailureResBean(0,"unLogin");

        assertEquals(0,responseBean.getStatus());
        assertEquals(true, StringUtil.isEmpty(responseBean.getData()));
    }

}