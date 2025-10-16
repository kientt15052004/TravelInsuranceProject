<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý User - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/usermanagement.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="header-left">
            <div class="logo">
                <div class="logo-text">
                    <span class="logo-main">Logo</span>
                </div>
            </div>
        </div>
        <div class="header-right">
            <div class="user-dropdown">
                <div class="user-info">
                    <i class="fas fa-user-circle"></i>
                    <span>Staff</span>
                </div>
                <i class="fas fa-chevron-down dropdown-arrow"></i>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                        <i class="fas fa-sign-out-alt"></i>
                        Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <nav class="sidebar-nav">
                <ul>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/staff" class="nav-link">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CreateContractServlet" class="nav-link">
                            <i class="fas fa-plus-circle"></i>
                            <span>Tạo hợp đồng mới</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/ContractManagementServlet" class="nav-link">
                            <i class="fas fa-file-contract"></i>
                            <span>Quản lý hợp đồng</span>
                        </a>
                    </li>
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/usermanagement" class="nav-link">
                            <i class="fas fa-users"></i>
                            <span>Quản lý User</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Quản Lý User</h1>
                <p>Xem và quản lý thông tin người dùng</p>
            </div>

            <!-- Search Form -->
            <div class="search-section">
                <form method="GET" action="${pageContext.request.contextPath}/usermanagement" class="search-form">
                    <div class="search-row">
                        <div class="search-group">
                            <label for="keyword">Tìm kiếm:</label>
                            <input type="text" id="keyword" name="keyword" 
                                   placeholder="Tên, email hoặc username..." 
                                   value="${searchKeyword}">
                        </div>
                        <div class="search-group">
                            <label for="role">Vai trò:</label>
                            <select id="role" name="role">
                                <option value="all" ${searchRole == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="customer" ${searchRole == 'customer' ? 'selected' : ''}>Khách hàng</option>
                                <option value="staff" ${searchRole == 'staff' ? 'selected' : ''}>Nhân viên</option>
                                <option value="admin" ${searchRole == 'admin' ? 'selected' : ''}>Quản trị</option>
                            </select>
                        </div>
                        <div class="search-group">
                            <label for="status">Trạng thái:</label>
                            <select id="status" name="status">
                                <option value="all" ${searchStatus == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="active" ${searchStatus == 'active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="inactive" ${searchStatus == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>
                        <div class="search-group">
                            <button type="submit" class="btn-search">
                                <i class="fas fa-search"></i>
                                Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/usermanagement" class="btn-clear">
                                <i class="fas fa-times"></i>
                                Xóa bộ lọc
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Users Table -->
            <div class="table-section">
                <div class="table-header">
                    <h3>Danh sách User (${users.size()} người dùng)</h3>
                </div>
                
                <c:choose>
                    <c:when test="${empty users}">
                        <div class="no-data">
                            <i class="fas fa-users"></i>
                            <p>Không tìm thấy user nào</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-container">
                            <table class="users-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Username</th>
                                        <th>Họ tên</th>
                                        <th>Email</th>
                                        <th>Số điện thoại</th>
                                        <th>Vai trò</th>
                                        <th>Trạng thái</th>
                                        <th>Tổng số tiền mua bảo hiểm</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.username}</td>
                                            <td>${user.fullname}</td>
                                            <td>${user.mail}</td>
                                            <td>${user.phone}</td>
                                            <td>
                                                <span class="role-badge role-${user.role}">
                                                    <c:choose>
                                                        <c:when test="${user.role == 'customer'}">Khách hàng</c:when>
                                                        <c:when test="${user.role == 'staff'}">Nhân viên</c:when>
                                                        <c:when test="${user.role == 'admin'}">Quản trị</c:when>
                                                        <c:otherwise>${user.role}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="status-badge status-${user.status}">
                                                    <c:choose>
                                                        <c:when test="${user.status == 'active'}">Hoạt động</c:when>
                                                        <c:when test="${user.status == 'inactive'}">Không hoạt động</c:when>
                                                        <c:otherwise>${user.status}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="total-amount">
                                                <fmt:formatNumber value="${user.totalInsuranceAmount}" type="currency" currencyCode="VND"/>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/usermanagement?action=detail&userId=${user.id}" 
                                                   class="btn-detail">
                                                    <i class="fas fa-eye"></i>
                                                    Xem chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
