<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="Model.User"%>
<%
    User currentUser = (User) session.getAttribute("user");
    boolean isAdmin = currentUser != null && "admin".equalsIgnoreCase(currentUser.getRole());
    boolean isStaff = currentUser != null && "staff".equalsIgnoreCase(currentUser.getRole());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Bồi thường - Hệ thống quản lý bảo hiểm</title>
    <c:choose>
        <c:when test="<%= isAdmin %>">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/admin-dashboard.css">
        </c:when>
        <c:otherwise>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/staff.css">
        </c:otherwise>
    </c:choose>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/claimdetail.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <c:choose>
        <c:when test="<%= isAdmin %>">
            <jsp:include page="component/admin-header.jsp"/>
        </c:when>
        <c:otherwise>
            <jsp:include page="component/staff-header.jsp"/>
        </c:otherwise>
    </c:choose>

    <div class="container">
        <c:choose>
            <c:when test="<%= isAdmin %>">
                <jsp:include page="component/admin-sidebar.jsp">
                    <jsp:param name="activePage" value="dashboard"/>
                </jsp:include>
            </c:when>
            <c:otherwise>
                <jsp:include page="component/staff-sidebar.jsp">
                    <jsp:param name="activePage" value="claims-management"/>
                </jsp:include>
            </c:otherwise>
        </c:choose>

        <div class="main-content">
            <div class="content-header">
                <div class="header-left">
                    <h1>Chi tiết Bồi thường</h1>
                    <p>Thông tin chi tiết về yêu cầu bồi thường</p>
                </div>
                <div class="header-right">
                    <c:choose>
                        <c:when test="<%= isAdmin %>">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Quay lại Dashboard
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/ClaimsManagementServlet" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i>
                                Quay lại danh sách
                            </a>
                        </c:otherwise>
                    </c:choose>
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
                <div class="claim-detail-card">
                    <div class="card-header">
                        <h2>
                            Thông tin Bồi thường #${claim.id}
                        </h2>
                        <div class="header-actions">
                            <div class="status-container">
                                <span class="status-badge status-${claim.claim_status.toLowerCase()}" id="currentStatusDisplay">
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
                    
                    <div class="card-body">
                        <div class="info-grid">
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
                                        <label>Số tiền yêu cầu:</label>
                                        <span class="amount">
                                            <fmt:formatNumber value="${claim.claim_amount}" type="currency" currencyCode="VND"/>
                                        </span>
                                    </div>
                                </c:if>
                                <c:if test="${claim.claim_status == 'approved'}">
                                    <div class="info-row">
                                        <label>Số tiền đền bù:</label>
                                        <span class="amount">
                                            <c:choose>
                                                <c:when test="${claim.compensation_amount != null}">
                                                    <fmt:formatNumber value="${claim.compensation_amount}" type="currency" currencyCode="VND"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #999;">Chưa cập nhật</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

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

                        <div class="attachments-section">
                            <h3>
                                <i class="fas fa-paperclip"></i>
                                Tài liệu đính kèm
                            </h3>
                            <div class="attachments-grid">
                                <c:if test="${not empty claim.related_img}">
                                    <div class="attachment-item">
                                        <div class="attachment-header">
                                            <i class="fas fa-image"></i>
                                            <span>Hình ảnh</span>
                                        </div>
                                        <div class="attachment-content">
                                            <c:choose>
                                                <c:when test="${claim.related_img.startsWith('http://') || claim.related_img.startsWith('https://')}">
                                                    <img src="${claim.related_img}" 
                                                         alt="Claim Image" 
                                                         class="claim-image"
                                                         onclick="openImageModal(this.src)">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/Image/${claim.related_img}" 
                                                         alt="Claim Image" 
                                                         class="claim-image"
                                                         onclick="openImageModal(this.src)">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:if>

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

                <c:if test="${not empty contract}">
                    <div class="contract-info-card">
                        <div class="card-header">
                            <h2>
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

                <div class="claim-responses-card">
                    <div class="card-header">
                        <h2>
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
                                                
                                                <c:if test="${not empty response.related_img || not empty response.related_file}">
                                                    <div class="message-attachments">
                                                        <c:if test="${not empty response.related_img}">
                                                            <div class="attachment-preview">
                                                                <c:choose>
                                                                    <c:when test="${response.related_img.startsWith('http://') || response.related_img.startsWith('https://')}">
                                                                        <img src="${response.related_img}" 
                                                                             alt="Attachment" 
                                                                             class="attachment-image"
                                                                             onclick="openImageModal(this.src)">
                                                                    </c:when>
                                                                    <c:when test="${response.related_img.startsWith('Image/')}">
                                                                        <img src="${pageContext.request.contextPath}/${response.related_img}" 
                                                                             alt="Attachment" 
                                                                             class="attachment-image"
                                                                             onclick="openImageModal(this.src)">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}/Image/${response.related_img}" 
                                                                             alt="Attachment" 
                                                                             class="attachment-image"
                                                                             onclick="openImageModal(this.src)">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <c:if test="${not empty response.related_file}">
                                                            <div class="attachment-file">
                                                                <c:choose>
                                                                    <c:when test="${response.related_file.startsWith('http://') || response.related_file.startsWith('https://')}">
                                                                        <a href="${response.related_file}" 
                                                                           class="file-link" 
                                                                           target="_blank">
                                                                            ${response.related_file}
                                                                        </a>
                                                                    </c:when>
                                                                    <c:when test="${response.related_file.startsWith('Image/')}">
                                                                        <a href="${pageContext.request.contextPath}/${response.related_file}" 
                                                                           class="file-link" 
                                                                           target="_blank">
                                                                            ${response.related_file}
                                                                        </a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="${pageContext.request.contextPath}/Image/${response.related_file}" 
                                                                           class="file-link" 
                                                                           target="_blank">
                                                                            ${response.related_file}
                                                                        </a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <c:if test="${claim.claim_status == 'approved'}">
                                    <div class="compensation-update-section" style="margin-bottom: 20px; padding: 15px; background: #f8f9fa;">
                                        <h4 style="margin-bottom: 10px;">
                                            <i class="fas fa-money-bill-wave"></i>
                                            Cập nhật số tiền đền bù
                                        </h4>
                                        <form action="${pageContext.request.contextPath}/AddClaimResponseServlet" method="POST" style="display: flex; gap: 10px; align-items: flex-end;">
                                            <input type="hidden" name="claimId" value="${claim.id}">
                                            <div style="flex: 1;">
                                                <label for="compensationAmountUpdate" style="display: block; margin-bottom: 5px; font-weight: 500;">Số tiền đền bù (VNĐ):</label>
                                                <input 
                                                    type="number" 
                                                    id="compensationAmountUpdate"
                                                    name="compensationAmount" 
                                                    step="0.01" 
                                                    min="0"
                                                    value="${claim.compensation_amount != null ? claim.compensation_amount : ''}"
                                                    placeholder="Nhập số tiền đền bù"
                                                    style="width: 100%; padding: 8px; border: 1px solid #ddd;">
                                            </div>
                                            <button type="submit" class="btn-approve" style="padding: 8px 20px;">
                                                <i class="fas fa-save"></i>
                                                Cập nhật
                                            </button>
                                        </form>
                                    </div>
                                </c:if>
                                
                                <div class="chat-input-section">
                                    <form action="${pageContext.request.contextPath}/AddClaimResponseServlet" method="POST" enctype="multipart/form-data" class="chat-form">
                                        <input type="hidden" name="claimId" value="${claim.id}">
                                        <div class="chat-input-wrapper">
                                            <textarea 
                                                name="description" 
                                                id="chatMessageInput" 
                                                class="chat-input"
                                                placeholder="Nhập phản hồi của bạn..."
                                                rows="3"
                                                required></textarea>
                                            
                                            <div style="margin-bottom: 10px; display: flex; gap: 10px; flex-wrap: wrap;">
                                                <div style="flex: 1; min-width: 200px;">
                                                    <label for="related_img" style="display: block; margin-bottom: 5px; font-weight: 500; font-size: 0.9em;">
                                                        <i class="fas fa-image"></i> Ảnh đính kèm (tùy chọn):
                                                    </label>
                                                    <input 
                                                        type="file" 
                                                        id="related_img"
                                                        name="related_img" 
                                                        accept="image/*"
                                                        style="width: 100%; padding: 6px; border: 1px solid #ddd; font-size: 0.9em;">
                                                </div>
                                                <div style="flex: 1; min-width: 200px;">
                                                    <label for="related_file" style="display: block; margin-bottom: 5px; font-weight: 500; font-size: 0.9em;">
                                                        <i class="fas fa-file"></i> File đính kèm (tùy chọn):
                                                    </label>
                                                    <input 
                                                        type="file" 
                                                        id="related_file"
                                                        name="related_file" 
                                                        style="width: 100%; padding: 6px; border: 1px solid #ddd; font-size: 0.9em;">
                                                </div>
                                            </div>
                                            
                                            <c:if test="${claim.claim_status == 'pending'}">
                                                <div style="margin-bottom: 10px;">
                                                    <label for="compensationAmount" style="display: block; margin-bottom: 5px; font-weight: 500;">
                                                        <i class="fas fa-money-bill-wave"></i>
                                                        Số tiền đền bù (VNĐ) - Tùy chọn:
                                                    </label>
                                                    <input 
                                                        type="number" 
                                                        id="compensationAmount"
                                                        name="compensationAmount" 
                                                        step="0.01" 
                                                        min="0"
                                                        placeholder="Nhập số tiền đền bù (có thể để trống)"
                                                        style="width: 100%; padding: 8px; border: 1px solid #ddd;">
                                                </div>
                                            </c:if>
                                            <div class="chat-actions">
                                                <input type="hidden" name="action" value="reply" id="actionType">
                                                <button type="submit" name="submitType" value="reply" class="btn-send">
                                                    <i class="fas fa-paper-plane"></i>
                                                    Gửi phản hồi
                                                </button>
                                                <c:if test="${claim.claim_status == 'pending'}">
                                                    <button type="submit" name="submitType" value="approve" class="btn-approve" onclick="setAction('approve')">
                                                        <i class="fas fa-check-circle"></i>
                                                        Chấp nhận Claim
                                                    </button>
                                                    <button type="submit" name="submitType" value="reject" class="btn-reject" onclick="setAction('reject')">
                                                        <i class="fas fa-times-circle"></i>
                                                        Từ chối Claim
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="chat-empty">
                                    <h3>Chưa có phản hồi nào</h3>
                                    <p>Claim này chưa có phản hồi hoặc theo dõi nào từ phía nhân viên.</p>
                                    
                                    <c:if test="${claim.claim_status == 'approved'}">
                                        <div class="compensation-update-section" style="margin-bottom: 20px; padding: 15px; background: #f8f9fa;">
                                            <h4 style="margin-bottom: 10px;">
                                                <i class="fas fa-money-bill-wave"></i>
                                                Cập nhật số tiền đền bù
                                            </h4>
                                            <form action="${pageContext.request.contextPath}/AddClaimResponseServlet" method="POST" style="display: flex; gap: 10px; align-items: flex-end;">
                                                <input type="hidden" name="claimId" value="${claim.id}">
                                                <div style="flex: 1;">
                                                    <label for="compensationAmountUpdateEmpty" style="display: block; margin-bottom: 5px; font-weight: 500;">Số tiền đền bù (VNĐ):</label>
                                                    <input 
                                                        type="number" 
                                                        id="compensationAmountUpdateEmpty"
                                                        name="compensationAmount" 
                                                        step="0.01" 
                                                        min="0"
                                                        value="${claim.compensation_amount != null ? claim.compensation_amount : ''}"
                                                        placeholder="Nhập số tiền đền bù"
                                                        style="width: 100%; padding: 8px; border: 1px solid #ddd;">
                                                </div>
                                                <button type="submit" class="btn-approve" style="padding: 8px 20px;">
                                                    <i class="fas fa-save"></i>
                                                    Cập nhật
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                    
                                    <div class="chat-input-section-empty">
                                        <form action="${pageContext.request.contextPath}/AddClaimResponseServlet" method="POST" enctype="multipart/form-data" class="chat-form">
                                            <input type="hidden" name="claimId" value="${claim.id}">
                                            <div class="chat-input-wrapper">
                                                <textarea 
                                                    name="description" 
                                                    id="chatMessageInputEmpty" 
                                                    class="chat-input"
                                                    placeholder="Nhập phản hồi đầu tiên..."
                                                    rows="3"
                                                    required></textarea>
                                                
                                                <div style="margin-bottom: 10px; display: flex; gap: 10px; flex-wrap: wrap;">
                                                    <div style="flex: 1; min-width: 200px;">
                                                        <label for="related_img_empty" style="display: block; margin-bottom: 5px; font-weight: 500; font-size: 0.9em;">
                                                            <i class="fas fa-image"></i> Ảnh đính kèm (tùy chọn):
                                                        </label>
                                                        <input 
                                                            type="file" 
                                                            id="related_img_empty"
                                                            name="related_img" 
                                                            accept="image/*"
                                                            style="width: 100%; padding: 6px; border: 1px solid #ddd; font-size: 0.9em;">
                                                    </div>
                                                    <div style="flex: 1; min-width: 200px;">
                                                        <label for="related_file_empty" style="display: block; margin-bottom: 5px; font-weight: 500; font-size: 0.9em;">
                                                            <i class="fas fa-file"></i> File đính kèm (tùy chọn):
                                                        </label>
                                                        <input 
                                                            type="file" 
                                                            id="related_file_empty"
                                                            name="related_file" 
                                                            style="width: 100%; padding: 6px; border: 1px solid #ddd; font-size: 0.9em;">
                                                    </div>
                                                </div>
                                                <c:if test="${claim.claim_status == 'pending'}">
                                                    <div style="margin-bottom: 10px;">
                                                        <label for="compensationAmountEmpty" style="display: block; margin-bottom: 5px; font-weight: 500;">
                                                            <i class="fas fa-money-bill-wave"></i>
                                                            Số tiền đền bù (VNĐ) - Tùy chọn:
                                                        </label>
                                                        <input 
                                                            type="number" 
                                                            id="compensationAmountEmpty"
                                                            name="compensationAmount" 
                                                            step="0.01" 
                                                            min="0"
                                                            placeholder="Nhập số tiền đền bù (có thể để trống)"
                                                            style="width: 100%; padding: 8px; border: 1px solid #ddd;">
                                                    </div>
                                                </c:if>
                                                <div class="chat-actions">
                                                    <input type="hidden" name="action" value="reply" id="actionTypeEmpty">
                                                    <button type="submit" name="submitType" value="reply" class="btn-send">
                                                        <i class="fas fa-paper-plane"></i>
                                                        Gửi phản hồi
                                                    </button>
                                                    <c:if test="${claim.claim_status == 'pending'}">
                                                        <button type="submit" name="submitType" value="approve" class="btn-approve" onclick="setActionEmpty('approve')">
                                                            <i class="fas fa-check-circle"></i>
                                                            Chấp nhận Claim
                                                        </button>
                                                        <button type="submit" name="submitType" value="reject" class="btn-reject" onclick="setActionEmpty('reject')">
                                                            <i class="fas fa-times-circle"></i>
                                                            Từ chối Claim
                                                        </button>
                                                    </c:if>
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

    <div id="imageModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <img id="modalImage" src="" alt="Claim Image">
        </div>
    </div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const userDropdown = document.querySelector('.user-dropdown');
    if (userDropdown) {
        userDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdown.classList.toggle('active');
        });
        
        document.addEventListener('click', function(e) {
            if (!userDropdown.contains(e.target)) {
                userDropdown.classList.remove('active');
            }
        });
    }
    
    const chatMessagesContainer = document.querySelector('.chat-messages-container');
    if (chatMessagesContainer) {
        const urlParams = new URLSearchParams(window.location.search);
        const scrollToBottom = urlParams.get('scrollToBottom');
        
        function scrollToBottomFunc() {
            chatMessagesContainer.scrollTop = chatMessagesContainer.scrollHeight;
        }
        
        setTimeout(scrollToBottomFunc, 100);
        setTimeout(scrollToBottomFunc, 300);
        
        if (scrollToBottom === 'true') {
            setTimeout(scrollToBottomFunc, 500);
            setTimeout(scrollToBottomFunc, 800);
            
            if (window.history.replaceState) {
                const newUrl = window.location.pathname + '?id=' + urlParams.get('id');
                window.history.replaceState({}, '', newUrl);
            }
        }
    }
});

function openImageModal(imageSrc) {
    const modal = document.getElementById('imageModal');
    const modalImg = document.getElementById('modalImage');
    modal.style.display = 'block';
    modalImg.src = imageSrc;
}

document.querySelector('.close').addEventListener('click', function() {
    document.getElementById('imageModal').style.display = 'none';
});

window.addEventListener('click', function(event) {
    const modal = document.getElementById('imageModal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
});


function setAction(action) {
    document.getElementById('actionType').value = action;
}

function setActionEmpty(action) {
    document.getElementById('actionTypeEmpty').value = action;
}
</script>

</body>
</html>
