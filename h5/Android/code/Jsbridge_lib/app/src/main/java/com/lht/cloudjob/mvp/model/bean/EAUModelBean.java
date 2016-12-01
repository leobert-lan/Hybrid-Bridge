package com.lht.cloudjob.mvp.model.bean;

import com.alibaba.fastjson.JSON;
import com.lht.cloudjob.interfaces.net.IRestfulApi;
import com.lht.cloudjob.mvp.model.EAuthenticModel;
import com.lht.cloudjob.util.string.StringUtil;
import com.litesuits.orm.db.annotation.PrimaryKey;
import com.litesuits.orm.db.annotation.Table;
import com.litesuits.orm.db.enums.AssignType;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.model.bean
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> EAUModelBean
 * <p><b>Description</b>: TODO
 * <p>Created by Administrator on 2016/9/5.
 * <p>
 * to see Model at{@link EAuthenticModel}
 * to see API at{@link IRestfulApi.EAuthenticate}
 */
@Table("eauth_bak")
public class EAUModelBean {
    /**
     * username	String     必须，用户名
     * <p>
     * company	String     必须，企业名称
     * <p>
     * licen_num	Number     必须，注册号码
     * <p>
     * licen_pic	String     必须，营业执照，图片地址
     * <p>
     * legal	String     可选，法定代表人
     * <p>
     * turnover	String     可选，主营范围
     * <p>
     * ent_start_time	Number     可选，成立日期，时间戳
     * <p>
     * ent_end_time	Number     可选，营业截止日期，时间戳
     * <p>
     * area_prov	String     可选，企业所属省，如 江苏
     * <p>
     * area_city	String     可选，企业所属市，如 苏州
     * <p>
     * area_dist	String     可选，企业所属区，如 虎丘区
     * <p>
     * licen_address	String     可选，营业执照登记地址，如 江苏省苏州市虎丘区科灵路78号
     * <p>
     * auth_area	Number     可选，认证地区（0=>大陆，1=>台湾，2=>香港，3=>澳门，默认0）
     * <p>
     * lang	String     可选，语言，默认zh-CN
     * zh-CN => 简体中文
     * zh-TW => 繁体中文
     * en => 英文
     */
    //            * auth_area	Number 可选，认证地区（0=>大陆，1=>台湾，2=>香港，3=>澳门，默认0）
    public static final int AREA_NULL = -1;
    public static final int AREA_ML = 0;
    public static final int AREA_TW = 1;
    public static final int AREA_HK = 2;
    public static final int AREA_MC = 3;

    @PrimaryKey(AssignType.BY_MYSELF)
    private String userName;
    private String companyName;
    private String licenNum;
    private String licenPic;
    private String legalPerson;
    private String turnOver;
    private long startTime;
    private long endTime;
    private String province = "";
    private String city = "";
    private String district = "";
    private String licenAddress;
    private int authArea;

    private String validityRegion;
//    private String validityRegion2;

    public static final int PERIOD_LONG = 1;

    public static final int PERIOD_SHORT = 2;
    /**
     * 执照期限-大陆
     * 0-未选择，1-长期，2-短期
     */
    private int periodCode;

    public void copy(EAuthenticQueryResBean bean) {
        this.setUserName(bean.getUsername());
        this.setCompanyName(bean.getCompany());
        this.setLicenNum(bean.getLicen_num());
        this.setLicenPic(bean.getLicen_pic());
        this.setLegalPerson(bean.getLegal());
        this.setTurnOver(bean.getTurnover());
        this.setStartTime(bean.getEnt_start_time());
        this.setEndTime(bean.getEnt_end_time());
        this.setProvince(bean.getArea_prov());
        this.setCity(bean.getArea_city());
        this.setAuthArea(bean.getAuth_area());
        this.setDistrict(bean.getArea_dist());
        this.setLicenAddress(bean.getLicen_address());
        if (bean.isLicenceLongPeriod()) {
            this.setPeriodCode(1);
        }
    }

//    public String getValidityRegion2() {
//        return validityRegion2;
//    }
//
//    public void setValidityRegion2(String validityRegion2) {
//        this.validityRegion2 = validityRegion2;
//    }

    public void setEndTime(long endTime) {
        this.endTime = endTime;
    }

    public void setStartTime(long startTime) {
        this.startTime = startTime;
    }


    public String getValidityRegion() {
        return validityRegion;
    }

    public void setValidityRegion(String validityRegion) {
        this.validityRegion = validityRegion;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getLicenNum() {
        return licenNum;
    }

    public void setLicenNum(String licenNum) {
        this.licenNum = licenNum;
    }

    public String getLicenPic() {
        return licenPic;
    }

    public void setLicenPic(String licenPic) {
        this.licenPic = licenPic;
    }

    public String getLegalPerson() {
        return legalPerson;
    }

    public void setLegalPerson(String legalPerson) {
        this.legalPerson = legalPerson;
    }

    public String getTurnOver() {
        return turnOver;
    }

    public void setTurnOver(String turnOver) {
        this.turnOver = turnOver;
    }

    public long getEndTime() {
        return endTime;
    }

    public long getStartTime() {
        return startTime;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getLicenAddress() {
        return licenAddress;
    }

    public void setLicenAddress(String licenAddress) {
        this.licenAddress = licenAddress;
    }

    public int getAuthArea() {
        return authArea;
    }

    public void setAuthArea(int authArea) {
        this.authArea = authArea;
    }

    public int getPeriodCode() {
        return periodCode;
    }

    public void setPeriodCode(int periodCode) {
        this.periodCode = periodCode;
    }

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }

    public String getFormatLocation() {
        if (StringUtil.isEmpty(getProvince())) {
            return "";
        }
        if (!StringUtil.isEmpty(getDistrict())) {
            String format = "%s-%s-%s";
            return String.format(format, getProvince(), getCity(), getDistrict());
        } else {
            String format = "%s-%s";
            return String.format(format, getProvince(), getCity());
        }
    }
}
