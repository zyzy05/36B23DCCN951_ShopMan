<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="vn.shopman.dao.InvoiceDAO1" %>
<%@ page import="vn.shopman.model.Customer1" %>
<%@ page import="vn.shopman.model.Invoice1" %>

<% request.setAttribute("requiredRole", "MANAGER"); %>
<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<%
    List<Invoice1> invoices = new ArrayList<>();
    Customer1 customer = null;
    BigDecimal totalRevenue = BigDecimal.ZERO;
    String error = null;
    int customerId = 0;
    LocalDate start = LocalDate.now().withDayOfMonth(1);
    LocalDate end = LocalDate.now();

    try {
        customerId = Integer.parseInt(request.getParameter("id"));
        if (customerId <= 0) throw new NumberFormatException();
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        if (startDate != null && !startDate.isBlank()) start = LocalDate.parse(startDate);
        if (endDate != null && !endDate.isBlank()) end = LocalDate.parse(endDate);
        if (end.isBefore(start)) throw new IllegalArgumentException("Ngày kết thúc phải sau ngày bắt đầu.");

        InvoiceDAO1 dao = new InvoiceDAO1();
        customer = dao.getCustomerById(customerId);
        if (customer == null) {
            error = "Không tìm thấy thông tin khách hàng.";
        } else {
            invoices = dao.getInvoicesByCustomerId(customerId, start, end);
            for (Invoice1 invoice : invoices) {
                if ("HOÀN THÀNH".equals(invoice.getStatus()) && invoice.getTotal() != null) {
                    totalRevenue = totalRevenue.add(invoice.getTotal());
                }
            }
        }
    } catch (NumberFormatException exception) {
        error = "Mã khách hàng không hợp lệ.";
    } catch (DateTimeParseException exception) {
        error = "Ngày không hợp lệ. Vui lòng chọn lại khoảng thời gian.";
    } catch (IllegalArgumentException exception) {
        error = exception.getMessage();
    } catch (SQLException exception) {
        application.log("Customer invoice history error", exception);
        error = "Không thể tải thông tin khách hàng.";
    }
    NumberFormat money = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
    money.setMaximumFractionDigits(0);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết khách hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
</head>
<body>
<%@ include file="/WEB-INF/views/common/header.jspf" %>
<div class="layout">
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>
    <main class="content">
        <div class="page-heading">
            <a class="back-link" href="statistics-result.jsp?startDate=<%= start %>&endDate=<%= end %>">Quay lại</a>
            <h2>Chi tiết lần mua của khách hàng</h2>
        </div>

        <% if (error != null) { %>
            <div class="alert"><%= error %></div>
        <% } else { %>
            <section class="info-card customer-summary">
                <div><span>Khách hàng: </span><%= escapeHtml(customer.getFullName()) %></div>
                <div><span>Mã KH: </span><%= escapeHtml(customer.getCustomerCode()) %></div>
                <div><span>Số điện thoại: </span><%= escapeHtml(customer.getPhone() == null ? "-" : customer.getPhone()) %></div>
                <div><span>Email: </span><%= escapeHtml(customer.getEmail() == null ? "-" : customer.getEmail()) %></div>
                <div><span>Địa chỉ: </span><%= escapeHtml(customer.getAddress() == null ? "-" : customer.getAddress()) %></div>
                <div><span>Thời gian xem: </span><%= start %> - <%= end %></div>
            </section>

            <div class="section-title-row">
                <h3>Hóa đơn hoàn thành</h3>
                <span><%= invoices.size() %> hóa đơn</span>
            </div>
            <p>Danh sách và doanh thu chỉ tính các hóa đơn đã hoàn thành.</p>
            <% if (invoices.isEmpty()) { %>
                <div class="empty-state">Không có hóa đơn trong khoảng thời gian này.</div>
            <% } else { %>
                <div class="table-wrap">
                    <table class="data-table customer-invoice-table">
                        <thead><tr><th>TT</th><th>Mã đơn hàng</th><th>Mã HĐ</th><th>Ngày mua</th><th>Tổng tiền</th><th>Trạng thái</th><th></th></tr></thead>
                        <tbody>
                        <% int index = 1; for (Invoice1 invoice : invoices) { %>
                            <tr>
                                <td><%= index++ %></td>
                                <td><%= String.format("DH%03d", invoice.getInvoiceId()) %></td>
                                <td><%= escapeHtml(invoice.getInvoiceCode()) %></td>
                                <td><%= invoice.getCreatedAt().toLocalDate() %></td>
                                <td class="money"><%= money.format(invoice.getTotal()) %></td>
                                <td><span class="status-badge"><%= escapeHtml(invoice.getStatus()) %></span></td>
                                <td><a href="invoice-detail.jsp?id=<%= invoice.getInvoiceId() %>">Chi tiết</a></td>
                            </tr>
                        <% } %>
                        </tbody>
                        <tfoot><tr><td colspan="4" class="total-label">Tổng doanh thu:</td><td class="total-revenue"><strong><%= money.format(totalRevenue) %></strong></td><td colspan="2"></td></tr></tfoot>
                    </table>
                </div>
            <% } %>
        <% } %>
    </main>
</div>
</body>
</html>
