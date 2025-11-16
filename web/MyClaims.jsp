<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Khiếu Nại Của Tôi</title>
        
        <!-- CSS riêng cho trang này -->
        <link rel="stylesheet" href="./CSS/MyClaims.css"/>
    </head>
    <body>               
        <jsp:include page="./component/header.jsp"></jsp:include>
        
        <!-- CSS riêng cho trang này - load sau header để override -->
        <link rel="stylesheet" href="./CSS/MyClaims.css"/>

        <main class="container my-4 my-lg-5">
            <!-- Header với button Tạo Khiếu Nại -->
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="title mb-0">Khiếu Nại Của Tôi</h1>
                    <p class="subtitle mb-0">Quản lý các yêu cầu bồi thường bảo hiểm của bạn.</p>
                </div>
                <button class="btn btn-create-claim" data-bs-toggle="modal" data-bs-target="#createClaimModal">
                    <i class="bi bi-plus-circle me-2"></i>
                    Tạo Khiếu Nại
                </button>
            </div>

            <!-- Toolbar Search & Filter -->
            <div class="toolbar mb-4">
                <div class="row g-2 align-items-center">
                    <div class="col-12 col-lg-5">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                            <input id="q" name="q" class="form-control border-start-0" type="search"
                                   value="${searchTerm}" placeholder="Tìm kiếm theo mã khiếu nại ..." aria-label="Search">
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <select id="type" name="type" class="form-select">
                            <option value="">Tất cả loại</option>
                            <c:forEach var="claimType" items="${claimTypes}">
                                <option value="${claimType}" ${typeFilter == claimType ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${claimType == 'medical'}">Y tế cấp cứu</c:when>
                                        <c:when test="${claimType == 'lost_baggage'}">Hành lý thất lạc</c:when>
                                        <c:when test="${claimType == 'flight_delay'}">Chậm chuyến bay</c:when>
                                        <c:when test="${claimType == 'trip_cancellation'}">Hủy chuyến</c:when>
                                        <c:when test="${claimType == 'third_party'}">Tai nạn / trách nhiệm thứ ba</c:when>
                                        <c:when test="${claimType == 'theft'}">Trộm cắp</c:when>
                                        <c:when test="${claimType == 'other'}">Khác</c:when>
                                        <c:otherwise>${claimType}</c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-6 col-lg-4">
                        <select id="status" name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="approved" ${statusFilter == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                            <option value="rejected" ${statusFilter == 'rejected' ? 'selected' : ''}>Từ chối</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Claims Table -->
            <div class="table-responsive border rounded-3">
                <table class="table align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Mã KN</th>
                            <th>Hợp đồng</th>
                            <th>Loại sự cố</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty claims}">
                                <c:forEach var="claim" items="${claims}">
                                    <tr>
                                        <td data-col="Mã KN">#KN-${claim.id}</td>
                                        <td data-col="Hợp đồng">#TG-${claim.contract_id}</td>
                                        <td data-col="Loại sự cố">
                                            <span class="claim-type-badge claim-type-${claim.claim_type}">
                                                <c:choose>
                                                    <c:when test="${claim.claim_type == 'medical'}">Y tế</c:when>
                                                    <c:when test="${claim.claim_type == 'lost_baggage'}">Hành lý</c:when>
                                                    <c:when test="${claim.claim_type == 'flight_delay'}">Chậm chuyến bay</c:when>
                                                    <c:when test="${claim.claim_type == 'trip_cancellation'}">Hủy chuyến</c:when>
                                                    <c:when test="${claim.claim_type == 'third_party'}">Tai nạn</c:when>
                                                    <c:when test="${claim.claim_type == 'theft'}">Trộm cắp</c:when>
                                                    <c:when test="${claim.claim_type == 'other'}">Khác</c:when>
                                                    <c:otherwise>${claim.claim_type}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td data-col="Ngày tạo">
                                            <fmt:formatDate value="${claim.requestDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td data-col="Trạng thái">
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
                                        </td>
                                        <td class="text-end td-actions">
                                            <a href="my-claim-detail?id=${claim.id}" class="action-icon me-1" title="Xem chi tiết">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="text-center py-5">
                                        <div class="empty-state">
                                            <i class="bi bi-clipboard-x fs-1 text-muted mb-3"></i>
                                            <h5 class="text-muted">Chưa có khiếu nại nào</h5>
                                            <p class="text-muted mb-3">Bạn chưa tạo khiếu nại bồi thường nào.</p>
                                            <button class="btn btn-create-claim" data-bs-toggle="modal" data-bs-target="#createClaimModal">
                                                <i class="bi bi-plus-circle me-2"></i>
                                                Tạo Khiếu Nại Đầu Tiên
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="d-flex flex-column flex-lg-row align-items-center justify-content-between mt-3 gap-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted">
                        Hiển thị ${((currentPage - 1) * pageSize) + 1} - ${currentPage * pageSize > totalRecords ? totalRecords : currentPage * pageSize} 
                        trong tổng số ${totalRecords} khiếu nại
                    </span>
                </div>
                
                <c:if test="${totalRecords > 0}">
                    <nav aria-label="Phân trang">
                        <ul class="pagination mb-0">
                            <c:if test="${totalPages > 1}">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}&q=${searchTerm}&status=${statusFilter}&type=${typeFilter}">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
                            <c:set var="endPage" value="${currentPage + 2 <= totalPages ? currentPage + 2 : totalPages}" />
                            
                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <c:choose>
                                        <c:when test="${totalPages > 1}">
                                            <a class="page-link" href="?page=${i}&q=${searchTerm}&status=${statusFilter}&type=${typeFilter}">${i}</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="page-link">${i}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${totalPages > 1}">
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}&q=${searchTerm}&status=${statusFilter}&type=${typeFilter}">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </main>

        <!-- Modal: Tạo Khiếu Nại Mới -->
        <div class="modal fade" id="createClaimModal" tabindex="-1" aria-labelledby="createClaimModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="createClaimModalLabel">Tạo Khiếu Nại Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <form id="createClaimForm" action="create-claim" method="POST" enctype="multipart/form-data">
                        <div class="modal-body">
                            <!-- Step 1: Chọn hợp đồng -->
                            <div class="form-step mb-4">
                                <div class="step-header">
                                    <span class="step-number">1</span>
                                    <h6 class="step-title">Chọn hợp đồng</h6>
                                </div>
                                <select id="contractId" name="contractId" class="form-select" required>
                                    <option value="">-- Chọn hợp đồng --</option>
                                    <c:forEach var="contract" items="${activeContracts}">
                                        <option value="${contract.contract_id}">
                                            #TG-${contract.contract_id} - ${contract.productName} 
                                            (${contract.destination})
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${empty activeContracts}">
                                    <div class="alert alert-warning mt-2">
                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                        Bạn không có hợp đồng đang hoạt động nào để tạo khiếu nại.
                                        <a href="purchased-insurance" class="alert-link">Xem hợp đồng của bạn</a>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Step 2: Loại sự cố -->
                            <div class="form-step mb-4">
                                <div class="step-header">
                                    <span class="step-number">2</span>
                                    <h6 class="step-title">Loại sự cố</h6>
                                </div>
                                <div class="claim-types-grid">
                                    <div class="claim-type-option">
                                        <input type="radio" id="medical" name="claimType" value="medical" class="form-check-input">
                                        <label for="medical" class="claim-type-label">
                                            <i class="bi bi-heart-pulse"></i>
                                            <span>Y tế cấp cứu</span>
                                        </label>
                                    </div>
                                    <div class="claim-type-option">
                                        <input type="radio" id="lost_baggage" name="claimType" value="lost_baggage" class="form-check-input">
                                        <label for="lost_baggage" class="claim-type-label">
                                            <i class="bi bi-suitcase"></i>
                                            <span>Hành lý thất lạc</span>
                                        </label>
                                    </div>
                                    <div class="claim-type-option">
                                        <input type="radio" id="trip_cancellation" name="claimType" value="trip_cancellation" class="form-check-input">
                                        <label for="trip_cancellation" class="claim-type-label">
                                            <i class="bi bi-x-circle"></i>
                                            <span>Hủy chuyến</span>
                                        </label>
                                    </div>
                                    <div class="claim-type-option">
                                        <input type="radio" id="flight_delay" name="claimType" value="flight_delay" class="form-check-input">
                                        <label for="flight_delay" class="claim-type-label">
                                            <i class="bi bi-airplane"></i>
                                            <span>Chậm chuyến bay</span>
                                        </label>
                                    </div>
                                    <div class="claim-type-option">
                                        <input type="radio" id="third_party" name="claimType" value="third_party" class="form-check-input">
                                        <label for="third_party" class="claim-type-label">
                                            <i class="bi bi-exclamation-triangle"></i>
                                            <span>Tai nạn</span>
                                        </label>
                                    </div>
                                    <div class="claim-type-option">
                                        <input type="radio" id="other" name="claimType" value="other" class="form-check-input">
                                        <label for="other" class="claim-type-label">
                                            <i class="bi bi-three-dots"></i>
                                            <span>Khác</span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Step 3: Mô tả chi tiết -->
                            <div class="form-step mb-4">
                                <div class="step-header">
                                    <span class="step-number">3</span>
                                    <h6 class="step-title">Mô tả chi tiết</h6>
                                </div>
                                <textarea id="description" name="description" class="form-control" rows="5" 
                                          placeholder="Mô tả sự việc chi tiết, thời gian xảy ra, địa điểm và các thông tin liên quan..." 
                                          maxlength="1000" required></textarea>
                                <div class="form-text">
                                    <span class="text-muted">Tối thiểu 50 ký tự</span>
                                    <span class="char-count float-end">0/1000</span>
                                </div>
                            </div>

                            <!-- Step 4: Tài liệu chứng minh -->
                            <div class="form-step mb-4">
                                <div class="step-header">
                                    <span class="step-number">4</span>
                                    <h6 class="step-title">Tài liệu chứng minh</h6>
                                </div>
                                <div class="alert alert-info py-2 mb-3">
                                    <i class="bi bi-info-circle me-2"></i>
                                    Vui lòng tải lên các giấy tờ liên quan như hóa đơn viện phí, vé máy bay, biên bản của hãng vận chuyển, báo cáo công an hoặc các ảnh chụp hiện trường để chứng minh cho yêu cầu bồi thường.
                                </div>
                                <div class="upload-area">
                                    <div class="upload-zone" id="uploadZone">
                                        <i class="bi bi-cloud-upload fs-1 text-muted"></i>
                                        <p class="mb-2">Tải lên tài liệu, hóa đơn, ảnh chứng minh</p>
                                        <p class="text-muted small">Hỗ trợ định dạng: JPG, PNG, PDF (tối đa 10MB mỗi file)</p>
                                        <div class="upload-buttons">
                                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="document.getElementById('imageFiles').click()">
                                                <i class="bi bi-image me-1"></i>
                                                Upload ảnh
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="document.getElementById('documentFiles').click()">
                                                <i class="bi bi-file-earmark-pdf me-1"></i>
                                                Upload PDF
                                            </button>
                                        </div>
                                    </div>
                                    <input type="file" id="imageFiles" name="imageFiles" multiple accept="image/*" style="display: none;">
                                    <input type="file" id="documentFiles" name="documentFiles" multiple accept=".pdf" style="display: none;">
                                    
                                    <!-- Preview uploaded files -->
                                    <div id="filePreview" class="file-preview mt-3"></div>
                                </div>
                            </div>

                            <!-- Step 5: Thông tin thanh toán (Optional) -->
                            <div class="form-step mb-4">
                                <div class="step-header">
                                    <span class="step-number">5</span>
                                    <h6 class="step-title">Thông tin thanh toán <span class="text-muted">(Tùy chọn)</span></h6>
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="paymentBank" class="form-label">Ngân hàng</label>
                                        <input type="text" id="paymentBank" name="paymentBank" class="form-control" 
                                               placeholder="Vietcombank, BIDV, Techcombank...">
                                    </div>
                                    <div class="col-md-6">
                                        <label for="paymentNumber" class="form-label">Số tài khoản</label>
                                        <input type="text" id="paymentNumber" name="paymentNumber" class="form-control" 
                                               placeholder="Số tài khoản nhận tiền bồi thường">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-create-claim" id="submitClaimBtn">
                                <i class="bi bi-send me-2"></i>
                                Gửi Khiếu Nại
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="./component/footer.jsp"></jsp:include>

        <!-- JavaScript -->
        <script>
            // Search & Filter functionality
            function performSearch() {
                const searchTerm = document.getElementById('q').value;
                const status = document.getElementById('status').value;
                const type = document.getElementById('type').value;
                
                const params = new URLSearchParams();
                if (searchTerm) params.append('q', searchTerm);
                if (status) params.append('status', status);
                if (type) params.append('type', type);
                params.append('page', '1');
                
                window.location.href = 'my-claims?' + params.toString();
            }
            
            // Event listeners
            ['status', 'type'].forEach(id => {
                const el = document.getElementById(id);
                if (el) {
                    el.addEventListener('change', performSearch);
                }
            });
            
            // Search với debounce
            const searchInput = document.getElementById('q');
            if (searchInput) {
                let searchTimeout;
                searchInput.addEventListener('input', function() {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(performSearch, 2000);
                });
            }

            // Character counter cho textarea
            const descriptionTextarea = document.getElementById('description');
            const charCount = document.querySelector('.char-count');
            
            if (descriptionTextarea && charCount) {
                descriptionTextarea.addEventListener('input', function() {
                    const count = this.value.length;
                    charCount.textContent = count + '/1000';
                    
                    if (count < 50) {
                        charCount.classList.add('text-danger');
                        charCount.classList.remove('text-success');
                    } else {
                        charCount.classList.add('text-success');
                        charCount.classList.remove('text-danger');
                    }
                });
            }

            // File upload preview
            function handleFileSelect(input, previewContainer) {
                const files = input.files;
                let previewHTML = '';
                
                for (let i = 0; i < files.length; i++) {
                    const file = files[i];
                    const fileSize = (file.size / 1024 / 1024).toFixed(2);
                    const fileIcon = file.type.includes('image') ? 'bi-image' : 'bi-file-earmark-pdf';
                    
                    previewHTML += `
                        <div class="file-item">
                            <i class="bi ${fileIcon}"></i>
                            <span class="file-name">${file.name}</span>
                            <span class="file-size">${fileSize} MB</span>
                            <button type="button" class="btn-remove" onclick="removeFile(this, '${input.id}', ${i})">
                                <i class="bi bi-x"></i>
                            </button>
                        </div>
                    `;
                }
                
                previewContainer.innerHTML = previewHTML;
            }

            // File input change events
            document.getElementById('imageFiles').addEventListener('change', function() {
                handleFileSelect(this, document.getElementById('filePreview'));
            });
            
            document.getElementById('documentFiles').addEventListener('change', function() {
                handleFileSelect(this, document.getElementById('filePreview'));
            });

            // Form validation
            document.getElementById('createClaimForm').addEventListener('submit', function(e) {
                const description = document.getElementById('description').value;
                const claimType = document.querySelector('input[name="claimType"]:checked');
                const contractId = document.getElementById('contractId').value;
                
                if (!contractId) {
                    e.preventDefault();
                    alert('Vui lòng chọn hợp đồng');
                    return;
                }
                
                if (!claimType) {
                    e.preventDefault();
                    alert('Vui lòng chọn loại sự cố');
                    return;
                }
                
                if (description.length < 50) {
                    e.preventDefault();
                    alert('Mô tả phải có ít nhất 50 ký tự');
                    return;
                }
            });

            // Edit claim function
            function editClaim(claimId) {
                // TODO: Implement edit functionality
                alert('Chức năng chỉnh sửa đang phát triển');
            }
        </script>
        
        <!-- Bootstrap JS (Required for modal) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
