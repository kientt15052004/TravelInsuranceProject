<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Bồi thường - Hệ thống quản lý bảo hiểm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/claimdetail.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="header-left">
            <div class="logo">
                <div class="logo-text">
                    <span class="logo-main">Logo</span>
                </div>
            </div>
        </div>
        <div class="header-right">
            <div class="user-dropdown">
                <div class="user-info">
                    <i class="fas fa-user-circle"></i>
                    <span>Staff</span>
                </div>
                <i class="fas fa-chevron-down dropdown-arrow"></i>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                        <i class="fas fa-sign-out-alt"></i>
                        Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Sidebar -->
        <jsp:include page="component/staff-sidebar.jsp">
            <jsp:param name="activePage" value="claims-management"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <div class="header-left">
                    <h1>Chi tiết Bồi thường</h1>
                    <p>Thông tin chi tiết về yêu cầu bồi thường</p>
                </div>
                <div class="header-right">
                    <a href="${pageContext.request.contextPath}/ClaimsManagementServlet" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại danh sách
                    </a>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${success}
                </div>
            </c:if>

            <c:if test="${not empty claim}">
                <!-- Claim Information Card -->
                <div class="claim-detail-card">
                    <div class="card-header">
                        <h2>
                            Thông tin Bồi thường #${claim.id}
                        </h2>
                        <div class="header-actions">
                            <div class="status-container">
                                <span class="status-badge status-${claim.claim_status.toLowerCase()}" id="currentStatusDisplay">
                                    ${claim.claim_status}
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <div class="info-grid">
                            <!-- Basic Information -->
                            <div class="info-section">
                                <h3>
                                    <i class="fas fa-info-circle"></i>
                                    Thông tin cơ bản
                                </h3>
                                <div class="info-row">
                                    <label>ID Bồi thường:</label>
                                    <span>#${claim.id}</span>
                                </div>
                                <div class="info-row">
                                    <label>Contract ID:</label>
                                    <span>
                                        <a href="${pageContext.request.contextPath}/ContractDetailServlet?id=${claim.contract_id}" 
                                           class="contract-link">
                                            #${claim.contract_id}
                                        </a>
                                    </span>
                                </div>
                                <div class="info-row">
                                    <label>Ngày yêu cầu:</label>
                                    <span><fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/></span>
                                </div>
                                <div class="info-row">
                                    <label>Loại bồi thường:</label>
                                    <span class="claim-type">${claim.claim_type}</span>
                                </div>
                                <div class="info-row">
                                    <label>Trạng thái:</label>
                                    <span class="status-badge status-${claim.claim_status.toLowerCase()}">
                                        ${claim.claim_status}
                                    </span>
                                </div>
                            </div>

                            <!-- Payment Information -->
                            <div class="info-section">
                                <h3>
                                    <i class="fas fa-credit-card"></i>
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
                                        <span class="amount">
                                            <fmt:formatNumber value="${claim.claim_amount}" type="currency" currencyCode="VND"/>
                                        </span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Description Section -->
                        <div class="description-section">
                            <h3>
                                <i class="fas fa-align-left"></i>
                                Mô tả chi tiết
                            </h3>
                            <div class="description-content">
                                <c:choose>
                                    <c:when test="${not empty claim.description}">
                                        ${claim.description}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="no-data">Chưa có mô tả</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Attachments Section -->
                        <div class="attachments-section">
                            <h3>
                                <i class="fas fa-paperclip"></i>
                                Tài liệu đính kèm
                            </h3>
                            <div class="attachments-grid">
                                <!-- Images -->
                                <c:if test="${not empty claim.related_img}">
                                    <div class="attachment-item">
                                        <div class="attachment-header">
                                            <i class="fas fa-image"></i>
                                            <span>Hình ảnh</span>
                                        </div>
                                        <div class="attachment-content">
                                            <img src="${claim.related_img}" 
                                                 alt="Claim Image" 
                                                 class="claim-image"
                                                 onclick="openImageModal(this.src)">
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Files -->
                                <c:if test="${not empty claim.related_file}">
                                    <div class="attachment-item">
                                        <div class="attachment-header">
                                            <i class="fas fa-file"></i>
                                            <span>Tài liệu</span>
                                        </div>
                                        <div class="attachment-content">
                                            <a href="${pageContext.request.contextPath}/Image/${claim.related_file}" 
                                               class="file-download" 
                                               target="_blank">
                                                <i class="fas fa-download"></i>
                                                Tải xuống
                                            </a>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- No attachments -->
                                <c:if test="${empty claim.related_img && empty claim.related_file}">
                                    <div class="no-attachments">
                                        <i class="fas fa-paperclip"></i>
                                        <span>Không có tài liệu đính kèm</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Contract Information Card -->
                <c:if test="${not empty contract}">
                    <div class="contract-info-card">
                        <div class="card-header">
                            <h2>
                                <i class="fas fa-file-contract"></i>
                                Thông tin Contract liên quan
                            </h2>
                            <a href="${pageContext.request.contextPath}/ContractDetailServlet?id=${contract.contract_id}" 
                               class="btn btn-primary">
                                Xem chi tiết Contract
                            </a>
                        </div>
                        <div class="card-body">
                            <div class="info-grid">
                                <div class="info-section">
                                    <div class="info-row">
                                        <label>Contract ID:</label>
                                        <span>#${contract.contract_id}</span>
                                    </div>
                                    <div class="info-row">
                                        <label>Ngày bắt đầu:</label>
                                        <span><fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/></span>
                                    </div>
                                    <div class="info-row">
                                        <label>Ngày kết thúc:</label>
                                        <span><fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/></span>
                                    </div>
                                </div>
                                <div class="info-section">
                                    <div class="info-row">
                                        <label>Trạng thái Contract:</label>
                                        <span class="status-badge status-${contract.contract_status.toLowerCase()}">
                                            ${contract.contract_status}
                                        </span>
                                    </div>
                                    <div class="info-row">
                                        <label>Premium:</label>
                                        <span><fmt:formatNumber value="${contract.totalPrice}" type="currency" currencyCode="VND"/></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Claim Responses Section - Chat Style -->
                <div class="claim-responses-card">
                    <div class="card-header">
                        <h2>
                            <i class="fas fa-comments"></i>
                            Phản hồi và Theo dõi
                        </h2>
                        <div class="responses-count">
                            <span class="count-badge">${claimResponses.size()} phản hồi</span>
                        </div>
                    </div>
                    <div class="card-body chat-container">
                        <c:choose>
                            <c:when test="${not empty claimResponses}">
                                <div class="chat-messages-container">
                                    <div class="chat-messages">
                                    <c:forEach var="response" items="${claimResponses}">
                                        <div class="message-item">
                                            <div class="message-avatar">
                                                <i class="fas fa-user-circle"></i>
                                            </div>
                                            <div class="message-content">
                                                <div class="message-header">
                                                    <c:choose>
                                                        <c:when test="${not empty response.user_fullname}">
                                                            <span class="message-sender">${response.user_fullname}</span>
                                                        </c:when>
                                                        <c:when test="${not empty response.user_name}">
                                                            <span class="message-sender">${response.user_name}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="message-sender">Null</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="message-date">
                                                        <fmt:formatDate value="${response.createDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </span>
                                                </div>
                                                <div class="message-bubble">
                                                    <c:choose>
                                                        <c:when test="${not empty response.description}">
                                                            ${response.description}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="no-data">Không có nội dung</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <!-- Message Attachments -->
                                                <c:if test="${not empty response.related_img || not empty response.related_file}">
                                                    <div class="message-attachments">
                                                        <c:if test="${not empty response.related_img}">
                                                            <div class="attachment-preview">
                                                                <img src="${response.related_img}" 
                                                                     alt="Attachment" 
                                                                     class="attachment-image"
                                                                     onclick="openImageModal(this.src)">
                                                            </div>
                                                        </c:if>
                                                        
                                                        <c:if test="${not empty response.related_file}">
                                                            <div class="attachment-file">
                                                                <a href="${pageContext.request.contextPath}/Image/${response.related_file}" 
                                                                   class="file-link" 
                                                                   target="_blank">
                                                                    ${response.related_file}
                                                                </a>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <!-- Chat Input Form -->
                                <div class="chat-input-section">
                                    <form action="${pageContext.request.contextPath}/AddClaimResponseServlet" method="POST" class="chat-form">
                                        <input type="hidden" name="claimId" value="${claim.id}">
                                        <div class="chat-input-wrapper">
                                            <textarea 
                                                name="description" 
                                                id="chatMessageInput" 
                                                class="chat-input"
                                                placeholder="Nhập phản hồi của bạn..."
                                                rows="3"
                                                required></textarea>
                                            <div class="chat-actions">
                                                <input type="hidden" name="action" value="reply" id="actionType">
                                                <button type="submit" name="submitType" value="reply" class="btn-send">
                                                    <i class="fas fa-paper-plane"></i>
                                                    Gửi phản hồi
                                                </button>
                                                <button type="submit" name="submitType" value="approve" class="btn-approve" onclick="setAction('approve')">
                                                    <i class="fas fa-check-circle"></i>
                                                    Chấp nhận Claim
                                                </button>
                                                <button type="submit" name="submitType" value="reject" class="btn-reject" onclick="setAction('reject')">
                                                    <i class="fas fa-times-circle"></i>
                                                    Từ chối Claim
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="chat-empty">
                                    <div class="empty-icon">
                                        <i class="fas fa-comments"></i>
                                    </div>
                                    <h3>Chưa có phản hồi nào</h3>
                                    <p>Claim này chưa có phản hồi hoặc theo dõi nào từ phía nhân viên.</p>
                                    
                                    <!-- Chat Input Form for empty state -->
                                    <div class="chat-input-section-empty">
                                        <form action="${pageContext.request.contextPath}/AddClaimResponseServlet" method="POST" class="chat-form">
                                            <input type="hidden" name="claimId" value="${claim.id}">
                                            <div class="chat-input-wrapper">
                                                <textarea 
                                                    name="description" 
                                                    id="chatMessageInputEmpty" 
                                                    class="chat-input"
                                                    placeholder="Nhập phản hồi đầu tiên..."
                                                    rows="3"
                                                    required></textarea>
                                                <div class="chat-actions">
                                                    <input type="hidden" name="action" value="reply" id="actionTypeEmpty">
                                                    <button type="submit" name="submitType" value="reply" class="btn-send">
                                                        <i class="fas fa-paper-plane"></i>
                                                        Gửi phản hồi
                                                    </button>
                                                    <button type="submit" name="submitType" value="approve" class="btn-approve" onclick="setActionEmpty('approve')">
                                                        <i class="fas fa-check-circle"></i>
                                                        Chấp nhận Claim
                                                    </button>
                                                    <button type="submit" name="submitType" value="reject" class="btn-reject" onclick="setActionEmpty('reject')">
                                                        <i class="fas fa-times-circle"></i>
                                                        Từ chối Claim
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Image Modal -->
    <div id="imageModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <img id="modalImage" src="" alt="Claim Image">
        </div>
    </div>

    <!-- Approval Modal -->
    <div id="approvalModal" class="modal">
        <div class="modal-content approval-modal">
            <div class="modal-header">
                <h3 id="modalTitle">Xác nhận hành động</h3>
                <span class="close" onclick="closeApprovalModal()">&times;</span>
            </div>
            <div class="modal-body">
                <p id="modalMessage">Bạn có chắc chắn muốn thực hiện hành động này?</p>
                <div id="reasonSection" style="display: none;">
                    <label for="rejectReason">Lý do từ chối:</label>
                    <textarea id="rejectReason" name="reason" rows="4" placeholder="Nhập lý do từ chối..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeApprovalModal()">
                    <i class="fas fa-times"></i>
                    Hủy
                </button>
                <button type="button" class="btn" id="confirmBtn" onclick="submitApproval()">
                    <i class="fas fa-check"></i>
                    Xác nhận
                </button>
            </div>
        </div>
    </div>

    <!-- Status Update Modal -->
    <div id="statusUpdateModal" class="modal">
        <div class="modal-content status-update-modal">
            <div class="modal-header">
                <h3>Cập nhật trạng thái Claim</h3>
                <span class="close" onclick="closeStatusUpdateModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="currentStatus">Trạng thái hiện tại:</label>
                    <div class="current-status-display">
                        <span class="status-badge status-${claim.claim_status.toLowerCase()}">
                            ${claim.claim_status}
                        </span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="newStatus">Trạng thái mới:</label>
                    <select id="newStatus" name="newStatus" class="form-select">
                        <option value="">-- Chọn trạng thái mới --</option>
                        <option value="pending" ${claim.claim_status.toLowerCase() == 'pending' ? 'disabled' : ''}>
                            Pending - Chờ xử lý
                        </option>
                        <option value="approved" ${claim.claim_status.toLowerCase() == 'approved' ? 'disabled' : ''}>
                            Approved - Đã duyệt
                        </option>
                        <option value="rejected" ${claim.claim_status.toLowerCase() == 'rejected' ? 'disabled' : ''}>
                            Rejected - Từ chối
                        </option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="statusReason">Lý do thay đổi:</label>
                    <textarea id="statusReason" name="reason" rows="4" 
                              placeholder="Nhập lý do thay đổi trạng thái (tùy chọn)..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeStatusUpdateModal()">
                    <i class="fas fa-times"></i>
                    Hủy
                </button>
                <button type="button" class="btn btn-primary" onclick="submitStatusUpdate()">
                    <i class="fas fa-save"></i>
                    Cập nhật
                </button>
            </div>
        </div>
    </div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    // User dropdown functionality
    const userDropdown = document.querySelector('.user-dropdown');
    if (userDropdown) {
        userDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdown.classList.toggle('active');
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!userDropdown.contains(e.target)) {
                userDropdown.classList.remove('active');
            }
        });
    }
});

