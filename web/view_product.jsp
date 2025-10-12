<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản Lý Sản Phẩm Bảo Hiểm Du Lịch</title>
        <style>
            :root {
                --primary-yellow: #FFD700;
                --light-yellow: #FFF9C4;
                --dark-yellow: #FFC107;
                --white: #FFFFFF;
                --text-dark: #2C3E50;
                --text-medium: #5D6D7E;
                --text-light: #85929E;
                --border-light: #EAEDED;
                --sidebar-bg: #FFFDF5;
                --shadow-light: 0 4px 12px rgba(0, 0, 0, 0.08);
                --shadow-medium: 0 8px 24px rgba(0, 0, 0, 0.12);
            }

            .view-product-container {
                background: transparent !important;
                color: var(--text-dark);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
                margin: 0;
                padding: 0;
                min-height: auto;
            }

            .view-product-container .header {
                background: linear-gradient(135deg, var(--primary-yellow) 0%, var(--dark-yellow) 100%);
                padding: 25px 30px;
                border-radius: 16px;
                margin-bottom: 25px;
                box-shadow: var(--shadow-light);
                border: 1px solid rgba(255, 255, 255, 0.4);
                position: relative;
                overflow: hidden;
            }

            .view-product-container .header::before {
                content: '';
                position: absolute;
                top: -30px;
                right: -30px;
                width: 150px;
                height: 150px;
                background: rgba(255, 255, 255, 0.25);
                border-radius: 50%;
            }

            .view-product-container .header h1 {
                color: var(--text-dark);
                margin: 0 0 8px 0;
                font-weight: 700;
                font-size: 28px;
                position: relative;
                text-shadow: 0 1px 2px rgba(255, 255, 255, 0.5);
            }

            .view-product-container .header p {
                margin: 4px 0;
                color: var(--text-dark);
                opacity: 0.9;
                font-size: 15px;
                position: relative;
                font-weight: 500;
            }

            .view-product-container .header .product-count {
                font-weight: 600;
                background: rgba(255, 255, 255, 0.3);
                padding: 4px 12px;
                border-radius: 20px;
                display: inline-block;
                margin-top: 5px;
            }

            .view-product-container .filter-section {
                background: var(--white);
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 25px;
                box-shadow: var(--shadow-light);
                border: 1px solid var(--border-light);
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .view-product-container .filter-label {
                font-weight: 600;
                color: var(--text-medium);
                margin-bottom: 0;
                white-space: nowrap;
            }

            .view-product-container .filter-select {
                background: var(--white);
                border: 1px solid var(--border-light);
                border-radius: 8px;
                padding: 10px 15px;
                color: var(--text-dark);
                font-weight: 500;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.04);
                transition: all 0.2s ease;
                min-width: 180px;
            }

            .view-product-container .filter-select:focus {
                outline: none;
                border-color: var(--primary-yellow);
                box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.2);
            }

            .view-product-container .table-container {
                background-color: var(--white);
                border-radius: 16px;
                box-shadow: var(--shadow-light);
                overflow: hidden;
                border: 1px solid var(--border-light);
                transition: all 0.3s ease;
            }

            .view-product-container .table-container:hover {
                box-shadow: var(--shadow-medium);
            }

            .view-product-container .table {
                margin-bottom: 0;
                border-collapse: separate;
                border-spacing: 0;
                width: 100%;
            }

            .view-product-container .table thead {
                background: linear-gradient(135deg, var(--primary-yellow) 0%, var(--dark-yellow) 100%);
            }

            .view-product-container .table thead th {
                border: none;
                padding: 18px 16px;
                font-weight: 700;
                font-size: 15px;
                color: var(--text-dark);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border-bottom: 2px solid var(--dark-yellow);
                vertical-align: middle;
                white-space: nowrap;
            }

            .view-product-container .table tbody tr {
                transition: all 0.2s ease;
                border-bottom: 1px solid var(--border-light);
            }

            .view-product-container .table tbody tr:last-child {
                border-bottom: none;
            }

            .view-product-container .table tbody tr:hover {
                background-color: var(--light-yellow);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            }

            .view-product-container .table tbody td {
                padding: 16px;
                vertical-align: middle;
                border-top: none;
                border-bottom: 1px solid var(--border-light);
                font-size: 15px;
            }

            .view-product-container .product-name {
                font-weight: 600;
                color: var(--text-dark);
            }

            .view-product-container .product-type {
                font-weight: 500;
                color: var(--text-medium);
            }

            .view-product-container .product-price {
                font-weight: 700;
                color: var(--text-dark);
                font-size: 15px;
            }

            .view-product-container .status-active {
                background: linear-gradient(135deg, rgba(46, 204, 113, 0.15) 0%, rgba(46, 204, 113, 0.25) 100%);
                color: #27AE60;
                font-weight: 700;
                padding: 8px 16px;
                border-radius: 20px;
                display: inline-block;
                font-size: 13px;
                border: 1px solid rgba(46, 204, 113, 0.3);
                box-shadow: 0 2px 4px rgba(46, 204, 113, 0.1);
            }

            .view-product-container .status-inactive {
                background: linear-gradient(135deg, rgba(231, 76, 60, 0.15) 0%, rgba(231, 76, 60, 0.25) 100%);
                color: #E74C3C;
                font-weight: 700;
                padding: 8px 16px;
                border-radius: 20px;
                display: inline-block;
                font-size: 13px;
                border: 1px solid rgba(231, 76, 60, 0.3);
                box-shadow: 0 2px 4px rgba(231, 76, 60, 0.1);
            }

            /* Các gói bảo hiểm với màu sắc phân cấp rõ ràng */
            .view-product-container .package-badge {
                font-weight: 600;
                padding: 8px 14px;
                border-radius: 12px;
                display: inline-block;
                font-size: 13px;
                border: 1px solid;
                text-align: center;
                min-width: 90px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .view-product-container .package-basic {
                background: linear-gradient(135deg, #E8F5E9 0%, #C8E6C9 100%);
                color: #2E7D32;
                border-color: #81C784;
            }

            .view-product-container .package-standard {
                background: linear-gradient(135deg, #E3F2FD 0%, #BBDEFB 100%);
                color: #1565C0;
                border-color: #64B5F6;
            }

            .view-product-container .package-advanced {
                background: linear-gradient(135deg, #FFF8E1 0%, #FFECB3 100%);
                color: #FF8F00;
                border-color: #FFD54F;
            }

            .view-product-container .package-comprehensive {
                background: linear-gradient(135deg, #FBE9E7 0%, #FFCCBC 100%);
                color: #D84315;
                border-color: #FF8A65;
            }

            .view-product-container .package-unknown {
                background: linear-gradient(135deg, #F5F5F5 0%, #EEEEEE 100%);
                color: #757575;
                border-color: #BDBDBD;
            }

            .view-product-container .btn-edit {
                background: linear-gradient(135deg, var(--primary-yellow) 0%, var(--dark-yellow) 100%);
                border: none;
                color: var(--text-dark);
                font-weight: 700;
                padding: 8px 16px;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                transition: all 0.2s ease;
                font-size: 14px;
                min-width: 70px;
            }

            .view-product-container .btn-edit:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                color: var(--text-dark);
            }

            .view-product-container .btn-delete {
                background: transparent;
                border: 1px solid #E74C3C;
                color: #E74C3C;
                font-weight: 700;
                padding: 8px 16px;
                border-radius: 8px;
                transition: all 0.2s ease;
                font-size: 14px;
                min-width: 70px;
            }

            .view-product-container .btn-delete:hover {
                background: linear-gradient(135deg, #E74C3C 0%, #C0392B 100%);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
            }

            .view-product-container .table-responsive {
                border-radius: 16px;
            }

            .view-product-container .empty-field {
                color: var(--text-light);
                font-style: italic;
                font-size: 14px;
            }

            /* Custom scrollbar */
            .view-product-container .table-responsive::-webkit-scrollbar {
                height: 8px;
            }

            .view-product-container .table-responsive::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 10px;
            }

            .view-product-container .table-responsive::-webkit-scrollbar-thumb {
                background: var(--primary-yellow);
                border-radius: 10px;
            }

            /* Animation for table rows */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .view-product-container .table tbody tr {
                animation: fadeInUp 0.4s ease forwards;
            }

            .view-product-container .table tbody tr:nth-child(1) {
                animation-delay: 0.05s;
            }
            .view-product-container .table tbody tr:nth-child(2) {
                animation-delay: 0.1s;
            }
            .view-product-container .table tbody tr:nth-child(3) {
                animation-delay: 0.15s;
            }
            .view-product-container .table tbody tr:nth-child(4) {
                animation-delay: 0.2s;
            }
            .view-product-container .table tbody tr:nth-child(5) {
                animation-delay: 0.25s;
            }
            .view-product-container .table tbody tr:nth-child(6) {
                animation-delay: 0.3s;
            }
            .view-product-container .table tbody tr:nth-child(7) {
                animation-delay: 0.35s;
            }

            /* Responsive adjustments */
            @media (max-width: 1200px) {
                .view-product-container .table thead th,
                .view-product-container .table tbody td {
                    padding: 14px 12px;
                    font-size: 14px;
                }

                .view-product-container .btn-edit,
                .view-product-container .btn-delete {
                    padding: 7px 14px;
                    font-size: 13px;
                    min-width: 65px;
                }

                .view-product-container .package-badge {
                    min-width: 80px;
                    padding: 7px 12px;
                }
            }

            @media (max-width: 992px) {
                .view-product-container .filter-section {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .view-product-container .filter-select {
                    width: 100%;
                    min-width: auto;
                }
            }

            @media (max-width: 768px) {
                .view-product-container .header {
                    padding: 20px 25px;
                }

                .view-product-container .header h1 {
                    font-size: 24px;
                }

                .view-product-container .header p {
                    font-size: 14px;
                }

                .view-product-container .table thead th {
                    padding: 12px 10px;
                    font-size: 13px;
                }

                .view-product-container .table tbody td {
                    padding: 12px 10px;
                    font-size: 13px;
                }

                .view-product-container .btn-edit,
                .view-product-container .btn-delete {
                    padding: 6px 12px;
                    font-size: 12px;
                    min-width: 60px;
                }

                .view-product-container .package-badge {
                    min-width: 70px;
                    padding: 6px 10px;
                    font-size: 12px;
                }

                .view-product-container .d-flex.gap-2 {
                    gap: 6px !important;
                }
            }

            @media (max-width: 576px) {
                .view-product-container .header {
                    padding: 15px 20px;
                }

                .view-product-container .header h1 {
                    font-size: 20px;
                }

                .view-product-container .table-responsive {
                    border-radius: 12px;
                }

                .view-product-container .table thead th {
                    padding: 10px 8px;
                    font-size: 12px;
                }

                .view-product-container .table tbody td {
                    padding: 10px 8px;
                    font-size: 12px;
                }

                .view-product-container .package-badge {
                    min-width: 60px;
                    padding: 5px 8px;
                    font-size: 11px;
                }
            }
        </style>
    </head>
    <body>
        <div class="view-product-container">
            <div class="header">
                <h1><i class="fas fa-list"></i> Danh sách sản phẩm bảo hiểm du lịch</h1>
                <p>Quản lý và theo dõi tất cả sản phẩm bảo hiểm du lịch</p>            
            </div>

            <form class="filter-section" action="${pageContext.request.contextPath}/filter" method="GET">
                <p class="filter-label">Lọc sản phẩm:</p>
                <select class="filter-select" name="filter">
                    <option value="all">Tất cả sản phẩm</option>
                    <option value="domestic">Trong nước</option>
                    <option value="international">Quốc tế</option>
                    <option value="nonactive">Chờ duyệt</option>
                    <option value="active">Hoạt động</option>
                </select>
                <button class="btn btn-warning px-5" type="submit"><i class="fas fa-filter"></i> Lọc</button>
            </form>

            <c:choose>
                <c:when test="${not empty products}">
                    <div class="table-container">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>Loại</th>
                                        <th>Giá tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Gói</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${products}" var="product">
                                        <c:if test="${!product.deleted}">
                                            <tr>
                                                <td class="product-name">${product.name}</td>
                                                <td class="product-type">${product.type == "domestic" ? "Trong nước" : "Quốc tế"}</td>
                                                <td class="product-price">
                                                    <c:choose>
                                                        <c:when test="${product.price != null}">
                                                            <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" groupingUsed="true"/> VNĐ
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="empty-field">Chưa có giá</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${product.active}">
                                                            <span class="status-active">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-inactive">Chờ duyệt</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${product.packageType == 'basic'}">
                                                            <span class="package-badge package-basic">Cơ bản</span>
                                                        </c:when>
                                                        <c:when test="${product.packageType == 'standard'}">
                                                            <span class="package-badge package-standard">Tiêu chuẩn</span>
                                                        </c:when>
                                                        <c:when test="${product.packageType == 'advanced'}">
                                                            <span class="package-badge package-advanced">Nâng cao</span>
                                                        </c:when>
                                                        <c:when test="${product.packageType == 'comprehensive'}">
                                                            <span class="package-badge package-comprehensive">Toàn diện</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="package-badge package-unknown">Chưa xác định</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-2">

                                                        <a href="${pageContext.request.contextPath}/edit_product?id=${product.id}&id_benefit=${product.benefitId}"> 
                                                            <button type="button" class="btn btn-edit">
                                                                <i class="fas fa-edit me-1"></i> Sửa
                                                            </button>
                                                        </a>

                                                        <a href="${pageContext.request.contextPath}/delete_product?id=${product.id}&id_benefit=${product.benefitId}">                                                           
                                                            <button class="btn btn-delete">
                                                                <i class="fas fa-trash me-1"></i> Xóa
                                                            </button>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div>
                        <h3>Không tìm thấy sản phẩm phù hợp!</h3>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script>
            document.querySelectorAll(".btn-delete").forEach(btn => {
                btn.addEventListener("click", (e) => {
                    e.preventDefault();
                    const confirmDelete = confirm("Bạn có chắc chắn muốn xóa sản phẩm này không?");
                    if (confirmDelete) {
                        const link = btn.closest("a");
                        if (link && link.href) {
                            window.location.href = link.href; // Chuyển hướng nếu nhấn OK
                        }
                    }
                });
            });
        </script>

    </body>
</html>