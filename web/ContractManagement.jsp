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
    <jsp:include page="component/staff-header.jsp"/>

    <div class="container">
        <jsp:include page="component/staff-sidebar.jsp">
            <jsp:param name="activePage" value="contract-management"/>
        </jsp:include>

        <div class="main-content">
            <div class="content-header">
                <h1>Quản Lý Hợp Đồng Bảo Hiểm</h1>
                <p>Xem và quản lý tất cả hợp đồng bảo hiểm</p>
            </div>

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

            <div class="contracts-table-section">
                <div class="table-header">
                    <div class="table-title-section">
                        <h3>Danh sách hợp đồng bảo hiểm</h3>
                        <p>Tổng cộng: ${contracts.size()} hợp đồng</p>
                    </div>
                    <div class="page-size-container">
                        <label>Hiển thị: 
                            <select id="pageSizeSelect">
                                <option value="10">10</option>
                                <option value="20">20</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                            </select> hợp đồng/trang
                        </label>
                    </div>
                </div>
                
                <c:if test="${not empty requestScope.error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        ${requestScope.error}
                    </div>
                </c:if>
                
                <c:if test="${not empty requestScope.success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${requestScope.success}
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
                                                    <span class="product-type">${contract.productType}</span>
                                                </div>
                                            </td>
                                            <td><fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <div class="buyer-info">
                                                    <div class="buyer-name"><strong>${contract.buyerName}</strong></div>
                                                    <div class="buyer-contact">
                                                        <small>SDT: ${contract.buyerPhone}</small><br>
                                                        <small>Email: ${contract.buyerEmail}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="price-amount">
                                                    <fmt:formatNumber value="${contract.totalPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/> ₫
                                                </span>
                                            </td>
                                            <td class="status-text status-${contract.contract_status.toLowerCase()}">
                                                ${contract.contract_status}
                                            </td>
                                            <td class="actions-cell">
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/ContractDetailServlet?id=${contract.contract_id}" class="btn-sm btn-info">
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

<script>
document.addEventListener("DOMContentLoaded", function () {
    const table = document.querySelector(".contracts-table");
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
        const sortableColumns = [0, 2, 3, 5, 6];
        
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
                            const aId = parseInt(aText.replace('#', ''));
                            const bId = parseInt(bText.replace('#', ''));
                            return (aId - bId) * sortOrder;
                        
                        case 2:
                        case 3:
                            const aDate = parseDate(aText);
                            const bDate = parseDate(bText);
                            if (aDate && bDate) {
                                return (aDate.getTime() - bDate.getTime()) * sortOrder;
                            }
                            return aText.localeCompare(bText, "vi") * sortOrder;
                        
                        case 5:
                            const aPrice = parsePrice(aText);
                            const bPrice = parsePrice(bText);
                            return (aPrice - bPrice) * sortOrder;
                        
                        case 6:
                            return aText.localeCompare(bText, "vi") * sortOrder;
                        
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

    function parseDate(dateStr) {
        const parts = dateStr.split('/');
        if (parts.length === 3) {
            const day = parseInt(parts[0]);
            const month = parseInt(parts[1]) - 1;
            const year = parseInt(parts[2]);
            return new Date(year, month, day);
        }
        return null;
    }

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
