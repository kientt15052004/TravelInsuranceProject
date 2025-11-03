<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="Model.User" %>

<!-- ===== TẤT CẢ CSS VÀ BOOTSTRAP CHO TOÀN BỘ WEBSITE ===== -->

<!-- Bootstrap 5 & Icons (CDN) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<!-- FontAwesome for icons -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<!-- CSS Files -->
<link rel="stylesheet" href="./CSS/header.css"/>
<link rel="stylesheet" href="./CSS/footer.css"/>

<style>
    /* ===== GLOBAL CSS VARIABLES ===== */
    :root{
        --brand-yellow: #FFD54D;      /* vàng chủ đạo */
        --brand-yellow-soft:#FFF4CC;  /* vàng nhạt cho hover/badge outline */
        --brand-black:#111111;
        --primary-yellow: #FDB614;
        --dark-navy: #1a2332;
        --light-gray: #f8f9fa;
    }
    
    /* ===== GLOBAL BODY STYLES ===== */
    body {
        background:#fff;
        color:#111;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }

    /* ===== HEADER NAVBAR STYLES ===== */
    .navbar {
        background-color: #fff;
        border-bottom: 1px solid #e0e0e0;
        padding: 1rem 0;
    }
    
    .navbar-brand {
        font-size: 1.5rem;
        font-weight: bold;
        color: #ff9800 !important;
        text-decoration: none;
    }
    
    .navbar-brand:hover {
        color: #e68900 !important;
    }
    
    .nav-link {
        color: #666 !important;
        font-weight: 500;
        transition: color 0.3s;
    }
    
    .nav-link:hover {
        color: #ff9800 !important;
    }
    
    .btn-sign-in {
        background-color: var(--brand-yellow);
        border: 1px solid var(--brand-yellow);
        color: #000;
        font-weight: 600;
        padding: 0.5rem 1.5rem;
        border-radius: 0.5rem;
        transition: all 0.3s;
    }
    
    .btn-sign-in:hover {
        background-color: #e68900;
        border-color: #e68900;
        color: #000;
    }
    
    .dropdown-toggle {
        color: #666 !important;
        font-weight: 500;
    }
    
    .dropdown-toggle:hover {
        color: #ff9800 !important;
    }

    /* ===== COMMON BUTTON STYLES ===== */
    .btn-brand{
        background: var(--brand-yellow);
        border-color: var(--brand-yellow);
        color:#000;
        font-weight:600;
        border-radius: 0.5rem;
        transition: all 0.3s;
    }
    .btn-brand:hover{
        filter: brightness(0.95);
        color:#000;
    }

    /* ===== COMMON TABLE STYLES ===== */
    .table> :not(caption)>*>*{
        padding-top: 14px;
        padding-bottom:14px;
        vertical-align: middle;
    }
    .table thead th{
        color:#6b7280;
        font-weight:600;
        font-size:14px;
        background:#f8f9fa;
        position: sticky;
        top:0;
        z-index:1;
    }

    /* ===== COMMON FORM CONTROLS ===== */
    .form-control, .form-select{
        border-radius:10px;
    }
    .form-control:focus, .form-select:focus{
        border-color: var(--brand-yellow);
    }

    /* ===== COMMON PAGINATION ===== */
    .pagination .page-link{
        color:#111;
    }
    .pagination .page-item.active .page-link{
        background:var(--brand-yellow);
        border-color:var(--brand-yellow);
        color:#000;
    }

    /* ===== COMMON PAGE HEADER ===== */
    .page-header{
        padding: 32px 0 16px;
    }
    .page-header .title{
        font-weight:700;
        font-size:28px;
        margin-bottom:6px;
    }
    .page-header .subtitle{
        color:#6b7280;
    }

    /* ===== UTILITY CLASSES ===== */
    .text-brand-yellow {
        color: var(--brand-yellow) !important;
    }
    
    .bg-brand-yellow {
        background-color: var(--brand-yellow) !important;
    }
    
    .border-brand-yellow {
        border-color: var(--brand-yellow) !important;
    }

    /* ===== CONTAINER RỘNG CHO TOÀN BỘ WEBSITE ===== */
    .container {
        max-width: 95% !important;
        margin: 0 auto !important;
    }

    @media (min-width: 1200px) {
        .container {
            max-width: 1400px !important;
        }
    }

    @media (min-width: 1400px) {
        .container {
            max-width: 1600px !important;
        }
    }
</style>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
                <li class="nav-item mx-3"><a class="nav-link" href="purchased-insurance">Bảo Hiểm Đã Mua</a></li>
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
