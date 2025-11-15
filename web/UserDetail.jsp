<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết User - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/userdetail.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="component/staff-header.jsp"/>

    <div class="container">
        <jsp:include page="component/staff-sidebar.jsp">
            <jsp:param name="activePage" value="user-management"/>
        </jsp:include>

        <div class="main-content">
            <div class="content-header">
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/usermanagement" class="btn-back">
                        Quay lại
                    </a>
                </div>
                <h1>Thông tin User</h1>
            </div>

            <c:if test="${param.success == 'true'}">
                <div class="alert alert-success">
                    Cập nhật thông tin thành công!
                </div>
            </c:if>
            <c:if test="${param.error == 'true'}">
                <div class="alert alert-error">
                    Có lỗi xảy ra khi cập nhật thông tin!
                </div>
            </c:if>

            <c:if test="${not empty user}">
                <div class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-user"></i> Thông tin cá nhân</h2>
                        <button type="button" class="btn-edit-toggle" onclick="toggleEditForm()">
                            <i class="fas fa-edit"></i>
                            Chỉnh sửa
                        </button>
                    </div>
                    
                    <div class="user-info-grid">
                        <div class="info-item">
                            <label>ID:</label>
                            <span>${user.id}</span>
                        </div>
                        <div class="info-item">
                            <label>Username:</label>
                            <span>${user.username}</span>
                        </div>
                        <div class="info-item">
                            <label>Họ tên:</label>
                            <span>${user.fullname}</span>
                        </div>
                        <div class="info-item">
                            <label>Email:</label>
                            <span>${user.mail}</span>
                        </div>
                        <div class="info-item">
                            <label>Ngày sinh:</label>
                            <span>
                                <c:choose>
                                    <c:when test="${not empty user.dob}">
                                        <%
                                            Model.User user = (Model.User) request.getAttribute("user");
                                            if (user != null && user.getDob() != null) {
                                                out.print(user.getDob().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
                                            }
                                        %>
                                    </c:when>
                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-item">
                            <label>CCCD:</label>
                            <span>${user.cccd}</span>
                        </div>
                        <div class="info-item">
                            <label>Số điện thoại:</label>
                            <span id="phone-display">${user.phone}</span>
                        </div>
                        <div class="info-item">
                            <label>Địa chỉ:</label>
                            <span id="address-display">${user.address}</span>
                        </div>
                        <div class="info-item">
                            <label>Vai trò:</label>
                            <p class="role-text role-${user.role}" id="role-display">
                                <c:choose>
                                    <c:when test="${user.role == 'customer'}">Khách hàng</c:when>
                                    <c:when test="${user.role == 'staff'}">Nhân viên</c:when>
                                    <c:when test="${user.role == 'admin'}">Quản trị</c:when>
                                    <c:otherwise>${user.role}</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="info-item">
                            <label>Trạng thái:</label>
                            <p id="status-display" class="status-text status-${user.status}">
                                <c:choose>
                                    <c:when test="${user.status == 'active'}">Hoạt động</c:when>
                                    <c:when test="${user.status == 'inactive'}">Không hoạt động</c:when>
                                    <c:otherwise>${user.status}</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="info-item">
                            <label>Tổng số tiền mua bảo hiểm:</label>
                            <span class="total-amount">
                                <fmt:formatNumber value="${totalInsuranceAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> ₫
                            </span>
                        </div>
                    </div>

                    <form id="edit-form" class="edit-form" method="POST" action="${pageContext.request.contextPath}/updateuser" style="display: none;">
                        <input type="hidden" name="userId" value="${user.id}">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="phone">Số điện thoại:</label>
                                <input type="text" id="phone" name="phone" value="${user.phone}" maxlength="15">
                            </div>
                            <div class="form-group">
                                <label for="status">Trạng thái:</label>
                                <select id="status" name="status">
                                    <option value="active" ${user.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="inactive" ${user.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Địa chỉ:</label>
                            <textarea id="address" name="address" rows="3" maxlength="500">${user.address}</textarea>
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn-save">
                                Lưu thay đổi
                            </button>
                            <button type="button" class="btn-cancel" onclick="toggleEditForm()">
                                Hủy
                            </button>
                        </div>
                    </form>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2>Lịch sử Mua Bảo Hiểm</h2>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty applications && empty contracts}">
                            <div class="no-data">
                                <p>Chưa có hợp đồng hoặc đơn mua hàng nào</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-container">
                                <table class="combined-table">
                                    <thead>
                                        <tr>
                                            <th>Application ID</th>
                                            <th>Contract ID</th>
                                            <th>Loại bảo hiểm</th>
                                            <th>Điểm đến</th>
                                            <th>Ngày bắt đầu</th>
                                            <th>Ngày kết thúc</th>
                                            <th>Số người</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="app" items="${applications}">
                                            <tr class="application-row">
                                                <td>${app.id}</td>
                                                <td>
                                                    <c:forEach var="contract" items="${contracts}">
                                                        <c:if test="${contract.application_id == app.id}">
                                                            ${contract.contract_id}
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                                <td>${app.type}</td>
                                                <td>${app.destination}</td>
                                                <td>
                                                    <fmt:formatDate value="${app.startDate}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${app.endDate}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>${app.travelers_quantity}</td>
                                                <td>
                                                    <fmt:formatNumber value="${app.total_price}" type="number" maxFractionDigits="0" groupingUsed="true"/> ₫
                                                </td>
                                                <td>
                                                    <c:forEach var="contract" items="${contracts}">
                                                        <c:if test="${contract.application_id == app.id}">
                                                            <span class="status-badge status-${contract.contract_status}">
                                                                ${contract.contract_status}
                                                            </span>
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                                <td>
                                                    <c:forEach var="contract" items="${contracts}">
                                                        <c:if test="${contract.application_id == app.id}">
                                                            <a href="${pageContext.request.contextPath}/ContractDetailServlet?id=${contract.contract_id}&userId=${user.id}" 
                                                               class="btn-detail">
                                                                Xem hợp đồng
                                                            </a>
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="section">
                    <div class="section-header">
                        <h2><i class="fas fa-exclamation-triangle"></i> Lịch sử Bồi thường</h2>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty claims}">
                            <div class="no-data">
                                <i class="fas fa-exclamation-triangle"></i>
                                <p>Chưa có yêu cầu bồi thường nào</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-container">
                                <table class="claims-table">
                                    <thead>
                                        <tr>
                                            <th>Claim ID</th>
                                            <th>Contract ID</th>
                                            <th>Ngày yêu cầu</th>
                                            <th>Loại bồi thường</th>
                                            <th>Mô tả</th>
                                            <th>Ngân hàng</th>
                                            <th>Số tài khoản</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="claim" items="${claims}">
                                            <tr>
                                                <td>${claim.id}</td>
                                                <td>${claim.contract_id}</td>
                                                <td>
                                                    <fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>${claim.claim_type}</td>
                                                <td class="description-cell">${claim.description}</td>
                                                <td>${claim.payment_bank}</td>
                                                <td>${claim.payment_number}</td>
                                                <td>
                                                    <span class="status-badge status-${claim.claim_status}">
                                                        ${claim.claim_status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/ClaimDetailServlet?id=${claim.id}" class="btn-detail">
                                                        Xem chi tiết
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        function toggleEditForm() {
            const editForm = document.getElementById('edit-form');
            const editButton = document.querySelector('.btn-edit-toggle');
            
            if (editForm.style.display === 'none') {
                editForm.style.display = 'block';
                editButton.innerHTML = '<i class="fas fa-times"></i> Hủy';
            } else {
                editForm.style.display = 'none';
                editButton.innerHTML = '<i class="fas fa-edit"></i> Chỉnh sửa';
            }
        }
    </script>
</body>
</html>
