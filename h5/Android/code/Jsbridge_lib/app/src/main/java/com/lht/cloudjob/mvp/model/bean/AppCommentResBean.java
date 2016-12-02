package com.lht.cloudjob.mvp.model.bean;

import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;

/**
 * <p><b>Package</b> com.lht.cloudjob.mvp.model.bean
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> AppCommentResBean
 * <p><b>Description</b>: app评论列表item的数据模型
 * <p>Created by leobert on 2016/11/15.
 */
@TempVersion(TempVersionEnum.V1019)
public class AppCommentResBean {

    private String id;

    /**
     * 发表评论者用户名
     */
    private String username;

    /**
     * 昵称
     */
    private String nickname;

    /**
     * 评论点赞数量
     */
    private long zans;

    /**
     * 评论内容
     */
    private String content;

    /**
     * 当前访问者是否已经对该评论点赞（0=>未点赞，1=>已点赞）
     */
    private int already_zan;

    public static final int ALREADY_ZAN = 1;

    /**
     * 评论提交时间，时间戳
     */
    private long created_at;

    /**
     * 发表评论者头像
     */
    private String avatar;

    /**
     * 发表评论者排名
     */
    private String ranking;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
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

    public int getAlready_zan() {
        return already_zan;
    }

    public void setAlready_zan(int already_zan) {
        this.already_zan = already_zan;
    }


    public long getCreated_at() {
        return created_at;
    }

    public void setCreated_at(long created_at) {
        this.created_at = created_at * 1000;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getRanking() {
        return ranking;
    }

    public void setRanking(String ranking) {
        this.ranking = ranking;
    }
}
