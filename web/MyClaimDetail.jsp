<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Khiếu Nại - InsureTravel</title>
    
    <!-- CSS riêng cho trang này -->
    <link rel="stylesheet" href="./CSS/MyClaimDetail.css"/>
</head>
<body>
    <jsp:include page="./component/header.jsp"></jsp:include>
    
    <!-- CSS riêng cho trang này - load sau header để override -->
    <link rel="stylesheet" href="./CSS/MyClaimDetail.css"/>

    <main class="container my-4 my-lg-5">
        <!-- Header -->
        <div class="page-header d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="title mb-0">Chi tiết Khiếu Nại</h1>
                <p class="subtitle mb-0">Thông tin chi tiết về yêu cầu bồi thường của bạn</p>
            </div>
            <a href="my-claims" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>
                Quay lại danh sách
            </a>
        </div>

        <!-- Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty claim}">
            <!-- Claim Information Card -->
            <div class="claim-detail-card border rounded-3 mb-4">
                <div class="card-header bg-light p-4 border-bottom">
                    <div class="d-flex justify-content-between align-items-center">
                        <h2 class="mb-0">
                            <i class="bi bi-file-earmark-text me-2"></i>
                            Khiếu Nại #KN-${claim.id}
                        </h2>
                        <div class="status-container">
                            <span class="status-badge status-${claim.claim_status}">
                                <c:choose>
                                    <c:when test="${claim.claim_status == 'pending'}">Chờ xử lý</c:when>
                                    <c:when test="${claim.claim_status == 'in_progress'}">Đang xử lý</c:when>
                                    <c:when test="${claim.claim_status == 'need_info'}">Yêu cầu bổ sung</c:when>
                                    <c:when test="${claim.claim_status == 'approved'}">Đã duyệt</c:when>
                                    <c:when test="${claim.claim_status == 'paid'}">Đã thanh toán</c:when>
                                    <c:when test="${claim.claim_status == 'rejected'}">Bị từ chối</c:when>
                                    <c:otherwise>${claim.claim_status}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="card-body p-4">
                    <div class="row g-4">
                        <!-- Basic Information -->
                        <div class="col-md-6">
                            <div class="info-section">
                                <h3 class="section-title">
                                    <i class="bi bi-info-circle me-2"></i>
                                    Thông tin cơ bản
                                </h3>
                                <div class="info-row">
                                    <label>Mã khiếu nại:</label>
                                    <span>#KN-${claim.id}</span>
                                </div>
                                <div class="info-row">
                                    <label>Hợp đồng:</label>
                                    <span>
                                        <a href="purchased-insurance" class="contract-link">
                                            #TG-${claim.contract_id}
                                        </a>
                                    </span>
                                </div>
                                <div class="info-row">
                                    <label>Ngày yêu cầu:</label>
                                    <span><fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/></span>
                                </div>
                                <div class="info-row">
                                    <label>Loại sự cố:</label>
                                    <span class="claim-type-badge claim-type-${claim.claim_type}">
                                        <c:choose>
                                            <c:when test="${claim.claim_type == 'medical'}">Y tế</c:when>
                                            <c:when test="${claim.claim_type == 'lost_baggage'}">Hành lý</c:when>
                                            <c:when test="${claim.claim_type == 'flight_delay'}">Chậm chuyến bay</c:when>
                                            <c:when test="${claim.claim_type == 'trip_cancellation'}">Hủy chuyến</c:when>
                                            <c:when test="${claim.claim_type == 'third_party'}">Tai nạn</c:when>
                                            <c:otherwise>${claim.claim_type}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Payment Information -->
                        <div class="col-md-6">
                            <div class="info-section">
                                <h3 class="section-title">
                                    <i class="bi bi-credit-card me-2"></i>
                                    Thông tin thanh toán
                                </h3>
                                <div class="info-row">
                                    <label>Ngân hàng:</label>
                                    <span>${claim.payment_bank != null ? claim.payment_bank : 'Chưa cập nhật'}</span>
                                </div>
                                <div class="info-row">
                                    <label>Số tài khoản:</label>
                                    <span>${claim.payment_number != null ? claim.payment_number : 'Chưa cập nhật'}</span>
                                </div>
                                <c:if test="${claim.claim_amount != null}">
                                    <div class="info-row">
                                        <label>Số tiền bồi thường:</label>
                                        <span class="amount text-success fw-bold">
                                            <fmt:formatNumber value="${claim.claim_amount}" type="currency" currencyCode="VND"/>
                                        </span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Description Section -->
                    <div class="description-section mt-4 pt-4 border-top">
                        <h3 class="section-title">
                            <i class="bi bi-align-left me-2"></i>
                            Mô tả chi tiết
                        </h3>
                        <div class="description-content p-3 bg-light rounded">
                            <c:choose>
                                <c:when test="${not empty claim.description}">
                                    ${claim.description}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Chưa có mô tả</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Attachments Section -->
                    <div class="attachments-section mt-4 pt-4 border-top">
                        <h3 class="section-title">
                            <i class="bi bi-paperclip me-2"></i>
                            Tài liệu đính kèm
                        </h3>
                        <div class="attachments-grid row g-3">
                            <!-- Images -->
                            <c:if test="${not empty claim.related_img}">
                                <c:set var="imageList" value="${fn:split(claim.related_img, ',')}" />
                                <c:forEach var="image" items="${imageList}">
                                    <div class="col-md-4">
                                        <div class="attachment-item border rounded p-3">
                                            <div class="attachment-header mb-2">
                                                <i class="bi bi-image me-2"></i>
                                                <span>Hình ảnh</span>
                                            </div>
                                            <div class="attachment-content">
                                                <img src="${pageContext.request.contextPath}/${image}" 
                                                     alt="Claim Image" 
                                                     class="claim-image img-fluid rounded"
                                                     onclick="openImageModal('${pageContext.request.contextPath}/${image}')">
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                            <!-- Files -->
                            <c:if test="${not empty claim.related_file}">
                                <c:set var="fileList" value="${fn:split(claim.related_file, ',')}" />
                                <c:forEach var="file" items="${fileList}">
                                    <div class="col-md-4">
                                        <div class="attachment-item border rounded p-3">
                                            <div class="attachment-header mb-2">
                                                <i class="bi bi-file-earmark-pdf me-2"></i>
                                                <span>Tài liệu</span>
                                            </div>
                                            <div class="attachment-content">
                                                <a href="${pageContext.request.contextPath}/${file}" 
                                                   class="file-download btn btn-outline-primary btn-sm" 
                                                   target="_blank">
                                                    <i class="bi bi-download me-1"></i>
                                                    Tải xuống
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                            <!-- No attachments -->
                            <c:if test="${empty claim.related_img && empty claim.related_file}">
                                <div class="col-12">
                                    <div class="no-attachments text-center py-4 text-muted">
                                        <i class="bi bi-paperclip fs-1 d-block mb-2"></i>
                                        <span>Không có tài liệu đính kèm</span>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contract Information Card -->
            <c:if test="${not empty contract}">
                <div class="contract-info-card border rounded-3 mb-4">
                    <div class="card-header bg-light p-4 border-bottom">
                        <div class="d-flex justify-content-between align-items-center">
                            <h2 class="mb-0">
                                <i class="bi bi-file-earmark-contract me-2"></i>
                                Thông tin Hợp đồng
                            </h2>
                            <a href="purchased-insurance" class="btn btn-outline-primary btn-sm">
                                Xem chi tiết hợp đồng
                            </a>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="info-row">
                                    <label>Mã hợp đồng:</label>
                                    <span>#TG-${contract.contract_id}</span>
                                </div>
                                <div class="info-row">
                                    <label>Trạng thái:</label>
                                    <span class="status-badge status-${contract.contract_status}">
                                        ${contract.contract_status}
                                    </span>
                                </div>
                            </div>
                            <c:if test="${not empty contract.startDate && not empty contract.endDate}">
                                <div class="col-md-6">
                                    <div class="info-row">
                                        <label>Ngày bắt đầu:</label>
                                        <span><fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/></span>
                                    </div>
                                    <div class="info-row">
                                        <label>Ngày kết thúc:</label>
                                        <span><fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/></span>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Claim Responses Section - Chat Style (Read-only) -->
            <div class="claim-responses-card border rounded-3">
                <div class="card-header bg-light p-4 border-bottom">
                    <div class="d-flex justify-content-between align-items-center">
                        <h2 class="mb-0">
                            <i class="bi bi-chat-dots me-2"></i>
                            Phản hồi từ nhân viên
                        </h2>
                        <div class="responses-count">
                            <span class="badge bg-primary">${claimResponses.size()} phản hồi</span>
                        </div>
                    </div>
                </div>
                <div class="card-body p-4">
                    <c:choose>
                        <c:when test="${not empty claimResponses}">
                            <div class="chat-messages-container" style="max-height: 500px; overflow-y: auto;">
                                <div class="chat-messages">
                                    <c:forEach var="response" items="${claimResponses}">
                                        <div class="message-item mb-3">
                                            <div class="d-flex align-items-start">
                                                <div class="message-avatar me-3">
                                                    <i class="bi bi-person-circle fs-3 text-primary"></i>
                                                </div>
                                                <div class="message-content flex-grow-1">
                                                    <div class="message-header mb-2">
                                                        <span class="message-sender fw-bold me-2">
                                                            <c:choose>
                                                                <c:when test="${not empty response.user_fullname}">
                                                                    ${response.user_fullname}
                                                                </c:when>
                                                                <c:when test="${not empty response.user_name}">
                                                                    ${response.user_name}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Nhân viên
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                        <span class="message-date text-muted small">
                                                            <fmt:formatDate value="${response.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </span>
                                                    </div>
                                                    <div class="message-bubble p-3 bg-light rounded">
                                                        <c:choose>
                                                            <c:when test="${not empty response.description}">
                                                                ${response.description}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Không có nội dung</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    
                                                    <!-- Message Attachments -->
                                                    <c:if test="${not empty response.related_img || not empty response.related_file}">
                                                        <div class="message-attachments mt-2">
                                                            <c:if test="${not empty response.related_img}">
                                                                <div class="attachment-preview mb-2">
                                                                    <img src="${pageContext.request.contextPath}/${response.related_img}" 
                                                                         alt="Attachment" 
                                                                         class="attachment-image img-thumbnail"
                                                                         style="max-width: 200px; cursor: pointer;"
                                                                         onclick="openImageModal('${pageContext.request.contextPath}/${response.related_img}')">
                                                                </div>
                                                            </c:if>
                                                            
                                                            <c:if test="${not empty response.related_file}">
                                                                <div class="attachment-file">
                                                                    <a href="${pageContext.request.contextPath}/${response.related_file}" 
                                                                       class="file-link btn btn-sm btn-outline-secondary" 
                                                                       target="_blank">
                                                                        <i class="bi bi-download me-1"></i>
                                                                        ${response.related_file}
                                                                    </a>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="chat-empty text-center py-5">
                                <i class="bi bi-chat-dots fs-1 text-muted d-block mb-3"></i>
                                <h5 class="text-muted">Chưa có phản hồi nào</h5>
                                <p class="text-muted">Nhân viên chưa phản hồi về khiếu nại này.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </main>

    <!-- Footer -->
    <jsp:include page="./component/footer.jsp"></jsp:include>

    <!-- Image Modal -->
    <div id="imageModal" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xem hình ảnh</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="" alt="Claim Image" class="img-fluid">
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        // Auto scroll to bottom (newest messages) when page loads
        document.addEventListener("DOMContentLoaded", function() {
            const chatMessagesContainer = document.querySelector('.chat-messages-container');
            if (chatMessagesContainer) {
                chatMessagesContainer.scrollTop = chatMessagesContainer.scrollHeight;
            }
        });

        // Image modal functionality
        function openImageModal(imageSrc) {
            const modal = new bootstrap.Modal(document.getElementById('imageModal'));
            document.getElementById('modalImage').src = imageSrc;
            modal.show();
        }
    </script>
</body>
</html>

