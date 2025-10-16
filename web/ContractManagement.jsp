<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Hợp Đồng - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/contractmanagement.css">
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
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/ContractManagementServlet" class="nav-link">
                            <i class="fas fa-file-contract"></i>
                            <span>Quản lý hợp đồng</span>
                        </a>
                    </li>
                    <li class="nav-item">
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
                <h1>Quản Lý Hợp Đồng Bảo Hiểm</h1>
                <p>Xem và quản lý tất cả hợp đồng bảo hiểm</p>
            </div>

            <!-- Search and Filter Section -->
            <div class="search-filter-section">
                <form method="GET" action="${pageContext.request.contextPath}/ContractManagementServlet" class="search-form">
                    <div class="search-row">
                        <div class="search-group">
                            <label for="search">Tìm kiếm:</label>
                            <input type="text" id="search" name="search" value="${searchTerm}" 
                                   placeholder="Tìm theo ID hợp đồng, tên sản phẩm, tên người mua...">
                        </div>
                        
                        <div class="filter-group">
                            <label for="status">Trạng thái:</label>
                            <select id="status" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Active" ${statusFilter == 'Active' ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                                <option value="Expired" ${statusFilter == 'Expired' ? 'selected' : ''}>Hết hạn</option>
                                <option value="Cancelled" ${statusFilter == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="product">Sản phẩm:</label>
                            <select id="product" name="product">
                                <option value="">Tất cả sản phẩm</option>
                                <c:forEach var="product" items="${products}">
                                    <option value="${product.id}" ${productFilter == product.id.toString() ? 'selected' : ''}>
                                        ${product.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-search">
                                <i class="fas fa-search"></i>
                                Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/ContractManagementServlet" class="btn btn-clear">
                                <i class="fas fa-times"></i>
                                Xóa bộ lọc
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Contracts Table -->
            <div class="contracts-table-section">
                <div class="table-header">
                    <h3>Danh sách hợp đồng bảo hiểm</h3>
                    <p>Tổng cộng: ${contracts.size()} hợp đồng</p>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>
                
                <div class="table-container">
                    <c:choose>
                        <c:when test="${not empty contracts}">
                            <table class="contracts-table">
                                <thead>
                                    <tr>
                                        <th>ID Hợp đồng</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Ngày kết thúc</th>
                                        <th>Thông tin người mua</th>
                                        <th>Tổng số tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="contract" items="${contracts}">
                                        <tr>
                                            <td>#${contract.contract_id}</td>
                                            <td>
                                                <div class="product-info">
                                                    <strong>${contract.productName}</strong>
                                                    <small class="product-type">${contract.productType}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <div class="buyer-info">
                                                    <div class="buyer-name"><strong>${contract.buyerName}</strong></div>
                                                    <div class="buyer-contact">
                                                        <small>📞 ${contract.buyerPhone}</small><br>
                                                        <small>📧 ${contract.buyerEmail}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="price-amount">
                                                    <fmt:formatNumber value="${contract.totalPrice}" type="currency" currencyCode="VND"/>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="status-text status-${contract.contract_status.toLowerCase()}">
                                                    ${contract.contract_status}
                                                </span>
                                            </td>
                                            <td class="actions-cell">
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/ContractDetailServlet?id=${contract.contract_id}" class="btn-sm btn-info" title="Xem chi tiết">
                                                        Xem chi tiết
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data">
                                <i class="fas fa-file-contract"></i>
                                <h3>Không có hợp đồng nào</h3>
                                <p>Không tìm thấy hợp đồng nào phù hợp với tiêu chí tìm kiếm.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
