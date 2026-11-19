<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="vn.shopman.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");

    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String role = user.getRole();

    if ("MANAGER".equals(role)) {
        response.sendRedirect("manager/home.jsp");
    } else if ("CUSTOMER".equals(role)) {
        String customerHome = Boolean.TRUE.equals(session.getAttribute("customerWelcomeSeen"))
                ? "customer/home.jsp"
                : "customer/welcome.jsp";
        response.sendRedirect(customerHome);
    } else {
        session.invalidate();
        response.sendRedirect("index.jsp?msg=role-disabled");
    }
%>
