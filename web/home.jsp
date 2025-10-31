<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="Model.InsuranceProduct" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
                    <div class="dropdown">
                        <a class="d-flex align-items-center text-decoration-none dropdown-toggle" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user me-2"></i>
                            <span><%= user.getFullname() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#profileModal">Profile</a></li>
                            <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#changePasswordModal">Change Password</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout">Logout</a></li>
                        </ul>
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
                            <img src="<%= p.getImg().startsWith("http") ? p.getImg() : "./" + p.getImg() %>" alt="<%= p.getName() %>" class="product-image">
                            <img src="./<%= p.getImg() %>" alt="<%= p.getName() %>" class="product-image">
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

        <!-- Profile Modal -->
        <div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg"> 
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="profileModalLabel">Edit Profile</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data"> <!-- multipart nếu upload avatar/CCCD -->
                        <div class="modal-body">
                            <div class="row g-3">
                                <!-- Avatar -->
                                <div class="col-md-3 text-center">
                                    <c:if test="${not empty user.avatar}">
                                        <img id="avatarPreview" src="<c:out value='${user.avatar}' />" alt="Avatar" class="img-fluid rounded-circle mb-2">
                                    </c:if>
                                    <input type="file" name="avatar" class="form-control mt-1" onchange="previewImage(this, 'avatarPreview')">
                                </div>

                                <div class="col-md-9">
                                    <input type="hidden" name="id" value="<c:out value='${user.id}' />">

                                    <div class="mb-2">
                                        <label class="form-label fw-semibold">Full Name:</label>
                                        <input type="text" class="form-control" name="fullname" value="<c:out value='${user.fullname}' />" required>
                                    </div>

                                    <div class="mb-2">
                                        <label class="form-label fw-semibold">Email:</label>
                                        <input type="email" class="form-control" name="mail" value="<c:out value='${user.mail}' />" required>
                                    </div>

                                    <div class="mb-2">
                                        <label class="form-label fw-semibold">Date of Birth:</label>
                                        <input type="date" class="form-control" name="dob" value="<c:out value='${user.dob}' />">
                                    </div>

                                    <div class="mb-2">
                                        <label class="form-label fw-semibold">Address:</label>
                                        <input type="text" class="form-control" name="address" value="<c:out value='${user.address}' />">
                                    </div>

                                    <div class="mb-2">
                                        <label class="form-label fw-semibold">Phone:</label>
                                        <input type="text" class="form-control" name="phone" value="<c:out value='${user.phone}' />">
                                    </div>

                                    <div class="mb-2">
                                        <label class="form-label fw-semibold">CCCD Number:</label>
                                        <input type="text" class="form-control" name="cccd" value="<c:out value='${user.cccd}' />">
                                    </div>

                                    <!-- CCCD Image -->
                                    <div class="mb-2">
                                        <label class="form-label fw-semibold">CCCD Image:</label>
                                        <c:if test="${not empty user.cccd_img}">
                                            <img id="cccdPreview" src="<c:out value='${user.cccd_img}' />" alt="CCCD Image" class="img-fluid mt-1 mb-1">
                                        </c:if>
                                        <input type="file" name="cccd_img" class="form-control mt-1" onchange="previewImage(this, 'cccdPreview')">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Update Profile</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Change Password Modal -->
        <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="changePasswordModalLabel">Change Password</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="ChangePasswordServlet" method="post">
                            <div class="mb-3">
                                <label class="form-label">Current Password</label>
                                <input type="password" class="form-control" name="currentPassword" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">New Password</label>
                                <input type="password" class="form-control" name="newPassword" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Confirm New Password</label>
                                <input type="password" class="form-control" name="confirmPassword" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Save</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="./component/footer.jsp"></jsp:include>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <script src="./JS/home.js"></script>

            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <c:if test="${not empty swalMessage}">
            <script>
                                            Swal.fire({
                                                icon: '<c:out value="${swalIcon}" />',
                                                title: '<c:out value="${swalMessage}" />',
                                                showConfirmButton: true,
                                                timer: 3000
                                            });

                                            // Nếu thất bại ở modal nào đó, mở lại modal tương ứng
                <c:choose>
                    <c:when test="${swalIcon == 'error' && swalMessage == 'Current password is incorrect!' || swalMessage == 'New password and confirm password do not match!'}">
                                            var changeModal = new bootstrap.Modal(document.getElementById('changePasswordModal'));
                                            changeModal.show();
                    </c:when>
                    <c:when test="${swalIcon == 'error' && swalMessage == 'Failed to update profile. Please try again.'}">
                                            var profileModal = new bootstrap.Modal(document.getElementById('profileModal'));
                                            profileModal.show();
                    </c:when>
                </c:choose>
            </script>
        </c:if>


        <script>
            function previewImage(input, previewId) {
                const file = input.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById(previewId).src = e.target.result;
                    }
                    reader.readAsDataURL(file);
                }
            }
        </script>
    </body>
</html>