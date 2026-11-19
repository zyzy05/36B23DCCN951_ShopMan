<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.shopman.dao.ProductDAO" %>
<%@ page import="vn.shopman.dao.ReviewDAO" %>
<%@ page import="vn.shopman.model.Product" %>
<%@ page import="vn.shopman.model.Review" %>

<%
    request.setAttribute("requiredRole", "CUSTOMER");
%>

<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<%
    Product product = null;
    List<Product> relatedProducts = new ArrayList<>();
    List<Review> reviews = new ArrayList<>();
    NumberFormat money = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
    money.setMaximumFractionDigits(0);

    String error = null;
    try {
        String productIdValue = request.getParameter("id");
        if (productIdValue == null || productIdValue.isBlank()) {
            throw new IllegalArgumentException("Mã mặt hàng không hợp lệ.");
        }
        int productId = Integer.parseInt(productIdValue);
        if (productId <= 0) {
            throw new IllegalArgumentException("Mã mặt hàng không hợp lệ.");
        }
        ProductDAO productDAO = new ProductDAO();

        product = productDAO.getProductDetails(productId);

        if (product != null) {
            relatedProducts = productDAO.getRelatedProducts(productId, 5);
            reviews = new ReviewDAO().getReviewsByProductId(productId);
        }
    } catch (NumberFormatException exception) {
        error = "Mã mặt hàng không hợp lệ.";
    } catch (IllegalArgumentException exception) {
        error = exception.getMessage();
    } catch (SQLException exception) {
        application.log("Product detail error", exception);
        error = "Không thể tải thông tin mặt hàng.";
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết mặt hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=3">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <main class="content">
            <% if (error != null) { %>
                <div class="alert"><%= escapeHtml(error) %></div>
            <% } else if (product == null) { %>
                <div class="alert">Không tìm thấy mặt hàng.</div>
            <% } else { %>
                <h2 class="product-detail-title"><%= escapeHtml(product.getName()) %></h2>

                <section class="product-detail panel" aria-label="Thông tin chi tiết sản phẩm">
                    <div class="product-detail-visual">
                        <% if (product.getImageUrl() != null
                                && !product.getImageUrl().isBlank()) { %>
                            <img
                                class="product-image"
                                src="<%= escapeHtml(product.getImageUrl()) %>"
                                alt="<%= escapeHtml(product.getName()) %>"
                            >
                        <% } else { %>
                            <div class="image-placeholder product-image-placeholder">
                                Chưa có ảnh sản phẩm
                            </div>
                        <% } %>
                    </div>

                    <div class="product-detail-info">
                        <div class="product-detail-price">
                            <span>Đơn giá</span>
                            <strong><%= money.format(product.getPrice()) %> ₫</strong>
                        </div>
                        <h3 class="product-info-heading">Thông tin sản phẩm</h3>
                        <dl class="product-info-list">
                            <div><dt>Mã mặt hàng</dt><dd><%= escapeHtml(product.getProductCode()) %></dd></div>
                            <div><dt>Tên sản phẩm</dt><dd><%= escapeHtml(product.getName()) %></dd></div>
                            <div><dt>Thương hiệu</dt><dd><%= escapeHtml(product.getBrand()) %></dd></div>
                            <div><dt>Đơn vị</dt><dd><%= escapeHtml(product.getUnit()) %></dd></div>
                            <div><dt>Số lượng tồn</dt><dd><%= product.getStock() %></dd></div>
                            <div><dt>Danh mục</dt><dd><%= escapeHtml(product.getCategory()) %></dd></div>
                            <div class="product-info-description"><dt>Mô tả</dt><dd><%= escapeHtml(product.getDescription()) %></dd></div>
                        </dl>
                    </div>
                </section>

                <h3>Sản phẩm cùng danh mục</h3>
                <ul>
                    <% for (Product related : relatedProducts) { %>
                        <li>
                            <a href="detail.jsp?id=<%= related.getProductId() %>">
                                <%= escapeHtml(related.getName()) %>
                            </a>
                        </li>
                    <% } %>
                </ul>

                <h3>Đánh giá</h3>
                <% for (Review review : reviews) { %>
                    <div class="panel">
                        <b><%= escapeHtml(review.getCustomerName()) %></b>
                        · <%= review.getRating() %>/5
                        <p><%= escapeHtml(review.getContent()) %></p>
                    </div>
                <% } %>
            <% } %>

            <a href="search.jsp">Quay lại tìm kiếm</a>
        </main>
    </div>
</body>
</html>
