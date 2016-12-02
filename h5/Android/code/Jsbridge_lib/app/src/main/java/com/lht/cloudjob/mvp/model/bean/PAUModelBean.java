package com.lht.cloudjob.mvp.model.bean;

import com.litesuits.orm.db.annotation.PrimaryKey;
import com.litesuits.orm.db.annotation.Table;
import com.litesuits.orm.db.enums.AssignType;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.model.bean
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> PAUModelBean
 * <p><b>Description</b>: 个人认证缓存数据模型
 * Created by leobert on 2016/8/8.
 */

@Table("pauth_bak")
public class PAUModelBean {
    //    username	String 必须，用户名
//    * <p/>
//            * realname	String 必须，真实姓名，2-4个中文字
//    * <p/>
//            * id_card	String 必须，身份证号
//    * <p/>
//            * id_pic	String 必须，身份证复印件正面，图片路径
//    * <p/>
//            * id_pic_2	String 必须，身份证复印件反面，图片路径
//    * <p/>
//            * id_pic_3	String 必须，手持证照片，图片路径
//    * <p/>
//            * validity_s_time	Number 可选，证件有效期开始时间，时间戳
//    * <p/>
//            * validity_e_time	Number 可选，证件有效期结束时间，时间戳
//    * <p/>
//            * auth_area	Number 可选，认证地区（0=>大陆，1=>台湾，2=>香港，3=>澳门，默认0）
    public static final int AREA_ML = 0;
    public static final int AREA_TW = 1;
    public static final int AREA_HK = 2;
    public static final int AREA_MC = 3;

    public static final int AREA_NULL = -1;


    @PrimaryKey(AssignType.BY_MYSELF)
    private String username;

    private String realName;

    private String idCard;

    private String idPicOne;

    private String idPicTwo;

    private String idPicThree;

    private long validityBegin;

    private long validityEnd;


    private int areaCode = 0;

    /**
     * 所属地区别名
     */
    private String validityRegion;

    public String getValidityRegion() {
        return validityRegion;
    }

    public void setValidityRegion(String validityRegion) {
        this.validityRegion = validityRegion;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getIdPicOne() {
        return idPicOne;
    }

    public void setIdPicOne(String idPicOne) {
        this.idPicOne = idPicOne;
    }

    public String getIdPicTwo() {
        return idPicTwo;
    }

    public void setIdPicTwo(String idPicTwo) {
        this.idPicTwo = idPicTwo;
    }

    public String getIdPicThree() {
        return idPicThree;
    }

    public void setIdPicThree(String idPicThree) {
        this.idPicThree = idPicThree;
    }

    public long getValidityBegin() {
        return validityBegin;
    }

    public void setValidityBegin(long validityBegin) {
        this.validityBegin = validityBegin;
    }

    public long getValidityEnd() {
        return validityEnd;
    }

    public void setValidityEnd(long validityEnd) {
        this.validityEnd = validityEnd;
    }

    public int getAreaCode() {
        return areaCode;
    }

    public void setAreaCode(int areaCode) {
        this.areaCode = areaCode;
    }

    public void copy(PAuthenticQueryResBean bean) {
        this.setAreaCode(bean.getAuth_area());
        this.setIdPicThree(bean.getId_pic_3());
        this.setIdCard(bean.getId_card());
        this.setIdPicTwo(bean.getId_pic_2());
        this.setIdPicOne(bean.getId_pic());
        this.setRealName(bean.getRealname());
        this.setUsername(bean.getUsername());
        this.setValidityBegin(bean.getValidity_s_time());
        this.setValidityEnd(bean.getValidity_e_time());
    }

    public static String getRegionString(int code) {
        String region;
        switch (code) {
            case AREA_ML:
                region = "中国大陆";
                break;
            case AREA_HK:
                region = "中国香港";
                break;
            case AREA_MC:
                region = "中国澳门";
                break;
            case AREA_TW:
                region = "中国台湾";
                break;
            default:
                region = "中国大陆";
                break;
        }
        return region;
    }
}
