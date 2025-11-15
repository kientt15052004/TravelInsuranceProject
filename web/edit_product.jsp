    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
    <!DOCTYPE html>
    <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Chỉnh Sửa Sản Phẩm - Hệ thống quản lý bảo hiểm</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/productmanagement.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/createproduct.css">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        </head>

        <body>
            <jsp:include page="component/admin-header.jsp"/>

            <div class="container">
                <jsp:include page="component/admin-sidebar.jsp">
                    <jsp:param name="activePage" value="view-products"/>
                </jsp:include>

                <div class="main-content">
                    <div class="content-header">
                        <h1>Chỉnh Sửa Sản Phẩm Bảo Hiểm Du Lịch</h1>
                        <p>Cập nhật thông tin sản phẩm bảo hiểm du lịch</p>
                </div>

                    <div class="form-container">
                        <form id="updateForm" action="${pageContext.request.contextPath}/update_product" enctype="multipart/form-data" method="POST">
                    <input type="hidden" name="product_id" value="${product.id}">
                    <input type="hidden" name="benefit_id" value="${product.benefit_id}">
                    <input type="hidden" name="original_deathOrDisability" value="${product.benefit.death_or_permanent_disability}">
                    <input type="hidden" name="original_deathByIllness" value="${product.benefit.death_due_to_illness}">
                    <input type="hidden" name="original_thirdPartyLiability" value="${product.benefit.third_party_liability}">
                    <input type="hidden" name="original_lostBankCard" value="${product.benefit.lost_bank_card}">
                    <input type="hidden" name="original_kidnapHostage" value="${product.benefit.kidnap_and_hostage}">
                    <input type="hidden" name="original_golfEquipLoss" value="${product.benefit.lost_or_damaged_golf_equipment}">
                    <input type="hidden" name="original_medical_cost" value="${product.benefit.medical_cost}">
                    <input type="hidden" name="original_emergency_transport" value="${product.benefit.emergency_transport}">
                    <input type="hidden" name="original_repatriation_vn" value="${product.benefit.repatriation_vn}">
                    <input type="hidden" name="original_repatriation_abroad" value="${product.benefit.repatriation_abroad}">
                    <input type="hidden" name="original_hospital_visit" value="${product.benefit.hospital_visit}">
                    <input type="hidden" name="original_funeral_arrangement" value="${product.benefit.funeral_arrangement}">
                    <input type="hidden" name="original_child_care" value="${product.benefit.child_care}">
                    <input type="hidden" name="original_hospital_allowance" value="${product.benefit.hospital_allowance}">
                    <input type="hidden" name="original_accident_death_injury" value="${product.benefit.accident_death_injury}">
                    <input type="hidden" name="original_trip_cancellation" value="${product.benefit.trip_cancellation}">
                    <input type="hidden" name="original_companion_support" value="${product.benefit.companion_support}">
                    <input type="hidden" name="original_delayed_baggage" value="${product.benefit.delayed_baggage}">
                    <input type="hidden" name="original_travel_documents" value="${product.benefit.travel_documents}">
                    <input type="hidden" name="original_trip_delay" value="${product.benefit.trip_delay}">

                    <div class="form-section">
                        <div class="section-header">
                            <h2>Thông tin cơ bản</h2>
                        </div>
                        <div class="form-row-custom">
                            <div class="form-group col-name">
                                <label for="name">Tên sản phẩm <span class="required">*</span></label>
                                <input name="name" type="text" class="form-control" id="name" 
                                       value="${product.name}" placeholder="Nhập tên sản phẩm..." required>
                            </div>
                            <div class="form-group col-type">
                                <label>Loại sản phẩm <span class="required">*</span></label>
                                <div class="radio-group-horizontal">
                                    <div class="radio-item">
                                        <input type="radio" name="choose" id="option1" value="domestic" ${product.type == 'domestic' ? 'checked' : ''}>
                                        <label for="option1">Trong nước</label>
                                    </div>
                                    <div class="radio-item">
                                        <input type="radio" name="choose" id="option2" value="international" ${product.type == 'international' ? 'checked' : ''}>
                                        <label for="option2">Ngoài nước</label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group col-package">
                                <label for="package_type">Chọn gói <span class="required">*</span></label>
                                <div class="select-wrapper">
                                    <select name="package_type" id="package_type_select" class="form-control form-select">
                                    <option value="basic" ${product.package_type != null && product.package_type.trim().toLowerCase() == 'basic' ? 'selected' : ''}>Cơ bản</option>
                                    <option value="standard" ${product.package_type != null && product.package_type.trim().toLowerCase() == 'standard' ? 'selected' : ''}>Tiêu chuẩn</option>
                                    <option value="advanced" ${product.package_type != null && product.package_type.trim().toLowerCase() == 'advanced' ? 'selected' : ''}>Nâng cao</option>
                                    <option value="comprehensive" ${product.package_type != null && product.package_type.trim().toLowerCase() == 'comprehensive' ? 'selected' : ''}>Toàn diện</option>
                                        <c:if test="${packageTypes != null && !empty packageTypes}">
                                            <c:forEach items="${packageTypes}" var="pkgType">
                                                <c:if test="${pkgType != 'Basic' && pkgType != 'Standard' && pkgType != 'Advanced' && pkgType != 'Comprehensive'}">
                                                    <c:choose>
                                                        <c:when test="${product.package_type != null && product.package_type.equalsIgnoreCase(pkgType)}">
                                                            <option value="${pkgType}" selected>${pkgType}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${pkgType}">${pkgType}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                        <c:set var="isCustomPackage" value="false" />
                                        <c:if test="${product.package_type != null}">
                                            <c:set var="pkgTypeLower" value="${product.package_type.trim().toLowerCase()}" />
                                            <c:if test="${pkgTypeLower != 'basic' && pkgTypeLower != 'standard' && pkgTypeLower != 'advanced' && pkgTypeLower != 'comprehensive'}">
                                                <c:set var="foundInList" value="false" />
                                                <c:if test="${packageTypes != null && !empty packageTypes}">
                                                    <c:forEach items="${packageTypes}" var="pkgType">
                                                        <c:if test="${pkgType != null && pkgType.equalsIgnoreCase(product.package_type)}">
                                                            <c:set var="foundInList" value="true" />
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                                <c:if test="${!foundInList}">
                                                    <c:set var="isCustomPackage" value="true" />
                                                </c:if>
                                            </c:if>
                                        </c:if>
                                        <option value="other" ${isCustomPackage ? 'selected' : ''}>Khác</option>
                                </select>
                                    <i class="fas fa-chevron-down select-arrow"></i>
                            </div>
                                <div id="custom_package_type_wrapper" style="display: none; margin-top: 10px;">
                                    <input type="text" 
                                           name="custom_package_type" 
                                           id="custom_package_type" 
                                           class="form-control" 
                                           placeholder="Nhập tên gói mới (ví dụ: Premium, Ultimate...)"
                                           <c:if test='${isCustomPackage}'>value="${product.package_type}"</c:if>
                                           maxlength="50"
                                           pattern="[a-zA-Z0-9\\s]+"
                                           title="Chỉ chứa chữ cái, số và khoảng trắng">
                                    <small class="form-text text-muted">Tối đa 50 ký tự, chỉ chứa chữ cái, số và khoảng trắng</small>
                        </div>
                                <c:if test='${isCustomPackage}'>
                                    <script>
                                        document.addEventListener('DOMContentLoaded', function() {
                                            const wrapper = document.getElementById('custom_package_type_wrapper');
                                            const select = document.getElementById('package_type_select');
                                            if (wrapper && select) {
                                                wrapper.style.display = 'block';
                                                select.value = 'other';
                                            }
                                        });
                                    </script>
                                </c:if>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="textarea">Mô tả sản phẩm <span class="required">*</span></label>
                            <textarea name="description" class="form-control" rows="6" id="textarea" 
                                      placeholder="Nhập mô tả cho sản phẩm..." required>${product.description}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="formFile">Hình ảnh sản phẩm</label>
                            <c:if test="${not empty product.img}">
                                <div class="current-image-container">
                                    <p class="form-label">Ảnh hiện tại:</p>
                                    <img src="${product.img}" class="current-image" alt="Current product image">
                                </div>
                            </c:if>
                            <input name="img" class="form-control" type="file" id="formFile" accept="image/png, image/jpeg, image/gif">
                            <div class="form-text">Hỗ trợ JPG, PNG, GIF (tối đa 5MB). Để trống nếu không muốn thay đổi ảnh.</div>
                        </div>
                        
                        <div class="form-group">
                            <label>Trạng thái hoạt động</label>
                            <select class="active form-select form-control" name="active">
                                <option value="true" ${product.is_active ? 'selected' : ""}>Hoạt động</option>
                                <option value="false" ${!product.is_active ? 'selected' : ""}>Chờ duyệt</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-section domestic-section">
                        <div class="section-header">
                            <h2>Cấu hình quyền lợi bảo hiểm trong nước</h2>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Tử vong, thương tật vĩnh viễn</label>
                                <fmt:formatNumber value="${product.benefit.death_or_permanent_disability}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated1" />
                                <input name="deathOrDisability" type="number" class="form-control domestic_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated1}"/>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Tử vong do ốm đau, bệnh tật</label>
                                <fmt:formatNumber value="${product.benefit.death_due_to_illness}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated2" />
                                <input name="deathByIllness" type="number" class="form-control domestic_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated2}">
                            </div>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Trách nhiệm cá nhân đối với bên thứ ba</label>
                                <fmt:formatNumber value="${product.benefit.third_party_liability}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated3" />
                                <input name="thirdPartyLiability" type="number" class="form-control domestic_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated3}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Bảo hiểm thất lạc thẻ ngân hàng</label>
                                <fmt:formatNumber value="${product.benefit.lost_bank_card}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated4" />
                                <input name="lostBankCard" type="number" class="form-control domestic_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated4}">
                            </div>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Bắt cóc và con tin</label>
                                <fmt:formatNumber value="${product.benefit.kidnap_and_hostage}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated5" />
                                <input name="kidnapHostage" type="number" class="form-control domestic_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated5}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Mất hoặc hư hỏng dụng cụ chơi Golf</label>
                                <fmt:formatNumber value="${product.benefit.lost_or_damaged_golf_equipment}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated6" />
                                <input name="golfEquipLoss" type="number" class="form-control domestic_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated6}">
                            </div>
                        </div>
                    </div>

                    <div class="form-section international-section">
                        <div class="section-header">
                            <h2>Cấu hình quyền lợi bảo hiểm ngoài nước</h2>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Chi phí y tế</label>
                                <fmt:formatNumber value="${product.benefit.medical_cost}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated7" />
                                <input name="medical_cost" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated7}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Chi phí vận chuyển y tế khẩn cấp</label>
                                <fmt:formatNumber value="${product.benefit.emergency_transport}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated8" />
                                <input name="emergency_transport" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated8}">
                            </div>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Hồi hương thi hài về Việt Nam</label>
                                <fmt:formatNumber value="${product.benefit.repatriation_vn}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated9" />
                                <input name="repatriation_vn" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated9}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Hồi hương thi hài về quê hương (ngoài VN)</label>
                                <fmt:formatNumber value="${product.benefit.repatriation_abroad}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated10" />
                                <input name="repatriation_abroad" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated10}">
                            </div>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Thăm Người được bảo hiểm tại bệnh viện</label>
                                <fmt:formatNumber value="${product.benefit.hospital_visit}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated11" />
                                <input name="hospital_visit" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated11}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Thăm viếng để thu xếp tang lễ</label>
                                <fmt:formatNumber value="${product.benefit.funeral_arrangement}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated12" />
                                <input name="funeral_arrangement" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated12}">
                            </div>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Chăm sóc trẻ em</label>
                                <fmt:formatNumber value="${product.benefit.child_care}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated13" />
                                <input name="child_care" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated13}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Trợ cấp nằm viện</label>
                                <fmt:formatNumber value="${product.benefit.hospital_allowance}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated14" />
                                <input name="hospital_allowance" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated14}">
                            </div>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Tử vong và thương tật do tai nạn</label>
                                <fmt:formatNumber value="${product.benefit.accident_death_injury}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated15" />
                                <input name="accident_death_injury" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated15}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Hủy bỏ chuyến đi</label>
                                <fmt:formatNumber value="${product.benefit.trip_cancellation}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated16" />
                                <input name="trip_cancellation" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated16}">
                            </div>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Hỗ trợ người đi cùng</label>
                                <fmt:formatNumber value="${product.benefit.companion_support}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated17" />
                                <input name="companion_support" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated17}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Hành lý đến chậm</label>
                                <fmt:formatNumber value="${product.benefit.delayed_baggage}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated18" />
                                <input name="delayed_baggage" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated18}">
                            </div>
                        </div>

                        <div class="row mb-4 g-3">
                            <div class="col-md-6">
                                <label class="form-label">Giấy tờ đi đường</label>
                                <fmt:formatNumber value="${product.benefit.travel_documents}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated19" />
                                <input name="travel_documents" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated19}">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Chuyến đi bị trì hoãn</label>
                                <fmt:formatNumber value="${product.benefit.trip_delay}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated20" />
                                <input name="trip_delay" type="number" class="form-control international_benefit" 
                                       min="0" placeholder="Nhập số tiền..." 
                                       value="${formated20}">
                            </div>
                        </div>
                    </div>

                    <div class="form-section domestic_preview">
                        <div class="section-header">
                            <h2>Tính giá sản phẩm trong nước</h2>
                        </div>
                        <div class="formula-box text-center">
                            <h4>Công thức tính giá sản phẩm</h4>
                            <p>Giá sản phẩm = <input class="coefficient_1 form-control coefficient-input" name="domestic_percentage_rate" placeholder="Nhập vào hệ số...." value="${product.domestic_percentage_rate}">% × Số tiền bảo hiểm × Số ngày × Số người</p>
                        </div>

                        <div class="row mt-4">
                            <div class="col-6 text-black">
                                <label class="form-label fw-bold">Số ngày</label>
                                <input class="op20 form-control" type="number" min="0" step="1" placeholder="Nhập vào số ngày....">
                            </div>

                            <div class="col-6 text-black">
                                <label class="form-label fw-bold">Số người</label>
                                <input class="op21 form-control" type="number" min="0" step="1" placeholder="Nhập vào số người...">
                            </div>

                            <div class="col-12 mt-3 text-black">
                                <label class="form-label text-primary fw-bold">Giá sản phẩm dự kiến</label>
                                <p><span class="result">0</span> VNĐ</p>
                                <label class="form-label text-primary fw-bold">Các mục: </label>
                                <p class="result1"></p>
                                <p class="result2"></p>
                                <p class="result3"></p>
                            </div>
                        </div>
                    </div>

                    <div class="form-section international_preview">
                        <div class="section-header">
                            <h2>Tính giá sản phẩm ngoài nước</h2>
                        </div>
                        <div class="formula-box text-center">
                            <h4>Công thức tính giá sản phẩm</h4>
                            <p>Phí bảo hiểm = Biểu phí theo ngày x số ngày x số người</p>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-custom">
                                <thead>
                                    <tr>
                                        <th scope="col" class="text-center">Khoảng thời gian</th>
                                        <th scope="col" class="text-center">Gói <span class="package_column">${product.package_type}</span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-center">1-7 ngày</td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${product.international_rate_1_7}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated21" />
                                            <input class="coefficient_1_7 form-control" name="international_rate_1_7" 
                                                   placeholder="Nhập vào biểu phí..." min="0" type="number" 
                                                   value="${formated21}">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="text-center">8-30 ngày</td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${product.international_rate_8_30}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated22"/>
                                            <input class="coefficient_8_30 form-control" name="international_rate_8_30" 
                                                   placeholder="Nhập vào biểu phí..." min="0" type="number" 
                                                   value="${formated22}">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="text-center">31-90 ngày</td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${product.international_rate_31_90}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated23"/>
                                            <input class="coefficient_31_90 form-control" name="international_rate_31_90" 
                                                   placeholder="Nhập vào biểu phí..." min="0" type="number" 
                                                   value="${formated23}">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="text-center">91-180 ngày</td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${product.international_rate_91_365}" type="number" maxFractionDigits="0" groupingUsed="false" var="formated24"/>
                                            <input class="coefficient_91_180 form-control" name="international_rate_91_180" 
                                                   placeholder="Nhập vào biểu phí..." min="0" type="number" 
                                                   value="${formated24}">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="row mt-4">
                            <div class="col-6 text-black">
                                <label class="form-label fw-bold">Số ngày</label>
                                <input class="op22 form-control" type="number" min="0" step="1" placeholder="Nhập vào số ngày....">
                            </div>

                            <div class="col-6 text-black">
                                <label class="form-label fw-bold">Số người</label>
                                <input class="op23 form-control" type="number" min="0" step="1" placeholder="Nhập vào số người....">
                            </div>

                            <div class="col-12 mt-3 text-black">
                                <label class="form-label text-primary fw-bold">Giá sản phẩm dự kiến</label>
                                <p><span class="result0">0</span> VNĐ</p>
                                <label class="form-label text-primary fw-bold">Các mục: </label>
                                <p class="result4"></p>
                                <p class="result5"></p>
                                <p class="result6"></p>
                            </div>
                        </div>
                    </div>

                            <input type="hidden" name="price" class="price" value="${product.price}">
                            <input type="hidden" name="domestic_percentage_rate" class="domestic_percentage_rate" value="${product.domestic_percentage_rate}">
                            <input type="hidden" name="international_rate_1_7" class="international_rate_1_7" value="${product.international_rate_1_7}">
                            <input type="hidden" name="international_rate_8_30" class="international_rate_8_30" value="${product.international_rate_8_30}">
                            <input type="hidden" name="international_rate_31_90" class="international_rate_31_90" value="${product.international_rate_31_90}">
                            <input type="hidden" name="international_rate_91_180" class="international_rate_91_180" value="${product.international_rate_91_365}">
                        </form>
                    </div>

                    <div class="form-actions">
                        <button type="submit" form="updateForm" class="btn btn-primary">
                            Cập Nhật Sản Phẩm
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                            Huỷ
                        </button>
                        <button type="button" class="btn btn-secondary btn-result">
                            Tính giá sản phẩm
                        </button>
                    </div>
                    <input type="hidden" name="original_thirdPartyLiability" value="${product.benefit.third_party_liability}">
                    <input type="hidden" name="original_lostBankCard" value="${product.benefit.lost_bank_card}">
                    <input type="hidden" name="original_kidnapHostage" value="${product.benefit.kidnap_and_hostage}">
                    <input type="hidden" name="original_golfEquipLoss" value="${product.benefit.lost_or_damaged_golf_equipment}">
                    <input type="hidden" name="original_medical_cost" value="${product.benefit.medical_cost}">
                    <input type="hidden" name="original_emergency_transport" value="${product.benefit.emergency_transport}">
                    <input type="hidden" name="original_repatriation_vn" value="${product.benefit.repatriation_vn}">
                    <input type="hidden" name="original_repatriation_abroad" value="${product.benefit.repatriation_abroad}">
                    <input type="hidden" name="original_hospital_visit" value="${product.benefit.hospital_visit}">
                    <input type="hidden" name="original_funeral_arrangement" value="${product.benefit.funeral_arrangement}">
                    <input type="hidden" name="original_child_care" value="${product.benefit.child_care}">
                    <input type="hidden" name="original_hospital_allowance" value="${product.benefit.hospital_allowance}">
                    <input type="hidden" name="original_accident_death_injury" value="${product.benefit.accident_death_injury}">
                    <input type="hidden" name="original_trip_cancellation" value="${product.benefit.trip_cancellation}">
                    <input type="hidden" name="original_companion_support" value="${product.benefit.companion_support}">
                    <input type="hidden" name="original_delayed_baggage" value="${product.benefit.delayed_baggage}">
                    <input type="hidden" name="original_travel_documents" value="${product.benefit.travel_documents}">
                    <input type="hidden" name="original_trip_delay" value="${product.benefit.trip_delay}">
                    <input type="hidden" name="product_id" value="${product.id}">
                    <input type="hidden" name="benefit_id" value="${product.benefit_id}">
                        

                </form>
            </div>

            <script>
                const domestic_option = document.querySelector('input[value="domestic"]');
                const international_option = document.querySelector('input[value="international"]');
                const domestic_div = document.querySelector('.domestic-section');
                const international_div = document.querySelector('.international-section');
                const domestic_preview = document.querySelector('.domestic_preview');
                const international_preview = document.querySelector('.international_preview');
                const package_comlumn = document.querySelector('.package_column');
                const btn = document.querySelector('.btn-result');
                const form = document.querySelector('.form');
                const result = document.querySelector('.result');
                const result0 = document.querySelector('.result0');
                const result1 = document.querySelector('.result1');
                const result2 = document.querySelector('.result2');
                const result3 = document.querySelector('.result3');
                const result4 = document.querySelector('.result4');
                const result5 = document.querySelector('.result5');
                const result6 = document.querySelector('.result6');
                const coefficient_1 = document.querySelector('.coefficient_1');
                const op20 = document.querySelector('.op20');
                const op21 = document.querySelector('.op21');
                const op22 = document.querySelector('.op22');
                const op23 = document.querySelector('.op23');
                const package_type = document.querySelector('select[name="package_type"]');
                const price = document.querySelector('.price');
                const domestic_percentage_rate = document.querySelector('input[name="domestic_percentage_rate"]');
                const international_rate_1_7 = document.querySelector('.international_rate_1_7');
                const international_rate_8_30 = document.querySelector('.international_rate_8_30');
                const international_rate_31_90 = document.querySelector('.international_rate_31_90');
                const international_rate_91_180 = document.querySelector('.international_rate_91_180');

                const coefficient_1_7 = document.querySelector('.coefficient_1_7');
                const coefficient_8_30 = document.querySelector('.coefficient_8_30');
                const coefficient_31_90 = document.querySelector('.coefficient_31_90');
                const coefficient_91_180 = document.querySelector('.coefficient_91_180');

                let fee = 0;
                let base_price = 0;

                window.onload = function () {
                    const packageSelect = document.querySelector('select[name="package_type"]');
                    console.log('Page loaded - package_type value:', packageSelect.value);
                    console.log('Page loaded - package_type selectedIndex:', packageSelect.selectedIndex);
                    console.log('Page loaded - package_type options:', Array.from(packageSelect.options).map(opt => opt.value + ':' + opt.selected));
                    toggleSections();
                    
                    // Initialize custom package type toggle
                    const packageTypeSelect = document.getElementById('package_type_select');
                    const customPackageTypeWrapper = document.getElementById('custom_package_type_wrapper');
                    const customPackageTypeInput = document.getElementById('custom_package_type');
                    
                    if (packageTypeSelect && customPackageTypeWrapper && customPackageTypeInput) {
                        // Check initial state
                        if (packageTypeSelect.value === 'other') {
                            customPackageTypeWrapper.style.display = 'block';
                            customPackageTypeInput.setAttribute('required', 'required');
                        }
                        
                        packageTypeSelect.addEventListener('change', function() {
                            if (this.value === 'other') {
                                customPackageTypeWrapper.style.display = 'block';
                                customPackageTypeInput.setAttribute('required', 'required');
                            } else {
                                customPackageTypeWrapper.style.display = 'none';
                                customPackageTypeInput.removeAttribute('required');
                                customPackageTypeInput.value = '';
                            }
                        });
                    }
                };

                function formatNumber(num) {
                    return Math.round(num).toLocaleString('vi-VN');
                }

                function toggleSections() {
                    if (domestic_option.checked) {
                        domestic_div.style.display = "block";
                        international_div.style.display = "none";
                        domestic_preview.style.display = "block";
                        international_preview.style.display = "none";
                        
                        const internationalInputs = document.querySelectorAll('.international_benefit');
                        internationalInputs.forEach(input => {
                            input.disabled = true;
                            input.removeAttribute('required');
                        });
                        
                        const domesticInputs = document.querySelectorAll('.domestic_benefit');
                        domesticInputs.forEach(input => {
                            input.disabled = false;
                        });
                    } else {
                        domestic_div.style.display = "none";
                        international_div.style.display = "block";
                        domestic_preview.style.display = "none";
                        international_preview.style.display = "block";
                        
                        const domesticInputs = document.querySelectorAll('.domestic_benefit');
                        domesticInputs.forEach(input => {
                            input.disabled = true;
                            input.removeAttribute('required');
                        });
                        
                        const internationalInputs = document.querySelectorAll('.international_benefit');
                        internationalInputs.forEach(input => {
                            input.disabled = false;
                        });
                    }
                }

                function togglePackages() {
                    if (package_type.value === "basic") {
                        package_comlumn.textContent = "cơ bản";
                    } else if (package_type.value === "standard") {
                        package_comlumn.textContent = "tiêu chuẩn";
                    } else if (package_type.value === "advanced") {
                        package_comlumn.textContent = "nâng cao";
                    } else if (package_type.value === "comprehensive") {
                        package_comlumn.textContent = "toàn diện";
                    }
                }

                if (package_type) {
                package_type.addEventListener('change', togglePackages);
                }
                if (domestic_option) {
                domestic_option.addEventListener('change', toggleSections);
                }
                if (international_option) {
                international_option.addEventListener('change', toggleSections);
                }

                function calculate() {
                    if (domestic_option.checked) {
                        const deathOrDisability = document.querySelector('input[name="deathOrDisability"]').value;
                        const deathByIllness = document.querySelector('input[name="deathByIllness"]').value;
                        const thirdPartyLiability = document.querySelector('input[name="thirdPartyLiability"]').value;
                        const lostBankCard = document.querySelector('input[name="lostBankCard"]').value;
                        const kidnapHostage = document.querySelector('input[name="kidnapHostage"]').value;
                        const golfEquipLoss = document.querySelector('input[name="golfEquipLoss"]').value;

                        const value1 = Number(deathOrDisability) || 0;
                        const value2 = Number(deathByIllness) || 0;
                        const value3 = Number(thirdPartyLiability) || 0;
                        const value4 = Number(lostBankCard) || 0;
                        const value5 = Number(kidnapHostage) || 0;
                        const value6 = Number(golfEquipLoss) || 0;
                        const value20 = Number(op20.value) || 1;
                        const value21 = Number(op21.value) || 1;
                        const coefficient_value_1 = Number(coefficient_1.value) || 0;

                        const hasValidBenefit = value1 > 0 || value2 > 0 || value3 > 0 || value4 > 0 || value5 > 0 || value6 > 0;
                        
                        let actualCoefficient = coefficient_value_1;
                        if (coefficient_value_1 >= 0.01 && coefficient_value_1 <= 10) {
                            actualCoefficient = coefficient_value_1 / 100;
                        }
                        else{
                            alert("Hệ số nhập vào phải trong khoảng từ 0.01% và tối đa 10%");
                        }
                        
                        
                        if (hasValidBenefit && value20 <= 180 && value21 <= 100 && value20 > 0 && value21 > 0 &&
                                ((coefficient_value_1 >= 0.0001 && coefficient_value_1 <= 0.1) || 
                                 (coefficient_value_1 >= 1 && coefficient_value_1 <= 10))) {
                            

                            let max = Math.max(value1, value2, value3, value4, value5, value6);
                            fee = actualCoefficient * max * value20 * value21;
                            base_price = actualCoefficient * max;                        
                            result.textContent = formatNumber(fee);
                            result1.innerText = `Số tiền bảo hiểm(Số tiền bảo hiểm): ` + formatNumber(max) + ' VNĐ';
                            result2.textContent = `Số ngày: ` + formatNumber(value20);
                            result3.textContent = `Số người đi: ` + formatNumber(value21);
                        } else {
                            alert('Vui lòng nhập ít nhất một quyền lợi bảo hiểm và đảm bảo số ngày từ 1-180, số người từ 1-100, hệ số từ 0.01% - 10% (hoặc 0.0001 - 0.1)!');
                            result.textContent = '0';
                            fee = 0;
                            base_price = 0;
                        }
                    } else if (international_option.checked) {
                        const value22 = Number(op22.value) || 1;
                        const value23 = Number(op23.value) || 1;

                        let per_day_premium = 0;

                        if (value22 >= 1 && value22 <= 7) {
                            per_day_premium = Number(coefficient_1_7.value) || 0;
                        } else if (value22 >= 8 && value22 <= 30) {
                            per_day_premium = Number(coefficient_8_30.value) || 0;
                        } else if (value22 >= 31 && value22 <= 90) {
                            per_day_premium = Number(coefficient_31_90.value) || 0;
                        } else if (value22 >= 91 && value22 <= 180) {
                            per_day_premium = Number(coefficient_91_180.value) || 0;
                        }

                        fee = per_day_premium * value22 * value23;
                        base_price = per_day_premium;

                        international_rate_1_7.value = coefficient_1_7.value;
                        international_rate_8_30.value = coefficient_8_30.value;
                        international_rate_31_90.value = coefficient_31_90.value;
                        international_rate_91_180.value = coefficient_91_180.value;

                        if (per_day_premium > 0 && value22 <= 180 && value22 > 0 && value23 > 0 && value23 <= 100) {
                            result0.textContent = formatNumber(fee);
                            result4.innerText = `Biểu phí theo ngày/người: ` + formatNumber(base_price) + ' VNĐ';
                            result5.textContent = `Số ngày: ` + formatNumber(value22);
                            result6.textContent = `Số người đi: ` + formatNumber(value23);
                        } else {
                            alert('Vui lòng nhập đầy đủ các trường và đảm bảo số ngày từ 1-180, số người từ 1-100, Các hệ số phải lớn hơn 0');
                            result0.textContent = '0';
                            fee = 0;
                            base_price = 0;
                        }
                    }
                }

                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    calculate();
                });

                form.addEventListener("submit", (e) => {
                    console.log('Form submit event triggered');
                    calculate();
                    console.log('After calculate - base_price:', base_price);
                    if (base_price !== 0) {
                        price.value = base_price;
                        console.log('Form will submit');
                    } else {
                        console.log('Form submission prevented - base_price is 0');
                        e.preventDefault();
                        alert('Vui lòng nhập ít nhất một quyền lợi bảo hiểm và đảm bảo số ngày từ 1-180, số người từ 1-100, hệ số từ 0.01% - 10% (hoặc 0.0001 - 0.1)!');
                    }
                });

                // Validate custom package type on form submit
                const updateForm = document.getElementById('updateForm');
                if (updateForm) {
                    updateForm.addEventListener('submit', function(e) {
                        const packageTypeSelect = document.getElementById('package_type_select');
                        const customPackageTypeInput = document.getElementById('custom_package_type');
                        if (packageTypeSelect && customPackageTypeInput && packageTypeSelect.value === 'other') {
                            const customValue = customPackageTypeInput.value.trim();
                            if (!customValue) {
                                e.preventDefault();
                                alert('Vui lòng nhập tên gói mới!');
                                customPackageTypeInput.focus();
                                return false;
                            }
                            // Validate format
                            if (!/^[a-zA-Z0-9\s]{1,50}$/.test(customValue)) {
                                e.preventDefault();
                                alert('Tên gói chỉ được chứa chữ cái, số và khoảng trắng, tối đa 50 ký tự!');
                                customPackageTypeInput.focus();
                                return false;
                            }
                        }
                    });
                }
            </script>
                </div>
            </div>
        </body>
    </html>