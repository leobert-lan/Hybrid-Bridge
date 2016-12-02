package com.lht.cloudjob.interfaces;

import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;

/**
 * <p><b>Package</b> com.lht.cloudjob.interfaces
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> IPublicConst
 * <p><b>Description</b>: TODO
 * <p> Create by Leobert on 2016/9/6
 * 简体：http://www.vsochina.com/protocol/pro_id/219.html
 * 繁体：http://www.vsochina.com/protocol/pro_id/1249.html
 * 英文：http://www.vsochina.com/protocol/pro_id/1250.html
 */
public interface IPublicConst {
    String TEL = "400-164-7979";

    String VSO_SESSION_PREFIX = "v-s-o-c*h*i*n*a";

    String SIMPLIFIED_AGREEMENT = "http://m.vsochina.com/protocol/user-agreement";

//    String COMPLEX_AGREEMENT = "http://www.vsochina.com/protocol/pro_id/1249.html";
//
//    String ENGLISH_AGREEMENT = "http://www.vsochina.com/protocol/pro_id/1250.html";

    String SHARE_APP_LINK = "http://m.vsochina.com/protocol/downloadApp";

    String AGREEMENT_MODEL_URL = "http://m.vsochina.com/protocol?taskbn=%s&auth_token=%s&auth_username=%s";

    String MSGINFO_URL_FORMAT = "http://m.vsochina.com/message/detail/%s?auth_token=%s&auth_username=%s";

    @TempVersion(TempVersionEnum.V1019)
    String APP_COMMENT_ACTIVITY = "http://m.vsochina.com/activity/likeapp";

    String APP_SID = "757D6429-6ED8-4869-A904-8905B8045B3D";

    String APP_SYS = "android";
}
