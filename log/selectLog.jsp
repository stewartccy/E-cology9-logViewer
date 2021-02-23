<%@ page import="com.lgd.util.LogUtils" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2021/1/17 0017
  Time: 14:23:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String sourcesName = request.getParameter("sources");
    String path = File.separator + "log" + File.separator + sourcesName;
    List<String> fileList = LogUtils.getFileList(path);
    String files = "";
    for (String fileName : fileList) {
        files += fileName + ',';
    }
    files = files.substring(0, files.length() - 1);
%>
<html>
<head>
    <title>选择日志</title>
    <meta name="viewport" content="maximum-scale=1.0,minimum-scale=1.0,user-scalable=0,width=device-width,initial-scale=1.0"/>
    <script type="text/javascript" src="/kailin/js/jquery-3.0.0.min.js"></script>
    <link rel="stylesheet" href="/kailin/lgd/log/css/select.css">
</head>
<body>
    <div class="head">
        <input id="filesListStr" type="hidden" value="<%=files %>">
        选择日志：
        <select name="" id="selectLog">
            <option value="" disabled selected>请选择需查看的日志文件</option>
        </select>
    </div>
    <div class="log_element">
        <iframe id="log_iframe" src="/kailin/lgd/log/showLog.jsp" frameborder="0"></iframe>
    </div>

    <div class="loading">
        <img src="/kailin/lgd/log/images/loading.gif" alt="loading">
    </div>
    <script type="text/javascript">
        $(function(){
            let filesList = $("#filesListStr").val().split(",");
            console.log(filesList);
            let htmlStr = "";
            for(let i = 0; i < filesList.length; i++) {
                htmlStr += '<option class="selectedLog" value="' + filesList[i] + '">' + filesList[i] + '</option>';
            }
            $("#selectLog").append($(htmlStr));

            $("#selectLog").on('change', function () {
                // debugger
                $(".loading").show();
                let value = $(this).val();
                let iframe = document.getElementById("log_iframe");
                iframe.src= "/kailin/lgd/log/showLog.jsp?name=" + value + "&sources=<%=sourcesName%>";
                iframe.onload = function () {
                    $(".loading").fadeOut(300);
                };
                document.body.appendChild(iframe);
            })
        })
    </script>
</body>
</html>
