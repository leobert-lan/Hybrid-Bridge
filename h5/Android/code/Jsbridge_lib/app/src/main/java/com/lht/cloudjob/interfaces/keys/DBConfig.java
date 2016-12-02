package com.lht.cloudjob.interfaces.keys;

/**
 * <p><b>Package</b> com.lht.cloudjob.interfaces.keys
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> DBConfig
 * <p><b>Description</b>: TODO
 * Created by leobert on 2016/8/16.
 */
public interface DBConfig {
    interface BasicDb {
        String DB_NAME = "basic.db";
    }

    interface AuthenticateDb {
        String DB_NAME = "authenticate.db";
    }

    interface SearchHistroyDb {
        /**
         * 保存搜索相关数据的数据库
         */
        String DB_NAME = "search.db";
    }

}
