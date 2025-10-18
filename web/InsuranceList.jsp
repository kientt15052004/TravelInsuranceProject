

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Insurance List</title>
        <link rel="stylesheet" href="./CSS/InsuranceList.css">
    </head>
    <body>
        <div class="frame">
            <div class="container">
                <!-- Header -->
                <jsp:include page="component/header.jsp" />

                <!-- Breadcrumb -->
                <div class="breadcrumb">
                    <a href="#">Home</a>
                    <span>&gt;</span>
                    <span>Insurance List</span>
                </div>

                <!-- Page Title -->
                <h1 class="page-title">
                    <span class="icon">🛡️</span>
                    Travel Insurance Products
                </h1>

                <!-- Filter Section -->
                <div class="filter-section">
                    <form action="InsuranceList" method="GET" class="filter-form">
                        <!-- Search by name -->
                        <div class="form-group">
                            <label>Search by Name</label>
                            <input type="text" class="form-input" name="searchName" value="${param.searchName}" placeholder="Enter insurance name...">
                        </div>

                        <!-- Filter by type -->
                        <div class="form-group">
                            <label>Filter by Type</label>
                            <select class="form-select" name="searchType">
                                <option value="">All Types</option>
                                <c:forEach var="t" items="${types}">
                                    <option value="${t}" ${param.searchType == t ? 'selected' : ''}>${t}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Filter by price -->
                        <div class="form-group price-filter">
                            <label>Filter by Price (USD)</label>
                            <div class="price-range">
                                <input type="number" class="form-input" name="minPrice" value="${param.minPrice}" placeholder="Min" min="0" step="1">
                                <span>-</span>
                                <input type="number" class="form-input" name="maxPrice" value="${param.maxPrice}" placeholder="Max" min="0" step="1">
                            </div>
                        </div>

                        <!-- Buttons -->
                        <div class="form-buttons">
                            <button type="submit" class="search-btn">🔍 Search</button>
                            <a href="InsuranceList" class="search-btn">🧹 Clear</a>
                        </div>
                    </form>
                </div>

                <!-- Results Info -->
                <div class="results-info">
                    <div class="results-count">
                        <c:set var="startIndex" value="${(currentPage - 1) * pageSize + 1}" />
                        <c:set var="endIndex" value="${currentPage * pageSize > totalRecords ? totalRecords : currentPage * pageSize}" />
                        Showing <strong>${totalRecords > 0 ? startIndex : 0}-${endIndex}</strong> of <strong>${totalRecords}</strong> results
                    </div>
                </div>

                <!-- Insurance Grid -->
                <div class="insurance-grid">
                    <c:choose>
                        <c:when test="${empty insurances}">
                            <div class="empty-state">
                                <div class="icon">🔍</div>
                                <h3>No results found</h3>
                                <p>Try adjusting your search or filter criteria</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${insurances}" var="insurance">
                                <a href="purchase-insurance?id=${insurance.id}" class="insurance-card">
                                    <div class="insurance-icon">
<<<<<<< Updated upstream
                                        <img src="${insurance.img.startsWith('http') ? insurance.img : pageContext.request.contextPath.concat('/').concat(insurance.img)}" 
=======
                                        <img src="${pageContext.request.contextPath}/${insurance.img}" 
>>>>>>> Stashed changes
                                             alt="${insurance.name}" class="insurance-img"/>
                                    </div>
                                    <span class="insurance-type">${insurance.type}</span>
                                    <div class="insurance-name">${insurance.name}</div>
                                    <div class="insurance-description">${insurance.description}</div>

                                    <!-- Added Price Display -->
                                    <div class="insurance-price">
                                        💰 Price: <strong>$${insurance.price}</strong>
                                    </div>

                                    <button class="view-details-btn">Purchase Now</button>
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
                                   class="page-btn">← Previous</a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">← Previous</span>
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
                                   class="page-btn">Next →</a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">Next →</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="./JS/SweetAlert.js"></script>
    </body>
</html>
