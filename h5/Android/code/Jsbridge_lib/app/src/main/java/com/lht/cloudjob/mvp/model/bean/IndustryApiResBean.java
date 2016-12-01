package com.lht.cloudjob.mvp.model.bean;

import com.lht.cloudjob.interfaces.net.IRestfulApi;
import com.lht.cloudjob.mvp.model.IndustryQueryModel;

import java.util.ArrayList;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.model.bean
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> IndustryApiResBean
 * <p><b>Description</b>: 旧版所有行业信息
 * 注意，data是数组，此处仅描述data中的一个元素
 * <p/>
 * Created by leobert on 2016/7/26.
 * to see Model at{@link IndustryQueryModel}
 * to see API at{@link IRestfulApi.IndustryApi}
 */
public class IndustryApiResBean {
    //    {
//        "ret": 0,
//            "status": 1,
//            "message": "成功",
//            "data": [
//        {
//            "indus_pid": "530",
//                "indus_name": "影视行业",
//                "indus_icn": "http://static.vsochina.com/task_icon/530.png",
//                "sub": [
//            {
//                "indus_id": "534",
//                    "indus_name": "宣传片/广告片/纪录片"
//            },

    private int indus_pid;
    private String indus_name;
    private String indus_icn;
    private ArrayList<SubIndustry> sub;
    private boolean isSelected;

    public int getIndus_pid() {
        return indus_pid;
    }

    public void setIndus_pid(int indus_pid) {
        this.indus_pid = indus_pid;
    }

    public String getIndus_name() {
        return indus_name;
    }

    public void setIndus_name(String indus_name) {
        this.indus_name = indus_name;
    }

    public String getIndus_icn() {
        return indus_icn;
    }

    public void setIndus_icn(String indus_icn) {
        this.indus_icn = indus_icn;
    }

    public ArrayList<SubIndustry> getSub() {
        return sub;
    }

    public void setSub(ArrayList<SubIndustry> sub) {
        this.sub = sub;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setIsSelected(boolean isSelected) {
        this.isSelected = isSelected;
    }

    public static class SubIndustry {
        private int indus_id;// "538",
        private String indus_name;

        public int getIndus_id() {
            return indus_id;
        }

        public void setIndus_id(int indus_id) {
            this.indus_id = indus_id;
        }

        public String getIndus_name() {
            return indus_name;
        }

        public void setIndus_name(String indus_name) {
            this.indus_name = indus_name;
        }
    }
}
