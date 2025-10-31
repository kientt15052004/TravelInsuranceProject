<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="Model.User" %>

<nav class="navbar navbar-expand-lg shadow-sm">
    <div class="container d-flex justify-content-between align-items-center">
        <div class="navbar-left d-flex align-items-center">
            <a class="navbar-brand" href="home">
                <i class="fas fa-shield-alt"></i>
                InsureTravel
            </a>
        </div>
        <!-- Nút toggle (mobile) --> 
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="navbar-center collapse navbar-collapse justify-content-center" id="navbarNav">
            <ul class="navbar-nav flex-row justify-content-center">
                <li class="nav-item mx-3"><a class="nav-link" href="InsuranceList">Gói Bảo Hiểm</a></li>
                <li class="nav-item mx-3"><a class="nav-link" href="#">Khiếu Nại</a></li>
            </ul>
        </div>

        <div class="navbar-right d-flex justify-content-end">
            <%
                Model.User user = (Model.User) session.getAttribute("user");
                if (user == null) {
            %>
            <button class="btn btn-sign-in" onclick="window.location.href = 'login.jsp'">Đăng Nhập</button>
            <%
                } else {
            %>
            <div class="dropdown">
                <a class="d-flex align-items-center text-decoration-none dropdown-toggle" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <span><%= user.getFullname() %></span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#profileModal">Hồ Sơ</a></li>
                    <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#changePasswordModal">Đổi Mật Khẩu</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="logout">Đăng Xuất</a></li>
                </ul>
            </div>
            <%
                }
            %>
        </div>
    </div>  
</nav>
