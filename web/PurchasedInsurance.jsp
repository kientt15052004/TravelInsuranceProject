<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Purchased Insurance</title>

        <!-- Bootstrap 5 & Icons (CDN) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Theme: yellow–white–black -->
        <style>
            :root{
                --brand-yellow: #FFD54D;      /* vàng chủ đạo (có thể chỉnh theo homepage) */
                --brand-yellow-soft:#FFF4CC;  /* vàng nhạt cho hover/badge outline */
                --brand-black:#111111;

                --primary-yellow: #FDB614;
                --dark-navy: #1a2332;
                --light-gray: #f8f9fa;

            }
            body {
                background:#fff;
                color:#111;
            }

            .page-header{
                padding: 32px 0 16px;
            }
            .page-header .title{
                font-weight:700;
                font-size:28px;
                margin-bottom:6px;
            }
            .page-header .subtitle{
                color:#6b7280;
            }

            .toolbar .form-control, .toolbar .form-select{
                border-radius:10px;
            }
            .btn-brand{
                background: var(--brand-yellow);
                border-color: var(--brand-yellow);
                color:#000;
                font-weight:600;
            }
            .btn-brand:hover{
                filter: brightness(0.95);
                color:#000;
            }

            .table> :not(caption)>*>*{
                padding-top: 14px;
                padding-bottom:14px;
                vertical-align: middle;
            }
            .table thead th{
                color:#6b7280;
                font-weight:600;
                font-size:14px;
                background:#f8f9fa;
                position: sticky;
                top:0;
                z-index:1;
            }

            /* Status badges */
            .badge-status {
                font-weight:600;
                padding:6px 10px;
                border-radius:999px;
            }
            .badge-pending {
                background: var(--brand-yellow-soft);
                color:#7a5a00;
                border:1px solid var(--brand-yellow);
            }
            .badge-active {
                background:#C7F9CC;
                color:#0f5132;
                border:1px solid #86efac;
            }
            .badge-cancelled {
                background:#e9ecef;
                color:#6c757d;
                border:1px solid #dee2e6;
            }

            /* Action icons */
            .action-icon{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                width:36px;
                height:36px;
                border-radius:10px;
                color:#111;
                border:1px solid #e5e7eb;
                background:#fff;
            }
            .action-icon:hover{
                background:#f8f9fa;
            }

            /* Card style for mobile (table -> cards) */
            @media (max-width: 992px){
                .table-responsive{
                    border:0;
                }
                table thead{
                    display:none;
                }
                table tbody tr{
                    display:block;
                    margin-bottom:12px;
                    border:1px solid #e5e7eb;
                    border-radius:14px;
                    padding:12px;
                }
                table tbody td{
                    display:flex;
                    justify-content:space-between;
                    border:0!important;
                    padding:8px 6px !important;
                }
                table tbody td[data-col]::before{
                    content: attr(data-col);
                    color:#6b7280;
                    font-weight:600;
                    margin-right:16px;
                }
                .td-actions{
                    justify-content:flex-start !important;
                    gap:8px;
                }
            }

            /* Pagination */
            .pagination .page-link{
                color:#111;
            }
            .pagination .page-item.active .page-link{
                background:var(--brand-yellow);
                border-color:var(--brand-yellow);
                color:#000;
            }

            /* Modal PDF height */
            .pdf-frame{
                width:100%;
                height:70vh;
                border:0;
                background:#f5f5f5;
            }
        </style>
        <link rel="stylesheet" href="./CSS/footer.css"/>
    </head>
    <body>

        <main class="container my-4 my-lg-5">
            <!-- Header -->
            <div class="page-header">
                <h1 class="title mb-0">Purchased Insurance</h1>
                <p class="subtitle mb-0">Quản lý các hợp đồng bảo hiểm du lịch bạn đã mua.</p>
            </div>

            <!-- Toolbar -->
            <div class="toolbar mb-3">
                <div class="row g-2 align-items-center">
                    <div class="col-12 col-lg-4">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="bi bi-search"></i></span>
                            <input id="q" class="form-control border-start-0" type="search"
                                   placeholder="Tìm theo Contract #, Plan, Destination…" aria-label="Search">
                        </div>
                    </div>
                    <div class="col-6 col-lg-2">
                        <select id="status" class="form-select">
                            <option value="">All Status</option>
                            <option value="active">Active</option>
                            <option value="pending">Pending</option>
                            <option value="cancelled">Cancelled</option>
                        </select>
                    </div>
                    <div class="col-6 col-lg-2">
                        <select id="type" class="form-select">
                            <option value="">All Types</option>
                            <option value="domestic">Domestic</option>
                            <option value="international">International</option>
                        </select>
                    </div>
                    <div class="col-6 col-lg-2">
                        <input id="dateFrom" type="date" class="form-control" placeholder="mm/dd/yyyy">
                    </div>
                    <div class="col-6 col-lg-2">
                        <div class="d-flex gap-2">
                            <input id="dateTo" type="date" class="form-control" placeholder="mm/dd/yyyy">
                            <select id="sort" class="form-select" style="max-width: 140px;">
                                <option value="newest">Mới nhất</option>
                                <option value="expiring">Sắp hết hạn</option>
                                <option value="price_desc">Giá trị cao → thấp</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table -->
            <div class="table-responsive border rounded-3">
                <table class="table align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Contract #</th>
                            <th>Plan / Package</th>
                            <th>Type</th>
                            <th>Destination</th>
                            <th>Coverage</th>
                            <th>Travelers</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <%-- 
                          Ví dụ loop dữ liệu:
                          <c:forEach var="row" items="${contracts}">
                            ...
                          </c:forEach>
                        --%>

                        <!-- DỮ LIỆU MẪU: thay bằng loop JSP khi có data -->
                        <tr>
                            <td data-col="Contract #">#TG-2024-001</td>
                            <td data-col="Plan / Package">
                                <div class="fw-semibold">Premium Travel Protection</div>
                                <div class="text-muted small">Comprehensive Package</div>
                            </td>
                            <td data-col="Type">International</td>
                            <td data-col="Destination">Japan</td>
                            <td data-col="Coverage">2024-12-15 – 2024-12-25</td>
                            <td data-col="Travelers">2</td>
                            <td data-col="Price"><strong>$280.00</strong></td>
                            <td data-col="Status"><span class="badge-status badge-active">Active</span></td>
                            <td class="text-end td-actions">
                                <a href="#" class="action-icon me-1" data-bs-toggle="modal" data-bs-target="#policyModal"
                                   data-contract="#TG-2024-001" data-name="Premium Travel Protection"
                                   data-package="Comprehensive Package" data-status="active"
                                   data-pdf="/files/policy_TG-2024-001.pdf" title="View PDF">
                                    <i class="bi bi-file-earmark-text"></i>
                                </a>
                                <a class="action-icon me-1" href="/files/policy_TG-2024-001.pdf" download title="Download">
                                    <i class="bi bi-download"></i>
                                </a>
                                <a class="action-icon" href="/renew?contractId=1" title="Renew">
                                    <i class="bi bi-arrow-clockwise"></i>
                                </a>
                            </td>
                        </tr>

                        <tr>
                            <td data-col="Contract #">#TG-2024-002</td>
                            <td data-col="Plan / Package">
                                <div class="fw-semibold">Basic Travel Insurance</div>
                                <div class="text-muted small">Standard Package</div>
                            </td>
                            <td data-col="Type">Domestic</td>
                            <td data-col="Destination">Da Nang</td>
                            <td data-col="Coverage">2024-11-20 – 2024-11-25</td>
                            <td data-col="Travelers">4</td>
                            <td data-col="Price"><strong>$120.00</strong></td>
                            <td data-col="Status"><span class="badge-status badge-pending">Pending</span></td>
                            <td class="text-end td-actions">
                                <a href="#" class="action-icon me-1" data-bs-toggle="modal" data-bs-target="#policyModal"
                                   data-contract="#TG-2024-002" data-name="Basic Travel Insurance"
                                   data-package="Standard Package" data-status="pending"
                                   data-pdf="/files/policy_TG-2024-002.pdf" title="View PDF">
                                    <i class="bi bi-file-earmark-text"></i>
                                </a>
                                <a class="action-icon me-1" href="/files/policy_TG-2024-002.pdf" download title="Download">
                                    <i class="bi bi-download"></i>
                                </a>
                                <a class="action-icon" href="/renew?contractId=2" title="Renew">
                                    <i class="bi bi-arrow-clockwise"></i>
                                </a>
                            </td>
                        </tr>

                        <tr>
                            <td data-col="Contract #">#TG-2024-003</td>
                            <td data-col="Plan / Package">
                                <div class="fw-semibold">European Adventure</div>
                                <div class="text-muted small">Premium Package</div>
                            </td>
                            <td data-col="Type">International</td>
                            <td data-col="Destination">France</td>
                            <td data-col="Coverage">2024-08-10 – 2024-08-20</td>
                            <td data-col="Travelers">2</td>
                            <td data-col="Price"><strong>$450.00</strong></td>
                            <td data-col="Status"><span class="badge-status badge-cancelled">Cancelled</span></td>
                            <td class="text-end td-actions">
                                <a href="#" class="action-icon me-1" data-bs-toggle="modal" data-bs-target="#policyModal"
                                   data-contract="#TG-2024-003" data-name="European Adventure"
                                   data-package="Premium Package" data-status="cancelled"
                                   data-pdf="/files/policy_TG-2024-003.pdf" title="View PDF">
                                    <i class="bi bi-file-earmark-text"></i>
                                </a>
                                <a class="action-icon me-1" href="/files/policy_TG-2024-003.pdf" download title="Download">
                                    <i class="bi bi-download"></i>
                                </a>
                                <a class="action-icon disabled" aria-disabled="true" title="Renew (disabled)">
                                    <i class="bi bi-arrow-clockwise"></i>
                                </a>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>

            <!-- Footer: rows per page + pagination -->
            <div class="d-flex flex-column flex-lg-row align-items-center justify-content-between mt-3 gap-2">
                <div class="d-flex align-items-center gap-2">
                    <label for="rowsPerPage" class="text-muted">Rows per page:</label>
                    <select id="rowsPerPage" class="form-select" style="width:90px;">
                        <option>10</option><option>20</option><option>50</option>
                    </select>
                </div>
                <nav aria-label="Pagination">
                    <ul class="pagination mb-0">
                        <li class="page-item disabled"><a class="page-link" href="#" tabindex="-1" aria-disabled="true"><i class="bi bi-chevron-left"></i></a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a></li>
                    </ul>
                </nav>
            </div>
        </main>



        <!-- Modal: Policy PDF Viewer -->
        <div class="modal fade" id="policyModal" tabindex="-1" aria-labelledby="policyModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title" id="policyModalLabel">Policy Document</h5>
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
                        <a id="downloadPdfBtn" class="btn btn-brand"><i class="bi bi-download me-1"></i>Download PDF</a>
                        <button type="button" class="btn btn-outline-dark" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="./component/footer.jsp"></jsp:include>
            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Minimal behaviors (chỉ UI, không gọi API) -->
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
                    policyModal.querySelector('#policyModalLabel').textContent = `Policy Document — ${contractId}`;
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

                        // (Gợi ý) Gắn filter/search: lắng nghe change và submit form để call servlet
                        ['q', 'status', 'type', 'dateFrom', 'dateTo', 'sort', 'rowsPerPage'].forEach(id => {
                            const el = document.getElementById(id);
                            if (!el)
                                return;
                            el.addEventListener('change', function () {
                                // TODO: submit form hoặc build querystring rồi redirect
                                // window.location.href = '/purchased-insurance?status='+...
                                // Tạm thời: highlight control khi đổi
                                this.classList.add('border', 'border-warning');
                                setTimeout(() => this.classList.remove('border', 'border-warning'), 800);
                            });
                        });
        </script>

    </body>

</html>
