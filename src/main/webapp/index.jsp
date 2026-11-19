<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="vn.shopman.dao.UserDAO" %>
<%@ page import="vn.shopman.model.User" %>

<%
    if (session.getAttribute("currentUser") != null) {
        response.sendRedirect("home.jsp");
        return;
    }

    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        username = username == null ? "" : username;
        password = password == null ? "" : password;

        try {
            User user = new UserDAO().authenticate(username, password);

            if (user == null) {
                error = "Tên đăng nhập hoặc mật khẩu không đúng, hoặc tài khoản đã khóa.";
            } else if (!"CUSTOMER".equals(user.getRole())
                    && !"MANAGER".equals(user.getRole())) {
                error = "Chức năng của tài khoản này đã được lược bỏ khỏi hệ thống.";
            } else {
                // Rotate the pre-authentication session id after successful login.
                request.changeSessionId();
                session.setAttribute("currentUser", user);
                response.sendRedirect("home.jsp");
                return;
            }
        } catch (SQLException exception) {
            application.log("Login error", exception);
            error = "Không thể kết nối cơ sở dữ liệu. Kiểm tra cấu hình MySQL.";
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập - ShopMan</title>
    <link rel="stylesheet" href="assets/css/style.css?v=2">
</head>
<body class="login-bg">
    <main class="login">
        <h1>SHOPMAN</h1>
        <p>Hệ thống quản lý bán hàng bách hóa</p>

        <% if (error != null) { %>
            <div class="alert">
                <%= error %>
            </div>
        <% } %>

        <form method="post">
            <label for="username">Tên đăng nhập</label>
            <input id="username" name="username" required autocomplete="username">

            <label for="password">Mật khẩu</label>
            <input
                id="password"
                type="password"
                name="password"
                required
                autocomplete="current-password"
            >

            <button type="submit">Đăng nhập</button>
        </form>

        <div class="demo">
            <b>Tài khoản dùng thử</b>
            <br>manager / Manager@123
            <br>customer / Customer@123
        </div>
    </main>
</body>
</html>
