package com.lht.cloudjob.mvp.model.bean;

import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.model.bean
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> MyAppCommentResBean
 * <p><b>Description</b>: TODO
 * <p> Create by Leobert on 2016/11/15
 */
@TempVersion(TempVersionEnum.V1019)
public class MyAppCommentResBean {
    /**
     * 发表评论者用户名
     */
    private String username;
    /**
     * 评论状态（0=>待处理，1=>通过，2=>驳回）
     */
    private int status;

    /**
     * 评论点赞数量
     */
    private long zans;

    /**
     * 评论内容
     */
    private String content;

    /**
     * 评论提交日期
     */
    private long created_at;

    /**
     * 发表评论者排名
     */
    private long ranking;

    /**
     * 发布评论者头像
     */
    private String avatar;

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getZans() {
        return zans;
    }

    public void setZans(long zans) {
        this.zans = zans;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public long getCreated_at() {
        return created_at;
    }

    public void setCreated_at(long created_at) {
        this.created_at = created_at * 1000; //format to millis
    }

    public long getRanking() {
        return ranking;
    }

    public void setRanking(long ranking) {
        this.ranking = ranking;
    }
}
