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
            <jsp:param name="activePage" value="contract-management"/>
        </jsp:include>

        <!-- Main Content -->
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

            <!-- Contract Information -->
            <div class="contract-detail-section">
                <div class="detail-grid">
                    <!-- Contract Basic Info -->
                    <div class="detail-card">
                        <div class="card-header">
                            <h3><i class="fas fa-file-contract"></i> Thông tin hợp đồng</h3>
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

                    <!-- Buyer Info -->
                    <c:if test="${not empty buyer}">
                    <div class="detail-card">
                        <div class="card-header">
                            <h3><i class="fas fa-user"></i> Thông tin người mua</h3>
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
                            <h3><i class="fas fa-clipboard-list"></i> Thông tin đơn đăng ký</h3>
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

                    <!-- Product Info -->
                    <c:if test="${not empty product}">
                    <div class="detail-card">
                        <div class="card-header">
                            <h3><i class="fas fa-shield-alt"></i> Thông tin sản phẩm</h3>
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

                    <!-- Application Travelers Info -->
        <c:if test="${not empty travelers}">
            <div class="travelers-section">
                <h3><i class="fas fa-users"></i> Danh sách khách hàng</h3>
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
        </div>
    </div>


</body>
</html>
