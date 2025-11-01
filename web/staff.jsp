<%-- 
    Document   : staff
    Created on : Dec 8, 2024
    Author     : Staff Page
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
</head>
  <body>
      <jsp:include page="component/staff-header.jsp"/>

      <div class="container">
        <jsp:include page="component/staff-sidebar.jsp">
            <jsp:param name="activePage" value="dashboard"/>
        </jsp:include>

        <div class="main-content">
            <div class="dashboard-container">
            <div class="content-header">
                <h1>Dashboard</h1>
                    <p>Tổng quan hệ thống và hoạt động</p>
                </div>

                <!-- Metrics Cards Section -->
                <div class="metrics-grid">
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Tổng bồi thường</h3>
                        </div>
                        <div class="metric-value">${totalClaims}</div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Bồi thường cần xử lý</h3>
                        </div>
                        <div class="metric-value highlight">${pendingClaims}</div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Bồi thường đã duyệt</h3>
                        </div>
                        <div class="metric-value">${approvedClaims}</div>
                    </div>
                    
                    <div class="metric-card">
                        <div class="metric-header">
                            <h3>Bồi thường mới trong 2 ngày vừa qua</h3>
                        </div>
                        <div class="metric-value">${recentClaimsCount}</div>
                    </div>
                </div>

                <!-- Recent Activity Section -->
                <div class="recent-activity">
                    <div class="activity-section">
                        <div class="section-header">
                            <h2>Bồi thường mới nhất</h2>
                            <a href="${pageContext.request.contextPath}/ClaimsManagementServlet" class="view-all-link">Xem tất cả</a>
                        </div>
                        <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Contract ID</th>
                                        <th>Loại</th>
                                        <th>Ngày yêu cầu</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentClaims}">
                                            <c:forEach var="claim" items="${recentClaims}">
                                                <tr>
                                                    <td>${claim.id}</td>
                                                    <td>${claim.contract_id}</td>
                                                    <td>${claim.claim_type}</td>
                                                    <td>
                                                        <fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-${fn:toLowerCase(claim.claim_status)}">${claim.claim_status}</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/ClaimDetailServlet?id=${claim.id}" class="view-detail-link">Chi tiết</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="empty-state">Chưa có yêu cầu bồi thường nào</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="activity-section">
                        <div class="section-header">
                            <h2>Bồi thường cần xử lý</h2>
                            <a href="${pageContext.request.contextPath}/ClaimsManagementServlet" class="view-all-link">Xem tất cả</a>
                        </div>
                        <div class="stats-table-container">
                            <table class="stats-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Contract ID</th>
                                        <th>Loại</th>
                                        <th>Ngày yêu cầu</th>
                                        <th>Giá trị hợp đồng</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty pendingClaimsList}">
                                            <c:forEach var="claim" items="${pendingClaimsList}">
                                                <tr>
                                                    <td>${claim.id}</td>
                                                    <td>${claim.contract_id}</td>
                                                    <td>${claim.claim_type}</td>
                                                    <td>
                                                        <fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${claim.contractTotalPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-${fn:toLowerCase(claim.claim_status)}">${claim.claim_status}</span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/ClaimDetailServlet?id=${claim.id}" class="view-detail-link">Chi tiết</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="empty-state">Không có yêu cầu bồi thường nào cần xử lý</td>
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
    
</body>
</html>