// Image modal functionality
function openImageModal(imageSrc) {
    const modal = document.getElementById('imageModal');
    const modalImg = document.getElementById('modalImage');
    modal.style.display = 'block';
    modalImg.src = imageSrc;
}

// Close modal when clicking X
document.querySelector('.close').addEventListener('click', function() {
    document.getElementById('imageModal').style.display = 'none';
});

// Close modal when clicking outside
window.addEventListener('click', function(event) {
    const modal = document.getElementById('imageModal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
});

// Approval Modal functionality
let currentAction = '';

function showApprovalModal(action) {
    currentAction = action;
    const modal = document.getElementById('approvalModal');
    const title = document.getElementById('modalTitle');
    const message = document.getElementById('modalMessage');
    const reasonSection = document.getElementById('reasonSection');
    const confirmBtn = document.getElementById('confirmBtn');
    
    if (action === 'approve') {
        title.textContent = 'Chấp nhận Claim';
        message.textContent = 'Bạn có chắc chắn muốn chấp nhận claim này?';
        reasonSection.style.display = 'none';
        confirmBtn.className = 'btn btn-approve';
        confirmBtn.innerHTML = '<i class="fas fa-check"></i> Chấp nhận';
    } else if (action === 'reject') {
        title.textContent = 'Từ chối Claim';
        message.textContent = 'Bạn có chắc chắn muốn từ chối claim này?';
        reasonSection.style.display = 'block';
        confirmBtn.className = 'btn btn-reject';
        confirmBtn.innerHTML = '<i class="fas fa-times"></i> Từ chối';
    }
    
    modal.style.display = 'block';
}

function closeApprovalModal() {
    document.getElementById('approvalModal').style.display = 'none';
    document.getElementById('rejectReason').value = '';
}

function submitApproval() {
    const reason = document.getElementById('rejectReason').value;
    
    // Validate reason for rejection
    if (currentAction === 'reject' && (!reason || reason.trim() === '')) {
        alert('Vui lòng nhập lý do từ chối');
        return;
    }
    
    // Create form and submit
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/ClaimApprovalServlet';
    
    const claimIdInput = document.createElement('input');
    claimIdInput.type = 'hidden';
    claimIdInput.name = 'claimId';
    claimIdInput.value = '${claim.id}';
    
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = currentAction;
    
    const reasonInput = document.createElement('input');
    reasonInput.type = 'hidden';
    reasonInput.name = 'reason';
    reasonInput.value = reason;
    
    form.appendChild(claimIdInput);
    form.appendChild(actionInput);
    form.appendChild(reasonInput);
    
    document.body.appendChild(form);
    form.submit();
}

// Close approval modal when clicking outside
window.addEventListener('click', function(event) {
    const approvalModal = document.getElementById('approvalModal');
    if (event.target === approvalModal) {
        closeApprovalModal();
    }
});

// Status Update Modal functionality
function showStatusUpdateModal() {
    const modal = document.getElementById('statusUpdateModal');
    modal.style.display = 'block';
    
    // Reset form
    document.getElementById('newStatus').value = '';
    document.getElementById('statusReason').value = '';
}

function closeStatusUpdateModal() {
    document.getElementById('statusUpdateModal').style.display = 'none';
    document.getElementById('newStatus').value = '';
    document.getElementById('statusReason').value = '';
}

function submitStatusUpdate() {
    const newStatus = document.getElementById('newStatus').value;
    const reason = document.getElementById('statusReason').value;
    
    // Validate new status
    if (!newStatus || newStatus.trim() === '') {
        alert('Vui lòng chọn trạng thái mới');
        return;
    }
    
    // Create form and submit
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/ClaimStatusUpdateServlet';
    
    const claimIdInput = document.createElement('input');
    claimIdInput.type = 'hidden';
    claimIdInput.name = 'claimId';
    claimIdInput.value = '${claim.id}';
    
    const newStatusInput = document.createElement('input');
    newStatusInput.type = 'hidden';
    newStatusInput.name = 'newStatus';
    newStatusInput.value = newStatus;
    
    const reasonInput = document.createElement('input');
    reasonInput.type = 'hidden';
    reasonInput.name = 'reason';
    reasonInput.value = reason;
    
    form.appendChild(claimIdInput);
    form.appendChild(newStatusInput);
    form.appendChild(reasonInput);
    
    document.body.appendChild(form);
    form.submit();
}

// Close status update modal when clicking outside
window.addEventListener('click', function(event) {
    const statusUpdateModal = document.getElementById('statusUpdateModal');
    if (event.target === statusUpdateModal) {
        closeStatusUpdateModal();
    }
});

// Function to set action type for approve/reject buttons
function setAction(action) {
    document.getElementById('actionType').value = action;
}

function setActionEmpty(action) {
    document.getElementById('actionTypeEmpty').value = action;
}
</script>

</body>
</html>
