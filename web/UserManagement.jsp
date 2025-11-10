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
    <jsp:include page="component/staff-header.jsp"/>

    <div class="container">
        <jsp:include page="component/staff-sidebar.jsp">
            <jsp:param name="activePage" value="user-management"/>
        </jsp:include>

        <div class="main-content">
            <div class="content-header">
                <h1>Quản Lý User</h1>
                <p>Xem và quản lý thông tin người dùng</p>
            </div>

            <div class="search-filter-section">
                <form method="GET" action="${pageContext.request.contextPath}/usermanagement" class="search-form">
                    <div class="search-row">
                        <div class="search-group">
                            <label for="keyword">Tìm kiếm:</label>
                            <input type="text" id="keyword" name="keyword" 
                                   placeholder="Tên, email hoặc username..." 
                                   value="${searchKeyword}">
                        </div>
                        
                        <div class="filter-group">
                            <label for="role">Vai trò:</label>
                            <select id="role" name="role">
                                <option value="all" ${searchRole == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="customer" ${searchRole == 'customer' ? 'selected' : ''}>Khách hàng</option>
                                <option value="staff" ${searchRole == 'staff' ? 'selected' : ''}>Nhân viên</option>
                                <option value="admin" ${searchRole == 'admin' ? 'selected' : ''}>Quản trị</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="status">Trạng thái:</label>
                            <select id="status" name="status">
                                <option value="all" ${searchStatus == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="active" ${searchStatus == 'active' ? 'selected' : ''}>Hoạt động</option>
                                <option value="inactive" ${searchStatus == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                            </select>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-search">
                                <i class="fas fa-search"></i>
                                Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/usermanagement" class="btn btn-clear">
                                <i class="fas fa-times"></i>
                                Xóa bộ lọc
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <div class="users-table-section">
                <div class="table-header">
                    <div class="table-title-section">
                        <h3>Danh sách User</h3>
                        <p>Tổng cộng: ${users.size()} người dùng</p>
                    </div>
                    <div class="page-size-container">
                        <label>Hiển thị: 
                            <select id="pageSizeSelect">
                                <option value="10">10</option>
                                <option value="20">20</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                            </select> người dùng/trang
                        </label>
                    </div>
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
                                            <td class="role-text role-${user.role}">
                                                <c:choose>
                                                    <c:when test="${user.role == 'customer'}">Khách hàng</c:when>
                                                    <c:when test="${user.role == 'staff'}">Nhân viên</c:when>
                                                    <c:when test="${user.role == 'admin'}">Quản trị</c:when>
                                                    <c:otherwise>${user.role}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="status-text status-${user.status}">
                                                <c:choose>
                                                    <c:when test="${user.status == 'active'}">Hoạt động</c:when>
                                                    <c:when test="${user.status == 'inactive'}">Không hoạt động</c:when>
                                                    <c:otherwise>${user.status}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="total-amount">
                                                <fmt:formatNumber value="${user.totalInsuranceAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> ₫
                                            </td>
                                            <td class="actions-cell">
                                                <div class="action-buttons">
                                                    <c:choose>
                                                        <c:when test="${currentUser.role == 'staff' && (user.role == 'admin' || user.role == 'staff')}">
                                                            <span class="btn-sm btn-info" style="opacity: 0.5; cursor: not-allowed; pointer-events: none;" title="Staff không có quyền xem chi tiết tài khoản admin/staff">
                                                                Xem chi tiết
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/usermanagement?action=detail&userId=${user.id}" 
                                                               class="btn-sm btn-info">
                                                                Xem chi tiết
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
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

<script>
document.addEventListener("DOMContentLoaded", function () {
    const userDropdown = document.querySelector('.user-dropdown');
    if (userDropdown) {
        userDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdown.classList.toggle('active');
        });
        
        document.addEventListener('click', function(e) {
            if (!userDropdown.contains(e.target)) {
                userDropdown.classList.remove('active');
            }
        });
    }
    const table = document.querySelector(".users-table");
    if (!table) return;

    const tbody = table.querySelector("tbody");
    const rows = Array.from(tbody.querySelectorAll("tr"));
    const paginationContainer = document.createElement("div");
    paginationContainer.classList.add("pagination-container");
    table.parentNode.appendChild(paginationContainer);


    let currentPage = 1;
    let pageSize = 10;

    function renderTable() {
        tbody.innerHTML = "";
        const start = (currentPage - 1) * pageSize;
        const end = start + pageSize;
        rows.slice(start, end).forEach(row => tbody.appendChild(row));
        renderPagination();
    }

    function renderPagination() {
        const totalPages = Math.ceil(rows.length / pageSize);
        paginationContainer.innerHTML = "";

        for (let i = 1; i <= totalPages; i++) {
            const btn = document.createElement("button");
            btn.textContent = i;
            btn.classList.add("page-btn");
            if (i === currentPage) btn.classList.add("active");
            btn.addEventListener("click", () => {
                currentPage = i;
                renderTable();
            });
            paginationContainer.appendChild(btn);
        }
    }

    document.getElementById("pageSizeSelect").addEventListener("change", function () {
        pageSize = parseInt(this.value);
        currentPage = 1;
        renderTable();
    });

    const headers = table.querySelectorAll("th");
    let sortOrder = 1;
    let sortedColumn = null;

    headers.forEach((th, index) => {
        const sortableColumns = [0, 2, 5, 6, 7];
        
        if (sortableColumns.includes(index)) {
            th.style.cursor = "pointer";
            th.addEventListener("click", () => {
                if (sortedColumn === index) sortOrder *= -1;
                else {
                    sortedColumn = index;
                    sortOrder = 1;
                }

                rows.sort((a, b) => {
                    const aText = a.children[index].textContent.trim();
                    const bText = b.children[index].textContent.trim();

                    switch(index) {
                        case 0:
                            const aId = parseInt(aText);
                            const bId = parseInt(bText);
                            return (aId - bId) * sortOrder;
                        
                        case 2:
                        case 5:
                        case 6:
                            return aText.localeCompare(bText, "vi") * sortOrder;
                        
                        case 7:
                            const aPrice = parsePrice(aText);
                            const bPrice = parsePrice(bText);
                            return (aPrice - bPrice) * sortOrder;
                        
                        default:
                            return 0;
                    }
                });

                renderTable();
                updateSortIcons(th, headers);
            });
        } else {
            th.style.cursor = "default";
        }
    });

    function parsePrice(priceStr) {
        let cleanPrice = priceStr.replace(/[₫\s]/g, '');
        
        cleanPrice = cleanPrice.replace(/\./g, '').replace(',', '.');
        
        return parseFloat(cleanPrice) || 0;
    }

    function updateSortIcons(activeTh, allThs) {
        allThs.forEach(th => {
            th.classList.remove("sorted-asc", "sorted-desc");
        });
        activeTh.classList.add(sortOrder === 1 ? "sorted-asc" : "sorted-desc");
    }

    renderTable();
});
</script>


</body>
</html>
