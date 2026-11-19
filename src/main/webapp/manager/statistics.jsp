<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setAttribute("requiredRole", "MANAGER");
%>

<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chọn thời gian thống kê khách hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <main class="content">
            <h2>Thống kê khách hàng theo doanh thu</h2>
            <p>Chọn khoảng thời gian cần thống kê, sau đó nhấn “Thống kê”.</p>

            <form action="statistics-result.jsp" method="get" class="filters">
                <label>
                    Từ ngày
                    <input type="date" name="startDate" required>
                </label>

                <label>
                    Đến ngày
                    <input type="date" name="endDate" required>
                </label>

                <button type="submit">Thống kê</button>
            </form>
        </main>
    </div>
</body>
</html>
