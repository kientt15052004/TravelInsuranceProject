<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="Model.InsuranceProduct" %>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Travel Insurance</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="./CSS/styleindex.css"/>
    </head>
    <body>
        <%--<jsp:include page="./component/header.jsp"></jsp:include>--%>
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg shadow-sm">
            <div class="container d-flex justify-content-between align-items-center">

                <div class="navbar-left d-flex align-items-center">
                    <a class="navbar-brand" href="#">
                        <i class="fas fa-shield-alt"></i>
                        InsureTravel
                    </a>
                </div>
                <!-- Nút toggle (mobile) --> 
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="navbar-center collapse navbar-collapse justify-content-center" id="navbarNav">
                    <ul class="navbar-nav flex-row justify-content-center">
                        <li class="nav-item mx-3"><a class="nav-link" href="#">Insurance Plans</a></li>
                        <li class="nav-item mx-3"><a class="nav-link" href="#">Claims</a></li>
                        <li class="nav-item mx-3"><a class="nav-link" href="#">About</a></li>
                        <li class="nav-item mx-3"><a class="nav-link" href="#">Support</a></li>
                    </ul>
                </div>

                <div class="navbar-right d-flex justify-content-end">
                    <%
                        Model.User user = (Model.User) session.getAttribute("user");
                        if (user == null) {
                    %>
                    <button class="btn btn-sign-in" onclick="window.location.href = 'login.jsp'">Sign In</button>
                    <%
                        } else {
                    %>
                    <div class="user-info d-flex align-items-center">
                        <i class="fas fa-user me-2"></i>
                        <span><%= user.getFullname() %></span>
                        <span class="mx-2 text-muted">|</span>
                        <a href="logout" class="text-black text-decoration-none fw-semibold">Đăng xuất</a>
                    </div>
                    <%
                        }
                    %>
                </div>

            </div>  
        </nav>



        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <h1>Travel with Confidence,</h1>
                        <h1 class="subtitle">Insured with Care</h1>
                        <p>Comprehensive travel insurance coverage for your peace of mind. From medical emergencies to trip cancellations, we've got you covered worldwide.</p>
                        <button class="btn btn-instant">Get Insurance</button>
                        <button class="btn btn-learn">Learn More</button>
                    </div>
                    <div class="col-lg-6">
                        <img src="./Image/img_home.png" alt="Travel Insurance" class="img-fluid hero-image">
                    </div>
                </div>
            </div>
        </section>

        <!-- Products Section -->
        <section class="products-section">
            <div class="container">
                <h2>Current Travel Insurance Products</h2>
                <p class="subtitle-text">Choose the perfect insurance plan for your next adventure</p>
                <div class="row g-4 justify-content-center">
                    <%
                        ArrayList<Model.InsuranceProduct> products = (ArrayList<Model.InsuranceProduct>) request.getAttribute("products");
                        if (products != null && !products.isEmpty()) {
                            for (Model.InsuranceProduct p : products) {
                    %>
                    <div class="col-lg-5 col-md-6">
                        <div class="product-card text-center">
                            <img src="<%= p.getImg() %>" alt="<%= p.getName() %>" class="product-image">
                            <button class="btn-select-plan"><%= p.getName() %></button>
                            <p class="product-desc mt-2"><%= p.getDescription() %></p>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <p class="text-center">Hiện chưa có sản phẩm nào được hiển thị.</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </section>


        <!-- Why Choose Section -->
        <section class="why-choose-section">
            <div class="container">
                <h2>Why Choose InsureTravel?</h2>
                <p class="subtitle-text">Trusted by over 2 million travelers worldwide</p>
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="feature-box">
                            <div class="feature-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <h4>Instant Coverage</h4>
                            <p>Get instant travel coverage with our streamlined application process</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="feature-box">
                            <div class="feature-icon">
                                <i class="fas fa-globe"></i>
                            </div>
                            <h4>Global Coverage</h4>
                            <p>Protected around the world with our comprehensive network</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="feature-box">
                            <div class="feature-icon">
                                <i class="fas fa-headset"></i>
                            </div>
                            <h4>24/7 Support</h4>
                            <p>Round-the-clock assistance whenever and wherever you need it</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="feature-box">
                            <div class="feature-icon">
                                <i class="fas fa-bolt"></i>
                            </div>
                            <h4>Fast Claims</h4>
                            <p>Quick and hassle-free claims processing with digital submission</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FAQ Section - Phần câu hỏi thường gặp -->
        <section class="faq-section">
            <div class="container">
                <h2>Frequently Asked Questions</h2>
                <p class="subtitle-text">Get answers to common travel insurance questions</p>
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- FAQ Item 1 -->
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span>What does travel insurance cover?</span>
                                <i class="fas fa-chevron-down faq-icon"></i>
                            </div>
                            <div class="faq-answer">
                                Travel insurance typically covers medical emergencies, trip cancellations, lost baggage, flight delays, and emergency evacuations. The specific coverage depends on the plan you choose. Our Basic plan covers essential medical needs, while Premium and Elite plans offer more comprehensive protection including adventure sports and cancel-for-any-reason options.
                            </div>
                        </div>

                        <!-- FAQ Item 2 -->
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span>When should I purchase travel insurance?</span>
                                <i class="fas fa-chevron-down faq-icon"></i>
                            </div>
                            <div class="faq-answer">
                                It's best to purchase travel insurance as soon as you book your trip. This ensures maximum coverage, especially for trip cancellation benefits. Some benefits, like pre-existing condition coverage, are only available if you purchase within a specific time frame after your initial trip deposit.
                            </div>
                        </div>

                        <!-- FAQ Item 3 -->
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span>How do I file a claim?</span>
                                <i class="fas fa-chevron-down faq-icon"></i>
                            </div>
                            <div class="faq-answer">
                                Filing a claim is easy! You can submit your claim online through our portal, via email, or by calling our 24/7 support team. You'll need to provide documentation such as receipts, medical reports, or police reports depending on your claim type. Most claims are processed within 10-15 business days.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <div class="container">
                <h2>Ready to Travel with Peace of Mind?</h2>
                <p>Get your personalized insurance in under 3 minutes</p>
                <button class="btn btn-cta" onclick="window.location.href = 'InsurancePurchase.jsp'">Get Now</button>
            </div>
        </section>

        <!-- Footer -->
        <jsp:include page="./component/footer.jsp"></jsp:include>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script src="./JS/home.js"></script>
    </body>
</html>