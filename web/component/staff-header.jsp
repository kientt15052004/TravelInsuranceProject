<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Staff Header Fragment (no dropdown) -->
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
            <span>Staff</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-link">Đăng xuất</a>
        </div>
    </div>
</div>
