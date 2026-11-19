<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.shopman.dao.ProductDAO" %>
<%@ page import="vn.shopman.dao.SearchHistoryDAO" %>
<%@ page import="vn.shopman.model.Product" %>
<%@ page import="vn.shopman.model.SearchHistory" %>

<%
    request.setAttribute("requiredRole", "CUSTOMER");
%>

<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<%
    String query = request.getParameter("q");
    List<Product> products = new ArrayList<>();
    NumberFormat money = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
    money.setMaximumFractionDigits(0);
    List<SearchHistory> history = new ArrayList<>();
    String error = null;
    String keyword = query == null ? "" : query.trim();

    try {
        ProductDAO productDAO = new ProductDAO();
        SearchHistoryDAO historyDAO = new SearchHistoryDAO();

        if (!keyword.isEmpty()) {
            if (keyword.codePointCount(0, keyword.length()) > 180) {
                error = "Từ khóa tìm kiếm không được vượt quá 180 ký tự.";
            } else {
                products = productDAO.searchProducts(keyword);
                historyDAO.saveSearchHistory(currentUser.getCustomerId(), keyword);
            }
        }

        history = historyDAO.getSearchHistory(currentUser.getCustomerId());
    } catch (SQLException exception) {
        application.log("Customer search error", exception);
        error = "Không thể tải dữ liệu. Vui lòng kiểm tra MySQL.";
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm mặt hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <main class="content">
            <h2>Tìm kiếm mặt hàng</h2>

            <form method="get" class="search">
                <input
                    name="q"
                    value="<%= escapeHtml(query == null ? "" : query) %>"
                    placeholder="Tên hoặc mã mặt hàng"
                    maxlength="180"
                >
                <button type="submit">Tìm kiếm</button>
            </form>

            <% if (error != null) { %>
                <div class="alert"><%= error %></div>
            <% } %>

            <% if (query != null && !keyword.isEmpty() && error == null) { %>
                <h3>Kết quả tìm kiếm</h3>

                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Mã</th>
                                <th>Tên mặt hàng</th>
                                <th>Đơn vị</th>
                                <th>Đơn giá</th>
                                <th>Tồn kho</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Product product : products) { %>
                                <tr>
                                    <td>
                                        <% if (product.getImageUrl() != null
                                                && !product.getImageUrl().isBlank()) { %>
                                            <img
                                                class="product-thumb"
                                                src="<%= escapeHtml(product.getImageUrl()) %>"
                                                alt="<%= escapeHtml(product.getName()) %>"
                                                loading="lazy"
                                            >
                                        <% } else { %>
                                            <span class="image-placeholder">Chưa có ảnh</span>
                                        <% } %>
                                    </td>
                                    <td><%= escapeHtml(product.getProductCode()) %></td>
                                    <td><%= escapeHtml(product.getName()) %></td>
                                    <td><%= escapeHtml(product.getUnit()) %></td>
                                    <td class="money"><%= money.format(product.getPrice()) %></td>
                                    <td><%= product.getStock() %></td>
                                    <td>
                                        <a href="detail.jsp?id=<%= product.getProductId() %>">
                                            Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <% if (products.isEmpty()) { %>
                    <p>Không tìm thấy mặt hàng phù hợp.</p>
                <% } %>
            <% } %>

            <h3>Lịch sử tìm kiếm gần đây</h3>
            <ul class="history-list">
                <% for (SearchHistory item : history) { %>
                    <li>
                        <a href="search.jsp?q=<%= URLEncoder.encode(item.getKeyword(), StandardCharsets.UTF_8) %>">
                            <%= escapeHtml(item.getKeyword()) %>
                        </a>
                        <small><%= escapeHtml(item.getSearchedAt()) %></small>
                    </li>
                <% } %>
            </ul>
        </main>
    </div>
</body>
</html>
