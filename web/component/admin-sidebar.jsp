<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<<<<<<< Updated upstream
<body>
=======
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Sidebar Component</title>
</head>
<body>
    <!-- Admin Sidebar Component -->
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
                <li class="nav-item has-dropdown ${param.activePage == 'product-management' ? 'active' : ''}">
                    <a href="#" class="nav-link">
                        <i class="fas fa-cube"></i>
                        <span>Product Management</span>
                        <i class="fas fa-chevron-down ms-auto"></i>
                    </a>
                    <div class="nav-dropdown">
                        <a href="${pageContext.request.contextPath}/navigate?page=create" class="nav-link">
                            <i class="fas fa-plus-circle"></i>
                            <span>Create Product</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/view_product" class="nav-link">
                            <i class="fas fa-eye"></i>
                            <span>View Products</span>
                        </a>
                    </div>
                </li>
                <li class="nav-item ${param.activePage == 'create-contract' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/CreateContractServlet" class="nav-link">
                        <i class="fas fa-plus-circle"></i>
                        <span>Tạo hợp đồng mới</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'contract-management' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/ContractManagementServlet" class="nav-link">
                        <i class="fas fa-file-contract"></i>
                        <span>Quản lý hợp đồng</span>
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'claims-management' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/ClaimsManagementServlet" class="nav-link">
                        <i class="fas fa-file-medical"></i>
                        <span>Quản lý bồi thường</span>
>>>>>>> Stashed changes
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
