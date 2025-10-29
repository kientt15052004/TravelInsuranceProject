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
        <jsp:include page="component/staff-sidebar.jsp">
            <jsp:param name="activePage" value="create-contract"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1></i> Tạo Hợp Đồng Bảo Hiểm Mới</h1>
                <p>Tạo hợp đồng bảo hiểm du lịch cho khách hàng tại quầy</p>
            </div>

            <% 
                // Declare successFlag once for the entire page
                Boolean successFlag = (Boolean) request.getAttribute("success");
            %>

            <!-- Success Message -->
            <% 
                if (successFlag != null && successFlag && request.getAttribute("contractId") != null) { 
            %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <strong>Thành công!</strong> Hợp đồng bảo hiểm đã được tạo thành công.
                <div class="success-info">
                    <strong>Mã hợp đồng:</strong> #<%= request.getAttribute("contractId") %><br>
                    <% if (request.getAttribute("travelerSummary") != null) { %>
                    <strong>Người được bảo hiểm:</strong> <%= request.getAttribute("travelerSummary") %><br>
                    <% } %>
                    <% if (request.getAttribute("travelerCount") != null) { %>
                    <strong>Số người được bảo hiểm:</strong> <%= request.getAttribute("travelerCount") %><br>
                    <% } %>
                    <% if (request.getAttribute("insuranceProduct") != null) { %>
                    <strong>Gói bảo hiểm:</strong> <%= ((InsuranceProduct) request.getAttribute("insuranceProduct")).getName() %><br>
                    <% } %>
                    <% if (request.getAttribute("startDate") != null && request.getAttribute("endDate") != null) { %>
                    <strong>Thời gian:</strong> <%= request.getAttribute("startDate") %> - <%= request.getAttribute("endDate") %><br>
                    <% } %>
                    <% if (request.getAttribute("totalPrice") != null) { %>
                    <strong>Tổng phí:</strong> <%= request.getAttribute("totalPrice") %> VNĐ
                    <% } %>
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

                <% 
                    // Use the successFlag already declared above
                    boolean resetTravelers = successFlag != null && successFlag;
                    String[] travelerNames = resetTravelers ? null : request.getParameterValues("travelerName");
                    String[] travelerIds = resetTravelers ? null : request.getParameterValues("travelerId");
                    String[] travelerPhones = resetTravelers ? null : request.getParameterValues("travelerPhone");
                    String[] travelerEmails = resetTravelers ? null : request.getParameterValues("travelerEmail");
                    String[] travelerGenders = resetTravelers ? null : request.getParameterValues("travelerGender");
                    String[] travelerBirthDates = resetTravelers ? null : request.getParameterValues("travelerBirthDate");
                    int travelerCount = (!resetTravelers && travelerNames != null && travelerNames.length > 0) ? travelerNames.length : 1;
                %>

                <!-- Customer/Traveler Information Section -->
                <div class="form-section">
                    <h2 class="form-title">
                        Thông tin khách hàng (người được bảo hiểm)
                    </h2>

                    <div id="travelersContainer">
                        <% for (int i = 0; i < travelerCount; i++) { 
                                String nameValue = (travelerNames != null && travelerNames.length > i && travelerNames[i] != null) ? travelerNames[i] : "";
                                String idValue = (travelerIds != null && travelerIds.length > i && travelerIds[i] != null) ? travelerIds[i] : "";
                                String phoneValue = (travelerPhones != null && travelerPhones.length > i && travelerPhones[i] != null) ? travelerPhones[i] : "";
                                String emailValue = (travelerEmails != null && travelerEmails.length > i && travelerEmails[i] != null) ? travelerEmails[i] : "";
                                String genderValue = (travelerGenders != null && travelerGenders.length > i && travelerGenders[i] != null) ? travelerGenders[i] : "";
                                String birthDateValue = (travelerBirthDates != null && travelerBirthDates.length > i && travelerBirthDates[i] != null) ? travelerBirthDates[i] : "";
                        %>
                        <div class="traveler-item" data-index="<%= i %>">
                            <div class="traveler-header">
                                <h3 class="traveler-title">Người được bảo hiểm <%= (i + 1) %></h3>
                                <button type="button" class="btn-remove-traveler" onclick="removeTraveler(this)" <%= travelerCount == 1 ? "disabled" : "" %>>
                                    <i class="fas fa-trash"></i>
                                    Xóa
                                </button>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="travelerName_<%= i %>" class="required-field">Họ và tên</label>
                                    <input type="text"
                                           id="travelerName_<%= i %>"
                                           name="travelerName"
                                           class="form-control"
                                           placeholder="Nhập họ và tên đầy đủ"
                                           value="<%= nameValue %>"
                                           required
                                           pattern="[a-zA-ZÀ-ỹ\s]{2,50}"
                                           title="Tên phải có từ 2-50 ký tự và chỉ chứa chữ cái">
                                </div>

                                <div class="form-group">
                                    <label for="travelerId_<%= i %>" class="required-field">Số CCCD/CMND</label>
                                    <input type="text"
                                           id="travelerId_<%= i %>"
                                           name="travelerId"
                                           class="form-control"
                                           placeholder="Nhập số CCCD/CMND"
                                           value="<%= idValue %>"
                                           required
                                           pattern="[0-9]{9,12}"
                                           title="Số CCCD/CMND phải có 9-12 chữ số">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="travelerPhone_<%= i %>" class="required-field">Số điện thoại</label>
                                    <input type="tel"
                                           id="travelerPhone_<%= i %>"
                                           name="travelerPhone"
                                           class="form-control"
                                           placeholder="Nhập số điện thoại"
                                           value="<%= phoneValue %>"
                                           required
                                           pattern="0[0-9]{9,10}"
                                           title="Số điện thoại phải có 10-11 số và bắt đầu bằng 0">
                                </div>

                                <div class="form-group">
                                    <label for="travelerEmail_<%= i %>" class="required-field">Email</label>
                                    <input type="email"
                                           id="travelerEmail_<%= i %>"
                                           name="travelerEmail"
                                           class="form-control"
                                           placeholder="Nhập địa chỉ email"
                                           value="<%= emailValue %>"
                                           required>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="travelerGender_<%= i %>" class="required-field">Giới tính</label>
                                    <select id="travelerGender_<%= i %>" name="travelerGender" class="form-select" required>
                                        <option value="">-- Chọn giới tính --</option>
                                        <option value="Nam" <%= "Nam".equalsIgnoreCase(genderValue) ? "selected" : "" %>>Nam</option>
                                        <option value="Nữ" <%= "Nữ".equalsIgnoreCase(genderValue) ? "selected" : "" %>>Nữ</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="travelerBirthDate_<%= i %>" class="required-field">Ngày sinh</label>
                                    <input type="date"
                                           id="travelerBirthDate_<%= i %>"
                                           name="travelerBirthDate"
                                           class="form-control"
                                           value="<%= birthDateValue %>"
                                           required
                                           max="<%= java.time.LocalDate.now().toString() %>"
                                           title="Ngày sinh không được trong tương lai">
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>

                    <div class="traveler-actions">
                        <button type="button" class="btn-add-traveler" onclick="addTraveler()">
                            <i class="fas fa-user-plus"></i>
                            Thêm người được bảo hiểm
                        </button>
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
                            <% 
                                List<InsuranceProduct> products = (List<InsuranceProduct>) request.getAttribute("insuranceProducts");
                                if (products != null && !products.isEmpty()) {
                                    for (InsuranceProduct product : products) {
                            %>
                                <option value="<%= product.getId() %>"
                                        <%= String.valueOf(product.getId()).equals(request.getParameter("insuranceProductId")) ? "selected" : "" %>>
                                    <%= product.getName() %> - <%= product.getType().equals("domestic") ? "Trong nước" : "Quốc tế" %> 
                                    (<%= product.getPrice() %> VNĐ/ngày)
                                </option>
                            <% 
                                    }
                                } else if (products != null && products.isEmpty()) {
                            %>
                                <option value="" disabled>Không có gói bảo hiểm nào khả dụng</option>
                            <% } %>
                        </select>
                        <% if (request.getAttribute("insuranceProducts") == null) { %>
                            <small style="color: #dc3545; display: block; margin-top: 5px;">
                                <i class="fas fa-exclamation-triangle"></i> Không thể tải danh sách gói bảo hiểm. Vui lòng tải lại trang.
                            </small>
                        <% } %>
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
        // Traveler dynamic fields
        let travelerIndexCounter = document.querySelectorAll('#travelersContainer .traveler-item').length;

        function addTraveler() {
            const container = document.getElementById('travelersContainer');
            if (!container) return;

            const index = travelerIndexCounter++;
            const today = new Date().toISOString().split('T')[0];

            const wrapper = document.createElement('div');
            wrapper.className = 'traveler-item';
            wrapper.setAttribute('data-index', index);
            wrapper.innerHTML = `
                <div class="traveler-header">
                    <h3 class="traveler-title">Người được bảo hiểm ${index + 1}</h3>
                    <button type="button" class="btn-remove-traveler" onclick="removeTraveler(this)">
                        <i class="fas fa-trash"></i>
                        Xóa
                    </button>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="travelerName_${index}" class="required-field">Họ và tên</label>
                        <input type="text"
                               id="travelerName_${index}"
                               name="travelerName"
                               class="form-control"
                               placeholder="Nhập họ và tên đầy đủ"
                               required
                               pattern="[a-zA-ZÀ-ỹ\\s]{2,50}"
                               title="Tên phải có từ 2-50 ký tự và chỉ chứa chữ cái">
                    </div>
                    <div class="form-group">
                        <label for="travelerId_${index}" class="required-field">Số CCCD/CMND</label>
                        <input type="text"
                               id="travelerId_${index}"
                               name="travelerId"
                               class="form-control"
                               placeholder="Nhập số CCCD/CMND"
                               required
                               pattern="[0-9]{9,12}"
                               title="Số CCCD/CMND phải có 9-12 chữ số">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="travelerPhone_${index}" class="required-field">Số điện thoại</label>
                        <input type="tel"
                               id="travelerPhone_${index}"
                               name="travelerPhone"
                               class="form-control"
                               placeholder="Nhập số điện thoại"
                               required
                               pattern="0[0-9]{9,10}"
                               title="Số điện thoại phải có 10-11 số và bắt đầu bằng 0">
                    </div>
                    <div class="form-group">
                        <label for="travelerEmail_${index}" class="required-field">Email</label>
                        <input type="email"
                               id="travelerEmail_${index}"
                               name="travelerEmail"
                               class="form-control"
                               placeholder="Nhập địa chỉ email"
                               required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="travelerGender_${index}" class="required-field">Giới tính</label>
                        <select id="travelerGender_${index}" name="travelerGender" class="form-select" required>
                            <option value="">-- Chọn giới tính --</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="travelerBirthDate_${index}" class="required-field">Ngày sinh</label>
                        <input type="date"
                               id="travelerBirthDate_${index}"
                               name="travelerBirthDate"
                               class="form-control"
                               required
                               max="${today}"
                               title="Ngày sinh không được trong tương lai">
                    </div>
                </div>
            `;

            container.appendChild(wrapper);
            updateTravelerState();
        }

        function removeTraveler(button) {
            const container = document.getElementById('travelersContainer');
            if (!container) return;

            const items = container.querySelectorAll('.traveler-item');
            if (items.length <= 1) {
                return;
            }

            const target = button.closest('.traveler-item');
            if (target) {
                container.removeChild(target);
                updateTravelerState();
            }
        }

        function updateTravelerState() {
            const items = document.querySelectorAll('#travelersContainer .traveler-item');
            items.forEach((item, idx) => {
                const title = item.querySelector('.traveler-title');
                if (title) {
                    title.textContent = 'Người được bảo hiểm ' + (idx + 1);
                }

                const removeBtn = item.querySelector('.btn-remove-traveler');
                if (removeBtn) {
                    removeBtn.disabled = items.length === 1;
                }
            });
        }

        document.addEventListener('DOMContentLoaded', () => {
            updateTravelerState();
        });

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
        
        // Auto-hide success alert after 5 seconds
        (function() {
            const successAlert = document.querySelector('.alert.alert-success');
            if (successAlert) {
                // Fade out animation
                setTimeout(() => {
                    successAlert.style.transition = 'opacity 0.5s ease-out, margin 0.5s ease-out, padding 0.5s ease-out';
                    successAlert.style.opacity = '0';
                    successAlert.style.margin = '0';
                    successAlert.style.padding = '0';
                    successAlert.style.height = '0';
                    successAlert.style.overflow = 'hidden';
                    
                    // Remove element completely after animation
                    setTimeout(() => {
                        if (successAlert.parentNode) {
                            successAlert.remove();
                        }
                    }, 500);
                }, 5000); // Show for 5 seconds
            }
        })();
    </script>
</body>
</html>
