<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="vn.shopman.dao.StatCustomerDAO1" %>
<%@ page import="vn.shopman.model.StatCustomer1" %>

<%
    request.setAttribute("requiredRole", "MANAGER");
%>

<%@ include file="/WEB-INF/views/common/auth.jspf" %>

<%
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    LocalDate start = null;
    LocalDate end = null;
    String error = null;
    List<StatCustomer1> rows = new ArrayList<>();
    NumberFormat money = NumberFormat.getNumberInstance(Locale.forLanguageTag("vi-VN"));
    money.setMaximumFractionDigits(0);

    try {
        if (startDate == null || startDate.isBlank() || endDate == null || endDate.isBlank()) {
            throw new IllegalArgumentException("Vui lòng chọn đầy đủ ngày bắt đầu và ngày kết thúc.");
        }

        start = LocalDate.parse(startDate);
        end = LocalDate.parse(endDate);

        if (end.isBefore(start)) {
            throw new IllegalArgumentException("Ngày kết thúc phải sau ngày bắt đầu.");
        }

        rows = new StatCustomerDAO1().statisticsCustomerByRevenue(start, end);
    } catch (DateTimeParseException exception) {
        error = "Ngày không hợp lệ. Vui lòng chọn lại khoảng thời gian.";
    } catch (IllegalArgumentException exception) {
        error = exception.getMessage();
    } catch (SQLException exception) {
        application.log("Customer revenue statistics error", exception);
        error = "Không tải được dữ liệu thống kê. Vui lòng thử lại.";
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả thống kê khách hàng</title>
    <link rel="stylesheet" href="../assets/css/style.css?v=2">
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <div class="layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <main class="content">
            <h2>Thống kê khách hàng theo doanh thu</h2>

            <form action="statistics-result.jsp" method="get" class="filters">
                <label>
                    Từ ngày
                    <input type="date" name="startDate" value="<%= start == null ? "" : start %>" required>
                </label>

                <label>
                    Đến ngày
                    <input type="date" name="endDate" value="<%= end == null ? "" : end %>" required>
                </label>

                <button type="submit">Thống kê</button>
            </form>

            <% if (error != null) { %>
                <div class="alert"><%= error %></div>
            <% } else { %>
                <p>
                    Khoảng thời gian:
                    <b><%= start %></b> đến <b><%= end %></b>
                </p>
                <p>Doanh thu và số hóa đơn chỉ tính hóa đơn đã hoàn thành; đơn đang xử lý, đã bàn giao hoặc đã hủy chưa được tính.</p>

                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã KH</th>
                                <th>Họ tên</th>
                                <th>Điện thoại</th>
                                <th>Email</th>
                                <th>Số hóa đơn hoàn thành</th>
                                <th>Doanh thu</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (StatCustomer1 row : rows) { %>
                                <tr>
                                    <td><%= escapeHtml(row.getCustomerCode()) %></td>
                                    <td><%= escapeHtml(row.getFullName()) %></td>
                                    <td><%= escapeHtml(row.getPhone() == null ? "-" : row.getPhone()) %></td>
                                    <td><%= escapeHtml(row.getEmail() == null ? "-" : row.getEmail()) %></td>
                                    <td><%= row.getInvoiceCount() %></td>
                                    <td class="money"><%= money.format(row.getRevenue()) %></td>
                                    <td>
                                        <a href="customer-detail.jsp?id=<%= row.getCustomerId() %>&startDate=<%= start %>&endDate=<%= end %>">
                                            Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <% if (rows.isEmpty()) { %>
                    <p>Không có dữ liệu trong khoảng thời gian đã chọn.</p>
                <% } %>
            <% } %>
        </main>
    </div>
</body>
</html>
