<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Travel Insurance</title>
        <link rel="stylesheet" href="./CSS/InsurancePurchase.css">
    </head>
    <body>
        <div class="frame">
            <div class="container">
                <!-- Header -->
                <header class="header">
                    <div class="logo">InsureTravel</div>
                    <nav class="nav">
                        <a href="#" class="nav-link">Home</a>
                        <a href="#" class="nav-link">Products</a>
                        <a href="#" class="nav-link">About</a>
                        <a href="#" class="nav-link">Contact</a>
                    </nav>
                    <div class="user-icon">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                        <circle cx="10" cy="6" r="4" stroke="currentColor" stroke-width="2"/>
                        <path d="M4 18c0-3.314 2.686-6 6-6s6 2.686 6 6" stroke="currentColor" stroke-width="2"/>
                        </svg>
                    </div>
                </header>

                <!-- Breadcrumb -->
                <div class="breadcrumb">
                    <a href="#">Home</a>
                    <span>&gt;</span>
                    <a href="#">Products</a>
                    <span>&gt;</span>
                    <span>Travel Insurance</span>
                </div>

                <!-- Progress Indicator -->
                <div class="progress-indicator">
                    <div class="progress-step active" id="step1">
                        <div class="progress-circle">✓</div>
                        <span>Choose an insurance package</span>
                    </div>
                    <div class="progress-line"></div>
                    <div class="progress-step" id="step2">
                        <div class="progress-circle">2</div>
                        <span>Buyer information</span>
                    </div>
                    <div class="progress-line"></div>
                    <div class="progress-step" id="step3">
                        <div class="progress-circle">3</div>
                        <span>Insurance Information</span>
                    </div>
                    <div class="progress-line"></div>
                    <div class="progress-step" id="step4">
                        <div class="progress-circle">4</div>
                        <span>Confirmation & Payment</span>
                    </div>
                </div>

                <!-- Main Content - Step 1: Insurance Selection -->
                <div class="content-grid" id="step1Content">
                    <!-- Left Panel - Purchase Form -->
                    <div class="card purchase-card">
                        <h2 class="card-title">
                            <span class="icon">🛡️</span>
                            Purchase Travel Insurance
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
                            <div class="package-card" data-price="1000" data-benefit="10">
                                <div class="package-icon">🚲</div>
                                <div class="package-name">Program 1</div>
                                <div class="package-price">1,000 VNĐ/person</div>
                                <div class="package-benefit">Benefits up to 10 million</div>
                            </div>
                            <div class="package-card selected" data-price="5000" data-benefit="50">
                                <div class="package-icon">🚗</div>
                                <div class="package-name">Program 2</div>
                                <div class="package-price">5,000 VNĐ/person</div>
                                <div class="package-benefit">Benefits up to 50 million</div>
                            </div>
                            <div class="package-card" data-price="12000" data-benefit="120">
                                <div class="package-icon">🚆</div>
                                <div class="package-name">Program 3</div>
                                <div class="package-price">12,000 VNĐ/person</div>
                                <div class="package-benefit">Benefits up to 120 million</div>
                            </div>
                            <div class="package-card" data-price="20000" data-benefit="200">
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
                                <div class="benefit-amount" data-base="2000000">10,000,000 VNĐ</div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-number">2</div>
                                <div class="benefit-text">Death due to illness, disease</div>
                                <div class="benefit-amount" data-base="1500000">7,500,000 VNĐ</div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-number">3</div>
                                <div class="benefit-text">Personal Liability to Third Parties</div>
                                <div class="benefit-amount" data-base="1000000">5,000,000 VNĐ</div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-number">4</div>
                                <div class="benefit-text">Lost bank card</div>
                                <div class="benefit-amount" data-base="500000">2,500,000 VNĐ</div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-number">5</div>
                                <div class="benefit-text">Kidnap and hostage</div>
                                <div class="benefit-amount" data-base="3000000">15,000,000 VNĐ</div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-number">6</div>
                                <div class="benefit-text">Lost or damaged golf equipment</div>
                                <div class="benefit-amount" data-base="800000">4,000,000 VNĐ</div>
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
                            Insurance buyer information
                            <span class="subtitle">(invoice information)</span>
                        </h2>

                        <!-- Tab Selection -->
                        <div class="tab-container">
                            <button class="tab-btn active" data-tab="individual">
                                <span class="tab-icon">👤</span>
                                Individual
                            </button>
