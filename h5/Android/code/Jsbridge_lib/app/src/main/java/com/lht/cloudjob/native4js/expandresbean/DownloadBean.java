package com.lht.cloudjob.native4js.expandresbean;

/**
 * Created by chhyu on 2016/12/6.
 */

public class DownloadBean {
    /**
     * the real name of the file
     */
    private String fileName;

    /**
     * url of the attachment
     */
    private String fileUrl;

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }
}
