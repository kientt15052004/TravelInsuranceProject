<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Sản Phẩm - Hệ thống quản lý bảo hiểm</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/usermanagement.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/productmanagement.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="component/admin-header.jsp"/>

        <div class="container">
            <jsp:include page="component/admin-sidebar.jsp">
                <jsp:param name="activePage" value="view-products"/>
            </jsp:include>

            <div class="main-content">
                <div class="content-header">
                    <h1>Quản Lý Sản Phẩm</h1>
                    <p>Xem và quản lý các sản phẩm bảo hiểm</p>
                </div>

                <div class="search-filter-section">
                    <form method="GET" action="${pageContext.request.contextPath}/view_product" class="search-form">
                        <div class="search-row">
                            <div class="search-group">
                                <label for="search">Tìm kiếm:</label>
                                <input type="text" id="search" name="search" value="${searchTerm}" 
                                       placeholder="Tìm theo tên sản phẩm, loại, gói...">
                            </div>

                            <div class="filter-group">
                                <label for="type">Loại:</label>
                                <select id="type" name="type">
                                    <option value="">Tất cả loại</option>
                                    <option value="domestic" ${typeFilter == 'domestic' ? 'selected' : ''}>Trong nước</option>
                                    <option value="international" ${typeFilter == 'international' ? 'selected' : ''}>Quốc tế</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label for="package">Gói:</label>
                                <select id="package" name="package_type">
                                    <option value="">Tất cả gói</option>
                                    <option value="basic" ${packageFilter == 'basic' ? 'selected' : ''}>Cơ bản</option>
                                    <option value="standard" ${packageFilter == 'standard' ? 'selected' : ''}>Tiêu chuẩn</option>
                                    <option value="advanced" ${packageFilter == 'advanced' ? 'selected' : ''}>Nâng cao</option>
                                    <option value="comprehensive" ${packageFilter == 'comprehensive' ? 'selected' : ''}>Toàn diện</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label for="status">Trạng thái:</label>
                                <select id="status" name="status">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>

                            <div class="button-group">
                                <button type="submit" class="btn btn-search">
                                    <i class="fas fa-search"></i>
                                    Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/view_product" class="btn btn-clear">
                                    <i class="fas fa-times"></i>
                                    Xóa bộ lọc
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="products-table-section">
                    <div class="table-header">
                        <div class="table-title-section">
                            <h3>Danh sách sản phẩm bảo hiểm</h3>
                            <p>Tổng cộng: ${products.size()} sản phẩm</p>
                        </div>
                        <div class="page-size-container">
                            <label>Hiển thị: 
                                <select id="pageSizeSelect">
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="50">50</option>
                                    <option value="100">100</option>
                                </select> sản phẩm/trang
                            </label>
                        </div>
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

                    <c:choose>
                        <c:when test="${not empty products}">
                            <div class="table-container">
                                <table class="products-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Loại</th>
                                            <th>Giá tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Gói</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${products}" var="product">
                                            <tr>
                                                <td>#${product.id}</td>

                                                <td>
                                                    <div class="product-info">
                                                        <strong>${product.name}</strong>
                                                        <small class="product-description">
                                                            <c:choose>
                                                                <c:when test="${fn:length(product.description) > 50}">
                                                                    ${fn:substring(product.description, 0, 50)}...
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${product.description}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </small>
                                                    </div>
                                                </td>

                                                <td>
                                                    <span class="type-badge type-${product.type}">
                                                        ${product.type == "domestic" ? "Trong nước" : "Quốc tế"}
                                                    </span>
                                                </td>

                                                <td class="price-amount">
                                                    <c:choose>
                                                        <c:when test="${product.price != null}">
                                                            <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> ₫
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="empty-field">Chưa có giá</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <span class="status-badge status-${product.is_active ? 'active' : 'inactive'}">
                                                        ${product.is_active ? 'Hoạt động' : 'Không hoạt động'}
                                                    </span>
                                                </td>

                                                <td>
                                                    <span class="package-badge package-${product.package_type}">
                                                        <c:choose>
                                                            <c:when test="${product.package_type == 'basic'}">Cơ bản</c:when>
                                                            <c:when test="${product.package_type == 'standard'}">Tiêu chuẩn</c:when>
                                                            <c:when test="${product.package_type == 'advanced'}">Nâng cao</c:when>
                                                            <c:when test="${product.package_type == 'comprehensive'}">Toàn diện</c:when>
                                                            <c:otherwise>${product.package_type}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>

                                                <td class="actions-cell">
                                                    <div class="action-buttons">

                                                        <!-- Nút sửa -->
                                                        <a href="${pageContext.request.contextPath}/edit_product?id=${product.id}&id_benefit=${product.benefit_id}" 
                                                           class="btn-sm btn-info">
                                                            <i class="fas fa-edit"></i> Sửa
                                                        </a>

                                                        <!-- Nút kích hoạt / vô hiệu hóa -->
                                                        <c:choose>
                                                            <c:when test="${product.is_active}">
                                                                <a href="${pageContext.request.contextPath}/delete_product?id=${product.id}&id_benefit=${product.benefit_id}" 
                                                                   class="btn-sm btn-warning delete-btn">
                                                                    <i class="fas fa-ban"></i>
                                                                    Vô hiệu hóa
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/delete_product?id=${product.id}&id_benefit=${product.benefit_id}" 
                                                                   class="btn-sm btn-success delete-btn">
                                                                    <i class="fas fa-check"></i>
                                                                    Kích hoạt
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
                        </c:when>
                        <c:otherwise>
                            <div class="no-data">
                                <h3>Không có sản phẩm nào</h3>
                                <p>Không tìm thấy sản phẩm nào phù hợp với tiêu chí tìm kiếm.</p>
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
                    userDropdown.addEventListener('click', function (e) {
                        e.stopPropagation();
                        userDropdown.classList.toggle('active');
                    });

                    document.addEventListener('click', function (e) {
                        if (!userDropdown.contains(e.target)) {
                            userDropdown.classList.remove('active');
                        }
                    });
                }

                document.querySelectorAll(".delete-btn").forEach(btn => {
                    btn.addEventListener("click", (e) => {
                        e.preventDefault();
                        const confirmDelete = confirm("Bạn có chắc chắn muốn xóa sản phẩm này không?");
                        if (confirmDelete) {
                            window.location.href = btn.href;
                        }
                    });
                });

                const table = document.querySelector(".products-table");
                if (!table)
                    return;

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
                        if (i === currentPage)
                            btn.classList.add("active");
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
                    const sortableColumns = [0, 1, 2, 3, 4, 5];

                    if (sortableColumns.includes(index)) {
                        th.style.cursor = "pointer";
                        th.addEventListener("click", () => {
                            if (sortedColumn === index)
                                sortOrder *= -1;
                            else {
                                sortedColumn = index;
                                sortOrder = 1;
                            }

                            rows.sort((a, b) => {
                                const aText = a.children[index].textContent.trim();
                                const bText = b.children[index].textContent.trim();

                                switch (index) {
                                    case 0:
                                        const aId = parseInt(aText.replace('#', ''));
                                        const bId = parseInt(bText.replace('#', ''));
                                        return (aId - bId) * sortOrder;

                                    case 1:
                                    case 2:
                                    case 4:
                                    case 5:
                                        return aText.localeCompare(bText, "vi") * sortOrder;

                                    case 3:
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
