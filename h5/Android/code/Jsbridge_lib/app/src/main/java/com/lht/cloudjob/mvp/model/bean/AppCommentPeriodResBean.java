package com.lht.cloudjob.mvp.model.bean;

import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.model.bean
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> AppCommentPeriodResBean
 * <p><b>Description</b>: TODO
 * <p>Created by leobert on 2016/11/17.
 */
@TempVersion(TempVersionEnum.V1019)
public class AppCommentPeriodResBean {
    /**
     * 活动开始日期，0点开始
     */
    private String start = "2016.11.22";

    /**
     * 活动截止日期，24点结束
     */
    private String end = "2016.12.12";

    public String getStart() {
        return start.replace("-",".");
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end.replace("-",".");
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public String getFormatPeriod() {
        return "活动时间：" + getStart() + "-" + getEnd();
    }
}
