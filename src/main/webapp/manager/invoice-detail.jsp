<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="vn.shopman.dao.InvoiceDAO1" %>
<%@ page import="vn.shopman.dao.InvoiceDetailsDAO1" %>
<%@ page import="vn.shopman.model.InvoiceDetails1" %>
<%@ page import="vn.shopman.model.InvoiceHeader1" %>

<% request.setAttribute("requiredRole", "MANAGER"); %>
<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<%
    List<InvoiceDetails1> rows = new ArrayList<>();
    InvoiceHeader1 invoice = null;
    BigDecimal goodsTotal = BigDecimal.ZERO;
    String error = null;
    NumberFormat money = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
    money.setMaximumFractionDigits(0);
    try {
        int invoiceId = Integer.parseInt(request.getParameter("id"));
        if (invoiceId <= 0) throw new NumberFormatException();
        invoice = new InvoiceDAO1().getInvoiceHeader(invoiceId);
        if (invoice == null) {
            error = "Không tìm thấy hóa đơn.";
        } else {
            rows = new InvoiceDetailsDAO1().getInvoiceDetails(invoiceId);
            for (InvoiceDetails1 row : rows) {
                if (row.getLineTotal() != null) goodsTotal = goodsTotal.add(row.getLineTotal());
            }
        }
    } catch (NumberFormatException exception) {
        error = "Mã hóa đơn không hợp lệ.";
    } catch (SQLException exception) {
        application.log("Invoice detail error", exception);
        error = "Không thể tải chi tiết hóa đơn.";
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hóa đơn</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>
    <main class="content">
        <div class="page-heading">
            <a class="back-link" href="javascript:history.back()">Quay lại</a>
            <h2>Chi tiết hóa đơn</h2>
        </div>

        <% if (error != null) { %>
            <div class="alert"><%= error %></div>
        <% } else { %>
            <section class="invoice-meta info-card">
                <div><span>Khách hàng: </span><%= escapeHtml(invoice.getCustomer().getFullName()) %></div>
                <div><span>Mã KH: </span><%= escapeHtml(invoice.getCustomer().getCustomerCode()) %></div>
                <div><span>Mã HĐ: </span><%= escapeHtml(invoice.getInvoiceCode()) %></div>
                <div><span>Ngày lập: </span><%= invoice.getCreatedAt().toLocalDate() %></div>
                <div><span>Điện thoại: </span><%= escapeHtml(invoice.getCustomer().getPhone() == null ? "-" : invoice.getCustomer().getPhone()) %></div>
                <div><span>Trạng thái: </span><span class="status-badge"><%= escapeHtml(invoice.getStatus()) %></span></div>
            </section>

            <div class="table-wrap">
                <table class="data-table invoice-detail-table">
                    <thead><tr><th>TT</th><th>Mã hàng</th><th>Tên mặt hàng</th><th>Đơn vị</th><th>Số lượng</th><th>Đơn giá (VNĐ)</th><th>Thành tiền (VNĐ)</th></tr></thead>
                    <tbody>
                    <% int index = 1; for (InvoiceDetails1 detail : rows) { %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><%= escapeHtml(detail.getProductCode()) %></td>
                            <td><%= escapeHtml(detail.getProductName()) %></td>
                            <td><%= escapeHtml(detail.getUnit()) %></td>
                            <td><%= detail.getQuantity() %></td>
                            <td class="money"><%= money.format(detail.getUnitPrice()) %></td>
                            <td class="money"><%= money.format(detail.getLineTotal()) %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <table class="invoice-total-table">
                <tbody>
                    <tr><th>Tổng tiền hàng</th><td><%= money.format(goodsTotal) %></td></tr>
                    <tr><th>Phí vận chuyển</th><td><%= money.format(invoice.getShippingFee() == null ? BigDecimal.ZERO : invoice.getShippingFee()) %></td></tr>
                    <tr><th>Giảm giá</th><td><%= money.format(BigDecimal.ZERO) %></td></tr>
                    <tr class="grand-total"><th>Tổng thanh toán</th><td><%= money.format(invoice.getTotal()) %></td></tr>
                </tbody>
            </table>
        <% } %>
    </main>
</div>
</body>
</html>
