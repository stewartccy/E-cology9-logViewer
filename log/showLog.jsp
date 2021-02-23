<%@ page import="com.lgd.util.LogUtils" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="java.io.File" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2021/1/17 0017
  Time: 10:22:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String logName = request.getParameter("name");
    String sourcesName = request.getParameter("sources");
    if(null == logName){
        return;
    }
    String path = GCONST.getRootPath() + File.separator + "log" + File.separator + sourcesName + File.separator + logName;
//    String path = GCONST.getRootPath() + File.separator + "log" + File.separator + "ecology";
    File file = new File(path);
    Long errorSize = 0L;
    if (file.exists()) {
        LogUtils logUtils = new LogUtils();
        String log = logUtils.readFileContent(path);
        errorSize = logUtils.errorSize;
        request.setAttribute("log", log);
    }
%>
<html>
<head>
    <title>查看日志</title>
    <meta name="viewport" content="maximum-scale=1.0,minimum-scale=1.0,user-scalable=0,width=device-width,initial-scale=1.0"/>
    <script type="text/javascript" src="/kailin/js/jquery-3.0.0.min.js"></script>
    <link rel="stylesheet" href="/kailin/lgd/log/css/log.css">
</head>
<body>
    <header>
        <button class="header_btn" onClick="javascript: location.reload();">刷新</button>
        <button class="header_btn interval" onClick="scrollToTop()">顶部</button>
        <button class="header_btn" onClick="scrollToBottom()">底部</button>
        <button class="header_btn interval" onClick="scrollToUp()">向上翻页</button>
        <button class="header_btn" onClick="scrollToDown()">向下翻页</button>
        <button class="header_btn searchErrorBtn interval" onClick="pointError(0)">查找上一个异常</button>
        <button class="header_btn searchErrorBtn" onClick="pointError(1)">查找下一个异常</button>
    </header>
    <div id="logBox">
        <%=request.getAttribute("log") %>
    </div>
    <script type="text/javascript">
        // 异常日志数量
        let errorSize = <%=errorSize%>;
        let logBox = document.getElementById('logBox');
        // 用于存放日志中的异常日志的坐标
        let errorPointArray = new Array(errorSize);
        $(function(){
            logBox.scrollTop = logBox.scrollHeight;
            $(".errorLog").css("color", "red");
            $(".infoLog").css("color", "green");
            $(".loadingBox").css("display", "none");
            if (0 == errorSize) {
                $(".searchErrorBtn").prop("disabled", "true");
            }
            for (let i = 0; i < errorSize; i++) {
                // 将异常日志坐标放到数组中
                errorPointArray[i] = $('#errorLog_' + i).get(0).offsetTop - 48;
            }
            console.log("异常日志坐标点", errorPointArray);
        })

        function scrollToTop() {
            $("#logBox").animate({
                scrollTop: 0
            }, 500);
        }
        function scrollToBottom(){
            $("#logBox").animate({
                scrollTop: logBox.scrollHeight
            }, 500);
        }

        function scrollToUp() {
            let height = $("#logBox").height(); // div高度
            let scrollHeight = $("#logBox").scrollTop(); // 当前滑动高度
            let scroll = scrollHeight - height;
            $("#logBox").animate({
                scrollTop: scroll
            }, 500);
        }
        function scrollToDown() {
            let height = $("#logBox").height(); // div高度
            let scrollHeight = $("#logBox").scrollTop(); // 当前滑动高度
            let scroll = scrollHeight + height;
            $("#logBox").animate({
                scrollTop: scroll
            }, 500);
        }

        /**
         * 查找异常日志并移动至该坐标
         * @param direction 查找方向(0:向上 1:向下)
         */
        function pointError(direction) {
            // debugger;
            let toPoint = null;
            // 当前坐标点
            let nowPoint = $("#logBox").scrollTop();
            // 查找方向向下 且 当前坐标在第一个异常日志坐标之前
            if (1 == direction && nowPoint < errorPointArray[0]) {
                toPoint = errorPointArray[0];
            }
            // 查找方向向上 且 当前坐标在最后一个异常日志坐标之后
            if (0 == direction && nowPoint > errorPointArray[errorPointArray.length - 1]) {
                toPoint = errorPointArray[errorPointArray.length - 1];
            }
            for (let i = 0; i < errorPointArray.length; i++) {
                // 当前坐标点停留在某个异常坐标点
                if (nowPoint == errorPointArray[i]) {
                    if (0 == direction) {
                        toPoint = errorPointArray[i - 1];
                    } else {
                        toPoint = errorPointArray[i + 1];
                    }
                }
                // 当前坐标点仪在两个异常坐标点中间
                if (nowPoint > errorPointArray[i] && nowPoint < errorPointArray[i + 1]) {
                    if (0 == direction) {
                        toPoint = errorPointArray[i];
                    } else {
                        toPoint = errorPointArray[i + 1];
                    }
                }
            }
            if (null != toPoint) {
                $("#logBox").animate({
                    scrollTop: toPoint
                }, 500);
                console.log("移动至坐标点 -> ", toPoint);
            } else {
                if (0 == direction) {
                    console.log("已到达第一个异常坐标点");
                } else {
                    console.log("已到达最后一个异常坐标点");
                }
            }
        }
    </script>
</body>
</html>
