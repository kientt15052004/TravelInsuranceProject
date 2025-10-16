<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Bồi Thường - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/claimsmanagement.css">
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
        <jsp:include page="component/staff-sidebar.jsp">
            <jsp:param name="activePage" value="claims-management"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Quản Lý Bồi Thường</h1>
                <p>Xem và quản lý tất cả yêu cầu bồi thường</p>
            </div>

            <!-- Search and Filter Section -->
            <div class="search-filter-section">
                <form method="GET" action="${pageContext.request.contextPath}/ClaimsManagementServlet" class="search-form">
                    <div class="search-row">
                        <div class="search-group">
                            <label for="search">Tìm kiếm:</label>
                            <input type="text" id="search" name="search" value="${searchTerm}" 
                                   placeholder="Tìm theo Contract ID hoặc mô tả...">
                        </div>
                        
                        <div class="filter-group">
                            <label for="status">Trạng thái:</label>
                            <select id="status" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                                <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Đã duyệt</option>
                                <option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="type">Loại bồi thường:</label>
                            <select id="type" name="type">
                                <option value="">Tất cả loại</option>
                                <c:forEach var="claimType" items="${claimTypes}">
                                    <option value="${claimType}" ${typeFilter == claimType ? 'selected' : ''}>
                                        ${claimType}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-search">
                                <i class="fas fa-search"></i>
                                Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/ClaimsManagementServlet" class="btn btn-clear">
                                <i class="fas fa-times"></i>
                                Xóa bộ lọc
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Claims Table -->
            <div class="claims-table-section">
                <div class="table-header">
                    <div class="table-title-section">
                        <h3>Danh sách yêu cầu bồi thường</h3>
                        <p>Tổng cộng: ${claims.size()} yêu cầu</p>
                    </div>
                    <div class="page-size-container">
                        <label>Hiển thị: 
                            <select id="pageSizeSelect">
                                <option value="10">10</option>
                                <option value="20">20</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                            </select> yêu cầu/trang
                        </label>
                    </div>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>
                
                <div class="table-container">
                    <c:choose>
                        <c:when test="${not empty claims}">
                            <table class="claims-table">
                                 <thead>
                                     <tr>
                                         <th>ID Claim</th>
                                         <th>Contract ID</th>
                                         <th>Ngày yêu cầu</th>
                                         <th>Loại bồi thường</th>
                                         <th>Mô tả</th>
                                         <th>Trạng thái</th>
                                         <th>Thao tác</th>
                                     </tr>
                                 </thead>
                                <tbody>
                                    <c:forEach var="claim" items="${claims}">
                                        <tr>
                                            <td>#${claim.id}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/ContractDetailServlet?id=${claim.contract_id}" 
                                                   class="contract-link">
                                                    #${claim.contract_id}
                                                </a>
                                            </td>
                                            <td><fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <span class="claim-type">${claim.claim_type}</span>
                                            </td>
                                             <td>
                                                 <div class="description-cell">
                                                     <c:choose>
                                                         <c:when test="${fn:length(claim.description) > 50}">
                                                             <span class="description-preview">${fn:substring(claim.description, 0, 50)}...</span>
                                                             <span class="description-full" style="display: none;">${claim.description}</span>
                                                             <button class="btn-toggle-description" onclick="toggleDescription(this)">
                                                                 <i class="fas fa-eye"></i>
                                                             </button>
                                                         </c:when>
                                                         <c:otherwise>
                                                             ${claim.description}
                                                         </c:otherwise>
                                                     </c:choose>
                                                 </div>
                                             </td>
                                             <td>
                                                 <span class="status-badge status-${claim.claim_status.toLowerCase()}">
                                                     ${claim.claim_status}
                                                 </span>
                                             </td>
                                             <td class="actions-cell">
                                                 <div class="action-buttons">
                                                      <a href="" class="btn-sm btn-info">
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
                                <i class="fas fa-file-medical"></i>
                                <h3>Không có yêu cầu bồi thường nào</h3>
                                <p>Không tìm thấy yêu cầu bồi thường nào phù hợp với tiêu chí tìm kiếm.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    // User dropdown functionality
    const userDropdown = document.querySelector('.user-dropdown');
    if (userDropdown) {
        userDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdown.classList.toggle('active');
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!userDropdown.contains(e.target)) {
                userDropdown.classList.remove('active');
            }
        });
    }
    const table = document.querySelector(".claims-table");
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

    // ==== SORT ====
    const headers = table.querySelectorAll("th");
    let sortOrder = 1; // 1 = asc, -1 = desc
    let sortedColumn = null;

     headers.forEach((th, index) => {
         // Chỉ cho phép sort các cột: ID (0), Contract ID (1), Ngày yêu cầu (2), Trạng thái (5)
         const sortableColumns = [0, 1, 2, 5];
        
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

                    // Xử lý sort cho từng loại cột
                    switch(index) {
                        case 0: // ID Claim
                        case 1: // Contract ID
                            const aId = parseInt(aText.replace('#', ''));
                            const bId = parseInt(bText.replace('#', ''));
                            return (aId - bId) * sortOrder;
                        
                        case 2: // Ngày yêu cầu
                            const aDate = parseDate(aText);
                            const bDate = parseDate(bText);
                            if (aDate && bDate) {
                                return (aDate.getTime() - bDate.getTime()) * sortOrder;
                            }
                            return aText.localeCompare(bText, "vi") * sortOrder;
                        
                         case 5: // Trạng thái
                             return aText.localeCompare(bText, "vi") * sortOrder;
                        
                        default:
                            return 0;
                    }
                });

                renderTable();
                updateSortIcons(th, headers);
            });
        } else {
            // Các cột không sort được
            th.style.cursor = "default";
        }
    });

    // Helper functions for parsing different data types
    function parseDate(dateStr) {
        // Format: dd/MM/yyyy
        const parts = dateStr.split('/');
        if (parts.length === 3) {
            const day = parseInt(parts[0]);
            const month = parseInt(parts[1]) - 1; // Month is 0-indexed
            const year = parseInt(parts[2]);
            return new Date(year, month, day);
        }
        return null;
    }

    function updateSortIcons(activeTh, allThs) {
        allThs.forEach(th => {
            th.classList.remove("sorted-asc", "sorted-desc");
        });
        activeTh.classList.add(sortOrder === 1 ? "sorted-asc" : "sorted-desc");
    }

    renderTable();
});

// Function to toggle description visibility
function toggleDescription(button) {
    const row = button.closest('tr');
    const preview = row.querySelector('.description-preview');
    const full = row.querySelector('.description-full');
    const icon = button.querySelector('i');
    
    if (preview.style.display === 'none') {
        preview.style.display = 'inline';
        full.style.display = 'none';
        icon.className = 'fas fa-eye';
    } else {
        preview.style.display = 'none';
        full.style.display = 'inline';
        icon.className = 'fas fa-eye-slash';
    }
}
</script>

</body>
</html>
