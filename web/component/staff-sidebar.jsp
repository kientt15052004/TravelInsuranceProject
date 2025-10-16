<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Sidebar Component</title>
</head>
<body>
    <!-- Staff Sidebar Component -->
    <div class="sidebar">
        <nav class="sidebar-nav">
            <ul>
                <li class="nav-item ${param.activePage == 'dashboard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/staff" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
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
                    </a>
                </li>
                <li class="nav-item ${param.activePage == 'user-management' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/usermanagement" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Quản lý User</span>
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
