<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Bảo Hiểm Đã Mua</title>
        <!-- CSS được load trong header.jsp -->
    </head>
    <body>               
        <jsp:include page="./component/header.jsp"></jsp:include>

            <!-- CSS riêng cho trang này - load sau header để override -->
            <link rel="stylesheet" href="./CSS/styleindex.css"/>
            <link rel="stylesheet" href="./CSS/PurchasedInsurance.css"/>

            <main class="container my-4 my-lg-5">
                <!-- Header -->
                <div class="page-header">
                    <h1 class="title mb-0">Bảo Hiểm Đã Mua</h1>
                    <p class="subtitle mb-0">Quản lý các hợp đồng bảo hiểm du lịch bạn đã mua.</p>
                </div>

                <!-- Toolbar -->
                <div class="toolbar mb-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-12 col-lg-5">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                                <input id="q" name="q" class="form-control border-start-0" type="search"
                                       value="${searchTerm}" placeholder="Tìm theo mã hợp đồng, tên gói, điểm đến..." aria-label="Search">
                        </div>
                    </div>
                    <div class="col-6 col-lg-2">
                        <select id="status" name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                            <option value="cancelled" ${statusFilter == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-6 col-lg-2">
                        <select id="type" name="type" class="form-select">
                            <option value="">Tất cả loại</option>
                            <option value="domestic" ${typeFilter == 'domestic' ? 'selected' : ''}>Trong nước</option>
                            <option value="international" ${typeFilter == 'international' ? 'selected' : ''}>Quốc tế</option>
                        </select>
                    </div>
                    <div class="col-6 col-lg-3">
                        <select id="sort" name="sort" class="form-select">
                            <option value="newest" ${sortParam == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="expiring" ${sortParam == 'expiring' ? 'selected' : ''}>Sắp hết hạn</option>
                            <option value="price_desc" ${sortParam == 'price_desc' ? 'selected' : ''}>Giá trị cao → thấp</option>
                            <option value="price_asc" ${sortParam == 'price_asc' ? 'selected' : ''}>Giá trị thấp → cao</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="table-responsive border rounded-3">
                <table class="table align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Mã hợp đồng</th>
                            <th>Gói bảo hiểm</th>
                            <th>Loại</th>
                            <th>Điểm đến</th>
                            <th>Ngày bắt đầu</th>
                            <th>Ngày kết thúc</th>
                            <th>Số khách</th>
                            <th>Giá trị</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <c:choose>
                            <c:when test="${not empty contracts}">
                                <c:forEach var="contract" items="${contracts}">
                                    <tr>
                                        <td data-col="Mã hợp đồng">#TG-${contract.contract_id}</td>
                                        <td data-col="Gói bảo hiểm">
                                            <div class="fw-semibold">${contract.productName}</div>
                                            <div class="text-muted small">
                                                <c:choose>
                                                    <c:when test="${contract.productType == 'domestic'}">Gói trong nước</c:when>
                                                    <c:otherwise>Gói quốc tế</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td data-col="Loại">
                                            <c:choose>
                                                <c:when test="${contract.productType == 'domestic'}">Trong nước</c:when>
                                                <c:otherwise>Quốc tế</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td data-col="Điểm đến">${contract.destination != null ? contract.destination : 'Chưa xác định'}</td>
                                        <td data-col="Ngày bắt đầu">
                                            <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td data-col="Ngày kết thúc">
                                            <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td data-col="Số khách">${contract.travelers_quantity != null ? contract.travelers_quantity : 1} người</td>
                                        <td data-col="Giá trị">
                                            <strong>
                                                <fmt:formatNumber value="${contract.totalPrice}" type="number" groupingUsed="true"/> VNĐ
                                            </strong>
                                        </td>
                                        <td data-col="Trạng thái">
                                            <span class="badge-status
                                                  <c:choose>
                                                      <c:when test="${contract.contract_status == 'active'}">badge-active</c:when>
                                                      <c:when test="${contract.contract_status == 'pending'}">badge-pending</c:when>
                                                      <c:otherwise>badge-cancelled</c:otherwise>
                                                  </c:choose>">
                                                <c:choose>
                                                    <c:when test="${contract.contract_status == 'active'}">Đang hoạt động</c:when>
                                                    <c:when test="${contract.contract_status == 'pending'}">Chờ duyệt</c:when>
                                                    <c:otherwise>Đã hủy</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="text-end td-actions">
                                            <a href="#" class="action-icon me-1 view-contract-btn" 
                                               data-contract-id="${contract.contract_id}" 
                                               title="Xem hợp đồng">
                                                <i class="bi bi-file-earmark-text"></i>
                                            </a>
                                            <c:if test="${contract.contract_status == 'active'}">
                                                <a href="#" class="action-icon me-1 view-certificate-btn" 
                                                   data-contract-id="${contract.contract_id}" 
                                                   title="Xem chứng chỉ bảo hiểm">
                                                    <i class="bi bi-award"></i>
                                                </a>
                                            </c:if>
                                            <!-- <c:choose>
                                                <c:when test="${contract.contract_status != 'cancelled'}">
                                                    <a class="action-icon" href="/renew?contractId=${contract.contract_id}" title="Gia hạn">
                                                        <i class="bi bi-arrow-clockwise"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="action-icon disabled" aria-disabled="true" title="Không thể gia hạn">
                                                        <i class="bi bi-arrow-clockwise"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose> -->
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="10" class="text-center py-5">
                                        <div class="text-muted">
                                            <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                            <h5>Chưa có hợp đồng bảo hiểm nào</h5>
                                            <p>Bạn chưa mua bảo hiểm du lịch nào. <a href="InsuranceList" class="text-decoration-none">Khám phá các gói bảo hiểm</a></p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Footer: rows per page + pagination -->
            <div class="d-flex flex-column flex-lg-row align-items-center justify-content-between mt-3 gap-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted">
                        Hiển thị ${((currentPage - 1) * pageSize) + 1} - ${currentPage * pageSize > totalRecords ? totalRecords : currentPage * pageSize} 
                        trong tổng số ${totalRecords} hợp đồng
                    </span>
                </div>

                <c:if test="${totalRecords > 0}">
                    <nav aria-label="Phân trang">
                        <ul class="pagination mb-0">
                            <!-- Previous button - chỉ hiện khi có nhiều hơn 1 trang và không phải trang đầu -->
                            <c:if test="${totalPages > 1}">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}&q=${searchTerm}&status=${statusFilter}&type=${typeFilter}&sort=${sortParam}" 
                                       tabindex="${currentPage == 1 ? '-1' : ''}" aria-disabled="${currentPage == 1 ? 'true' : 'false'}">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>

                            <!-- Page numbers -->
                            <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
                            <c:set var="endPage" value="${currentPage + 2 <= totalPages ? currentPage + 2 : totalPages}" />

                            <c:if test="${startPage > 1 && totalPages > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=1&q=${searchTerm}&status=${statusFilter}&type=${typeFilter}&sort=${sortParam}">1</a>
                                </li>
                                <c:if test="${startPage > 2}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                </c:if>

                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <c:choose>
                                        <c:when test="${totalPages > 1}">
                                            <a class="page-link" href="?page=${i}&q=${searchTerm}&status=${statusFilter}&type=${typeFilter}&sort=${sortParam}">${i}</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="page-link">${i}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>

                            <c:if test="${endPage < totalPages && totalPages > 1}">
                                <c:if test="${endPage < totalPages - 1}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                    </c:if>
                                <li class="page-item">
                                    <a class="page-link" href="?page=${totalPages}&q=${searchTerm}&status=${statusFilter}&type=${typeFilter}&sort=${sortParam}">${totalPages}</a>
                                </li>
                            </c:if>

                            <!-- Next button - chỉ hiện khi có nhiều hơn 1 trang và không phải trang cuối -->
                            <c:if test="${totalPages > 1}">
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}&q=${searchTerm}&status=${statusFilter}&type=${typeFilter}&sort=${sortParam}"
                                       tabindex="${currentPage == totalPages ? '-1' : ''}" aria-disabled="${currentPage == totalPages ? 'true' : 'false'}">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </main>



        <!-- Modal: Xem Hợp Đồng Chi Tiết -->
        <div class="modal fade" id="contractDetailModal" tabindex="-1" aria-labelledby="contractDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title" id="contractDetailModalLabel">Chi Tiết Hợp Đồng</h5>
                            <div class="small text-muted" id="contractDetailMeta"></div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <div id="contractDetailLoading" class="text-center py-5">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Đang tải...</span>
                            </div>
                            <p class="mt-2">Đang tải thông tin hợp đồng...</p>
                        </div>
                        <div id="contractDetailContent" class="d-none">
                            <!-- Thông tin hợp đồng -->
                            <div class="mb-4">
                                <h6 class="fw-bold mb-3"><i class="bi bi-file-earmark-text me-2"></i>Thông tin hợp đồng</h6>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="text-muted small">Mã hợp đồng</label>
                                        <div class="fw-semibold" id="contractCode"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">Trạng thái</label>
                                        <div id="contractStatus"></div>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="text-muted small">Mô tả</label>
                                        <div id="contractDescription"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Thông tin sản phẩm -->
                            <div class="mb-4">
                                <h6 class="fw-bold mb-3"><i class="bi bi-box-seam me-2"></i>Thông tin sản phẩm</h6>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="text-muted small">Tên gói bảo hiểm</label>
                                        <div class="fw-semibold" id="productName"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">Loại</label>
                                        <div id="productType"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">Gói</label>
                                        <div id="packageType"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">Mô tả</label>
                                        <div id="productDescription"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Thông tin chuyến đi -->
                            <div class="mb-4">
                                <h6 class="fw-bold mb-3"><i class="bi bi-geo-alt me-2"></i>Thông tin chuyến đi</h6>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="text-muted small">Điểm đến</label>
                                        <div class="fw-semibold" id="destination"></div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="text-muted small">Ngày bắt đầu</label>
                                        <div id="startDate"></div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="text-muted small">Ngày kết thúc</label>
                                        <div id="endDate"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">Số người được bảo hiểm</label>
                                        <div id="travelersQuantity"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">Tổng giá trị</label>
                                        <div class="fw-semibold text-primary" id="totalPrice"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Thông tin người mua -->
                            <div class="mb-4">
                                <h6 class="fw-bold mb-3"><i class="bi bi-person me-2"></i>Thông tin người mua</h6>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="text-muted small">Họ và tên</label>
                                        <div class="fw-semibold" id="buyerName"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">Số điện thoại</label>
                                        <div id="buyerPhone"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">Email</label>
                                        <div id="buyerEmail"></div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="text-muted small">CCCD/CMND</label>
                                        <div id="buyerCccd"></div>
                                    </div>
                                    <div class="col-md-12">
                                        <label class="text-muted small">Địa chỉ</label>
                                        <div id="buyerAddress"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Danh sách người được bảo hiểm -->
                            <div class="mb-4">
                                <h6 class="fw-bold mb-3"><i class="bi bi-people me-2"></i>Danh sách người được bảo hiểm</h6>
                                <div class="table-responsive">
                                    <table class="table table-sm table-bordered">
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Họ và tên</th>
                                                <th>Giới tính</th>
                                                <th>CCCD/CMND</th>
                                                <th>Ngày sinh</th>
                                                <th>Tuổi</th>
                                                <th>SĐT</th>
                                                <th>Email</th>
                                            </tr>
                                        </thead>
                                        <tbody id="travelersTableBody">
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <!-- Thông tin quyền lợi -->
                            <div class="mb-4">
                                <h6 class="fw-bold mb-3"><i class="bi bi-shield-check me-2"></i>Quyền lợi bảo hiểm</h6>
                                <div class="row g-3" id="benefitsContent">
                                </div>
                            </div>

                            <!-- Thông tin thanh toán -->
                            <div class="mb-4" id="invoiceSection">
                                <h6 class="fw-bold mb-3"><i class="bi bi-receipt me-2"></i>Thông tin thanh toán</h6>
                                <div class="row g-3" id="invoiceContent">
                                </div>
                            </div>
                        </div>
                        <div id="contractDetailError" class="d-none text-center py-5">
                            <i class="bi bi-exclamation-triangle text-warning fs-1 d-block mb-2"></i>
                            <p class="text-danger">Có lỗi xảy ra khi tải thông tin hợp đồng.</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a id="downloadContractPdfBtn" class="btn btn-primary d-none"><i class="bi bi-download me-1"></i>Tải PDF hợp đồng</a>
                        <button type="button" class="btn btn-outline-dark" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS - Phải load trước khi dùng Modal -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Đợi DOM load xong mới chạy script
            document.addEventListener('DOMContentLoaded', function() {
                // Format số tiền
                function formatCurrency(amount) {
                    if (!amount)
                        return '0 VNĐ';
                    return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
                }

                // Format ngày
                function formatDate(dateStr) {
                    if (!dateStr)
                        return '-';
                    return dateStr;
                }

                // Xử lý click button "Xem hợp đồng"
                console.log('Setting up view-contract-btn listeners...');
                const viewContractButtons = document.querySelectorAll('.view-contract-btn');
                console.log('Found ' + viewContractButtons.length + ' view-contract buttons');
                
                viewContractButtons.forEach(btn => {
                    btn.addEventListener('click', function (e) {
                        e.preventDefault();
                        console.log('View contract button clicked!');
                        const contractId = this.getAttribute('data-contract-id');
                        console.log('Contract ID: ' + contractId);
                        
                        if (!contractId) {
                            console.error('No contract ID found!');
                            alert('Không tìm thấy mã hợp đồng!');
                            return;
                        }

                        // Reset modal
                        const loadingEl = document.getElementById('contractDetailLoading');
                        const contentEl = document.getElementById('contractDetailContent');
                        const errorEl = document.getElementById('contractDetailError');
                        const downloadBtn = document.getElementById('downloadContractPdfBtn');
                        
                        if (loadingEl) loadingEl.classList.remove('d-none');
                        if (contentEl) contentEl.classList.add('d-none');
                        if (errorEl) errorEl.classList.add('d-none');
                        if (downloadBtn) downloadBtn.classList.add('d-none');

                        // Mở modal
                        const modalEl = document.getElementById('contractDetailModal');
                        if (!modalEl) {
                            console.error('Modal element not found!');
                            alert('Không tìm thấy modal!');
                            return;
                        }
                        
                        // Kiểm tra Bootstrap
                        if (typeof bootstrap === 'undefined') {
                            console.error('Bootstrap is not loaded!');
                            alert('Bootstrap chưa được load!');
                            return;
                        }
                        
                        const modal = new bootstrap.Modal(modalEl);
                        modal.show();
                        console.log('Modal opened');

                        // Load data
                        loadContractDetail(contractId);
                    });
                });

                // Load chi tiết hợp đồng
                function loadContractDetail(contractId) {
                    console.log('Loading contract detail for ID: ' + contractId);
                    const url = 'view-contract-detail?contractId=' + contractId;
                    console.log('Fetching from: ' + url);
                    
                    fetch(url)
                            .then(response => {
                                console.log('Response status: ' + response.status);
                                if (!response.ok) {
                                    throw new Error('Network response was not ok: ' + response.status);
                                }
                                return response.json();
                            })
                            .then(data => {
                                console.log('Data received:', data);
                                displayContractDetail(data);
                            })
                            .catch(error => {
                                console.error('Error loading contract detail:', error);
                                const loadingEl = document.getElementById('contractDetailLoading');
                                const errorEl = document.getElementById('contractDetailError');
                                if (loadingEl) loadingEl.classList.add('d-none');
                                if (errorEl) errorEl.classList.remove('d-none');
                                alert('Có lỗi xảy ra khi tải thông tin hợp đồng: ' + error.message);
                            });
                }

                // Hiển thị chi tiết hợp đồng
                function displayContractDetail(data) {
                    // Ẩn loading, hiện content
                    document.getElementById('contractDetailLoading').classList.add('d-none');
                    document.getElementById('contractDetailContent').classList.remove('d-none');

                    // Contract info
                    if (data.contract) {
                        document.getElementById('contractCode').textContent = data.contract.contractCode || 'TG-' + data.contract.contractId;
                        const status = data.contract.status;
                        let statusClass = 'badge-pending';
                        let statusText = 'Chờ duyệt';
                        if (status === 'active') {
                            statusClass = 'badge-active';
                            statusText = 'Đang hoạt động';
                        } else if (status === 'cancelled') {
                            statusClass = 'badge-cancelled';
                            statusText = 'Đã hủy';
                        }
                        document.getElementById('contractStatus').innerHTML =
                                '<span class="badge-status ' + statusClass + '">' + statusText + '</span>';
                        document.getElementById('contractDescription').textContent = data.contract.description || '-';

                        // Set modal title
                        document.getElementById('contractDetailModalLabel').textContent =
                                'Chi Tiết Hợp Đồng - ' + (data.contract.contractCode || 'TG-' + data.contract.contractId);
                    }

                    // Product info
                    if (data.product) {
                        document.getElementById('productName').textContent = data.product.name || '-';
                        document.getElementById('productType').textContent =
                                (data.product.type === 'domestic' ? 'Trong nước' : 'Quốc tế') || '-';
                        document.getElementById('packageType').textContent = data.product.packageType || '-';
                        document.getElementById('productDescription').textContent = data.product.description || '-';
                    }

                    // Application info
                    if (data.application) {
                        document.getElementById('destination').textContent = data.application.destination || '-';
                        document.getElementById('startDate').textContent = formatDate(data.application.startDate);
                        document.getElementById('endDate').textContent = formatDate(data.application.endDate);
                        document.getElementById('travelersQuantity').textContent =
                                (data.application.travelersQuantity || 0) + ' người';
                        document.getElementById('totalPrice').textContent = formatCurrency(data.application.totalPrice);
                    }

                    // Buyer info
                    if (data.buyer) {
                        document.getElementById('buyerName').textContent = data.buyer.fullname || '-';
                        document.getElementById('buyerPhone').textContent = data.buyer.phone || '-';
                        document.getElementById('buyerEmail').textContent = data.buyer.email || '-';
                        document.getElementById('buyerCccd').textContent = data.buyer.cccd || '-';
                        document.getElementById('buyerAddress').textContent = data.buyer.address || '-';
                    }

                    // Travelers
                    const travelersBody = document.getElementById('travelersTableBody');
                    travelersBody.innerHTML = '';
                    if (data.travelers && data.travelers.length > 0) {
                        data.travelers.forEach((traveler, index) => {
                            const row = document.createElement('tr');
                            const genderText = (traveler.gender === 'Male' || traveler.gender === 'Nam') ? 'Nam' : 'Nữ';
                            row.innerHTML =
                                    '<td>' + (index + 1) + '</td>' +
                                    '<td>' + (traveler.name || '-') + '</td>' +
                                    '<td>' + genderText + '</td>' +
                                    '<td>' + (traveler.cccdId || '-') + '</td>' +
                                    '<td>' + formatDate(traveler.dob) + '</td>' +
                                    '<td>' + (traveler.age || '-') + '</td>' +
                                    '<td>' + (traveler.phone || '-') + '</td>' +
                                    '<td>' + (traveler.email || '-') + '</td>';
                            travelersBody.appendChild(row);
                        });
                    } else {
                        travelersBody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">Không có dữ liệu</td></tr>';
                    }

                    // Benefits
                    const benefitsContent = document.getElementById('benefitsContent');
                    benefitsContent.innerHTML = '';
                    if (data.benefit) {
                        const benefits = [
                            {label: 'Chi phí y tế', value: data.benefit.medicalCost},
                            {label: 'Vận chuyển cấp cứu', value: data.benefit.emergencyTransport},
                            {label: 'Hồi hương trong nước', value: data.benefit.repatriationVn},
                            {label: 'Hồi hương nước ngoài', value: data.benefit.repatriationAbroad},
                            {label: 'Thăm viếng bệnh viện', value: data.benefit.hospitalVisit},
                            {label: 'Tổ chức tang lễ', value: data.benefit.funeralArrangement},
                            {label: 'Chăm sóc trẻ em', value: data.benefit.childCare},
                            {label: 'Trợ cấp bệnh viện', value: data.benefit.hospitalAllowance},
                            {label: 'Tử vong/thương tật do tai nạn', value: data.benefit.accidentDeathInjury},
                            {label: 'Hủy chuyến đi', value: data.benefit.tripCancellation},
                            {label: 'Hỗ trợ đồng hành', value: data.benefit.companionSupport},
                            {label: 'Hành lý bị trễ', value: data.benefit.delayedBaggage},
                            {label: 'Giấy tờ du lịch', value: data.benefit.travelDocuments},
                            {label: 'Trễ chuyến', value: data.benefit.tripDelay},
                            {label: 'Tử vong/thương tật vĩnh viễn', value: data.benefit.deathOrPermanentDisability},
                            {label: 'Tử vong do bệnh tật', value: data.benefit.deathDueToIllness},
                            {label: 'Trách nhiệm bên thứ ba', value: data.benefit.thirdPartyLiability},
                            {label: 'Mất thẻ ngân hàng', value: data.benefit.lostBankCard},
                            {label: 'Bắt cóc và con tin', value: data.benefit.kidnapAndHostage},
                            {label: 'Mất/hư hỏng dụng cụ golf', value: data.benefit.lostOrDamagedGolfEquipment}
                        ];

                        benefits.forEach(benefit => {
                            if (benefit.value) {
                                const col = document.createElement('div');
                                col.className = 'col-md-6 col-lg-4';
                                const benefitLabel = benefit.label;
                                const benefitValue = formatCurrency(benefit.value);
                                col.innerHTML = 
                                    '<div class="border rounded p-2 mb-2">' +
                                    '<small class="text-muted d-block">' + benefitLabel + '</small>' +
                                    '<strong>' + benefitValue + '</strong>' +
                                    '</div>';
                                benefitsContent.appendChild(col);
                            }
                        });
                    }

                    // Invoice
                    const invoiceSection = document.getElementById('invoiceSection');
                    const invoiceContent = document.getElementById('invoiceContent');
                    if (data.invoice) {
                        invoiceSection.classList.remove('d-none');
                        let paymentMethodText = '-';
                        if (data.invoice.paymentMethod === 'credit_card') {
                            paymentMethodText = 'Thẻ tín dụng';
                        } else if (data.invoice.paymentMethod === 'bank_transfer') {
                            paymentMethodText = 'Chuyển khoản';
                        } else if (data.invoice.paymentMethod === 'cash') {
                            paymentMethodText = 'Tiền mặt';
                        }

                        const taxRateText = data.invoice.taxRate ?
                                ((parseFloat(data.invoice.taxRate) * 100).toFixed(2) + '%') : '-';

                        invoiceContent.innerHTML =
                                '<div class="col-md-6">' +
                                '<label class="text-muted small">Số tiền cơ bản</label>' +
                                '<div class="fw-semibold">' + formatCurrency(data.invoice.baseAmount) + '</div>' +
                                '</div>' +
                                '<div class="col-md-6">' +
                                '<label class="text-muted small">Thuế suất</label>' +
                                '<div>' + taxRateText + '</div>' +
                                '</div>' +
                                '<div class="col-md-6">' +
                                '<label class="text-muted small">Phương thức thanh toán</label>' +
                                '<div>' + paymentMethodText + '</div>' +
                                '</div>' +
                                '<div class="col-md-6">' +
                                '<label class="text-muted small">Mã thanh toán</label>' +
                                '<div>' + (data.invoice.paymentCode || '-') + '</div>' +
                                '</div>' +
                                '<div class="col-md-12">' +
                                '<label class="text-muted small">Ghi chú</label>' +
                                '<div>' + (data.invoice.notes || '-') + '</div>' +
                                '</div>' +
                                '<div class="col-md-12">' +
                                '<label class="text-muted small">Ngày tạo</label>' +
                                '<div>' + formatDate(data.invoice.createdAt) + '</div>' +
                                '</div>';
                    } else {
                        invoiceSection.classList.add('d-none');
                    }

                    // Show download button
                    document.getElementById('downloadContractPdfBtn').classList.remove('d-none');
                    document.getElementById('downloadContractPdfBtn').href =
                            'contract-pdf?contractId=' + data.contract.contractId;
                }

                // Xử lý filter/search
                function performSearch() {
                    const searchTerm = document.getElementById('q').value;
                    const status = document.getElementById('status').value;
                    const type = document.getElementById('type').value;
                    const sort = document.getElementById('sort').value;

                    // Build query string
                    const params = new URLSearchParams();
                    if (searchTerm)
                        params.append('q', searchTerm);
                    if (status)
                        params.append('status', status);
                    if (type)
                        params.append('type', type);
                    if (sort)
                        params.append('sort', sort);
                    params.append('page', '1'); // Reset về trang 1 khi search

                    // Redirect với parameters
                    window.location.href = 'purchased-insurance?' + params.toString();
                }

                // Gắn event listeners cho filter
                ['status', 'type', 'sort'].forEach(id => {
                    const el = document.getElementById(id);
                    if (el) {
                        el.addEventListener('change', performSearch);
                    }
                });

                // Search input
                const searchInput = document.getElementById('q');
                if (searchInput) {
                    let searchTimeout;
                    searchInput.addEventListener('input', function () {
                        clearTimeout(searchTimeout);
                        searchTimeout = setTimeout(performSearch, 2000);
                    });

                    // Enter key
                    searchInput.addEventListener('keypress', function (e) {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            clearTimeout(searchTimeout);
                            performSearch();
                        }
                    });
                }
            }); // End DOMContentLoaded
        </script>

        <!-- Footer -->
        <jsp:include page="./component/footer.jsp"></jsp:include>
    </body>

</html>
