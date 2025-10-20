<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<body>
    <div class="sidebar">
        <nav class="sidebar-nav">
            <ul>
                <li class="nav-item ${param.activePage == 'home' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/navigate?page=home" class="nav-link">
                        <i class="fas fa-home"></i>
                        <span>Home Page</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'user-management' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/navigate?page=user" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>User Management</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'daily-report' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/navigate?page=report" class="nav-link">
                        <i class="fas fa-chart-bar"></i>
                        <span>Daily Report</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'product-management' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/navigate?page=create" class="nav-link">
                        <i class="fas fa-plus-circle"></i>
                        <span>Tạo sản phẩm</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'view-products' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/view_product" class="nav-link">
                        <i class="fas fa-eye"></i>
                        <span>Quản lý sản phẩm</span>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="sidebar-footer">
            <!-- Empty footer for now -->
        </div>
    </div>
</body>
</html>
