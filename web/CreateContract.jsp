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
    <jsp:include page="component/staff-header.jsp"/>

    <div class="container">
        <jsp:include page="component/staff-sidebar.jsp">
            <jsp:param name="activePage" value="create-contract"/>
        </jsp:include>

        <div class="main-content">
            <div class="content-header">
                <h1></i> Tạo Hợp Đồng Bảo Hiểm Mới</h1>
                <p>Tạo hợp đồng bảo hiểm du lịch cho khách hàng tại quầy</p>
            </div>

            <% 
                Boolean successFlag = (Boolean) request.getAttribute("success");
            %>

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

            <form action="${pageContext.request.contextPath}/CreateContractServlet" method="POST" class="contract-form">
                
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
                                   value="<%= request.getAttribute("buyerId") != null ? request.getAttribute("buyerId") : (request.getParameter("buyerId") != null ? request.getParameter("buyerId") : "") %>"
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
                                   value="<%= request.getAttribute("buyerName") != null ? request.getAttribute("buyerName") : (request.getParameter("buyerName") != null ? request.getParameter("buyerName") : "") %>"
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
                                   value="<%= request.getAttribute("buyerPhone") != null ? request.getAttribute("buyerPhone") : (request.getParameter("buyerPhone") != null ? request.getParameter("buyerPhone") : "") %>"
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
                                   value="<%= request.getAttribute("buyerEmail") != null ? request.getAttribute("buyerEmail") : (request.getParameter("buyerEmail") != null ? request.getParameter("buyerEmail") : "") %>"
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
                                   value="<%= request.getAttribute("buyerAddress") != null ? request.getAttribute("buyerAddress") : (request.getParameter("buyerAddress") != null ? request.getParameter("buyerAddress") : "") %>"
                                   required>
                        </div>
                    </div>
                </div>

                <%
                    boolean resetTravelers = successFlag != null && successFlag;
                    String action = request.getParameter("action");
                    
                    // Check if data comes from attributes (from removeTraveler action)
                    String[] travelerNames = (String[]) request.getAttribute("travelerNames");
                    String[] travelerIds = (String[]) request.getAttribute("travelerIds");
                    String[] travelerPhones = (String[]) request.getAttribute("travelerPhones");
                    String[] travelerEmails = (String[]) request.getAttribute("travelerEmails");
                    String[] travelerGenders = (String[]) request.getAttribute("travelerGenders");
                    String[] travelerBirthDates = (String[]) request.getAttribute("travelerBirthDates");
                    
                    // If not from attributes, get from parameters
                    if (travelerNames == null) {
                        travelerNames = resetTravelers ? null : request.getParameterValues("travelerName");
                        travelerIds = resetTravelers ? null : request.getParameterValues("travelerId");
                        travelerPhones = resetTravelers ? null : request.getParameterValues("travelerPhone");
                        travelerEmails = resetTravelers ? null : request.getParameterValues("travelerEmail");
                        travelerGenders = resetTravelers ? null : request.getParameterValues("travelerGender");
                        travelerBirthDates = resetTravelers ? null : request.getParameterValues("travelerBirthDate");
                    }
                    
                    int travelerCount = 1;
                    if (!resetTravelers && travelerNames != null && travelerNames.length > 0) {
                        if ("addTraveler".equals(action)) {
                            travelerCount = travelerNames.length + 1;
                        } else if ("removeTraveler".equals(action)) {
                            travelerCount = Math.max(1, travelerNames.length - 1);
                        } else {
                            travelerCount = travelerNames.length;
                        }
                    }
                %>
                
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
                            <input type="hidden" name="removeIndex" value="<%= i %>" />
                            <div class="traveler-header">
                                <h3 class="traveler-title">Người được bảo hiểm <%= (i + 1) %></h3>
                                <button type="submit" name="action" value="removeTraveler" class="btn-remove-traveler" formnovalidate <%= travelerCount == 1 ? "disabled" : "" %>>
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
                        <button type="submit" name="action" value="addTraveler" class="btn-add-traveler" formnovalidate>
                            <i class="fas fa-user-plus"></i>
                            Thêm người được bảo hiểm
                        </button>
                    </div>
                </div>

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
                                        String priceStr = product.getPrice() != null ? product.getPrice().toString() : "0";
                                        String typeStr = product.getType() != null ? product.getType() : "";
                                        String domesticRate = product.getDomestic_percentage_rate() != null ? product.getDomestic_percentage_rate().toString() : "1";
                                        String intRate1_7 = product.getInternational_rate_1_7() != null ? product.getInternational_rate_1_7().toString() : "1";
                                        String intRate8_30 = product.getInternational_rate_8_30() != null ? product.getInternational_rate_8_30().toString() : "1";
                                        String intRate31_90 = product.getInternational_rate_31_90() != null ? product.getInternational_rate_31_90().toString() : "1";
                                        String intRate91_365 = product.getInternational_rate_91_365() != null ? product.getInternational_rate_91_365().toString() : "1";
                            %>
                                <option value="<%= product.getId() %>"
                                        data-price="<%= priceStr %>"
                                        data-type="<%= typeStr %>"
                                        data-domestic-rate="<%= domesticRate %>"
                                        data-int-rate-1-7="<%= intRate1_7 %>"
                                        data-int-rate-8-30="<%= intRate8_30 %>"
                                        data-int-rate-31-90="<%= intRate31_90 %>"
                                        data-int-rate-91-365="<%= intRate91_365 %>"
                                        <%= String.valueOf(product.getId()).equals(request.getAttribute("insuranceProductId") != null ? request.getAttribute("insuranceProductId").toString() : (request.getParameter("insuranceProductId") != null ? request.getParameter("insuranceProductId") : "")) ? "selected" : "" %>>
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
                               value="<%= request.getAttribute("destination") != null ? request.getAttribute("destination") : (request.getParameter("destination") != null ? request.getParameter("destination") : "") %>"
                               required>
                    </div>
                </div>

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
                                   value="<%= request.getAttribute("startDate") != null ? request.getAttribute("startDate") : (request.getParameter("startDate") != null ? request.getParameter("startDate") : "") %>"
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
                                   value="<%= request.getAttribute("endDate") != null ? request.getAttribute("endDate") : (request.getParameter("endDate") != null ? request.getParameter("endDate") : "") %>"
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
                                  placeholder="Nhập ghi chú thêm về hợp đồng (không bắt buộc)"><%= request.getAttribute("contractDescription") != null ? request.getAttribute("contractDescription") : (request.getParameter("contractDescription") != null ? request.getParameter("contractDescription") : "") %></textarea>
                    </div>
                </div>

                <%
                    // Tính tổng tiền ở server-side
                    String totalPriceDisplay = "0";
                    
                    try {
                        // Lấy các giá trị từ request
                        String insuranceProductIdParam = null;
                        Object insuranceProductIdAttr = request.getAttribute("insuranceProductId");
                        if (insuranceProductIdAttr != null) {
                            insuranceProductIdParam = insuranceProductIdAttr.toString();
                        } else {
                            insuranceProductIdParam = request.getParameter("insuranceProductId");
                        }
                        
                        String startDateParam = null;
                        Object startDateAttr = request.getAttribute("startDate");
                        if (startDateAttr != null) {
                            startDateParam = startDateAttr.toString();
                        } else {
                            startDateParam = request.getParameter("startDate");
                        }
                        
                        String endDateParam = null;
                        Object endDateAttr = request.getAttribute("endDate");
                        if (endDateAttr != null) {
                            endDateParam = endDateAttr.toString();
                        } else {
                            endDateParam = request.getParameter("endDate");
                        }
                        
                        // Kiểm tra nếu có đủ thông tin để tính
                        if (insuranceProductIdParam != null && !insuranceProductIdParam.trim().isEmpty() 
                            && startDateParam != null && !startDateParam.trim().isEmpty() 
                            && endDateParam != null && !endDateParam.trim().isEmpty()) {
                            
                            // Lấy product từ list (dùng tên biến khác để tránh conflict)
                            List<InsuranceProduct> productList = (List<InsuranceProduct>) request.getAttribute("insuranceProducts");
                            InsuranceProduct selectedProduct = null;
                            if (productList != null && !productList.isEmpty()) {
                                String productIdStr = insuranceProductIdParam.trim();
                                for (InsuranceProduct p : productList) {
                                    if (p != null && String.valueOf(p.getId()).equals(productIdStr)) {
                                        selectedProduct = p;
                                        break;
                                    }
                                }
                            }
                            
                            if (selectedProduct != null && selectedProduct.getPrice() != null) {
                                try {
                                    // Parse dates
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                                    java.util.Date startDate = sdf.parse(startDateParam.trim());
                                    java.util.Date endDate = sdf.parse(endDateParam.trim());
                                    
                                    // Tính số ngày
                                    long diffInMillies = endDate.getTime() - startDate.getTime();
                                    int days = (int) (diffInMillies / (1000 * 60 * 60 * 24)) + 1;
                                    
                                    if (days > 0 && travelerCount > 0) {
                                        // Công thức: Giá tiền × Số ngày × Số người
                                        java.math.BigDecimal basePrice = selectedProduct.getPrice();
                                        java.math.BigDecimal totalPrice = basePrice
                                            .multiply(new java.math.BigDecimal(days))
                                            .multiply(new java.math.BigDecimal(travelerCount));
                                        
                                        // Format số tiền - dùng cách đơn giản để tránh lỗi locale
                                        long totalPriceLong = totalPrice.longValue();
                                        // Format thủ công với dấu phẩy ngăn cách hàng nghìn
                                        java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");
                                        totalPriceDisplay = df.format(totalPriceLong);
                                    }
                                } catch (java.text.ParseException pe) {
                                    // Lỗi parse date, giữ giá trị "0"
                                    totalPriceDisplay = "0";
                                } catch (Exception e) {
                                    // Lỗi khác, giữ giá trị "0"
                                    totalPriceDisplay = "0";
                                }
                            }
                        }
                    } catch (Exception e) {
                        // Nếu có lỗi bất kỳ, giữ giá trị mặc định "0"
                        totalPriceDisplay = "0";
                    }
                %>

                <!-- Tổng số tiền -->
                <div class="form-section total-price-section">
                    <div class="total-price-container">
                        <div class="total-price-label">
                            <i class="fas fa-calculator"></i>
                            <span>Tổng số tiền:</span>
                        </div>
                        <div class="total-price-amount" id="totalPriceDisplay">
                            <span class="price-value"><%= totalPriceDisplay %></span>
                            <span class="currency">VNĐ</span>
                        </div>
                    </div>
                    <div class="total-price-actions">
                        <button type="submit" name="action" value="calculatePrice" class="btn-calculate-price" formnovalidate>
                            <i class="fas fa-sync-alt"></i>
                            Tính tổng tiền
                        </button>
                    </div>
                    <div class="total-price-breakdown" id="priceBreakdown" style="display: none;">
                        <small class="breakdown-text">
                            <span id="breakdownText"></span>
                        </small>
                    </div>
                </div>

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

    
    <script>
        // Hàm format số tiền - định nghĩa trước
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(Math.round(amount));
        }
        
        // JavaScript functions for price calculation removed - now using server-side calculation
        // Price calculation is now done in JSP scriptlet (server-side)
        
        // Setup event listener khi DOM ready
        document.addEventListener('DOMContentLoaded', function() {
            // Buyer ID blur event
            const buyerIdField = document.getElementById('buyerId');
            if (buyerIdField) {
                buyerIdField.addEventListener('blur', function() {
                    const cccd = this.value.trim();
                    if (cccd.length >= 9) {
                        checkBuyerByCccd(cccd);
                    }
                });
            }
            
            // Reset button event
            const resetButton = document.querySelector('button[type="reset"]');
            if (resetButton) {
                resetButton.addEventListener('click', function() {
                    setTimeout(() => {
                        enableBuyerFields();
                        hideBuyerFoundIndicator();
                        const message = document.getElementById('autoFillMessage');
                        if (message) {
                            message.remove();
                        }
                    }, 100);
                });
            }
            
            // Auto-hide success alert
            const successAlert = document.querySelector('.alert.alert-success');
            if (successAlert) {
                setTimeout(() => {
                    successAlert.style.transition = 'opacity 0.5s ease-out, margin 0.5s ease-out, padding 0.5s ease-out';
                    successAlert.style.opacity = '0';
                    successAlert.style.margin = '0';
                    successAlert.style.padding = '0';
                    successAlert.style.height = '0';
                    successAlert.style.overflow = 'hidden';
                    
                    setTimeout(() => {
                        if (successAlert.parentNode) {
                            successAlert.remove();
                        }
                    }, 500);
                }, 5000);
            }
        });
        
        function checkBuyerByCccd(cccd) {
            fetch('${pageContext.request.contextPath}/CheckUserServlet?cccd=' + encodeURIComponent(cccd))
                .then(response => response.json())
                .then(data => {
                    if (data.exists) {
                        document.getElementById('buyerName').value = data.fullname || '';
                        document.getElementById('buyerPhone').value = data.phone || '';
                        document.getElementById('buyerEmail').value = data.email || '';
                        document.getElementById('buyerAddress').value = data.address || '';
                        
                        document.getElementById('buyerName').readOnly = true;
                        document.getElementById('buyerPhone').readOnly = true;
                        document.getElementById('buyerEmail').readOnly = true;
                        document.getElementById('buyerAddress').readOnly = true;
                        
                        showBuyerFoundIndicator();
                        
                        showMessage('Tìm thấy dữ liệu người mua.', 'success');
                    } else {
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
            const existingMessage = document.getElementById('autoFillMessage');
            if (existingMessage) {
                existingMessage.remove();
            }
            
            const messageDiv = document.createElement('div');
            messageDiv.id = 'autoFillMessage';
            messageDiv.className = 'alert alert-' + (type === 'success' ? 'success' : 'info');
            messageDiv.style.marginTop = '10px';
            messageDiv.innerHTML = '<i class="fas fa-info-circle"></i> ' + message;
            
            const buyerSection = document.querySelector('.form-section');
            buyerSection.appendChild(messageDiv);
            
            setTimeout(() => {
                if (messageDiv.parentNode) {
                    messageDiv.remove();
                }
            }, 5000);
        }
    </script>
</body>
</html>
