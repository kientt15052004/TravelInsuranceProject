<%-- 
    Document   : InsurancePurchase
    Created on : Oct 2, 2025, 5:11:15 PM
    Author     : FPTSHOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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

            <!-- Main Content -->
            <div class="content-grid">
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
                            <input type="text" class="date-input" placeholder="mm/dd/yyyy" id="startDate">
                        </div>
                        <div class="form-group">
                            <label>Insurance End Date*</label>
                            <input type="text" class="date-input" placeholder="mm/dd/yyyy" id="endDate">
                        </div>
                        <button class="swap-btn">⇄</button>
                    </div>

                    <!-- Passengers -->
                    <div class="form-group">
                        <label>Number of Passengers</label>
                        <div class="passenger-select">
                            <span id="passengerText">1 Passenger</span>
                            <button class="dropdown-btn" id="passengerBtn">▼</button>
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
                            <div class="package-name">Bicycle</div>
                            <div class="package-price">1,000 VNĐ/person</div>
                            <div class="package-benefit">Benefits up to 10 million</div>
                        </div>
                        <div class="package-card" data-price="5000" data-benefit="50">
                            <div class="package-icon">🚗</div>
                            <div class="package-name">Car</div>
                            <div class="package-price">5,000 VNĐ/person</div>
                            <div class="package-benefit">Benefits up to 50 million</div>
                        </div>
                        <div class="package-card" data-price="12000" data-benefit="120">
                            <div class="package-icon">🚆</div>
                            <div class="package-name">Train</div>
                            <div class="package-price">12,000 VNĐ/person</div>
                            <div class="package-benefit">Benefits up to 120 million</div>
                        </div>
                        <div class="package-card selected" data-price="20000" data-benefit="200">
                            <div class="package-icon">✈️</div>
                            <div class="package-name">Plane</div>
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

                    <h3 class="section-title">Main Benefits</h3>
                    <div class="benefits-list">
                        <div class="benefit-item">
                            <div class="benefit-number">1</div>
                            <div class="benefit-text">Death, permanent disability, temporary disability</div>
                            <div class="benefit-amount">120,000,000 VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">2</div>
                            <div class="benefit-text">Death due to illness, disease</div>
                            <div class="benefit-amount">60,000,000 VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">3</div>
                            <div class="benefit-text">Personal Liability to Third Parties</div>
                            <div class="benefit-amount">60,000,000 VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">4</div>
                            <div class="benefit-text">Lost Bank Card</div>
                            <div class="benefit-amount">12,000,000 VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">5</div>
                            <div class="benefit-text">Kidnapping and Hostage</div>
                            <div class="benefit-amount">24,000,000 VNĐ</div>
                        </div>
                        <div class="benefit-item">
                            <div class="benefit-number">6</div>
                            <div class="benefit-text">Lost or Damaged Golf Equipment</div>
                            <div class="benefit-amount">6,000,000 VNĐ</div>
                        </div>
                    </div>

                    <a href="#" class="view-summary">
                        <span>📄</span>
                        View Summary of Benefits
                    </a>
                </div>
            </div>

            <!-- Bottom Bar -->
            <div class="bottom-bar">
                <button class="back-btn">
                    ← Back
                </button>
                <div class="total-section">
                    <span class="total-label">Total Insurance Fee</span>
                    <span class="total-amount" id="totalAmount">20,000 VNĐ</span>
                </div>
                <button class="continue-btn">
                    Continue →
                </button>
            </div>
        </div>
    </div>

    <script src="./JS/InsurancePurchase.js"></script>
</body>
</html>
