<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Hợp Đồng Bảo Hiểm - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/createcontract.css">
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
        <div class="sidebar">
            <nav class="sidebar-nav">
                <ul>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/staff" class="nav-link">
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/CreateContractServlet" class="nav-link">
                            <span>Tạo hợp đồng mới</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/staff/manage-contracts" class="nav-link">
                            <span>Quản lý hợp đồng</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Tạo Hợp Đồng Bảo Hiểm</h1>
                <p style="color: #666; font-size: 14px;">Nhập thông tin khách hàng và sản phẩm bảo hiểm để tạo hợp đồng mới</p>
            </div>
            
            <c:if test="${not empty success}">
                <div class="alert alert-success" role="alert">
                    <i class="fas fa-check-circle"></i> ${success}
                    <c:if test="${not empty contractId}">
                        <div class="success-info">
                            <strong>Mã hợp đồng:</strong> ${contractId}
                        </div>
                    </c:if>
                    <c:if test="${not empty applicationId}">
                        <div class="success-info">
                            <strong>Mã đơn đăng ký:</strong> ${applicationId}
                        </div>
                    </c:if>
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
                
            <form action="${pageContext.request.contextPath}/CreateContractServlet" method="POST" class="needs-validation" novalidate>
                <div class="form-row">
                    <div class="form-section">
                        <div class="form-title">
                            <span>Thông tin khách hàng</span>
                        </div>
                        
                        <div class="form-group">
                            <label for="fullname" class="required-field">Họ và tên</label>
                            <input type="text" class="form-control" id="fullname" name="fullname" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email" class="required-field">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone" class="required-field">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="cccd" class="required-field">CCCD/CMND</label>
                            <input type="text" class="form-control" id="cccd" name="cccd" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Địa chỉ</label>
                            <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label for="dob">Ngày sinh</label>
                            <input type="date" class="form-control" id="dob" name="dob">
                        </div>
                    </div>
                    
                    <div class="form-section">
                        <div class="form-title">
                            <span>Thông tin bảo hiểm</span>
                        </div>
                        
                        <div class="form-group">
                            <label for="productId" class="required-field">Sản phẩm bảo hiểm</label>
                            <select class="form-select" id="productId" name="productId" required>
                                <option value="">-- Chọn sản phẩm bảo hiểm --</option>
                                <c:forEach var="product" items="${products}">
                                    <option value="${product.id}">
                                        ${product.name} - 
                                        <c:choose>
                                            <c:when test="${product.type == 'domestic'}">Trong Nước</c:when>
                                            <c:when test="${product.type == 'international'}">Quốc Tế</c:when>
                                            <c:otherwise>${product.type}</c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="destination">Điểm đến</label>
                            <input type="text" class="form-control" id="destination" name="destination" placeholder="Ví dụ: Thái Lan, Singapore...">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="startDate" class="required-field">Ngày bắt đầu</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" required>
                            </div>
                            <div class="form-group">
                                <label for="endDate" class="required-field">Ngày kết thúc</label>
                                <input type="date" class="form-control" id="endDate" name="endDate" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="travelersQuantity" class="required-field">Số lượng người tham gia</label>
                            <input type="number" class="form-control" id="travelersQuantity" name="travelersQuantity" min="1" value="1" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="contractDescription">Mô tả hợp đồng</label>
                            <textarea class="form-control" id="contractDescription" name="contractDescription" rows="3" placeholder="Mô tả chi tiết về hợp đồng bảo hiểm..."></textarea>
                        </div>
                    </div>
                </div>
                
                <div class="button-container">
                    <button type="submit" class="btn-create">
                        <i class="fas fa-save" style="margin-right: 8px;"></i>Tạo Hợp Đồng
                    </button>
                    <button type="reset" class="btn-secondary">
                        <i class="fas fa-undo" style="margin-right: 8px;"></i>Làm mới
                    </button>
                </div>
            </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/JS/staff.js"></script>
    <script>
        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
        
        // Date validation
        document.getElementById('endDate').addEventListener('change', function() {
            var startDate = document.getElementById('startDate').value;
            var endDate = this.value;
            
            if (startDate && endDate && new Date(endDate) <= new Date(startDate)) {
                this.setCustomValidity('Ngày kết thúc phải sau ngày bắt đầu');
            } else {
                this.setCustomValidity('');
            }
        });
        
        document.getElementById('startDate').addEventListener('change', function() {
            var startDate = this.value;
            var endDate = document.getElementById('endDate').value;
            
            if (startDate && endDate && new Date(endDate) <= new Date(startDate)) {
                document.getElementById('endDate').setCustomValidity('Ngày kết thúc phải sau ngày bắt đầu');
            } else {
                document.getElementById('endDate').setCustomValidity('');
            }
        });
    </script>
</body>
</html>