<!--                            <button class="tab-btn" data-tab="organization">
                                <span class="tab-icon">🏢</span>
                                Tổ chức
                            </button>-->
                        </div>

                        <!-- Auto-fill Notice -->
                        <div class="autofill-notice">
                            <svg width="40" height="40" viewBox="0 0 40 40" fill="none" style="flex-shrink: 0;">
                                <rect x="8" y="12" width="24" height="16" rx="2" stroke="#856404" stroke-width="2"/>
                                <circle cx="14" cy="18" r="2" fill="#856404"/>
                                <path d="M18 24h8M18 20h8" stroke="#856404" stroke-width="1.5"/>
                            </svg>
                            <span>Take/upload photo of ID to automatically enter information (Optional)</span>
                        </div>

                        <!-- Individual Form -->
                        <div id="individualForm" class="buyer-form">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Identification number*</label>
                                    <input type="text" placeholder="Nhập" class="form-input" id="idNumber">
                                </div>
                                <div class="form-group">
                                    <label>Full name*</label>
                                    <input type="text" placeholder="Nhập" class="form-input" id="fullName">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Sex*</label>
                                    <div class="radio-group">
                                        <label class="radio-label">
                                            <input type="radio" name="gender" value="male" checked>
                                            <span>Male</span>
                                        </label>
                                        <label class="radio-label">
                                            <input type="radio" name="gender" value="female">
                                            <span>Female</span>
                                        </label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Date of birth*</label>
                                    <input type="date" class="form-input" id="birthDate">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Phone number*</label>
                                    <input type="tel" placeholder="Nhập" class="form-input" id="phoneNumber">
                                </div>
                                <div class="form-group">
                                    <label>Email*</label>
                                    <input type="email" placeholder="Nhập" class="form-input" id="email">
                                </div>
                            </div>

                            <div class="form-group full-width">
                                <label>Address*</label>
                                <input type="text" placeholder="Nhập" class="form-input" id="address">
                            </div>
                        </div>

                        <!-- Organization Form (Hidden by default) -->
                        <div id="organizationForm" class="buyer-form" style="display: none;">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Tax code*</label>
                                    <input type="text" placeholder="Nhập" class="form-input">
                                </div>
                                <div class="form-group">
                                    <label>Organization name*</label>
                                    <input type="text" placeholder="Nhập" class="form-input">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Representative*</label>
                                    <input type="text" placeholder="Nhập" class="form-input">
                                </div>
                                <div class="form-group">
                                    <label>Phone number*</label>
                                    <input type="tel" placeholder="Nhập" class="form-input">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Email*</label>
                                    <input type="email" placeholder="Nhập" class="form-input">
                                </div>
                                <div class="form-group">
                                    <label>Address*</label>
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
                                Information of the insured person
                            </h2>
                            <button class="add-person-btn" onclick="openAddPersonModal()">
                                <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
                                    <path d="M10 5v10M5 10h10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                </svg>
                                Add insured
                            </button>
                        </div>

                        <div id="insuredPersonsList">
                            <p style="text-align: center; color: #999; padding: 40px;">
                                No insured person yet. Click "Add Insured" button to add.
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
                                <span>I agree <a href="#" style="color: #e74c3c; text-decoration: none;">Company's personal data protection policy</a></span>
                            </label>
                        </div>
                        <p style="font-size: 13px; color: #666; margin-top: 15px; line-height: 1.6;">
                            I certify that the declared information is accurate, honest and I am fully responsible for the declared information.
                        </p>
                        <p style="font-size: 13px; color: #666; margin-top: 10px; line-height: 1.6;">
                            Detailed terms agreed by the Insurer's representative in the Insurance Terms and Conditions.
                        </p>
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
                                Take/upload photo of ID to automatically enter information (Optional)
                            </h3>
                            <button class="modal-close" onclick="closeAddPersonModal()">×</button>
                        </div>
                        
                        <form id="personForm" class="buyer-form">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Full name*</label>
                                    <input type="text" placeholder="Nhập" class="form-input" id="personFullName">
                                </div>
                                <div class="form-group">
                                    <label>Sex*</label>
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
                                    <label>Identification number*</label>
                                    <input type="text" placeholder="Nhập" class="form-input" id="personIdNumber">
                                </div>
                                <div class="form-group">
                                    <label>Date of birth*</label>
                                    <input type="date" class="form-input" id="personBirthDate">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Phone number*</label>
                                    <input type="tel" placeholder="Nhập" class="form-input" id="personPhoneNumber">
                                </div>
                                <div class="form-group">
                                    <label>Email*</label>
                                    <input type="email" placeholder="Nhập" class="form-input" id="personEmail">
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
        </div>

        <script src="./JS/InsurancePurchase.js"></script>
    </body>
</html>