<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết hợp đồng - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/contractmanagement.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/contractdetail.css">
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
                <div class="header-actions">
                    <c:choose>
                        <c:when test="${not empty userId}">
                            <a href="${pageContext.request.contextPath}/usermanagement?action=detail&userId=${userId}" class="btn btn-secondary">
                                Quay lại
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/ContractManagementServlet" class="btn btn-secondary">
                                Quay lại
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h1>Chi tiết hợp đồng #${contract.contract_id}</h1>
                <p>Thông tin chi tiết về hợp đồng bảo hiểm</p>
            </div>

            <div class="contract-detail-section">
                <div class="detail-grid">
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Thông tin hợp đồng</h3>
                        </div>
                        <div class="card-content">
                            <div class="info-row">
                                <label>ID Hợp đồng:</label>
                                <span>#${contract.contract_id}</span>
                            </div>
                            <div class="info-row">
                                <label>ID Đơn đăng ký:</label>
                                <span>#${contract.application_id}</span>
                            </div>
                            <div class="info-row">
                                <label>Trạng thái:</label>
                                <span class="status-badge status-${contract.contract_status.toLowerCase()}">
                                    ${contract.contract_status}
                                </span>
                            </div>
                            <div class="info-row">
                                <label>Mô tả:</label>
                                <span>${contract.description}</span>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty buyer}">
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Thông tin người mua</h3>
                        </div>
                        <div class="card-content">
                            <div class="info-row">
                                <label>Họ tên:</label>
                                <span>${not empty buyer.fullname ? buyer.fullname : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="info-row">
                                <label>Email:</label>
                                <span>${not empty buyer.mail ? buyer.mail : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="info-row">
                                <label>Số điện thoại:</label>
                                <span>${not empty buyer.phone ? buyer.phone : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="info-row">
                                <label>Địa chỉ:</label>
                                <span>${not empty buyer.address ? buyer.address : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="info-row">
                                <label>CCCD:</label>
                                <span>${not empty buyer.cccd ? buyer.cccd : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="info-row">
                                <label>Ngày sinh:</label>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty buyer.dob}">
                                            ${buyer.dob}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                    </c:if>
                    <c:if test="${not empty application}">
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Thông tin đơn đăng ký</h3>
                        </div>
                        <div class="card-content">
                            <div class="info-row">
                                <label>Loại bảo hiểm:</label>
                                <span>${application.type}</span>
                            </div>
                            <div class="info-row">
                                <label>Điểm đến:</label>
                                <span>${application.destination}</span>
                            </div>
                            <div class="info-row">
                                <label>Ngày bắt đầu:</label>
                                <span>${application.startDate}</span>
                            </div>
                            <div class="info-row">
                                <label>Ngày kết thúc:</label>
                                <span>${application.endDate}</span>
                            </div>
                            <div class="info-row">
                                <label>Số lượng người:</label>
                                <span>${application.travelers_quantity}</span>
                            </div>
                            <div class="info-row">
                                <label>Tổng giá trị:</label>
                                <span>${application.total_price} VNĐ</span>
                            </div>
                        </div>
                    </div>
                    </c:if>

                    <c:if test="${not empty product}">
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Thông tin sản phẩm</h3>
                        </div>
                        <div class="card-content">
                            <div class="info-row">
                                <label>Tên sản phẩm:</label>
                                <span>${product.name}</span>
                            </div>
                            <div class="info-row">
                                <label>Loại:</label>
                                <span>${product.type}</span>
                            </div>
                            <div class="info-row">
                                <label>Giá:</label>
                                <span>${product.price} VNĐ</span>
                            </div>
                            <div class="info-row">
                                <label>Mô tả:</label>
                                <span>${product.description}</span>
                            </div>
                        </div>
                    </div>
                    </c:if>

                </div>
            </div>

        <c:if test="${not empty travelers}">
            <div class="travelers-section">
                <h3>Danh sách khách hàng</h3>
                <p><strong>Tổng số người:</strong> ${travelers.size()} người</p>
                
                <div class="travelers-table">
                    <table class="travelers-list">
                        <thead>
                            <tr>
                                <th>Họ tên</th>
                                <th>Giới tính</th>
                                <th>Ngày sinh</th>
                                <th>Số điện thoại</th>
                                <th>Email</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="traveler" items="${travelers}">
                                <tr>
                                    <td>${traveler.name}</td>
                                    <td>${traveler.gender}</td>
                                     <td><fmt:formatDate value="${traveler.dob}" pattern="dd/MM/yyyy"/></td>
                                    <td>${traveler.phone}</td>
                                    <td>${traveler.email}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            </c:if>

            <c:if test="${not empty claims}">
                <div class="claims-section">
                    <h3>Danh sách yêu cầu bồi thường</h3>
                    <p><strong>Tổng số yêu cầu:</strong> ${claims.size()} yêu cầu</p>
                    
                    <div class="claims-table">
                        <table class="claims-list">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>ID Hợp đồng</th>
                                    <th>Ngày yêu cầu</th>
                                    <th>Loại bồi thường</th>
                                    <th>Mô tả</th>
                                    <th>Ngân hàng</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="claim" items="${claims}">
                                    <tr>
                                        <td>#${claim.id}</td>
                                        <td>#${claim.contract_id}</td>
                                        <td><fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${claim.claim_type == 'lost_baggage'}">Mất hành lý</c:when>
                                                <c:when test="${claim.claim_type == 'flight_delay'}">Chậm chuyến bay</c:when>
                                                <c:when test="${claim.claim_type == 'third_party'}">Bên thứ ba</c:when>
                                                <c:when test="${claim.claim_type == 'trip_cancellation'}">Hủy chuyến</c:when>
                                                <c:when test="${claim.claim_type == 'medical'}">Y tế</c:when>
                                                <c:otherwise>Khác</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${claim.description}</td>
                                        <td>${claim.payment_bank}</td>
                                        <td>
                                            <span class="status-badge status-${claim.claim_status.toLowerCase()}">
                                                <c:choose>
                                                    <c:when test="${claim.claim_status == 'pending'}">Chờ xử lý</c:when>
                                                    <c:when test="${claim.claim_status == 'in_progress'}">Đang xử lý</c:when>
                                                    <c:when test="${claim.claim_status == 'need_info'}">Yêu cầu bổ sung</c:when>
                                                    <c:when test="${claim.claim_status == 'approved'}">Đã duyệt</c:when>
                                                    <c:when test="${claim.claim_status == 'paid'}">Đã thanh toán</c:when>
                                                    <c:when test="${claim.claim_status == 'rejected'}">Từ chối</c:when>
                                                    <c:otherwise>${claim.claim_status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="actions-cell">
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/ClaimDetailServlet?id=${claim.id}" class="btn-sm btn-info">
                                                    Xem chi tiết
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>
        </div>
    </div>


</body>
</html>
