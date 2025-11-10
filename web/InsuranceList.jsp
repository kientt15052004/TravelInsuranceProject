

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Danh Sách Bảo Hiểm</title>
    </head>
    <body>
        <jsp:include page="component/header.jsp" />
        <link rel="stylesheet" href="./CSS/styleindex.css"/>
        <link rel="stylesheet" href="./CSS/InsuranceList.css">
        
        <div class="container">

            <h1 class="page-title">
                Sản Phẩm Bảo Hiểm Du Lịch
            </h1>

            <div class="filter-section">
                <form action="InsuranceList" method="GET" class="filter-form">

                    <div class="form-group">
                        <label>Tìm kiếm theo tên</label>
                        <input type="text" class="form-input" name="searchName" value="${param.searchName}" placeholder="Nhập tên bảo hiểm...">
                    </div>

                    <div class="form-group">
                        <label>Lọc theo loại</label>
                        <select class="form-select" name="searchType">
                            <option value="">Tất cả loại</option>
                            <c:forEach var="t" items="${types}">
                                <option value="${t}" ${param.searchType == t ? 'selected' : ''}>${t}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group price-filter">
                        <label>Lọc theo giá (USD)</label>
                        <div class="price-range">
                            <input type="number" class="form-input" name="minPrice" value="${param.minPrice}" placeholder="Tối thiểu" min="0" step="1">
                            <span>-</span>
                            <input type="number" class="form-input" name="maxPrice" value="${param.maxPrice}" placeholder="Tối đa" min="0" step="1">
                        </div>
                    </div>

                    <div class="form-buttons">
                        <button type="submit" class="search-btn">Tìm kiếm</button>
                        <a href="InsuranceList" class="search-btn">Xóa bộ lọc</a>
                    </div>
                </form>
            </div>

            <div class="results-info">
                <div class="results-count">
                    <c:set var="startIndex" value="${(currentPage - 1) * pageSize + 1}" />
                    <c:set var="endIndex" value="${currentPage * pageSize > totalRecords ? totalRecords : currentPage * pageSize}" />
                    Hiển thị <strong>${totalRecords > 0 ? startIndex : 0}-${endIndex}</strong> trong tổng số <strong>${totalRecords}</strong> kết quả
                </div>
            </div>

            <div class="insurance-grid">
                <c:choose>
                    <c:when test="${empty insurances}">
                        <div class="empty-state">
                            <h3>Không tìm thấy kết quả</h3>
                            <p>Vui lòng điều chỉnh tiêu chí tìm kiếm hoặc bộ lọc</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${insurances}" var="insurance">
                            <a href="purchase-insurance?id=${insurance.id}" class="insurance-card">
                                <div class="insurance-icon">
                                    <img src="${insurance.img.startsWith('http') ? insurance.img : pageContext.request.contextPath.concat('/').concat(insurance.img)}" 
                                         alt="${insurance.name}" class="insurance-img"/>
                                </div>
                                <span class="insurance-type">${insurance.type}</span>
                                <div class="insurance-name">${insurance.name}</div>
                                <div class="insurance-description">${insurance.description}</div>

                                <!-- Added Price Display -->
                                <div class="insurance-price">
                                    Giá: <strong>$${insurance.price}</strong>
                                </div>

                                <button class="view-details-btn">Mua Ngay</button>
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <!-- Previous Button -->
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="InsuranceList?page=${currentPage - 1}&searchName=${param.searchName}&searchType=${param.searchType}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                               class="page-btn">← Trước</a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-btn disabled">← Trước</span>
                        </c:otherwise>
                    </c:choose>

                    <!-- Page Numbers -->
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                <a href="InsuranceList?page=${i}&searchName=${param.searchName}&searchType=${param.searchType}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                                   class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                            </c:when>
                            <c:when test="${i == currentPage - 2 || i == currentPage + 2}">
                                <span class="pagination-ellipsis">...</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    <!-- Next Button -->
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="InsuranceList?page=${currentPage + 1}&searchName=${param.searchName}&searchType=${param.searchType}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
                               class="page-btn">Sau →</a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-btn disabled">Sau →</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="./JS/SweetAlert.js"></script>
    </body>
</html>
