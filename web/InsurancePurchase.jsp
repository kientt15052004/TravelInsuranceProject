
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Travel Insurance</title>
        <link rel="stylesheet" href="./CSS/InsurancePurchase.css">
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <jsp:include page="component/header.jsp" />

            <!-- Breadcrumb -->
            <div class="breadcrumb">
                <a href="#">Home</a>
                <span>&gt;</span>
                <a href="./InsuranceList">Insurance List</a>
                <span>&gt;</span>
                <span>Purchase Insurance</span>
            </div>

            <!-- Progress Indicator -->
            <div class="progress-indicator">
                <div class="progress-step active" id="step1">
                    <div class="progress-circle">✓</div>
                    <span>Select Insurance Package</span>
                </div>
                <div class="progress-line"></div>
                <div class="progress-step" id="step2">
                    <div class="progress-circle">2</div>
                    <span>Buyer Information</span>
                </div>
                <div class="progress-line"></div>
                <div class="progress-step" id="step3">
                    <div class="progress-circle">3</div>
                    <span>Insured Person Information</span>
                </div>
                <div class="progress-line"></div>
                <div class="progress-step" id="step4">
                    <div class="progress-circle">4</div>
                    <span>Confirmation</span>
                </div>
                <div class="progress-line"></div>
                <div class="progress-step" id="step5">
                    <div class="progress-circle">5</div>
                    <span>Payment</span>
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
                            <label>Insurance Start Date*</label>
                            <input type="date" class="date-input" id="startDate">
                        </div>
                        <div class="form-group">
                            <label>Insurance End Date*</label>
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
                        <span>Insurance period for each trip is not more than 180 days</span>
                    </div>

                    <!-- Insurance Packages -->
                    <h3 class="section-title">Select Insurance Package</h3>
                    <div class="packages-grid">
                        <div class="package-card" data-price="1000" data-benefit="1">
                            <div class="package-icon">🚲</div>
                            <div class="package-name">Program 1</div>
                            <div class="package-price">1,000 VNĐ/person</div>
                            <div class="package-benefit">Benefits up to 10 million</div>
                        </div>
                        <div class="package-card selected" data-price="5000" data-benefit="5">
                            <div class="package-icon">🚗</div>
                            <div class="package-name">Program 2</div>
                            <div class="package-price">5,000 VNĐ/person</div>
                            <div class="package-benefit">Benefits up to 50 million</div>
                        </div>
                        <div class="package-card" data-price="12000" data-benefit="12">
                            <div class="package-icon">🚆</div>
                            <div class="package-name">Program 3</div>
                            <div class="package-price">12,000 VNĐ/person</div>
                            <div class="package-benefit">Benefits up to 120 million</div>
                        </div>
                        <div class="package-card" data-price="20000" data-benefit="20">
                            <div class="package-icon">✈️</div>
                            <div class="package-name">Program 4</div>
                            <div class="package-price">20,000 VNĐ/person</div>
                            <div class="package-benefit">Benefits up to 200 million</div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel - Benefits -->
                <div class="card benefits-card">
                    <h2 class="card-title">
                        <span class="icon">🎯</span>
                        Insurance Benefits
                    </h2>
                    <c:set var="benefit" value="${requestScope.insurance.benefit}" scope="request"/>

                    <h3 class="section-title">Main Benefits</h3>
                    <div class="benefits-list">
                        <div class="benefit-item">
                            <div class="benefit-number">1</div>
                            <div class="benefit-text">Death, permanent disability, temporary disability</div>
                            <div class="benefit-amount" data-base="${benefit.death_or_permanent_disability}">${benefit.death_or_permanent_disability} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">2</div>
                            <div class="benefit-text">Death due to illness, disease</div>
                            <div class="benefit-amount" data-base="${benefit.death_due_to_illness}">${benefit.death_due_to_illness} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">3</div>
                            <div class="benefit-text">Personal Liability to Third Parties</div>
                            <div class="benefit-amount" data-base="${benefit.third_party_liability}">${benefit.third_party_liability} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">4</div>
                            <div class="benefit-text">Lost bank card</div>
                            <div class="benefit-amount" data-base="${benefit.lost_bank_card}">${benefit.lost_bank_card} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">5</div>
                            <div class="benefit-text">Kidnap and hostage</div>
                            <div class="benefit-amount" data-base="${benefit.kidnap_and_hostage}">${benefit.kidnap_and_hostage} VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">6</div>
                            <div class="benefit-text">Lost or damaged golf equipment</div>
                            <div class="benefit-amount" data-base="${benefit.lost_or_damaged_golf_equipment}">${benefit.lost_or_damaged_golf_equipment} VNĐ</div>
                        </div>
                    </div>

                    <a href="#" class="view-summary">
                        <span>📄</span>
                        View Summary of Benefits
                    </a>
                </div>
            </div>

            <!-- Main Content - Step 2: Buyer Information -->
            <div class="content-grid" id="step2Content" style="display: none;">
                <div class="card info-card">
                    <h2 class="card-title">
                        <span class="icon">👤</span>
                        Insurance Buyer Information
                        <span class="subtitle">(invoice information)</span>
                    </h2>

                    <!-- Tab Selection -->
                    <div class="tab-container">
                        <button class="tab-btn active" data-tab="individual">
                            <span class="tab-icon">👤</span>
                            Individual
                        </button>
                    </div>

                    <!-- Individual Form -->
                    <div id="individualForm" class="buyer-form">

                        <div class="form-row">
                            <div class="form-group">
                                <label>CCCD ID*</label>
                                <input type="text" placeholder="Enter" class="form-input" id="idNumber"
                                       value="${sessionScope.user.cccd}" readonly>
                            </div>
                            <div class="form-group">
                                <label>Full Name*</label>
                                <input type="text" placeholder="Enter" class="form-input" id="fullName"
                                       value="${sessionScope.user.fullname}" readonly>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Gender*</label>
                                <div class="radio-group">
                                    <label class="radio-label">
                                        <input type="radio" name="gender" value="male" checked disabled>
                                        <span>Male</span>
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="gender" value="female" disabled>
                                        <span>Female</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Date of Birth*</label>
                                <input type="date" class="form-input" id="birthDate"
                                       value="${sessionScope.user.dob}" readonly>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Phone Number*</label>
                                <input type="tel" placeholder="Enter" class="form-input" id="phoneNumber"
                                       value="${sessionScope.user.phone}" readonly>
                            </div>
                            <div class="form-group">
                                <label>Email*</label>
                                <input type="email" placeholder="Enter" class="form-input" id="email"
                                       value="${sessionScope.user.mail}" readonly>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label>Address*</label>
                            <input type="text" placeholder="Enter" class="form-input" id="address"
                                   value="${sessionScope.user.address}" readonly>
                        </div>
                    </div>


                    <!-- Organization Form (Hidden by default) -->
                    <div id="organizationForm" class="buyer-form" style="display: none;">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Tax Code*</label>
                                <input type="text" placeholder="Enter" class="form-input">
                            </div>
                            <div class="form-group">
                                <label>Organization Name*</label>
                                <input type="text" placeholder="Enter" class="form-input">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Representative*</label>
                                <input type="text" placeholder="Enter" class="form-input">
                            </div>
                            <div class="form-group">
                                <label>Phone Number*</label>
                                <input type="tel" placeholder="Enter" class="form-input">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Email*</label>
                                <input type="email" placeholder="Enter" class="form-input">
                            </div>
                            <div class="form-group">
                                <label>Address*</label>
                                <input type="text" placeholder="Enter" class="form-input">
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
                            Insured Person Information
                        </h2>
                        <button class="add-person-btn" onclick="openAddPersonModal()">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                            <path d="M10 5v10M5 10h10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                            Add Insured Person
                        </button>
                    </div>

                    <div id="insuredPersonsList">
                        <p style="text-align: center; color: #999; padding: 40px;">
                            No insured persons yet. Click "Add Insured Person" button to add.
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
                            <span>I agree to <a href="#" style="color: #e74c3c; text-decoration: none;">MIC's Personal Data Protection Policy</a></span>
                        </label>
                    </div>
                    <p style="font-size: 13px; color: #666; margin-top: 15px; line-height: 1.6;">
                        I certify that the declared information is accurate, truthful, and I am fully responsible for the information provided.
                    </p>
                    <p style="font-size: 13px; color: #666; margin-top: 10px; line-height: 1.6;">
                        Detailed terms of agreement of the Insurance Party representative are in the Insurance Terms and Conditions.
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
                            Payment Information
                        </h2>

                        <div class="form-group">
                            <label>Cardholder Name*</label>
                            <input type="text" placeholder="Enter full name on card" class="form-input" id="cardholderName">
                        </div>

                        <div class="form-group">
                            <label>Card Number*</label>
                            <input type="text" placeholder="0000 0000 0000 0000" class="form-input" id="cardNumber" maxlength="19">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Expiry Date (MM/YY)*</label>
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
                            <span style="font-size: 12px; color: #27ae60;">Your payment information is secure and encrypted</span>
                        </div>
                    </div>

                    <!-- Right Panel - Payment Summary -->
                    <div class="card payment-summary-card">
                        <h2 class="card-title">
                            <span class="icon">📋</span>
                            Order Summary
                        </h2>
                        <div id="paymentSummaryContent"></div>

                        <div class="payment-methods-info" style="margin-top: 24px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                            <h3 class="section-title" style="margin-bottom: 12px;">Payment Method</h3>
                            <div style="display: flex; align-items: center; gap: 8px; padding: 12px; background: #f0f8ff; border-radius: 6px; border: 1px solid #b3d9ff;">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                                <rect x="2" y="5" width="20" height="14" rx="2" stroke="currentColor" stroke-width="2"/>
                                <path d="M2 10h20" stroke="currentColor" stroke-width="2"/>
                                </svg>
                                <span style="font-size: 14px; color: #333; font-weight: 500;">Bank Card (Debit/Credit)</span>
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
                            Take/upload a photo of your ID to auto-fill information (Optional)
                        </h3>
                        <button class="modal-close" onclick="closeAddPersonModal()">×</button>
                    </div>

                    <form id="personForm" class="buyer-form">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Full Name*</label>
                                <input type="text" placeholder="Enter" class="form-input" id="personFullName">
                            </div>
                            <div class="form-group">
                                <label>Gender*</label>
                                <div class="radio-group">
                                    <label class="radio-label">
                                        <input type="radio" name="personGender" value="male" checked>
                                        <span>Male</span>
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="personGender" value="female">
                                        <span>Female</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>ID Number*</label>
                                <input type="text" placeholder="Enter" class="form-input" id="personIdNumber">
                            </div>
                            <div class="form-group">
                                <label>Date of Birth*</label>
                                <input type="date" class="form-input" id="personBirthDate">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Phone Number*</label>
                                <input type="tel" placeholder="Enter" class="form-input" id="personPhoneNumber">
                            </div>
                            <div class="form-group">
                                <label>Email*</label>
                                <input type="email" placeholder="Enter" class="form-input" id="personEmail">
                            </div>
                        </div>

                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeAddPersonModal()">Cancel</button>
                            <button type="button" class="btn-primary" onclick="saveInsuredPerson()">Save</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Bottom Bar -->
            <div class="bottom-bar">
                <button class="back-btn" id="backBtn">
                    ← Back
                </button>
                <div class="total-section">
                    <span class="total-label">Total Insurance Fee</span>
                    <span class="sp" id="totalAmount">0 VNĐ</span>
                </div>
                <button class="continue-btn" id="continueBtn">
                    Continue →
                </button>
            </div>
        </div>

        <script>
// Khai báo biến global trước khi load file JS
            const INSURANCE_TYPE = '${requestScope.insurance.type}';
            const BENEFIT_ID = '${requestScope.insurance.benefit_id}';
        </script>

        <script src="./JS/InsurancePurchase.js"></script>
    </body>
</html>