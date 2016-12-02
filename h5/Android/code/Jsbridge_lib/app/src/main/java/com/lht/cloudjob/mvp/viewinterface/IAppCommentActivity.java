package com.lht.cloudjob.mvp.viewinterface;

import com.lht.cloudjob.annotation.antideadcode.TempVersion;
import com.lht.cloudjob.annotation.antideadcode.TempVersionEnum;

/**
 * Created by chhyu on 2016/11/15.
 */
@TempVersion(TempVersionEnum.V1019)
public interface IAppCommentActivity extends IActivityAsyncProtected {

    void notifyCommentTextLength();

    void notifyCurrentTextCount(int currentCount);
}
