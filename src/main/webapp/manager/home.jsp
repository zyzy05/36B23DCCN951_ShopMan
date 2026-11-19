<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setAttribute("requiredRole", "MANAGER");
%>

<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý - ShopMan</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <main class="content">
            <h2>Khu vực nhân viên quản lý</h2>
            <p>Chọn chức năng cần thực hiện.</p>

            <div class="cards">
                <a class="panel" href="statistics.jsp">
                    <h3>Thống kê khách hàng</h3>
                    <p>Thống kê theo doanh thu và khoảng thời gian.</p>
                </a>
            </div>
        </main>
    </div>
</body>
</html>
