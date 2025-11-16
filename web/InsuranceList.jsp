<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Danh Sách Bảo Hiểm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                    <!-- Search by name -->
                    <div class="form-group">
                        <label>Tìm kiếm theo tên</label>
                        <input type="text" class="form-input" name="searchName" value="${param.searchName}" placeholder="Nhập tên bảo hiểm...">
                    </div>

                    <div class="form-group">
                        <label>Lọc theo loại</label>
                        <select class="form-select" name="searchType">
                            <option value="">Tất cả loại</option>

                            <option value="domestic" 
                                    ${param.searchType == 'domestic' ? 'selected' : ''}>
                                Bảo Hiểm Nội Địa
                            </option>

                            <option value="international" 
                                    ${param.searchType == 'international' ? 'selected' : ''}>
                                Bảo Hiểm Ngoại Địa
                            </option>
                        </select>
                    </div>
                    
                    <!-- Filter by price -->
                    <div class="form-group">
                        <label>Giá tối thiểu (VNĐ)</label>
                        <input type="number" class="form-input" name="minPrice" value="${param.minPrice}" placeholder="Nhập giá tối thiểu..." min="0" step="1000">
                    </div>
                    
                    <div class="form-group">
                        <label>Giá tối đa (VNĐ)</label>
                        <input type="number" class="form-input" name="maxPrice" value="${param.maxPrice}" placeholder="Nhập giá tối đa..." min="0" step="1000">
                    </div>
                      
                    <!-- Buttons -->
                    <div class="form-buttons">
                        <button type="submit" class="search-btn">Tìm kiếm</button>
                        <a href="InsuranceList" class="search-btn">Xóa bộ lọc</a>
                    </div>
                </form>
            </div>

            <!-- Insurance Grid -->
            <c:choose>
                <c:when test="${insurances != null && !empty insurances}">
                    <div class="insurance-grid">
                        <c:forEach var="insurance" items="${insurances}">
                            <a href="purchase-insurance?id=${insurance.id}" class="insurance-card">
                                <div class="insurance-icon">
                                    <c:choose>
                                        <c:when test="${insurance.img != null && !empty insurance.img}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(insurance.img, 'http')}">
                                                    <img src="${insurance.img}" 
                                                         alt="${insurance.name}" 
                                                         onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="./${insurance.img}" 
                                                         alt="${insurance.name}" 
                                                         onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/300x200?text=No+Image" alt="${insurance.name}">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="insurance-type">${insurance.type}</span>
                                <div class="insurance-name">${insurance.name}</div>
                                <c:if test="${insurance.price != null}">
                                    <div class="insurance-price">
                                        <fmt:formatNumber value="${insurance.price}" type="number" maxFractionDigits="0" /> VNĐ
                                    </div>
                                </c:if>
                                <div class="insurance-description">
                                    ${insurance.description != null ? insurance.description : 'Không có mô tả'}
                                </div>
                                <button class="view-details-btn">Mua Ngay</button>
                            </a>
                        </c:forEach>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <c:set var="paginationParams" value=""/>
                        <c:if test="${param.searchName != null && !empty param.searchName}">
                            <c:set var="paginationParams" value="${paginationParams}&searchName=${param.searchName}"/>
                        </c:if>
                        <c:if test="${param.searchType != null && !empty param.searchType}">
                            <c:set var="paginationParams" value="${paginationParams}&searchType=${param.searchType}"/>
                        </c:if>
                        <c:if test="${param.minPrice != null && !empty param.minPrice}">
                            <c:set var="paginationParams" value="${paginationParams}&minPrice=${param.minPrice}"/>
                        </c:if>
                        <c:if test="${param.maxPrice != null && !empty param.maxPrice}">
                            <c:set var="paginationParams" value="${paginationParams}&maxPrice=${param.maxPrice}"/>
                        </c:if>
                        
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="InsuranceList?page=${currentPage - 1}${paginationParams}" 
                                   class="page-btn">Trước</a>
                            </c:if>
                            
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:when test="${i <= 3 || i > totalPages - 3 || (i >= currentPage - 1 && i <= currentPage + 1)}">
                                        <a href="InsuranceList?page=${i}${paginationParams}" 
                                           class="page-btn">${i}</a>
                                    </c:when>
                                    <c:when test="${i == 4 || i == totalPages - 3}">
                                        <span class="pagination-ellipsis">...</span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="InsuranceList?page=${currentPage + 1}${paginationParams}" 
                                   class="page-btn">Sau</a>
                            </c:if>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>Không tìm thấy sản phẩm bảo hiểm nào phù hợp với tiêu chí tìm kiếm của bạn.</p>
                        <a href="InsuranceList" class="search-btn">Xóa bộ lọc</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
                <jsp:include page="./component/footer.jsp"></jsp:include>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="./JS/SweetAlert.js"></script>
    </body>
</html>
