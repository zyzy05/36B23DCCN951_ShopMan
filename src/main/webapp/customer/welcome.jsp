<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setAttribute("requiredRole", "CUSTOMER");
%>

<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        session.setAttribute("customerWelcomeSeen", Boolean.TRUE);
        response.sendRedirect("home.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ - ShopMan</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <main class="content">
            <h2>Trang khách hàng</h2>
            <p>Tra cứu mặt hàng trong hệ thống bách hóa.</p>

            <div class="cards">
                <section class="panel">
                    <form action="welcome.jsp" method="post">
                        <button type="submit">Thống kê khách hàng theo doanh thu</button>
                    </form>
                </section>
            </div>
        </main>
    </div>
</body>
</html>
