<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.User"%>
<%
    User user = (User) session.getAttribute("user");
    String displayName = (user != null && user.getFullname() != null) ? user.getFullname() : "Admin";
%>
<!-- Admin Header Fragment (no dropdown) -->
<div class="top-header">
    <div class="header-left">
        <div class="logo">
            <div class="logo-text">
                <span class="logo-main">Logo</span>
            </div>
        </div>
    </div>
    <div class="header-right">
        <div class="user-info">
            <i class="fas fa-user-circle"></i>
            <span><%= displayName %></span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-link">
                Đăng xuất
            </a>
        </div>
    </div>
</div>
