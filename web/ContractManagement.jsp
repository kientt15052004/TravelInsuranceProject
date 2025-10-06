<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/CreateContractServlet" class="nav-link">
                            <span>Tạo hợp đồng mới</span>
                        </a>
                    </li>
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/ContractManagementServlet" class="nav-link">
                            <span>Quản lý hợp đồng</span>
                        </a>
                    </li>
                </ul>
            </nav>
            <div class="sidebar-footer">
                <!-- Empty footer for now -->
            </div>
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
                                   placeholder="Tìm theo ID hợp đồng, ID đơn đăng ký, mô tả...">
                        </div>
                        
                        <div class="filter-group">
                            <label for="status">Trạng thái:</label>
                            <select id="status" name="status">
                                <option value="">Tất cả trạng thái</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="product">Sản phẩm:</label>
                            <select id="product" name="product">
                                <option value="">Tất cả sản phẩm</option>
                                <c:forEach var="product" items="${products}">
                                    <option value="${product.id}" ${productFilter == product.id ? 'selected' : ''}>
                                        ${product.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            
                        </div>
                        
                        <div class="filter-group">

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
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/JS/staff.js"></script>
    <script>
        function viewContract(contractId) {
            // Implement view contract functionality
            alert('Xem chi tiết hợp đồng ID: ' + contractId);
        }
        
        function editContract(contractId) {
            // Implement edit contract functionality
            alert('Chỉnh sửa hợp đồng ID: ' + contractId);
        }
        
        function toggleStatusDropdown(contractId) {
            const dropdown = document.getElementById('statusDropdown' + contractId);
            const allDropdowns = document.querySelectorAll('.dropdown-menu');
            
            // Close all other dropdowns
            allDropdowns.forEach(d => {
                if (d.id !== 'statusDropdown' + contractId) {
                    d.style.display = 'none';
                }
            });
            
            // Toggle current dropdown
            if (dropdown.style.display === 'block') {
                dropdown.style.display = 'none';
            } else {
                dropdown.style.display = 'block';
            }
        }
        
        // Close dropdowns when clicking outside
        document.addEventListener('click', function(event) {
            if (!event.target.closest('.status-dropdown')) {
                document.querySelectorAll('.dropdown-menu').forEach(dropdown => {
                    dropdown.style.display = 'none';
                });
            }
        });
    </script>
</body>
</html>
