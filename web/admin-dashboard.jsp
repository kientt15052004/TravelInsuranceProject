<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="component/admin-header.jsp"/>

    <div class="container">
        <jsp:include page="component/admin-sidebar.jsp">
            <jsp:param name="activePage" value="${param.activePage != null ? param.activePage : 'dashboard'}"/>
        </jsp:include>

        <div class="main-content">
            <div class="dashboard-container">
                <div class="content-header">
                    <h1>Admin Dashboard</h1>
                    <p>Tổng quan hệ thống và chỉ số quan trọng</p>
                </div>

                <div class="metrics-grid">
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Tổng hợp đồng đang có hiệu lực</h3>
                        </div>
                        <div class="metric-value">${activeContractsCount}</div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Claim 30 ngày qua</h3>
                        </div>
                        <div class="metric-value">${claimsLast30Days}</div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Tỷ lệ Approved/Rejected</h3>
                        </div>
                        <div class="metric-value">
                            <c:if test="${not empty approvedRejectedRatio}">
                                <div>Approved: ${approvedRejectedRatio.approved} (<fmt:formatNumber value="${approvedRejectedRatio.approvedRatio}" maxFractionDigits="1"/>%)</div>
                                <div>Rejected: ${approvedRejectedRatio.rejected} (<fmt:formatNumber value="${approvedRejectedRatio.rejectedRatio}" maxFractionDigits="1"/>%)</div>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Tổng doanh thu</h3>
                        </div>
                        <div class="metric-value">
                            <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                        </div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Tổng số tiền đã đền bù</h3>
                        </div>
                        <div class="metric-value">
                            <fmt:formatNumber value="${totalCompensationAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                        </div>
                    </div>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2>Chỉ số toàn hệ thống</h2>
                    </div>

                    <div class="tables-grid">
                        <div class="table-section">
                            <div class="table-header-with-filter">
                                <h3>Doanh thu theo sản phẩm</h3>
                                <select class="table-limit-select" data-table="revenueByProduct">
                                    <option value="5" ${defaultLimit == 5 ? 'selected' : ''} selected>5</option>
                                    <option value="10" ${defaultLimit == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${defaultLimit == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${defaultLimit == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </div>
                            <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>Doanh thu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty revenueByProduct}">
                                            <c:forEach var="product" items="${revenueByProduct}">
                                                <tr>
                                                    <td>${product.productName}</td>
                                                    <td><fmt:formatNumber value="${product.revenue}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="2" class="empty-state">Chưa có dữ liệu</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                            <div class="table-pagination" data-table="revenueByProduct"></div>
                        </div>

                        <div class="table-section">
                            <div class="table-header-with-filter">
                                <h3>Tỷ lệ claim/hợp đồng theo sản phẩm</h3>
                                <select class="table-limit-select" data-table="claimRateByProduct">
                                    <option value="5" ${defaultLimit == 5 ? 'selected' : ''} selected>5</option>
                                    <option value="10" ${defaultLimit == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${defaultLimit == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${defaultLimit == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </div>
                            <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>Tổng hợp đồng</th>
                                        <th>Tổng claim</th>
                                        <th>Tỷ lệ claim (%)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty claimRateByProduct}">
                                            <c:forEach var="product" items="${claimRateByProduct}">
                                                <tr>
                                                    <td>${product.productName}</td>
                                                    <td>${product.totalContracts}</td>
                                                    <td>${product.totalClaims}</td>
                                                    <td><fmt:formatNumber value="${product.claimRate}" maxFractionDigits="2"/>%</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="empty-state">Chưa có dữ liệu</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                            <div class="table-pagination" data-table="claimRateByProduct"></div>
                        </div>
                    </div>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2>Cảnh báo rủi ro</h2>
                    </div>

                    <div class="tables-grid">
                        <div class="table-section">
                            <div class="table-header-with-filter">
                                <h3>Claim được đền bù số tiền lớn</h3>
                                <select class="table-limit-select" data-table="fraudAlertClaims">
                                    <option value="5" selected>5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="50">50</option>
                                </select>
                            </div>
                            <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Claim ID</th>
                                        <th>Contract ID</th>
                                        <th>Loại claim</th>
                                        <th>Số tiền đền bù</th>
                                        <th>Ngày</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty fraudAlertClaims}">
                                            <c:forEach var="claim" items="${fraudAlertClaims}">
                                                <tr class="risk-row">
                                                    <td>${claim.id}</td>
                                                    <td>${claim.contract_id}</td>
                                                    <td>${claim.claim_type}</td>
                                                    <td>
                                                        <strong style="color: #dc3545;">
                                                            <fmt:formatNumber value="${claim.compensation_amount}" type="number" maxFractionDigits="0" groupingUsed="true"/>₫
                                                        </strong>
                                                    </td>
                                                    <td><fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td><a href="${pageContext.request.contextPath}/ClaimDetailServlet?id=${claim.id}" class="view-detail-link" style="font-size: 11px;">Chi tiết</a></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="empty-state">Không có claim nào đã được đền bù</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                            <div class="table-pagination" data-table="fraudAlertClaims"></div>
                        </div>

                        <div class="table-section">
                            <div class="table-header-with-filter">
                                <h3>Claim của hợp đồng lớn bất thường</h3>
                                <select class="table-limit-select" data-table="unusualLargeContractClaims">
                                    <option value="5" selected>5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="50">50</option>
                                </select>
                            </div>
                            <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Claim ID</th>
                                        <th>Contract ID</th>
                                        <th>Giá trị HĐ</th>
                                        <th>Ngày</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty unusualLargeContractClaims}">
                                            <c:forEach var="claim" items="${unusualLargeContractClaims}">
                                                <tr class="risk-row">
                                                    <td>${claim.id}</td>
                                                    <td>${claim.contract_id}</td>
                                                    <td><fmt:formatNumber value="${claim.contractTotalPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/>₫</td>
                                                    <td><fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td><a href="${pageContext.request.contextPath}/ClaimDetailServlet?id=${claim.id}" class="view-detail-link" style="font-size: 11px;">Chi tiết</a></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="empty-state">Không có claim hợp đồng lớn</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                            <div class="table-pagination" data-table="unusualLargeContractClaims"></div>
                        </div>

                        <div class="table-section">
                            <div class="table-header-with-filter">
                                <h3>Top khách hàng rủi ro</h3>
                                <select class="table-limit-select" data-table="topRiskCustomers">
                                    <option value="5" ${defaultLimit == 5 ? 'selected' : ''} selected>5</option>
                                    <option value="10" ${defaultLimit == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${defaultLimit == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${defaultLimit == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </div>
                            <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Tên khách hàng</th>
                                        <th>Tổng claim</th>
                                        <th>Claim bị reject</th>
                                        <th>Điểm rủi ro (%)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty topRiskCustomers}">
                                            <c:forEach var="customer" items="${topRiskCustomers}">
                                                <tr class="risk-row">
                                                    <td>${customer.customerName}</td>
                                                    <td>${customer.totalClaims}</td>
                                                    <td>${customer.rejectedClaims}</td>
                                                    <td><span class="risk-score"><fmt:formatNumber value="${customer.riskScore}" maxFractionDigits="1"/>%</span></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="empty-state">Không có khách hàng rủi ro</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                            <div class="table-pagination" data-table="topRiskCustomers"></div>
                        </div>
                    </div>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2>Quản lý sản phẩm</h2>
                    </div>

                    <div class="tables-grid">
                        <div class="table-section">
                            <div class="table-header-with-filter">
                                <h3>Sản phẩm bán chạy</h3>
                                <select class="table-limit-select" data-table="topSellingProducts">
                                    <option value="5" selected>5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="50">50</option>
                                </select>
                            </div>
                            <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>Số lượng hợp đồng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty topSellingProducts}">
                                            <c:forEach var="product" items="${topSellingProducts}">
                                                <tr>
                                                    <td>${product.productName}</td>
                                                    <td>${product.contractCount}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="2" class="empty-state">Chưa có dữ liệu</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                            <div class="table-pagination" data-table="topSellingProducts"></div>
                        </div>

                        <div class="table-section">
                            <div class="table-header-with-filter">
                                <h3>Sản phẩm bị claim nhiều nhất</h3>
                                <select class="table-limit-select" data-table="productsWithMostClaims">
                                    <option value="5" selected>5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="50">50</option>
                                </select>
                            </div>
                            <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>Số lượng claim</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty productsWithMostClaims}">
                                            <c:forEach var="product" items="${productsWithMostClaims}">
                                                <tr>
                                                    <td>${product.productName}</td>
                                                    <td>${product.claimCount}</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="2" class="empty-state">Chưa có dữ liệu</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                            <div class="table-pagination" data-table="productsWithMostClaims"></div>
                        </div>

                        <div class="table-section">
                            <div class="table-header-with-filter">
                                <h3>Sản phẩm có doanh thu cao nhất</h3>
                                <select class="table-limit-select" data-table="topRevenueProducts">
                                    <option value="5" ${defaultLimit == 5 ? 'selected' : ''} selected>5</option>
                                    <option value="10" ${defaultLimit == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${defaultLimit == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${defaultLimit == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </div>
                            <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>Doanh thu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty topRevenueProducts}">
                                            <c:forEach var="product" items="${topRevenueProducts}">
                                                <tr>
                                                    <td>${product.productName}</td>
                                                    <td><fmt:formatNumber value="${product.revenue}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ</td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="2" class="empty-state">Chưa có dữ liệu</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            </div>
                            <div class="table-pagination" data-table="topRevenueProducts"></div>
                        </div>
                    </div>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2>Phân tích Staff</h2>
                    </div>

                    <div class="filter-form">
                        <form method="POST" action="${pageContext.request.contextPath}/admin/dashboard">
                            <input type="hidden" name="action" value="staffApproval">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Từ ngày:</label>
                                    <input type="date" name="fromDate" value="<fmt:formatDate value='${selectedFromDate != null ? selectedFromDate : defaultFromDate}' pattern='yyyy-MM-dd'/>" required>
                                </div>
                                <div class="form-group">
                                    <label>Đến ngày:</label>
                                    <input type="date" name="toDate" value="<fmt:formatDate value='${selectedToDate != null ? selectedToDate : defaultToDate}' pattern='yyyy-MM-dd'/>" required>
                                </div>
                                <div class="form-group">
                                    <button type="submit" class="btn-filter">Lọc</button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="table-section">
                        <h3>Staff chấp nhận nhiều claim</h3>
                        <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Tên staff</th>
                                        <th>Số claim đã approve</th>
                                        <th>Số claim đã reject</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty staffApprovalStats}">
                                            <c:forEach var="staff" items="${staffApprovalStats}">
                                                <tr>
                                                    <td>${staff.staffName}</td>
                                                    <td>${staff.approvedCount}</td>
                                                    <td>${staff.rejectedCount}</td>
                                                    <td>
                                                        <form method="POST" action="${pageContext.request.contextPath}/admin/dashboard" style="display: inline;">
                                                            <input type="hidden" name="action" value="staffApproval">
                                                            <input type="hidden" name="staffId" value="${staff.staffId}">
                                                            <input type="hidden" name="fromDate" value="<fmt:formatDate value='${selectedFromDate != null ? selectedFromDate : defaultFromDate}' pattern='yyyy-MM-dd'/>">
                                                            <input type="hidden" name="toDate" value="<fmt:formatDate value='${selectedToDate != null ? selectedToDate : defaultToDate}' pattern='yyyy-MM-dd'/>">
                                                            <button type="submit" class="btn-view">Xem danh sách</button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="empty-state">Không có dữ liệu</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <c:if test="${not empty claimsByStaff}">
                        <div class="table-section">
                            <h3>Danh sách claim theo staff đã chọn</h3>
                            <div class="stats-table-container">
                                <table class="stats-table">
                                    <thead>
                                        <tr>
                                            <th>Claim ID</th>
                                            <th>Contract ID</th>
                                            <th>Loại claim</th>
                                            <th>Trạng thái</th>
                                            <th>Số tiền đền bù</th>
                                            <th>Ngày yêu cầu</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="claim" items="${claimsByStaff}">
                                            <tr>
                                                <td>${claim.id}</td>
                                                <td>${claim.contract_id}</td>
                                                <td>${claim.claim_type}</td>
                                                <td><span class="status-badge status-${fn:toLowerCase(claim.claim_status)}">${claim.claim_status}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${claim.claim_status == 'approved' && claim.compensation_amount != null}">
                                                            <fmt:formatNumber value="${claim.compensation_amount}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                                                        </c:when>
                                                        <c:when test="${claim.claim_status == 'approved'}">
                                                            <span style="color: #999;">Chưa cập nhật</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: #999;">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/></td>
                                                <td><a href="${pageContext.request.contextPath}/ClaimDetailServlet?id=${claim.id}" class="view-detail-link">Chi tiết</a></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2>Phân tích rủi ro khách hàng</h2>
                    </div>

                    <div class="filter-form">
                        <form method="POST" action="${pageContext.request.contextPath}/admin/dashboard">
                            <input type="hidden" name="action" value="customerRisk">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Số hợp đồng tối thiểu:</label>
                                    <input type="number" name="minContracts" value="${selectedMinContracts != null ? selectedMinContracts : 3}" min="1" required>
                                </div>
                                <div class="form-group">
                                    <label>Trong vòng (ngày):</label>
                                    <input type="number" name="days" value="${selectedDays != null ? selectedDays : 7}" min="1" required>
                                </div>
                                <div class="form-group">
                                    <button type="submit" class="btn-filter">Tìm kiếm</button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="table-section">
                        <h3>Khách hàng mua nhiều hợp đồng trong thời gian ngắn</h3>
                        <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>Tên khách hàng</th>
                                        <th>Số hợp đồng</th>
                                        <th>Ngày hợp đồng đầu tiên</th>
                                        <th>Ngày hợp đồng cuối cùng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty customersWithManyContracts}">
                                            <c:forEach var="customer" items="${customersWithManyContracts}">
                                                <tr class="risk-row">
                                                    <td>${customer.customerName}</td>
                                                    <td>${customer.contractCount}</td>
                                                    <td><fmt:formatDate value="${customer.firstContractDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td><fmt:formatDate value="${customer.lastContractDate}" pattern="dd/MM/yyyy"/></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="empty-state">Không tìm thấy khách hàng nào</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/JS/admin-dashboard.js"></script>
</body>
</html>

