package com.lgd.util;

import weaver.general.GCONST;

import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * kboss查看日志工具类
 */
public class LogUtils {

    public Long errorSize = 0L;

    /**
     * 获取文件列表
     * @param path 路径
     * @return 文件列表
     */
    public static List<String> getFileList(String path){
        List<String> fileList = new ArrayList<>();
        File file = new File(GCONST.getRootPath() + path);
        File[] files = file.listFiles();
        if (null != files) {
            for (File file1 : files) {
                fileList.add(file1.getName());
            }
        }
        String osName = System.getProperty("os.name");
        if (!osName.toLowerCase().contains("windows")) {
            // 当服务器不是windows时将列表倒序
            Collections.reverse(fileList);
        }
        return fileList;
    }

    /**
     * 读取文件
     * @param fileName 文件名(全路径)
     * @return 日志内容
     */
    public String readFileContent(String fileName) {
        File file = new File(fileName);
        BufferedReader reader = null;
        InputStreamReader isr = null;
        StringBuilder sbf = new StringBuilder();
        try {
            isr = new InputStreamReader(new FileInputStream(file), "GBK");
            reader = new BufferedReader(isr);
            String tempStr;
            long errorIndex = 0L;
            while ((tempStr = reader.readLine()) != null) {
                if (tempStr.startsWith("\tat ")) { // 异常堆栈缩进
                    sbf.append("　　").append(tempStr).append("<br />");
                } else if (tempStr.contains("ERROR")) { // 错误日志标红
                    sbf.append("<span class=\"errorLog\" id=\"errorLog_"+errorIndex+"\">").append(tempStr).append("</span><br />");
                    errorIndex++;
                } else if (tempStr.contains("INFO")) { // 信息日志标绿
                    sbf.append("<span class=\"infoLog\">").append(tempStr).append("</span><br />");
                } else {
                    sbf.append(tempStr).append("<br />");
                }
            }
            errorSize = errorIndex;
            return sbf.toString();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (reader != null) {
                    reader.close();
                }
                if (isr != null) {
                    isr.close();
                }
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
        return sbf.toString();
    }



}
