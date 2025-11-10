<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<body>
    <div class="sidebar">
        <nav class="sidebar-nav">
            <ul>
                <li class="nav-item ${param.activePage == 'dashboard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'home' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin" class="nav-link">
                        <span>Home Page</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'user-role-management' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/user-role-management" class="nav-link">
                        <span>Quản lý quyền tài khoản</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'product-management' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/create_product" class="nav-link">
                        <span>Tạo sản phẩm</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'view-products' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/view_product" class="nav-link">
                        <span>Quản lý sản phẩm</span>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</body>
</html>
