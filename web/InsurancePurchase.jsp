
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Mua Bảo Hiểm</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="./CSS/styleindex.css"/>
        <link rel="stylesheet" href="./CSS/InsurancePurchase.css">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="component/header.jsp" />

        <div class="container">

            <!-- Progress Indicator -->
            <div class="progress-indicator">
                <div class="progress-step active" id="step1">
                    <div class="progress-circle">✓</div>
                    <span>Chọn Gói Bảo Hiểm</span>
                </div>
                <div class="progress-line"></div>
                <div class="progress-step" id="step2">
                    <div class="progress-circle">2</div>
                    <span>Thông Tin Người Mua</span>
                </div>
                <div class="progress-line"></div>
                <div class="progress-step" id="step3">
                    <div class="progress-circle">3</div>
                    <span>Thông Tin Người Được Bảo Hiểm</span>
                </div>
                <div class="progress-line"></div>
                <div class="progress-step" id="step4">
                    <div class="progress-circle">4</div>
                    <span>Xác Nhận</span>
                </div>
                <div class="progress-line"></div>
                <div class="progress-step" id="step5">
                    <div class="progress-circle">5</div>
                    <span>Thanh Toán</span>
                </div>
            </div>

            <!-- Main Content - Step 1: Insurance Selection -->
            <div class="content-grid" id="step1Content">
                <!-- Left Panel - Purchase Form -->
                <div class="card purchase-card">
                    <h2 class="card-title">
                        <span class="icon">🛡️</span>
                        ${requestScope.insurance.name}
                        <span data-insurance-price="${requestScope.insurance.price}" style="display: none;"></span>
                    </h2>

                    <!-- Date Inputs -->
                    <div class="date-row">
                        <div class="form-group">
                            <label>Ngày Bắt Đầu Bảo Hiểm*</label>
                            <input type="date" class="date-input" id="startDate">
                        </div>
                        <div class="form-group">
                            <label>Ngày Kết Thúc Bảo Hiểm*</label>
                            <input type="date" class="date-input" id="endDate">
                        </div>
                        <!-- Passengers -->
                        <div class="form-group">
                            <!--                                <label>Number of Passengers*</label>-->
                            <input type="hidden" id="passengerInput" class="passenger-input" min="1" value="1">
                        </div>
                    </div>

                    <!-- Warning Message -->
                    <div class="warning-box">
                        <span class="warning-icon">⚠️</span>
                        <span>Thời hạn bảo hiểm cho mỗi chuyến đi không quá 180 ngày</span>
                    </div>

                    <!-- Insurance Packages -->
                    <h3 class="section-title">Chọn Gói Bảo Hiểm</h3>
                    <div class="packages-grid">
                        <div class="package-card" data-price="1000" data-benefit="1">
                            <div class="package-icon">🚲</div>
                            <div class="package-name">Gói 1</div>
                            <div class="package-price">1,000 VNĐ/người</div>
                            <div class="package-benefit">Quyền lợi lên đến 10 triệu</div>
                        </div>
                        <div class="package-card selected" data-price="5000" data-benefit="5">
                            <div class="package-icon">🚗</div>
                            <div class="package-name">Gói 2</div>
                            <div class="package-price">5,000 VNĐ/người</div>
                            <div class="package-benefit">Quyền lợi lên đến 50 triệu</div>
                        </div>
                        <div class="package-card" data-price="12000" data-benefit="12">
                            <div class="package-icon">🚆</div>
                            <div class="package-name">Gói 3</div>
                            <div class="package-price">12,000 VNĐ/người</div>
                            <div class="package-benefit">Quyền lợi lên đến 120 triệu</div>
                        </div>
                        <div class="package-card" data-price="20000" data-benefit="20">
                            <div class="package-icon">✈️</div>
                            <div class="package-name">Gói 4</div>
                            <div class="package-price">20,000 VNĐ/người</div>
                            <div class="package-benefit">Quyền lợi lên đến 200 triệu</div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel - Benefits -->
                <div class="card benefits-card">
                    <h2 class="card-title">
                        <span class="icon">🎯</span>
                        Quyền Lợi Bảo Hiểm
                    </h2>
                    <c:set var="benefit" value="${requestScope.insurance.benefit}" scope="request"/>

                    <h3 class="section-title">Quyền Lợi Chính</h3>
                    <div class="benefits-list">
                        <div class="benefit-item">
                            <div class="benefit-number">1</div>
                            <div class="benefit-text">Tử vong, thương tật vĩnh viễn, thương tật tạm thời</div>
                            <div class="benefit-amount" data-base="${benefit.death_or_permanent_disability}">${benefit.death_or_permanent_disability} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">2</div>
                            <div class="benefit-text">Tử vong do bệnh tật</div>
                            <div class="benefit-amount" data-base="${benefit.death_due_to_illness}">${benefit.death_due_to_illness} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">3</div>
                            <div class="benefit-text">Trách nhiệm cá nhân đối với bên thứ ba</div>
                            <div class="benefit-amount" data-base="${benefit.third_party_liability}">${benefit.third_party_liability} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">4</div>
                            <div class="benefit-text">Mất thẻ ngân hàng</div>
                            <div class="benefit-amount" data-base="${benefit.lost_bank_card}">${benefit.lost_bank_card} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">5</div>
                            <div class="benefit-text">Bắt cóc và con tin</div>
                            <div class="benefit-amount" data-base="${benefit.kidnap_and_hostage}">${benefit.kidnap_and_hostage} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">6</div>
                            <div class="benefit-text">Mất hoặc hư hỏng dụng cụ golf</div>
                            <div class="benefit-amount" data-base="${benefit.lost_or_damaged_golf_equipment}">${benefit.lost_or_damaged_golf_equipment} VNĐ</div>
                        </div>
                    </div>

                    
                </div>
            </div>

            <!-- Main Content - Step 2: Buyer Information -->
            <div class="content-grid" id="step2Content" style="display: none;">
                <div class="card info-card">
                    <h2 class="card-title">
                        <span class="icon">👤</span>
                        Thông Tin Người Mua Bảo Hiểm
                        <span class="subtitle">(thông tin hóa đơn)</span>
                    </h2>

                    <!-- Tab Selection -->
                    <div class="tab-container">
                        <button class="tab-btn active" data-tab="individual">
                            <span class="tab-icon">👤</span>
                            Cá Nhân
                        </button>
                    </div>

                    <!-- Individual Form -->
                    <div id="individualForm" class="buyer-form">

                        <div class="form-row">
                            <div class="form-group">
                                <label>Số CCCD*</label>
                                <input type="text" placeholder="Nhập" class="form-input" id="idNumber"
                                       value="${sessionScope.user.cccd}" readonly>
                            </div>
                            <div class="form-group">
                                <label>Họ và Tên*</label>
                                <input type="text" placeholder="Nhập" class="form-input" id="fullName"
                                       value="${sessionScope.user.fullname}" readonly>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Giới Tính*</label>
                                <div class="radio-group">
                                    <label class="radio-label">
                                        <input type="radio" name="gender" value="male" checked disabled>
                                        <span>Nam</span>
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="gender" value="female" disabled>
                                        <span>Nữ</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Ngày Sinh*</label>
                                <input type="date" class="form-input" id="birthDate"
                                       value="${sessionScope.user.dob}" readonly>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Số Điện Thoại*</label>
                                <input type="tel" placeholder="Nhập" class="form-input" id="phoneNumber"
                                       value="${sessionScope.user.phone}" readonly>
                            </div>
                            <div class="form-group">
                                <label>Email*</label>
                                <input type="email" placeholder="Nhập" class="form-input" id="email"
                                       value="${sessionScope.user.mail}" readonly>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label>Địa Chỉ*</label>
                            <input type="text" placeholder="Nhập" class="form-input" id="address"
                                   value="${sessionScope.user.address}" readonly>
                        </div>
                    </div>


                    <!-- Organization Form (Hidden by default) -->
                    <div id="organizationForm" class="buyer-form" style="display: none;">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Mã Số Thuế*</label>
                                <input type="text" placeholder="Nhập" class="form-input">
                            </div>
                            <div class="form-group">
                                <label>Tên Tổ Chức*</label>
                                <input type="text" placeholder="Nhập" class="form-input">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Người Đại Diện*</label>
                                <input type="text" placeholder="Nhập" class="form-input">
                            </div>
                            <div class="form-group">
                                <label>Số Điện Thoại*</label>
                                <input type="tel" placeholder="Nhập" class="form-input">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Email*</label>
                                <input type="email" placeholder="Nhập" class="form-input">
                            </div>
                            <div class="form-group">
                                <label>Địa Chỉ*</label>
                                <input type="text" placeholder="Nhập" class="form-input">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content - Step 3: Insured Persons -->
            <div id="step3Content" style="display: none;">
                <div class="card info-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                        <h2 class="card-title" style="margin-bottom: 0;">
                            <span class="icon">👥</span>
                            Thông Tin Người Được Bảo Hiểm
                        </h2>
                        <button class="add-person-btn" onclick="openAddPersonModal()">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                            <path d="M10 5v10M5 10h10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                            Thêm Người Được Bảo Hiểm
                        </button>
                    </div>

                    <div id="insuredPersonsList">
                        <p style="text-align: center; color: #999; padding: 40px;">
                            Chưa có người được bảo hiểm. Nhấn nút "Thêm Người Được Bảo Hiểm" để thêm.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Main Content - Step 4: Confirmation -->
            <div id="step4Content" style="display: none;">
                <div id="confirmationContent"></div>

                <div class="card info-card" style="margin-top: 20px;">
                    <div class="form-group">
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                            <input type="checkbox" id="agreeTerms" style="width: 20px; height: 20px; cursor: pointer; accent-color: #e74c3c;">
                            <span>Tôi đồng ý với <a href="#" style="color: #e74c3c; text-decoration: none;">Chính Sách Bảo Vệ Dữ Liệu Cá Nhân của MIC</a></span>
                        </label>
                    </div>
                    <p style="font-size: 13px; color: #666; margin-top: 15px; line-height: 1.6;">
                        Tôi xác nhận rằng thông tin đã khai báo là chính xác, trung thực và tôi hoàn toàn chịu trách nhiệm về thông tin đã cung cấp.
                    </p>
                    <p style="font-size: 13px; color: #666; margin-top: 10px; line-height: 1.6;">
                        Các điều khoản chi tiết của đại diện Bên Bảo Hiểm được quy định trong Điều Khoản và Điều Kiện Bảo Hiểm.
                    </p>
                </div>
            </div>

            <!-- Step 5: Payment Information -->
            <div id="step5Content" style="display: none;">
                <div class="content-grid" style="grid-template-columns: 1fr 1fr; gap: 24px;">
                    <!-- Left Panel - Payment Form -->
                    <div class="card payment-card">
                        <h2 class="card-title">
                            <span class="icon">💳</span>
                            Thông Tin Thanh Toán
                        </h2>

                        <div class="form-group">
                            <label>Tên Chủ Thẻ*</label>
                            <input type="text" placeholder="Nhập họ và tên trên thẻ" class="form-input" id="cardholderName">
                        </div>

                        <div class="form-group">
                            <label>Số Thẻ*</label>
                            <input type="text" placeholder="0000 0000 0000 0000" class="form-input" id="cardNumber" maxlength="19">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Ngày Hết Hạn (MM/YY)*</label>
                                <input type="text" placeholder="MM/YY" class="form-input" id="expiryDate" maxlength="5">
                            </div>
                            <div class="form-group">
                                <label>CVV*</label>
                                <input type="text" placeholder="000" class="form-input" id="cvv" maxlength="3">
                            </div>
                        </div>

                        <div class="security-notice">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none" style="flex-shrink: 0;">
                            <path d="M10 1L4 4v5c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V4l-6-3z" fill="#27ae60"/>
                            <path d="M9 13l-3-3 1-1 2 2 4-4 1 1-5 5z" fill="white"/>
                            </svg>
                            <span style="font-size: 12px; color: #27ae60;">Thông tin thanh toán của bạn được bảo mật và mã hóa</span>
                        </div>
                    </div>

                    <!-- Right Panel - Payment Summary -->
                    <div class="card payment-summary-card">
                        <h2 class="card-title">
                            <span class="icon">📋</span>
                            Tóm Tắt Đơn Hàng
                        </h2>
                        <div id="paymentSummaryContent"></div>

                        <div class="payment-methods-info" style="margin-top: 24px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                            <h3 class="section-title" style="margin-bottom: 12px;">Phương Thức Thanh Toán</h3>
                            <div style="display: flex; align-items: center; gap: 8px; padding: 12px; background: #f0f8ff; border: 1px solid #b3d9ff;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                                <rect x="2" y="5" width="20" height="14" rx="2" stroke="currentColor" stroke-width="2"/>
                                <path d="M2 10h20" stroke="currentColor" stroke-width="2"/>
                                </svg>
                                <span style="font-size: 14px; color: #333; font-weight: 500;">Thẻ Ngân Hàng (Ghi Nợ/Thẻ Tín Dụng)</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal - Add Insured Person -->
            <div id="addPersonModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3>
                            <svg width="30" height="30" viewBox="0 0 40 40" fill="none" style="vertical-align: middle;">
                            <rect x="8" y="12" width="24" height="16" rx="2" stroke="#666" stroke-width="2"/>
                            <circle cx="14" cy="18" r="2" fill="#666"/>
                            <path d="M18 24h8M18 20h8" stroke="#666" stroke-width="1.5"/>
                            </svg>
                            Chụp/tải lên ảnh CCCD để tự động điền thông tin (Tùy chọn)
                        </h3>
                        <button class="modal-close" onclick="closeAddPersonModal()">×</button>
                    </div>

                    <form id="personForm" class="buyer-form needs-validation" novalidate>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Họ và Tên*</label>
                                <input type="text" placeholder="Nhập" class="form-input" id="personFullName">
                            </div>
                            <div class="form-group">
                                <label>Giới Tính*</label>
                                <div class="radio-group">
                                    <label class="radio-label">
                                        <input type="radio" name="personGender" value="male" checked>
                                        <span>Nam</span>
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="personGender" value="female">
                                        <span>Nữ</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Số CCCD*</label>
                                <input type="text" placeholder="Nhập" class="form-input" id="personIdNumber">
                            </div>
                            <div class="form-group">
                                <label>Ngày Sinh*</label>
                                <input type="date" class="form-input" id="personBirthDate">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Số Điện Thoại*</label>
                                <input type="tel" placeholder="Nhập" class="form-input" id="personPhoneNumber">
                            </div>
                            <div class="form-group">
                                <label>Email*</label>
                                <input type="email" placeholder="Nhập" class="form-input" id="personEmail">
                            </div>
                        </div>

                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeAddPersonModal()">Hủy</button>
                            <button type="button" class="btn-primary" onclick="saveInsuredPerson()">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Bottom Bar -->
            <div class="bottom-bar">
                <button class="back-btn" id="backBtn">
                    ← Quay Lại
                </button>
                <div class="total-section">
                    <span class="total-label">Tổng Phí Bảo Hiểm</span>
                    <span class="sp" id="totalAmount">0 VNĐ</span>
                </div>
                <button class="continue-btn" id="continueBtn">
                    Tiếp Tục →
                </button>
            </div>
        </div>
                        <jsp:include page="./component/footer.jsp"></jsp:include>
        <script>
// Khai báo biến global trước khi load file JS
            const INSURANCE_TYPE = '${requestScope.insurance.type}';
            const BENEFIT_ID = '${requestScope.insurance.benefit_id}';
        </script>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script src="./JS/InsurancePurchase.js"></script>
    </body>
</html>