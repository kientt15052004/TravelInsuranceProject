<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="Model.InsuranceProduct" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Bảo Hiểm Du Lịch</title>
        <!-- CSS được load trong header.jsp -->
    </head>
    <body>
        <jsp:include page="./component/header.jsp"></jsp:include>
        <!-- CSS riêng cho trang này -->
        <link rel="stylesheet" href="./CSS/styleindex.css"/>

            <!-- Hero Section -->
            <section class="hero-section">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-lg-6">
                            <h1>Du lịch tự tin,</h1>
                            <h1 class="subtitle">Được bảo hiểm an toàn</h1>
                            <p>Bảo hiểm du lịch toàn diện cho sự an tâm của bạn. Từ các trường hợp cấp cứu y tế đến hủy chuyến đi, chúng tôi bảo vệ bạn trên toàn thế giới.</p>
                            <button class="btn btn-instant" onclick="window.location.href = 'InsuranceList'">Mua Bảo Hiểm</button>
                            <button class="btn btn-learn" onclick="window.location.href = 'InsuranceList'">Tìm Hiểu Thêm</button>
                        </div>
                        <div class="col-lg-6">
                            <img src="./Image/img_home.png" alt="Bảo Hiểm Du Lịch" class="img-fluid hero-image">
                        </div>
                    </div>
                </div>
            </section>

            <!-- Products Section -->
            <section class="products-section">
                <div class="container">
                    <h2>Sản phẩm hệ thống đang bán</h2>
                    <p class="subtitle-text">Chọn gói bảo hiểm hoàn hảo cho chuyến phiêu lưu tiếp theo của bạn</p>
                    <div class="row g-4 justify-content-center">
                    <%
                        ArrayList<Model.InsuranceProduct> products = (ArrayList<Model.InsuranceProduct>) request.getAttribute("products");
                        if (products != null && !products.isEmpty()) {
                            int count = 0;
                            for (Model.InsuranceProduct p : products) {
                                if (count >= 4) break;
                                count++;
                    %>
                    <div class="col-lg-5 col-md-6">
                        <div class="product-card text-center">
                            <img src="<%= p.getImg().startsWith("http") ? p.getImg() : "./" + p.getImg() %>" alt="<%= p.getName() %>" class="product-image">
                            <button class="btn-select-plan" onclick="window.location.href = 'InsuranceList'"><%= p.getName() %></button>
                            <p class="product-desc mt-2"><%= p.getDescription() %></p>
                        </div>
                    </div>
                    <%
                            }
                    %>
                    <div class="col-12 text-center mt-4">
                        <button class="btn btn-instant" onclick="window.location.href = 'InsuranceList'" style="padding: 12px 30px; font-size: 1.1rem;">Xem Tất Cả Sản Phẩm</button>
                    </div>
                    <%
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
                <h2>Tại sao chọn InsureTravel?</h2>
                <p class="subtitle-text">Được tin tưởng bởi hơn 2 triệu khách du lịch trên toàn thế giới</p>
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="feature-box">
                            <div class="feature-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <h4>Bảo hiểm tức thì</h4>
                            <p>Nhận bảo hiểm du lịch ngay lập tức với quy trình đăng ký đơn giản</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="feature-box">
                            <div class="feature-icon">
                                <i class="fas fa-globe"></i>
                            </div>
                            <h4>Bảo vệ toàn cầu</h4>
                            <p>Được bảo vệ trên toàn thế giới với mạng lưới toàn diện của chúng tôi</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="feature-box">
                            <div class="feature-icon">
                                <i class="fas fa-headset"></i>
                            </div>
                            <h4>Hỗ trợ 24/7</h4>
                            <p>Hỗ trợ liên tục bất cứ khi nào và ở đâu bạn cần</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="feature-box">
                            <div class="feature-icon">
                                <i class="fas fa-bolt"></i>
                            </div>
                            <h4>Giải quyết nhanh chóng</h4>
                            <p>Xử lý khiếu nại nhanh chóng và dễ dàng với nộp đơn kỹ thuật số</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FAQ Section - Phần câu hỏi thường gặp -->
        <section class="faq-section">
            <div class="container">
                <h2>Câu Hỏi Thường Gặp</h2>
                <p class="subtitle-text">Nhận câu trả lời cho các câu hỏi phổ biến về bảo hiểm du lịch</p>
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- FAQ Item 1 -->
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span>Bảo hiểm du lịch bao gồm những gì?</span>
                                <i class="fas fa-chevron-down faq-icon"></i>
                            </div>
                            <div class="faq-answer">
                                Bảo hiểm du lịch thường bao gồm các trường hợp cấp cứu y tế, hủy chuyến đi, hành lý bị mất, chậm chuyến bay và sơ tán khẩn cấp. Phạm vi bảo hiểm cụ thể phụ thuộc vào gói bạn chọn. Gói Cơ bản của chúng tôi bao gồm các nhu cầu y tế thiết yếu, trong khi các gói Cao cấp và Cao nhất cung cấp bảo vệ toàn diện hơn bao gồm thể thao mạo hiểm và các tùy chọn hủy vì bất kỳ lý do nào.
                            </div>
                        </div>

                        <!-- FAQ Item 2 -->
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span>Khi nào tôi nên mua bảo hiểm du lịch?</span>
                                <i class="fas fa-chevron-down faq-icon"></i>
                            </div>
                            <div class="faq-answer">
                                Tốt nhất là bạn nên mua bảo hiểm du lịch ngay sau khi đặt chuyến đi. Điều này đảm bảo phạm vi bảo hiểm tối đa, đặc biệt là các quyền lợi hủy chuyến đi. Một số quyền lợi, như bảo hiểm cho các tình trạng sẵn có, chỉ có sẵn nếu bạn mua trong một khung thời gian cụ thể sau khi đặt cọc chuyến đi ban đầu.
                            </div>
                        </div>

                        <!-- FAQ Item 3 -->
                        <div class="faq-item" onclick="toggleFAQ(this)">
                            <div class="faq-question">
                                <span>Làm thế nào để nộp đơn khiếu nại?</span>
                                <i class="fas fa-chevron-down faq-icon"></i>
                            </div>
                            <div class="faq-answer">
                                Nộp đơn khiếu nại rất dễ dàng! Bạn có thể gửi đơn khiếu nại trực tuyến qua cổng thông tin của chúng tôi, qua email hoặc bằng cách gọi cho đội hỗ trợ 24/7 của chúng tôi. Bạn sẽ cần cung cấp tài liệu như hóa đơn, báo cáo y tế hoặc báo cáo cảnh sát tùy thuộc vào loại khiếu nại của bạn. Hầu hết các khiếu nại được xử lý trong vòng 10-15 ngày làm việc.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <div class="container">
                <h2>Sẵn sàng du lịch với sự an tâm?</h2>
                <p>Nhận bảo hiểm cá nhân hóa của bạn trong vòng chưa đầy 3 phút</p>
                <button class="btn btn-cta" onclick="window.location.href = 'InsuranceList'">Xem Sản Phẩm</button>
            </div>
        </section>

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
                    <c:when test="${swalIcon == 'error' && swalMessage == 'Mật khẩu hiện tại sai!' || swalMessage == 'mật khẩu mới xác nhận không khớp!'}">
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
    </body>
</html>