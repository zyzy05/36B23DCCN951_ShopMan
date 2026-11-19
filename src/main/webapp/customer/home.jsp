<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.shopman.dao.SearchHistoryDAO" %>
<%@ page import="vn.shopman.model.SearchHistory" %>

<%
    request.setAttribute("requiredRole", "CUSTOMER");
%>

<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<%
    if (!Boolean.TRUE.equals(session.getAttribute("customerWelcomeSeen"))) {
        response.sendRedirect("welcome.jsp");
        return;
    }
%>

<%
    List<SearchHistory> history = new ArrayList<>();
    String error = null;

    try {
        history = new SearchHistoryDAO()
                .getSearchHistory(currentUser.getCustomerId());
    } catch (SQLException exception) {
        application.log("Search history error", exception);
        error = "Không thể tải lịch sử tìm kiếm.";
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Khách hàng - ShopMan</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <main class="content">
            <h2>Trang khách hàng</h2>
            <p>Tra cứu mặt hàng trong hệ thống bách hóa.</p>

            <form action="search.jsp" method="get" class="search">
                <input name="q" placeholder="Nhập tên hoặc mã mặt hàng">
                <button type="submit">Tìm kiếm</button>
            </form>

            <h3>Lịch sử tìm kiếm gần đây</h3>

            <% if (error != null) { %>
                <div class="alert"><%= error %></div>
            <% } else if (history.isEmpty()) { %>
                <p class="muted">Chưa có lịch sử tìm kiếm.</p>
            <% } else { %>
                <ul class="history-list">
                    <% for (SearchHistory item : history) { %>
                        <li>
                            <a href="search.jsp?q=<%= java.net.URLEncoder.encode(item.getKeyword(), java.nio.charset.StandardCharsets.UTF_8) %>">
                                <%= escapeHtml(item.getKeyword()) %>
                            </a>
                            <small><%= escapeHtml(item.getSearchedAt()) %></small>
                        </li>
                    <% } %>
                </ul>
            <% } %>
        </main>
    </div>
</body>
</html>
