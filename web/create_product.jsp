<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo Sản Phẩm - Hệ thống quản lý bảo hiểm</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/productmanagement.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/createproduct.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="component/admin-header.jsp"/>

        <div class="container">
            <jsp:include page="component/admin-sidebar.jsp">
                <jsp:param name="activePage" value="product-management"/>
            </jsp:include>

            <div class="main-content">
                <div class="content-header">
                    <h1>Tạo Sản Phẩm Bảo Hiểm Du Lịch</h1>
                    <p>Tạo sản phẩm bảo hiểm du lịch mới với đầy đủ thông tin và quyền lợi</p>
                </div>

                <c:if test="${not empty notification && not empty img_src 
                              && not empty name && not empty type
                              && not empty package_type && not empty description && not empty price}">
                      <div class="alert alert-success">
                          <div class="alert-content">
                              <div class="alert-icon">
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
                                          <fmt:formatNumber value="${price}" type="number" maxFractionDigits="0" groupingUsed="true" var="formated21" />
                                          <p><strong>Giá tiền:</strong>${formated21} VNĐ</p>
                                      </div>
                                  </div>
                              </div>
                              <button type="button" onclick="this.parentElement.parentElement.style.display = 'none'">
                              </button>
                          </div>
                      </div>
                </c:if>

                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/create_product" enctype="multipart/form-data" method="POST">

                        <div class="form-section">
                            <div class="section-header">
                                <h2>Thông tin cơ bản</h2>
                            </div>
                            <div class="form-row-custom">
                                <div class="form-group col-name">
                                    <label for="name">Tên sản phẩm <span class="required">*</span></label>
                                    <input name="name" type="text" class="form-control" id="name" placeholder="Nhập tên sản phẩm...." required>
                                </div>
                                <div class="form-group col-type">
                                    <label>Loại sản phẩm <span class="required">*</span></label>
                                    <div class="radio-group-horizontal">
                                        <div class="radio-item">
                                            <input type="radio" name="choose" id="option1" value="domestic" checked>
                                            <label for="option1">Trong nước</label>
                                        </div>
                                        <div class="radio-item">
                                            <input type="radio" name="choose" id="option2" value="international">
                                            <label for="option2">Ngoài nước</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col-package">
                                    <label for="package_type">Chọn gói <span class="required">*</span></label>
                                    <div class="select-wrapper">
                                        <select name="package_type" class="form-control form-select">
                                            <option value="basic">Cơ bản</option>
                                            <option value="standard">Tiêu chuẩn</option>
                                            <option value="advanced">Nâng cao</option>
                                            <option value="comprehensive">Toàn diện</option>
                                        </select>
                                        <i class="fas fa-chevron-down select-arrow"></i>
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

                        <div class="form-section domestic-section">
                            <div class="section-header">
                                <h2>Cấu hình quyền lợi bảo hiểm trong nước</h2>
                            </div>
                            <div class="form-row-three">
                                <div class="form-group col-4">
                                    <label for="deathOrDisability">Tử vong, thương tật vĩnh viễn <span class="required">*</span></label>
                                    <input name="deathOrDisability" type="number" class="form-control domestic_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                                <div class="form-group col-4">
                                    <label for="deathByIllness">Tử vong do ốm đau, bệnh tật <span class="required">*</span></label>
                                    <input name="deathByIllness" type="number" class="form-control domestic_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                                <div class="form-group col-4">
                                    <label for="thirdPartyLiability">Trách nhiệm cá nhân đối với bên thứ ba <span class="required">*</span></label>
                                    <input name="thirdPartyLiability" type="number" class="form-control domestic_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                            </div>
                            <div class="form-row-three">
                                <div class="form-group col-4">
                                    <label for="lostBankCard">Bảo hiểm thất lạc thẻ ngân hàng <span class="required">*</span></label>
                                    <input name="lostBankCard" type="number" class="form-control domestic_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                                <div class="form-group col-4">
                                    <label for="kidnapHostage">Bắt cóc và con tin <span class="required">*</span></label>
                                    <input name="kidnapHostage" type="number" class="form-control domestic_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                                <div class="form-group col-4">
                                    <label for="golfEquipLoss">Mất hoặc hư hỏng dụng cụ chơi Golf <span class="required">*</span></label>
                                    <input name="golfEquipLoss" type="number" class="form-control domestic_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                            </div>
                        </div>

                        <div class="form-section international-section">
                            <div class="section-header">
                                <h2>Cấu hình quyền lợi bảo hiểm ngoài nước</h2>
                            </div>
                            <!-- Row: Hồi hương (ngoài VN) -->
                            <div class="form-row-four">
                                <div class="form-group col-3">
                                    <label for="medical_costs">Chi phí y tế <span class="required">*</span></label>
                                    <input name="medical_costs" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>

                                <div class="form-group col-3">
                                    <label for="emergency_transport">Chi phí vận chuyển y tế khẩn cấp <span class="required">*</span></label>
                                    <input name="emergency_transport" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>

                                <div class="form-group col-3">
                                    <label for="repatriation_vietnam">Hồi hương thi hài về Việt Nam <span class="required">*</span></label>
                                    <input name="repatriation_vietnam" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>

                                <div class="form-group col-3">
                                    <label for="repatriation_abroad">Hồi hương thi hài về quê (ngoài VN) <span class="required">*</span></label>
                                    <input name="repatriation_abroad" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                            </div>


                            <div class="form-row-four">
                                <div class="form-group col-3">
                                    <label for="hospital_visit">Thăm Người được bảo hiểm tại viện <span class="required">*</span></label>
                                    <input name="hospital_visit" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>

                                <div class="form-group col-3">
                                    <label for="funeral_arrangement">Thăm viếng để thu xếp tang lễ <span class="required">*</span></label>
                                    <input name="funeral_arrangement" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>

                                <div class="form-group col-3">
                                    <label for="child_care">Chăm sóc trẻ em <span class="required">*</span></label>
                                    <input name="child_care" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>

                                <div class="form-group col-3">
                                    <label for="hospital_allowance">Trợ cấp nằm viện <span class="required">*</span></label>
                                    <input name="hospital_allowance" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                            </div>


                            <div class="form-row-four">
                                <div class="form-group col-3">
                                    <label for="accident_death_injury">Tử vong và thương tật do tai nạn <span class="required">*</span></label>
                                    <input name="accident_death_injury" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                                <div class="form-group col-3">
                                    <label for="trip_cancellation">Hủy bỏ chuyến đi <span class="required">*</span></label>
                                    <input name="trip_cancellation" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                                <div class="form-group col-3">
                                    <label for="companion_support">Hỗ trợ người đi cùng <span class="required">*</span></label>
                                    <input name="companion_support" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                                <div class="form-group col-3">
                                    <label for="delayed_baggage">Hành lý đến chậm <span class="required">*</span></label>
                                    <input name="delayed_baggage" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="travel_documents">Giấy tờ đi đường <span class="required">*</span></label>
                                    <input name="travel_documents" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                                <div class="form-group col-6">
                                    <label for="trip_delay">Chuyến đi bị trì hoãn <span class="required">*</span></label>
                                    <input name="trip_delay" type="number" class="form-control international_required" min="0" placeholder="Nhập số tiền...">
                                </div>
                            </div>
                        </div>

                        <div class="form-section domestic-pricing-section">
                            <div class="section-header">
                                <h2>Tính phí</h2>
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

                        <div class="form-section international-pricing-section">
                            <div class="section-header">
                                <h2><i class="fas fa-calculator"></i> Tính phí</h2>
                            </div>
                            <div class="pricing-formula">
                                <h4>Công thức tính phí</h4>
                                <p>Phí bảo hiểm = Biểu phí theo ngày x số ngày x số người</p>
                            </div>
                            <div class="form-section international-pricing-section">
                                <div class="section-header">
                                    <h2><i class="fas fa-calculator"></i> Bảng phí ngoài nước</h2>
                                </div>

                                <div class="pricing-table table-responsive">
                                    <table class="table table-bordered table-hover table-custom">
                                        <thead>
                                            <tr>
                                                <th style="width: 50%;" class="text-center">Khoảng thời gian</th>
                                                <th style="width: 50%;" class="text-center">Biểu phí (VNĐ)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="text-center">1 - 7 ngày</td>
                                                <td>
                                                    <input name="international_rate_1_7" type="number" min="0" step="1000" class="form-control coefficient_1_7 international_rate" placeholder="Nhập biểu phí..." required value="0">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="text-center">8 - 30 ngày</td>
                                                <td>
                                                    <input name="international_rate_8_30" type="number" min="0" step="1000" class="form-control coefficient_8_30 international_rate" placeholder="Nhập biểu phí..." required value="0">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="text-center">31 - 90 ngày</td>
                                                <td>
                                                    <input name="international_rate_31_90" type="number" min="0" step="1000" class="form-control coefficient_31_90 international_rate" placeholder="Nhập biểu phí..." required value="0">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="text-center">91 - 180 ngày</td>
                                                <td>
                                                    <input name="international_rate_91_180" type="number" min="0" step="1000" class="form-control coefficient_91_180 international_rate" placeholder="Nhập biểu phí..." required value="0">
                                                </td>
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
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                Tạo sản phẩm
                            </button>
                            <button type="button" class="btn btn-secondary btn-calculate">
                                Tính phí
                            </button>
                        </div>

                        <input type="hidden" name="price" class="price">
                        <input type="hidden" name="domestic_percentage_rate" class="domestic_percentage_rate">
                        <input type="hidden" name="international_rate_1_7" class="international_rate_1_7">
                        <input type="hidden" name="international_rate_8_30" class="international_rate_8_30">
                        <input type="hidden" name="international_rate_31_90" class="international_rate_31_90">
                        <input type="hidden" name="international_rate_91_180" class="international_rate_91_180"> 
                    </form>

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const domesticOption = document.querySelector('input[value="domestic"]');
                            const internationalOption = document.querySelector('input[value="international"]');
                            const domesticSection = document.querySelector('.domestic-section');
                            const internationalSection = document.querySelector('.international-section');
                            const domesticPricingSection = document.querySelector('.domestic-pricing-section');
                            const internationalPricingSection = document.querySelector('.international-pricing-section');
                            const calculateBtn = document.querySelector('.btn-calculate');
                            const form = document.querySelector('form');
                            const priceField = document.querySelector('.price');

                            function toggleSections() {
                                if (domesticOption.checked) {
                                    domesticSection.style.display = 'block';
                                    internationalSection.style.display = 'none';
                                    domesticPricingSection.style.display = 'block';
                                    internationalPricingSection.style.display = 'none';
                                    if (priceField)
                                        priceField.value = '0';
                                } else {
                                    domesticSection.style.display = 'none';
                                    internationalSection.style.display = 'block';
                                    domesticPricingSection.style.display = 'none';
                                    internationalPricingSection.style.display = 'block';
                                    if (priceField)
                                        priceField.value = '0';
                                }
                            }

                            domesticOption.addEventListener('change', toggleSections);
                            internationalOption.addEventListener('change', toggleSections);

                            toggleSections();

                            if (calculateBtn) {
                                calculateBtn.addEventListener('click', function (e) {
                                    e.preventDefault();
                                    calculateFee();
                                });
                            }

                            function calculateFee() {
                                if (domesticOption && domesticOption.checked) {
                                    calculateDomesticFee();
                                } else if (internationalOption && internationalOption.checked) {
                                    calculateInternationalFee();
                                } else {
                                    alert('Vui lòng chọn loại sản phẩm (Trong nước hoặc Ngoài nước)');
                                }
                            }

                            function calculateDomesticFee() {
                                const coefficient = domesticPricingSection.querySelector('.coefficient-input');
                                const days = domesticPricingSection.querySelector('input[placeholder="Nhập vào số ngày...."]');
                                const people = domesticPricingSection.querySelector('input[placeholder="Nhập vào số người..."]');
                                const result = domesticPricingSection.querySelector('.result');

                                if (coefficient && days && people && result) {
                                    const deathOrDisability = Number(document.querySelector('input[name="deathOrDisability"]')?.value) || 0;
                                    const deathByIllness = Number(document.querySelector('input[name="deathByIllness"]')?.value) || 0;
                                    const thirdPartyLiability = Number(document.querySelector('input[name="thirdPartyLiability"]')?.value) || 0;
                                    const lostBankCard = Number(document.querySelector('input[name="lostBankCard"]')?.value) || 0;
                                    const kidnapHostage = Number(document.querySelector('input[name="kidnapHostage"]')?.value) || 0;
                                    const golfEquipLoss = Number(document.querySelector('input[name="golfEquipLoss"]')?.value) || 0;

                                    const value1 = deathOrDisability;
                                    const value2 = deathByIllness;
                                    const value3 = thirdPartyLiability;
                                    const value4 = lostBankCard;
                                    const value5 = kidnapHostage;
                                    const value6 = golfEquipLoss;

                                    const value20 = Number(days.value) || 1;
                                    const value21 = Number(people.value) || 1;
                                    const coefficient_value_1 = Number(coefficient.value) || 0;
                                    const hasValidBenefit = value1 > 0 || value2 > 0 || value3 > 0 || value4 > 0 || value5 > 0 || value6 > 0;

                                    let actualCoefficient = coefficient_value_1;
                                    if (coefficient_value_1 >= 0.01 && coefficient_value_1 <= 10) {
                                        actualCoefficient = coefficient_value_1 / 100;
                                    }

                                    if (hasValidBenefit && value20 <= 180 && value21 <= 100 && value20 > 0 && value21 > 0 &&
                                            ((coefficient_value_1 >= 0.0001 && coefficient_value_1 <= 0.1) ||
                                                    (coefficient_value_1 >= 1 && coefficient_value_1 <= 10))) {

                                        let max = Math.max(value1, value2, value3, value4, value5, value6);
                                        const base_price = actualCoefficient * max;
                                        const fee_preview = base_price * value20 * value21;

                                        result.textContent = fee_preview.toLocaleString('vi-VN');

                                        if (priceField)
                                            priceField.value = base_price.toFixed(2);

                                        const domesticRateField = document.querySelector('.domestic_percentage_rate');
                                        if (domesticRateField)
                                            domesticRateField.value = actualCoefficient;
                                    } else {
                                        alert('Vui lòng nhập ít nhất một quyền lợi bảo hiểm và đảm bảo số ngày từ 1-180, số người từ 1-100, hệ số từ 0.01% - 10%!');
                                        result.textContent = '0';
                                        if (priceField)
                                            priceField.value = '0';
                                    }
                                } else {
                                    alert('Vui lòng nhập đầy đủ thông tin: hệ số, số ngày, số người');
                                }
                            }

                            function calculateInternationalFee() {
                                const rate1_7 = document.querySelector('input[name="international_rate_1_7"]');
                                const days = internationalPricingSection.querySelector('input[placeholder="Nhập vào số ngày...."]');
                                const people = internationalPricingSection.querySelector('input[placeholder="Nhập vào số người...."]');
                                const result = internationalPricingSection.querySelector('.result0');

                                if (days && people && result && rate1_7) {
                                    try {
                                        const daysValue = parseInt(days.value) || 0;
                                        const peopleValue = parseInt(people.value) || 0;
                                        const rate = parseFloat(rate1_7.value) || 0;

                                        if (daysValue < 1 || daysValue > 180 || peopleValue < 1 || peopleValue > 100 || rate <= 0) {
                                            alert('Vui lòng kiểm tra lại thông số đầu vào: Số ngày (1-180), Số người (1-100), Biểu phí (phải lớn hơn 0).');
                                            result.textContent = '0';
                                            if (priceField)
                                                priceField.value = '0';
                                            return;
                                        }

                                        const fee_preview = rate * daysValue * peopleValue;
                                        result.textContent = fee_preview.toLocaleString('vi-VN');

                                        if (priceField)
                                            priceField.value = rate.toFixed(2);

                                    } catch (error) {
                                        console.error('An unexpected error occurred during calculation:', error);
                                        alert('Đã xảy ra lỗi trong quá trình tính toán. Vui lòng kiểm tra Console.');
                                    }
                                } else {
                                    alert('Vui lòng nhập đầy đủ thông tin: số ngày, số người và biểu phí (Ít nhất Rate 1-7 ngày).');
                                }
                            }

                            form.addEventListener("submit", (e) => {
                                if (domesticOption.checked) {
                                    calculateDomesticFee();
                                } else if (internationalOption.checked) {
                                    calculateInternationalFee();
                                }

                                if (Number(priceField.value) <= 0) {
                                    e.preventDefault();
                                    alert('Vui lòng tính phí và đảm bảo giá sản phẩm (Base Rate) lớn hơn 0 trước khi tạo!');
                                }
                            });

                        });
                    </script>
                </div>
            </div>
    </body>
</html>
