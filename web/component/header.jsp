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

    .dropdown-menu {
        display: none;
        position: absolute;
        z-index: 1050 !important;
        pointer-events: auto !important;
    }

    .dropdown-menu.show {
        display: block !important;
    }

    .dropdown-toggle {
        cursor: pointer !important;
        pointer-events: auto !important;
    }

    .navbar-right {
        position: relative;
        z-index: 1040;
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
                <button class="btn btn-link text-decoration-none p-0 d-flex align-items-center" 
                        type="button" 
                        id="userDropdown" 
                        data-bs-toggle="dropdown" 
                        aria-expanded="false"
                        style="color: #666; font-weight: 500;">
                    <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                    <img src="<%= user.getAvatar() %>" alt="Avatar" class="rounded-circle me-2" style="width: 32px; height: 32px; object-fit: cover; border: 2px solid #e0e0e0;">
                    <% } else { %>
                    <i class="bi bi-person-circle me-2" style="font-size: 32px;"></i>
                    <% } %>
                    <span><%= user.getFullname() %></span>
                    <i class="bi bi-chevron-down ms-2"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#profileModal">
                            <i class="bi bi-person me-2"></i>Hồ Sơ
                        </a></li>
                    <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                            <i class="bi bi-key me-2"></i>Đổi Mật Khẩu
                        </a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng Xuất
                        </a></li>
                </ul>
            </div>
            <%
                }
            %>
        </div>
    </div>  
</nav>

<!-- Profile Modal -->
<div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg"> 
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="profileModalLabel">Hồ Sơ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data"> <!-- multipart nếu upload avatar/CCCD -->
                <div class="modal-body">
                    <div class="row g-3">
                        <!-- Avatar -->
                        <div class="col-md-3 text-center">
                            <label class="form-label fw-semibold d-block mb-2">Ảnh đại diện</label>
                            <c:if test="${not empty user.avatar}">
                                <img id="avatarPreview" src="<c:out value='${user.avatar}' />" alt="Ảnh đại diện" class="img-fluid avatar-image mb-2">
                            </c:if>
                            <c:if test="${empty user.avatar}">
                                <img id="avatarPreview" src="" alt="Ảnh đại diện" class="img-fluid avatar-image mb-2" style="display: none;">
                            </c:if>
                            <input type="file" name="avatar" class="form-control mt-1" accept="image/*" onchange="previewImage(this, 'avatarPreview')">
                        </div>

                        <div class="col-md-9">
                            <input type="hidden" name="id" value="<c:out value='${user.id}' />">

                            <div class="mb-2">
                                <label class="form-label fw-semibold">Họ và Tên:</label>
                                <input type="text" class="form-control" name="fullname" value="<c:out value='${user.fullname}' />" required>
                            </div>

                            <div class="mb-2">
                                <label class="form-label fw-semibold">Email:</label>
                                <input type="email" class="form-control" name="mail" value="<c:out value='${user.mail}' />" required>
                            </div>

                            <div class="mb-2">
                                <label class="form-label fw-semibold">Ngày Sinh:</label>
                                <input type="date" class="form-control" name="dob" value="<c:out value='${user.dob}' />">
                            </div>

                            <div class="mb-2">
                                <label class="form-label fw-semibold">Địa Chỉ:</label>
                                <input type="text" class="form-control" name="address" value="<c:out value='${user.address}' />">
                            </div>

                            <div class="mb-2">
                                <label class="form-label fw-semibold">Số Điện Thoại:</label>
                                <input type="text" class="form-control" name="phone" value="<c:out value='${user.phone}' />">
                            </div>

                            <div class="mb-2">
                                <label class="form-label fw-semibold">Số CCCD:</label>
                                <input type="text" class="form-control" name="cccd" value="<c:out value='${user.cccd}' />">
                            </div>

                            <!-- CCCD Image -->
                            <div class="mb-2">
                                <label class="form-label fw-semibold">Ảnh CCCD:</label>
                                <c:if test="${not empty user.cccd_img}">
                                    <img id="cccdPreview" src="<c:out value='${user.cccd_img}' />" alt="Ảnh CCCD" class="img-fluid mt-1 mb-1">
                                </c:if>
                                <input type="file" name="cccd_img" class="form-control mt-1" onchange="previewImage(this, 'cccdPreview')">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Cập Nhật Hồ Sơ</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Change Password Modal -->
<div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="changePasswordModalLabel">Đổi Mật Khẩu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="ChangePasswordServlet" method="post">
                    <div class="mb-3">
                        <label class="form-label">Mật Khẩu Hiện Tại</label>
                        <input type="password" class="form-control" name="currentPassword" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mật Khẩu Mới</label>
                        <input type="password" class="form-control" name="newPassword" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Xác Nhận Mật Khẩu Mới</label>
                        <input type="password" class="form-control" name="confirmPassword" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </form>
            </div>
        </div>
    </div>
</div>

<c:if test="${not empty swalMessage}">
    <script>
        Swal.fire({
            icon: '<c:out value="${swalIcon}" />',
            title: '<c:out value="${swalMessage}" />',
            showConfirmButton: true,
            timer: 3000
        });

        // Nếu thất bại ở modal nào đó, mở lại modal tương ứng
        <c:choose>
            <c:when test="${swalIcon == 'error' && swalMessage == 'Current password is incorrect!' || swalMessage == 'New password and confirm password do not match!'}">
        var changeModal = new bootstrap.Modal(document.getElementById('changePasswordModal'));
        changeModal.show();
            </c:when>
            <c:when test="${swalIcon == 'error' && swalMessage == 'Failed to update profile. Please try again.'}">
        var profileModal = new bootstrap.Modal(document.getElementById('profileModal'));
        profileModal.show();
            </c:when>
        </c:choose>
    </script>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


<script>
        function previewImage(input, previewId) {
            const file = input.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const previewImg = document.getElementById(previewId);
                    previewImg.src = e.target.result;
                    previewImg.style.display = 'block';
                }
                reader.readAsDataURL(file);
            }
        }
</script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const dropdownBtn = document.querySelector('#userDropdown');
        const dropdownMenu = document.querySelector('#userDropdown + .dropdown-menu');

        if (dropdownBtn && dropdownMenu) {
            dropdownBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();

                const isShown = dropdownMenu.classList.contains('show');

                document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                    menu.classList.remove('show');
                });

                if (!isShown) {
                    dropdownMenu.classList.add('show');
                    dropdownBtn.setAttribute('aria-expanded', 'true');
                } else {
                    dropdownMenu.classList.remove('show');
                    dropdownBtn.setAttribute('aria-expanded', 'false');
                }
            });

            document.addEventListener('click', function (e) {
                if (!dropdownBtn.contains(e.target) && !dropdownMenu.contains(e.target)) {
                    dropdownMenu.classList.remove('show');
                    dropdownBtn.setAttribute('aria-expanded', 'false');
                }
            });
        }
    });
</script>
