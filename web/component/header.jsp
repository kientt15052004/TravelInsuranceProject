<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="Model.User" %>

<!-- Bootstrap 5 & Icons (CDN) - CHỈ CSS, KHÔNG DÙNG JS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<!-- CSS Files -->
<link rel="stylesheet" href="./CSS/header.css"/>
<link rel="stylesheet" href="./CSS/footer.css"/>
<link rel="stylesheet" href="./CSS/statuses.css"/>

<style>
    /* ===== GLOBAL CSS VARIABLES ===== */
    :root{
        --brand-yellow: #FFD54D;
        --brand-yellow-soft:#FFF4CC;
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
        background: linear-gradient(to bottom, #ffffff 0%, #fafafa 100%);
        border-bottom: 2px solid var(--brand-yellow);
        padding: 1.25rem 0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    .navbar-brand {
        font-size: 1.75rem;
        font-weight: 700;
        background: linear-gradient(135deg, #ff9800 0%, #ff6b00 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-decoration: none;
        letter-spacing: -0.5px;
        transition: all 0.3s ease;
    }

    .navbar-brand:hover {
        transform: scale(1.05);
        filter: brightness(1.1);
    }

    .nav-link {
        color: #555 !important;
        font-weight: 600;
        font-size: 15px;
        padding: 0.5rem 1rem !important;
        border-radius: 6px;
        transition: all 0.3s ease;
        position: relative;
    }

    .nav-link::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        width: 0;
        height: 2px;
        background: var(--brand-yellow);
        transition: all 0.3s ease;
        transform: translateX(-50%);
    }

    .nav-link:hover {
        color: #ff9800 !important;
        background-color: rgba(255, 184, 0, 0.1);
    }

    .nav-link:hover::after {
        width: 80%;
    }

    .btn-sign-in {
        background: linear-gradient(135deg, var(--brand-yellow) 0%, #ffc107 100%);
        border: none;
        color: #000;
        font-weight: 700;
        padding: 0.65rem 2rem;
        border-radius: 25px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(255, 184, 0, 0.3);
        text-transform: uppercase;
        font-size: 14px;
        letter-spacing: 0.5px;
    }

    .btn-sign-in:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(255, 184, 0, 0.4);
        background: linear-gradient(135deg, #ffc107 0%, var(--brand-yellow) 100%);
    }

    /* ===== DROPDOWN THU?N CSS/JS ===== */
    .user-dropdown {
        position: relative;
    }

    .dropdown-trigger {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        background: #f8f9fa;
        border: 1px solid #e0e0e0;
        border-radius: 4px;
        color: #333;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
    }

    .dropdown-trigger:hover {
        background: #e9ecef;
        border-color: #ff9800;
        color: #ff9800;
    }

    .dropdown-trigger.active {
        background: #e9ecef;
        border-color: #ff9800;
        color: #ff9800;
    }

    .dropdown-trigger .chevron {
        font-size: 12px;
        transition: transform 0.3s ease;
    }

    .dropdown-trigger.active .chevron {
        transform: rotate(180deg);
    }

    .dropdown-menu-custom {
        position: absolute;
        top: calc(100% + 8px);
        right: 0;
        min-width: 200px;
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 4px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        padding: 8px 0;
        list-style: none;
        margin: 0;
        z-index: 1050;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.3s ease;
    }

    .dropdown-menu-custom.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .dropdown-menu-custom .dropdown-item-custom {
        display: flex;
        align-items: center;
        padding: 10px 16px;
        color: #333;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.2s ease;
    }

    .dropdown-menu-custom .dropdown-item-custom:hover {
        background-color: #f8f9fa;
        color: #ff9800;
    }

    .dropdown-menu-custom .dropdown-item-custom i {
        margin-right: 8px;
        width: 16px;
    }

    .dropdown-menu-custom .dropdown-divider-custom {
        height: 1px;
        margin: 8px 0;
        background: #e0e0e0;
        border: none;
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

    /* ===== CONTAINER R?NG CHO TOÀN B? WEBSITE ===== */
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

    /* ===== MODAL STYLES ===== */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9998;
        animation: fadeIn 0.3s ease;
    }

    .modal-overlay.show {
        display: block;
    }

    .modal-custom {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        z-index: 9999;
        background: white;
        border-radius: 8px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        max-width: 90%;
        max-height: 90vh;
        overflow-y: auto;
        animation: modalSlideIn 0.3s ease;
    }

    .modal-custom.show {
        display: block;
    }

    .modal-custom.modal-lg {
        width: 800px;
    }

    .modal-custom.modal-md {
        width: 500px;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }

    @keyframes modalSlideIn {
        from {
            opacity: 0;
            transform: translate(-50%, -60%);
        }
        to {
            opacity: 1;
            transform: translate(-50%, -50%);
        }
    }

    .modal-header-custom {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1.25rem;
        border-bottom: 1px solid #e0e0e0;
    }

    .modal-title-custom {
        margin: 0;
        font-size: 1.25rem;
        font-weight: 600;
    }

    .modal-close {
        font-size: 1.5rem;
        line-height: 1;
        color: #666;
        cursor: pointer;
        border: none;
        background: none;
        padding: 0;
        width: 30px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: color 0.3s;
    }

    .modal-close:hover {
        color: #000;
    }

    .modal-body-custom {
        padding: 1.25rem;
    }

    .modal-footer-custom {
        display: flex;
        justify-content: flex-end;
        gap: 0.5rem;
        padding: 1rem 1.25rem;
        border-top: 1px solid #e0e0e0;
    }
</style>

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
                <li class="nav-item mx-3"><a class="nav-link" href="my-claims">Khiếu Nại</a></li>
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
            <div class="user-dropdown">
                <div class="dropdown-trigger" id="userDropdownTrigger">
                    <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                    <img src="<%= user.getAvatar() %>" alt="Avatar" class="rounded-circle" style="width: 32px; height: 32px; object-fit: cover; border: 2px solid #e0e0e0;">
                    <% } else { %>
                    <i class="bi bi-person-circle" style="font-size: 32px;"></i>
                    <% } %>
                    <span><%= user.getFullname() %></span>
                    <i class="bi bi-chevron-down chevron"></i>
                </div>
                <ul class="dropdown-menu-custom" id="userDropdownMenu">
                    <li><a class="dropdown-item-custom" href="#" onclick="openModal('profileModal'); return false;">
                            <i class="bi bi-person"></i>Hồ Sơ
                        </a></li>
                    <li><a class="dropdown-item-custom" href="#" onclick="openModal('changePasswordModal'); return false;">
                            <i class="bi bi-key"></i>Đổi Mật Khẩu
                        </a></li>
                    <li><hr class="dropdown-divider-custom"></li>
                    <li><a class="dropdown-item-custom" href="logout">
                            <i class="bi bi-box-arrow-right"></i>Đăng Xuất
                        </a></li>
                </ul>
            </div>
            <%
                }
            %>
        </div>
    </div>  
</nav>


<!-- Modal Overlay -->
<div class="modal-overlay" id="modalOverlay" onclick="closeAllModals()"></div>

<!-- Profile Modal -->
<div class="modal-custom modal-lg" id="profileModal">
    <div class="modal-header-custom">
        <h5 class="modal-title-custom">Hồ Sơ</h5>
        <button class="modal-close" onclick="closeModal('profileModal')">&times;</button>
    </div>
    <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data">
        <div class="modal-body-custom">
            <div class="row g-3">
                <div class="col-md-3 text-center">
                    <label class="form-label fw-semibold d-block mb-2">Ảnh Đại Diện</label>
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
                        <input type="text" class="form-control" name="fullname" value="<c:out value='${user.fullname}' />">
                    </div>
                    <div class="mb-2">
                        <label class="form-label fw-semibold">Email:</label>
                        <input type="text" class="form-control" name="mail" value="<c:out value='${user.mail}' />">
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
        <div class="modal-footer-custom">
            <button type="button" class="btn btn-secondary" onclick="closeModal('profileModal')">Đóng</button>
            <button type="submit" class="btn btn-primary">Cập Nhật Hồ Sơ</button>
        </div>
    </form>
</div>

<!-- Change Password Modal -->
<div class="modal-custom modal-md" id="changePasswordModal">
    <div class="modal-header-custom">
        <h5 class="modal-title-custom">Đổi Mật Khẩu</h5>
        <button class="modal-close" onclick="closeModal('changePasswordModal')">&times;</button>
    </div>
    <form action="ChangePasswordServlet" method="post">
        <div class="modal-body-custom">
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
        </div>
        <div class="modal-footer-custom">
            <button type="button" class="btn btn-secondary" onclick="closeModal('changePasswordModal')">Đóng</button>
            <button type="submit" class="btn btn-primary">Lưu</button>
        </div>
    </form>
</div>


<c:if test="${not empty swalMessage}">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
                Swal.fire({
                    icon: '<c:out value="${swalIcon}" />',
                    title: '<c:out value="${swalMessage}" />',
                    showConfirmButton: true,
                    timer: 3000
                });

        <c:choose>
            <c:when test="${swalIcon == 'error' && (swalMessage == 'Mật khẩu hiện tại không đúng!' || swalMessage == 'Mật khẩu mới và mật khẩu xác nhận không khớp!')}">
                setTimeout(() => openModal('changePasswordModal'), 500);
            </c:when>
            <c:when test="${swalIcon == 'error' && swalMessage == 'Không cập nhật được hồ sơ. Vui lòng thử lại.'}">
                setTimeout(() => openModal('profileModal'), 500);
            </c:when>
        </c:choose>
    </script>
</c:if>

<script>
// Dropdown functionality
    const dropdownTrigger = document.getElementById('userDropdownTrigger');
    const dropdownMenu = document.getElementById('userDropdownMenu');

    if (dropdownTrigger && dropdownMenu) {
        dropdownTrigger.addEventListener('click', function (e) {
            e.stopPropagation();
            const isOpen = dropdownMenu.classList.contains('show');

            if (isOpen) {
                dropdownMenu.classList.remove('show');
                dropdownTrigger.classList.remove('active');
            } else {
                dropdownMenu.classList.add('show');
                dropdownTrigger.classList.add('active');
            }
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function (e) {
            if (!dropdownTrigger.contains(e.target) && !dropdownMenu.contains(e.target)) {
                dropdownMenu.classList.remove('show');
                dropdownTrigger.classList.remove('active');
            }
        });
    }

// Modal functionality
    function openModal(modalId) {
        const modal = document.getElementById(modalId);
        const overlay = document.getElementById('modalOverlay');

        if (modal && overlay) {
            modal.classList.add('show');
            overlay.classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        // Close dropdown if open
        if (dropdownMenu) {
            dropdownMenu.classList.remove('show');
            dropdownTrigger.classList.remove('active');
        }
    }

    function closeModal(modalId) {
        const modal = document.getElementById(modalId);
        const overlay = document.getElementById('modalOverlay');

        if (modal && overlay) {
            modal.classList.remove('show');
            overlay.classList.remove('show');
            document.body.style.overflow = '';
        }
    }

    function closeAllModals() {
        const modals = document.querySelectorAll('.modal-custom');
        const overlay = document.getElementById('modalOverlay');

        modals.forEach(modal => modal.classList.remove('show'));
        if (overlay)
            overlay.classList.remove('show');
        document.body.style.overflow = '';
    }

// Preview image function
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

// Close modal with Escape key
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeAllModals();
        }
    });


</script>

<script src="./JS/ValidateProfile.js"></script>