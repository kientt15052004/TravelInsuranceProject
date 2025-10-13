<%-- 
    Document   : CreateContractSimple
    Created on : Dec 8, 2024
    Author     : Staff Contract Creation - No JavaScript Version
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Model.InsuranceProduct"%>
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
                        <a href="${pageContext.request.contextPath}/ContractManagementServlet" class="nav-link">
                            <span>Quản lý hợp đồng</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1></i> Tạo Hợp Đồng Bảo Hiểm Mới</h1>
                <p>Tạo hợp đồng bảo hiểm du lịch cho khách hàng tại quầy</p>
            </div>

            <!-- Success Message -->
            <% if (request.getAttribute("success") != null && (Boolean) request.getAttribute("success")) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <strong>Thành công!</strong> Hợp đồng bảo hiểm đã được tạo thành công.
                <div class="success-info">
                    <strong>Mã hợp đồng:</strong> #<%= request.getAttribute("contractId") %><br>
                    <strong>Khách hàng:</strong> <%= request.getAttribute("customerName") %><br>
                    <strong>Gói bảo hiểm:</strong> <%= ((InsuranceProduct) request.getAttribute("insuranceProduct")).getName() %><br>
                    <strong>Thời gian:</strong> <%= request.getAttribute("startDate") %> - <%= request.getAttribute("endDate") %><br>
                    <strong>Tổng phí:</strong> <%= request.getAttribute("totalPrice") %> VNĐ
                </div>
            </div>
            <% } %>

            <!-- Error Messages -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Lỗi!</strong> <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <% if (request.getAttribute("errors") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Có lỗi xảy ra:</strong>
                <ul style="margin: 10px 0 0 20px;">
                    <% for (String error : (List<String>) request.getAttribute("errors")) { %>
                    <li><%= error %></li>
                    <% } %>
                </ul>
            </div>
            <% } %>

            <!-- Contract Creation Form -->
            <form action="${pageContext.request.contextPath}/CreateContractServlet" method="POST" class="contract-form">
                
                <!-- Buyer Information Section -->
                <div class="form-section">
                    <h2 class="form-title">
                        Thông tin người mua
                    </h2>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="buyerId" class="required-field">Số CCCD/CMND</label>
                            <input type="text" 
                                   id="buyerId" 
                                   name="buyerId" 
                                   class="form-control" 
                                   placeholder="Nhập số CCCD/CMND"
                                   value="<%= request.getParameter("buyerId") != null ? request.getParameter("buyerId") : "" %>"
                                   required
                                   pattern="[0-9]{9,12}"
                                   title="Số CCCD/CMND phải có 9-12 chữ số">
                        </div>

                        <div class="form-group">
                            <label for="buyerName" class="required-field">Họ và tên</label>
                            <input type="text" 
                                   id="buyerName" 
                                   name="buyerName" 
                                   class="form-control" 
                                   placeholder="Nhập họ và tên đầy đủ"
                                   value="<%= request.getParameter("buyerName") != null ? request.getParameter("buyerName") : "" %>"
                                   required
                                   pattern="[a-zA-ZÀ-ỹ\s]{2,50}"
                                   title="Tên phải có từ 2-50 ký tự và chỉ chứa chữ cái">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="buyerPhone" class="required-field">Số điện thoại</label>
                            <input type="tel" 
                                   id="buyerPhone" 
                                   name="buyerPhone" 
                                   class="form-control" 
                                   placeholder="Nhập số điện thoại"
                                   value="<%= request.getParameter("buyerPhone") != null ? request.getParameter("buyerPhone") : "" %>"
                                   required
                                   pattern="0[0-9]{9,10}"
                                   title="Số điện thoại phải có 10-11 số và bắt đầu bằng 0">
                        </div>
                        
                        <div class="form-group">
                            <label for="buyerEmail" class="required-field">Email</label>
                            <input type="email" 
                                   id="buyerEmail" 
                                   name="buyerEmail" 
                                   class="form-control" 
                                   placeholder="Nhập địa chỉ email"
                                   value="<%= request.getParameter("buyerEmail") != null ? request.getParameter("buyerEmail") : "" %>"
                                   required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="buyerAddress" class="required-field">Địa chỉ</label>
                            <input type="text" 
                                   id="buyerAddress" 
                                   name="buyerAddress" 
                                   class="form-control" 
                                   placeholder="Nhập địa chỉ đầy đủ"
                                   value="<%= request.getParameter("buyerAddress") != null ? request.getParameter("buyerAddress") : "" %>"
                                   required>
                        </div>
                    </div>
                </div>

                <!-- Customer/Traveler Information Section -->
                <div class="form-section">
                    <h2 class="form-title">
                        Thông tin khách hàng (người được bảo hiểm)
                    </h2>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="customerName" class="required-field">Họ và tên</label>
                            <input type="text" 
                                   id="customerName" 
                                   name="customerName" 
                                   class="form-control" 
                                   placeholder="Nhập họ và tên đầy đủ"
                                   value="<%= request.getParameter("customerName") != null ? request.getParameter("customerName") : "" %>"
                                   required
                                   pattern="[a-zA-ZÀ-ỹ\s]{2,50}"
                                   title="Tên phải có từ 2-50 ký tự và chỉ chứa chữ cái">
                        </div>
                        
                        <div class="form-group">
                            <label for="customerId" class="required-field">Số CCCD/CMND</label>
                            <input type="text" 
                                   id="customerId" 
                                   name="customerId" 
                                   class="form-control" 
                                   placeholder="Nhập số CCCD/CMND"
                                   value="<%= request.getParameter("customerId") != null ? request.getParameter("customerId") : "" %>"
                                   required
                                   pattern="[0-9]{9,12}"
                                   title="Số CCCD/CMND phải có 9-12 chữ số">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="customerPhone" class="required-field">Số điện thoại</label>
                            <input type="tel" 
                                   id="customerPhone" 
                                   name="customerPhone" 
                                   class="form-control" 
                                   placeholder="Nhập số điện thoại"
                                   value="<%= request.getParameter("customerPhone") != null ? request.getParameter("customerPhone") : "" %>"
                                   required
                                   pattern="0[0-9]{9,10}"
                                   title="Số điện thoại phải có 10-11 số và bắt đầu bằng 0">
                        </div>
                        
                        <div class="form-group">
                            <label for="customerEmail" class="required-field">Email</label>
                            <input type="email" 
                                   id="customerEmail" 
                                   name="customerEmail" 
                                   class="form-control" 
                                   placeholder="Nhập địa chỉ email"
                                   value="<%= request.getParameter("customerEmail") != null ? request.getParameter("customerEmail") : "" %>"
                                   required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="customerGender" class="required-field">Giới tính</label>
                            <select id="customerGender" name="customerGender" class="form-select" required>
                                <option value="">-- Chọn giới tính --</option>
                                <option value="Nam" <%= "Nam".equals(request.getParameter("customerGender")) ? "selected" : "" %>>Nam</option>
                                <option value="Nữ" <%= "Nữ".equals(request.getParameter("customerGender")) ? "selected" : "" %>>Nữ</option>
                                <option value="Khác" <%= "Khác".equals(request.getParameter("customerGender")) ? "selected" : "" %>>Khác</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="customerBirthDate" class="required-field">Ngày sinh</label>
                            <input type="date" 
                                   id="customerBirthDate" 
                                   name="customerBirthDate" 
                                   class="form-control"
                                   value="<%= request.getParameter("customerBirthDate") != null ? request.getParameter("customerBirthDate") : "" %>"
                                   required
                                   max="<%= java.time.LocalDate.now().toString() %>"
                                   title="Ngày sinh không được trong tương lai">
                        </div>
                    </div>
                </div>

                <!-- Insurance Package Selection -->
                <div class="form-section">
                    <h2 class="form-title">
                        Chọn gói bảo hiểm
                    </h2>
                    
                    <div class="form-group">
                        <label for="insuranceProductId" class="required-field">Gói bảo hiểm</label>
                        <select id="insuranceProductId" name="insuranceProductId" class="form-select" required>
                            <option value="">-- Chọn gói bảo hiểm --</option>
                            <% if (request.getAttribute("insuranceProducts") != null) { %>
                                <% for (InsuranceProduct product : (List<InsuranceProduct>) request.getAttribute("insuranceProducts")) { %>
                                <option value="<%= product.getId() %>" 
                                        <%= String.valueOf(product.getId()).equals(request.getParameter("insuranceProductId")) ? "selected" : "" %>>
                                    <%= product.getName() %> - <%= product.getType().equals("domestic") ? "Trong nước" : "Quốc tế" %> 
                                    (<%= product.getPrice() %> VNĐ/ngày)
                                </option>
                                <% } %>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="destination" class="required-field">Điểm đến</label>
                        <input type="text" 
                               id="destination" 
                               name="destination" 
                               class="form-control" 
                               placeholder="Nhập điểm đến du lịch"
                               value="<%= request.getParameter("destination") != null ? request.getParameter("destination") : "" %>"
                               required>
                    </div>
                </div>

                <!-- Contract Period -->
                <div class="form-section">
                    <h2 class="form-title">
                        Thời gian bảo hiểm
                    </h2>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startDate" class="required-field">Ngày bắt đầu</label>
                            <input type="date" 
                                   id="startDate" 
                                   name="startDate" 
                                   class="form-control"
                                   value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : "" %>"
                                   required
                                   min="<%= java.time.LocalDate.now().toString() %>"
                                   title="Ngày bắt đầu không được trong quá khứ">
                        </div>
                        
                        <div class="form-group">
                            <label for="endDate" class="required-field">Ngày kết thúc</label>
                            <input type="date" 
                                   id="endDate" 
                                   name="endDate" 
                                   class="form-control"
                                   value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : "" %>"
                                   required
                                   min="<%= java.time.LocalDate.now().toString() %>"
                                   title="Ngày kết thúc phải sau ngày bắt đầu">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="contractDescription">Ghi chú thêm</label>
                        <textarea id="contractDescription" 
                                  name="contractDescription" 
                                  class="form-control" 
                                  rows="3" 
                                  placeholder="Nhập ghi chú thêm về hợp đồng (không bắt buộc)"><%= request.getParameter("contractDescription") != null ? request.getParameter("contractDescription") : "" %></textarea>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="button-container">
                    <button type="submit" class="btn-create">
                        Tạo hợp đồng
                    </button>
                    <button type="reset" class="btn-secondary">
                        Làm mới
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Meta refresh removed - was causing infinite reload loop -->
    
    <script>
        // Auto-fill functionality for BUYER when CCCD is entered
        document.getElementById('buyerId').addEventListener('blur', function() {
            const cccd = this.value.trim();
            if (cccd.length >= 9) { // Minimum CCCD length
                checkBuyerByCccd(cccd);
            }
        });
        
        function checkBuyerByCccd(cccd) {
            fetch('${pageContext.request.contextPath}/CheckUserServlet?cccd=' + encodeURIComponent(cccd))
                .then(response => response.json())
                .then(data => {
                    if (data.exists) {
                        // Tim thay user thi gan data vao cac truong
                        document.getElementById('buyerName').value = data.fullname || '';
                        document.getElementById('buyerPhone').value = data.phone || '';
                        document.getElementById('buyerEmail').value = data.email || '';
                        document.getElementById('buyerAddress').value = data.address || '';
                        
                        // Chuyen sang trang thai read only
                        document.getElementById('buyerName').readOnly = true;
                        document.getElementById('buyerPhone').readOnly = true;
                        document.getElementById('buyerEmail').readOnly = true;
                        document.getElementById('buyerAddress').readOnly = true;
                        
                        // Add visual indicator
                        showBuyerFoundIndicator();
                        
                        // Show message
                        showMessage('Tìm thấy dữ liệu người mua.', 'success');
                    } else {
                        // Buyer not found - enable buyer fields for manual input
                        enableBuyerFields();
                        hideBuyerFoundIndicator();
                    }
                })
                .catch(error => {
                    console.error('Error checking buyer:', error);
                    enableBuyerFields();
                    hideBuyerFoundIndicator();
                });
        }
        
        function enableBuyerFields() {
            document.getElementById('buyerName').readOnly = false;
            document.getElementById('buyerPhone').readOnly = false;
            document.getElementById('buyerEmail').readOnly = false;
            document.getElementById('buyerAddress').readOnly = false;
        }
        
        function showBuyerFoundIndicator() {
            const buyerIdField = document.getElementById('buyerId');
            buyerIdField.style.borderColor = '#28a745';
            buyerIdField.style.backgroundColor = '#f8fff9';
            
            // Add checkmark icon
            if (!document.getElementById('buyerFoundIcon')) {
                const icon = document.createElement('i');
                icon.id = 'buyerFoundIcon';
                icon.className = 'fas fa-check-circle';
                icon.style.color = '#28a745';
                icon.style.marginLeft = '10px';
                buyerIdField.parentNode.appendChild(icon);
            }
        }
        
        function hideBuyerFoundIndicator() {
            const buyerIdField = document.getElementById('buyerId');
            buyerIdField.style.borderColor = '';
            buyerIdField.style.backgroundColor = '';
            
            const icon = document.getElementById('buyerFoundIcon');
            if (icon) {
                icon.remove();
            }
        }
        
        function showMessage(message, type) {
            // Remove existing message
            const existingMessage = document.getElementById('autoFillMessage');
            if (existingMessage) {
                existingMessage.remove();
            }
            
            // Create new message
            const messageDiv = document.createElement('div');
            messageDiv.id = 'autoFillMessage';
            messageDiv.className = 'alert alert-' + (type === 'success' ? 'success' : 'info');
            messageDiv.style.marginTop = '10px';
            messageDiv.innerHTML = '<i class="fas fa-info-circle"></i> ' + message;
            
            // Insert after buyer information section
            const buyerSection = document.querySelector('.form-section');
            buyerSection.appendChild(messageDiv);
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                if (messageDiv.parentNode) {
                    messageDiv.remove();
                }
            }, 5000);
        }
        
        // Reset form functionality
        document.querySelector('button[type="reset"]').addEventListener('click', function() {
            setTimeout(() => {
                enableBuyerFields();
                hideBuyerFoundIndicator();
                const message = document.getElementById('autoFillMessage');
                if (message) {
                    message.remove();
                }
            }, 100);
        });
    </script>
</body>
</html>
