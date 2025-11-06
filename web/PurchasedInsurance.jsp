<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Bảo Hiểm Đã Mua</title>
    </head>
    <body>               
        <jsp:include page="./component/header.jsp"></jsp:include>
        
        <!-- CSS riêng cho trang này - load sau header để override -->
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
                                            <a href="#" class="action-icon me-1" data-bs-toggle="modal" data-bs-target="#policyModal"
                                               data-contract="#TG-${contract.contract_id}" 
                                               data-name="${contract.productName}"
                                               data-package="${contract.productType} Package" 
                                               data-status="${contract.contract_status}"
                                               data-pdf="/files/policy_TG-${contract.contract_id}.pdf" title="Xem hợp đồng">
                                                <i class="bi bi-file-earmark-text"></i>
                                            </a>
                                            <a class="action-icon me-1" href="/files/policy_TG-${contract.contract_id}.pdf" download title="Tải xuống">
                                                <i class="bi bi-download"></i>
                                            </a>
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



        <!-- Modal: Policy PDF Viewer -->
        <div class="modal fade" id="policyModal" tabindex="-1" aria-labelledby="policyModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title" id="policyModalLabel">Hợp Đồng Bảo Hiểm</h5>
                            <div class="small text-muted" id="policyMeta"></div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body p-0">
                        <iframe id="policyPdf" class="pdf-frame" title="Policy PDF"></iframe>
                        <div id="pdfFallback" class="d-none p-4">
                            <p class="mb-3">Không thể nhúng PDF trong trình duyệt này.</p>
                            <a id="openNewTab" class="btn btn-brand" target="_blank">Mở trong tab mới</a>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a id="downloadPdfBtn" class="btn btn-brand"><i class="bi bi-download me-1"></i>Tải xuống PDF</a>
                        <button type="button" class="btn btn-outline-dark" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        

            <script>
                // Mở modal + set meta / iframe
                const policyModal = document.getElementById('policyModal');
                policyModal.addEventListener('show.bs.modal', function (event) {
                    const trigger = event.relatedTarget;
                    if (!trigger)
                        return;
                    const contractId = trigger.getAttribute('data-contract') || '';
                    const planName = trigger.getAttribute('data-name') || '';
                    const planPkg = trigger.getAttribute('data-package') || '';
                    const status = trigger.getAttribute('data-status') || '';
                    const pdfUrl = trigger.getAttribute('data-pdf') || '';

                    // Tiêu đề + meta
                    policyModal.querySelector('#policyModalLabel').textContent = `Hợp Đồng Bảo Hiểm — ${contractId}`;
                    policyModal.querySelector('#policyMeta').textContent = `${planName} • ${planPkg} • ${status}`;

                            // PDF
                            const frame = policyModal.querySelector('#policyPdf');
                            const fallback = policyModal.querySelector('#pdfFallback');
                            frame.classList.remove('d-none');
                            fallback.classList.add('d-none');
                            frame.src = pdfUrl;

                            // Download + open new tab
                            policyModal.querySelector('#downloadPdfBtn').setAttribute('href', pdfUrl);
                            policyModal.querySelector('#downloadPdfBtn').setAttribute('download', '');
                            policyModal.querySelector('#openNewTab').setAttribute('href', pdfUrl);

                            // Fallback nếu iframe lỗi
                            frame.addEventListener('error', () => {
                                frame.classList.add('d-none');
                                fallback.classList.remove('d-none');
                            }, {once: true});
                        });

                        // Xử lý filter/search
                        function performSearch() {
                            const searchTerm = document.getElementById('q').value;
                            const status = document.getElementById('status').value;
                            const type = document.getElementById('type').value;
                            const sort = document.getElementById('sort').value;
                            
                            // Build query string
                            const params = new URLSearchParams();
                            if (searchTerm) params.append('q', searchTerm);
                            if (status) params.append('status', status);
                            if (type) params.append('type', type);
                            if (sort) params.append('sort', sort);
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
                            searchInput.addEventListener('input', function() {
                                clearTimeout(searchTimeout);
                                searchTimeout = setTimeout(performSearch, 500);
                            });
                            
                            // Enter key
                            searchInput.addEventListener('keypress', function(e) {
                                if (e.key === 'Enter') {
                                    e.preventDefault();
                                    clearTimeout(searchTimeout);
                                    performSearch();
                                }
                            });
                        }
        </script>
<!-- Footer -->
<jsp:include page="./component/footer.jsp"></jsp:include>
    </body>

</html>
