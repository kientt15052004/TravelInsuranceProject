    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <!DOCTYPE html>
<html lang="vi">
        <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Sản Phẩm Bảo Hiểm Du Lịch - TIS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/createproduct.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Top Header -->
    <jsp:include page="component/admin-header.jsp"/>

    <div class="main-container">

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h1>Tạo Sản Phẩm Bảo Hiểm Du Lịch</h1>
                <p>Tạo sản phẩm bảo hiểm du lịch mới với đầy đủ thông tin và quyền lợi</p>
            </div>

            <!-- Success Notification -->
                <c:if test="${not empty notification && not empty img_src 
                              && not empty name && not empty type
                              && not empty package_type && not empty description && not empty price}">
                <div class="alert alert-success">
                    <div class="alert-content">
                        <div class="alert-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="alert-text">
                            <h4>${notification}</h4>
                            <div class="product-summary">
                                <img src="${img_src}" alt="${img_name}" class="product-image">
                                <div class="product-details">
                                    <p><strong>Tên sản phẩm:</strong> ${name}</p>
                                    <p><strong>Loại hình:</strong> ${type}</p>
                                    <p><strong>Gói:</strong> ${package_type}</p>
                                    <p><strong>Mô tả:</strong> ${description}</p>
                                    <p><strong>Giá tiền:</strong> ${price} VNĐ</p>
                                  </div>
                              </div>
                          </div>
                        <button type="button" class="btn-close" onclick="this.parentElement.parentElement.style.display='none'">
                            <i class="fas fa-times"></i>
                        </button>
                          </div>
                      </div>
                </c:if>

            <!-- Create Product Form -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/create_product" enctype="multipart/form-data" method="POST">
                    
                    <!-- Basic Information Section -->
                    <div class="form-section">
                        <div class="section-header">
                            <h2><i class="fas fa-info-circle"></i> Thông tin cơ bản</h2>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-9">
                                <label for="name">Tên sản phẩm <span class="required">*</span></label>
                                <input name="name" type="text" class="form-control" id="name" placeholder="Nhập tên sản phẩm...." required>
                            </div>
                            <div class="form-group col-3">
                                <label for="package_type">Chọn gói <span class="required">*</span></label>
                                <select name="package_type" class="form-control">
                                    <option value="basic">Cơ bản</option>
                                    <option value="standard">Tiêu chuẩn</option>
                                    <option value="advanced">Nâng cao</option>
                                    <option value="comprehensive">Toàn diện</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Loại sản phẩm <span class="required">*</span></label>
                            <div class="radio-group">
                                <div class="radio-item">
                                    <input type="radio" name="choose" id="option1" value="domestic" checked>
                                    <label for="option1"><i class="fas fa-home"></i> Trong nước</label>
                                </div>
                                <div class="radio-item">
                                    <input type="radio" name="choose" id="option2" value="international">
                                    <label for="option2"><i class="fas fa-globe"></i> Ngoài nước</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="description">Mô tả sản phẩm <span class="required">*</span></label>
                            <textarea name="description" class="form-control" rows="6" id="description" placeholder="Nhập mô tả cho sản phẩm...." required></textarea>
                        </div>

                        <div class="form-group">
                            <label for="formFile">Hình ảnh sản phẩm <span class="required">*</span></label>
                            <input name="img" class="form-control" type="file" id="formFile" accept="image/png, image/jpeg, image/gif" required>
                            <div class="form-text">Hỗ trợ JPG, PNG, GIF (tối đa 5MB)</div>
                        </div>
                    </div>

                    <!-- Domestic Benefits Section -->
                    <div class="form-section domestic-section">
                        <div class="section-header">
                            <h2><i class="fas fa-shield-alt"></i> Cấu hình quyền lợi bảo hiểm trong nước</h2>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="deathOrDisability">Tử vong, thương tật vĩnh viễn <span class="required">*</span></label>
                                <input name="deathOrDisability" type="number" class="form-control domestic_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="deathByIllness">Tử vong do ốm đau, bệnh tật <span class="required">*</span></label>
                                <input name="deathByIllness" type="number" class="form-control domestic_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="thirdPartyLiability">Trách nhiệm cá nhân đối với bên thứ ba <span class="required">*</span></label>
                                <input name="thirdPartyLiability" type="number" class="form-control domestic_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="lostBankCard">Bảo hiểm thất lạc thẻ ngân hàng <span class="required">*</span></label>
                                <input name="lostBankCard" type="number" class="form-control domestic_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="kidnapHostage">Bắt cóc và con tin <span class="required">*</span></label>
                                <input name="kidnapHostage" type="number" class="form-control domestic_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="golfEquipLoss">Mất hoặc hư hỏng dụng cụ chơi Golf <span class="required">*</span></label>
                                <input name="golfEquipLoss" type="number" class="form-control domestic_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                    </div>

                    <!-- International Benefits Section -->
                    <div class="form-section international-section">
                        <div class="section-header">
                            <h2><i class="fas fa-globe-americas"></i> Cấu hình quyền lợi bảo hiểm ngoài nước</h2>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="medical_cost">Chi phí y tế <span class="required">*</span></label>
                                <input name="medical_cost" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="emergency_transport">Chi phí vận chuyển y tế khẩn cấp <span class="required">*</span></label>
                                <input name="emergency_transport" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="repatriation_vn">Hồi hương thi hài về Việt Nam <span class="required">*</span></label>
                                <input name="repatriation_vn" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="repatriation_abroad">Hồi hương thi hài về quê hương (ngoài VN) <span class="required">*</span></label>
                                <input name="repatriation_abroad" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="hospital_visit">Thăm Người được bảo hiểm tại bệnh viện <span class="required">*</span></label>
                                <input name="hospital_visit" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="funeral_arrangement">Thăm viếng để thu xếp tang lễ <span class="required">*</span></label>
                                <input name="funeral_arrangement" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="child_care">Chăm sóc trẻ em <span class="required">*</span></label>
                                <input name="child_care" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="hospital_allowance">Trợ cấp nằm viện <span class="required">*</span></label>
                                <input name="hospital_allowance" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="accident_death_injury">Tử vong và thương tật do tai nạn <span class="required">*</span></label>
                                <input name="accident_death_injury" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="trip_cancellation">Hủy bỏ chuyến đi <span class="required">*</span></label>
                                <input name="trip_cancellation" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="companion_support">Hỗ trợ người đi cùng <span class="required">*</span></label>
                                <input name="companion_support" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="delayed_baggage">Hành lý đến chậm <span class="required">*</span></label>
                                <input name="delayed_baggage" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="travel_documents">Giấy tờ đi đường <span class="required">*</span></label>
                                <input name="travel_documents" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                            <div class="form-group col-6">
                                <label for="trip_delay">Chuyến đi bị trì hoãn <span class="required">*</span></label>
                                <input name="trip_delay" type="number" class="form-control international_required" min="0" step="100000" placeholder="Nhập số tiền...">
                            </div>
                        </div>
                    </div>

                    <!-- Domestic Pricing Section -->
                    <div class="form-section domestic-pricing-section">
                        <div class="section-header">
                            <h2><i class="fas fa-calculator"></i> Tính phí</h2>
                        </div>
                        <div class="pricing-formula">
                            <h4>Công thức tính phí</h4>
                            <p>Phí = <input class="form-control coefficient-input" name="coefficient_1" placeholder="Nhập vào hệ số....">% × STBH × Số ngày × Số người</p>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="days">Số ngày</label>
                                <input class="form-control" type="number" min="0" step="1" placeholder="Nhập vào số ngày....">
                        </div>
                            <div class="form-group col-6">
                                <label for="people">Số người</label>
                                <input class="form-control" type="number" min="0" step="1" placeholder="Nhập vào số người...">
                            </div>
                            </div>
                        <div class="pricing-result">
                            <div class="result-item">
                                <label>Phí dự kiến</label>
                                <p><span class="result">0</span> VNĐ</p>
                            </div>
                            <div class="result-details">
                                <p class="result1"></p>
                                <p class="result2"></p>
                                <p class="result3"></p>
                            </div>
                        </div>
                    </div>

                    <!-- International Pricing Section -->
                    <div class="form-section international-pricing-section">
                        <div class="section-header">
                            <h2><i class="fas fa-calculator"></i> Tính phí</h2>
                        </div>
                        <div class="pricing-formula">
                            <h4>Công thức tính phí</h4>
                            <p>Phí bảo hiểm = Biểu phí theo ngày x số ngày x số người</p>
                        </div>
                        <div class="pricing-table">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Khoảng thời gian</th>
                                        <th>Gói Cơ bản</th>
                                        <th>Gói Tiêu chuẩn</th>
                                        <th>Gói Nâng cao</th>
                                        <th>Gói Toàn diện</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1-7 ngày</td>
                                        <td><input class="form-control" name="coefficient_2" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_3" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_4" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_5" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                    </tr>
                                    <tr>
                                        <td>8-30 ngày</td>
                                        <td><input class="form-control" name="coefficient_6" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_7" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_8" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_9" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                    </tr>
                                    <tr>
                                        <td>31-90 ngày</td>
                                        <td><input class="form-control" name="coefficient_10" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_11" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_12" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_13" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                    </tr>
                                    <tr>
                                        <td>91-180 ngày</td>
                                        <td><input class="form-control" name="coefficient_14" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_15" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_16" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td><input class="form-control" name="coefficient_17" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="days_int">Số ngày</label>
                                <input class="form-control" type="number" min="0" step="1" placeholder="Nhập vào số ngày....">
                            </div>
                            <div class="form-group col-6">
                                <label for="people_int">Số người</label>
                                <input class="form-control" type="number" min="0" step="1" placeholder="Nhập vào số người....">
                            </div>
                            </div>
                        <div class="pricing-result">
                            <div class="result-item">
                                <label>Phí dự kiến</label>
                                <p><span class="result0">0</span> VNĐ</p>
                            </div>
                            <div class="result-details">
                                <p class="result4"></p>
                                <p class="result5"></p>
                                <p class="result6"></p>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-plus"></i>
                            Tạo sản phẩm
                        </button>
                        <button type="button" class="btn btn-secondary btn-calculate">
                            <i class="fas fa-calculator"></i>
                            Tính phí
                        </button>
                    </div>

                    <!-- Hidden inputs for form submission -->
                        <input type="hidden" name="price" class="price">
                        <input type="hidden" name="domestic_percentage_rate" class="domestic_percentage_rate">
                        <input type="hidden" name="international_rate_1_7" class="international_rate_1_7">
                        <input type="hidden" name="international_rate_8_30" class="international_rate_8_30">
                        <input type="hidden" name="international_rate_31_90" class="international_rate_31_90">
                        <input type="hidden" name="international_rate_91_180" class="international_rate_91_180">
                </form>
            </div>
        </div>
            </div>

    <!-- Clear session attributes -->
            <%
                if (session.getAttribute("notification") != null &&
                    session.getAttribute("img_src") != null &&
                    session.getAttribute("name") != null &&
                    session.getAttribute("type") != null &&
                    session.getAttribute("package_type") != null &&
                    session.getAttribute("description") != null &&
                    session.getAttribute("price") != null) {
                    session.removeAttribute("notification");
                    session.removeAttribute("img_src");
                    session.removeAttribute("name");
                    session.removeAttribute("type");
                    session.removeAttribute("package_type");
                    session.removeAttribute("description");
                    session.removeAttribute("price");
                }
            %>

            <script>
        // Form functionality JavaScript (keeping the original logic)
        document.addEventListener("DOMContentLoaded", function() {
            // User dropdown functionality
            const userDropdown = document.querySelector('.user-dropdown');
            if (userDropdown) {
                userDropdown.addEventListener('click', function(e) {
                    e.stopPropagation();
                    userDropdown.classList.toggle('active');
                });
                
                document.addEventListener('click', function(e) {
                    if (!userDropdown.contains(e.target)) {
                        userDropdown.classList.remove('active');
                    }
                });
            }

            // Form section visibility logic
            const domesticOption = document.querySelector('input[value="domestic"]');
            const internationalOption = document.querySelector('input[value="international"]');
            const domesticSection = document.querySelector('.domestic-section');
            const internationalSection = document.querySelector('.international-section');
            const domesticPricingSection = document.querySelector('.domestic-pricing-section');
            const internationalPricingSection = document.querySelector('.international-pricing-section');

            function toggleSections() {
                if (domesticOption.checked) {
                    domesticSection.style.display = 'block';
                    internationalSection.style.display = 'none';
                    domesticPricingSection.style.display = 'block';
                    internationalPricingSection.style.display = 'none';
                        } else {
                    domesticSection.style.display = 'none';
                    internationalSection.style.display = 'block';
                    domesticPricingSection.style.display = 'none';
                    internationalPricingSection.style.display = 'block';
                }
            }

            domesticOption.addEventListener('change', toggleSections);
            internationalOption.addEventListener('change', toggleSections);
            
            // Initialize
            toggleSections();
        });
            </script>
        </body>
    </html>
