package com.lht.jsbridge_lib.demo;

/**
 * <p><b>Package</b> com.lht.jsbridge_lib.demo
 * <p><b>Project</b> Jsbridge_lib
 * <p><b>Classname</b> WebSearchReqBean
 * <p><b>Description</b>: TODO
 * <p>Created by leobert on 2016/12/6.
 */

public class WebSearchReqBean {

    public static final String API_NAME = "APP_W_REQ_SEARCH_LIST";
    private String direction;
    //    \" : \"ASC\",\n " +
    private int pno;
    //    " \"pno\" : \"0\",\n  \"order\" :" +
    private String order;

    private String lang = "zh-CN";

    private int pageSize = 20;

    private String keyword;
//            " \"sub_end_time\",\n  \"lang\" : \"zh-CN\",\n  \"pageSize\" : \"20\",\n  \"keyword\" : \"3d\"\n}


    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public int getPno() {
        return pno;
    }

    public void setPno(int pno) {
        this.pno = pno;
    }

    public String getOrder() {
        return order;
    }

    public void setOrder(String order) {
        this.order = order;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getLang() {
        return lang;
    }

    public int getPageSize() {
        return pageSize;
    }
}
