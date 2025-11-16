<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>InsureTravel - Danh Sách Bảo Hiểm</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <jsp:include page="component/header.jsp" />
        <link rel="stylesheet" href="./CSS/styleindex.css"/>
        <link rel="stylesheet" href="./CSS/InsuranceList.css">
        
        <div class="container">

            <h1 class="page-title">
                Sản Phẩm Bảo Hiểm Du Lịch
            </h1>

            <div class="filter-section">
                <form action="InsuranceList" method="GET" class="filter-form">
                    <!-- Search by name -->
                    <div class="form-group">
                        <label>Tìm kiếm theo tên</label>
                        <input type="text" class="form-input" name="searchName" value="${param.searchName}" placeholder="Nhập tên bảo hiểm...">
                    </div>

                    <div class="form-group">
                        <label>Lọc theo loại</label>
                        <select class="form-select" name="searchType">
                            <option value="">Tất cả loại</option>

                            <option value="domestic" 
                                    ${param.searchType == 'domestic' ? 'selected' : ''}>
                                Bảo Hiểm Nội Địa
                            </option>

                            <option value="international" 
                                    ${param.searchType == 'international' ? 'selected' : ''}>
                                Bảo Hiểm Ngoại Địa
                            </option>
                        </select>
                    </div>


                    <div class="form-group price-filter">
                        <label>Lọc theo giá (USD)</label>
                        <div class="price-range">
                            <input type="number" class="form-input" name="minPrice" value="${param.minPrice}" placeholder="Tối thiểu" min="0" step="1">
                            <span>-</span>
                            <input type="number" class="form-input" name="maxPrice" value="${param.maxPrice}" placeholder="Tối đa" min="0" step="1">
                        </div>
                    </div>
                      
                    <!-- Buttons -->
                    <div class="form-buttons">
                        <button type="submit" class="search-btn">Tìm kiếm</button>
                        <a href="InsuranceList" class="search-btn">Xóa bộ lọc</a>
                    </div>
                </form>
            </div>

            <!-- Insurance Grid - Only 2 cards -->
            <div class="insurance-grid" style="grid-template-columns: repeat(2, 1fr); max-width: 1000px; margin: 0 auto;">
                <a href="purchase-insurance?type=domestic" class="insurance-card">
                    <div class="insurance-icon">
                        <img src="https://5.imimg.com/data5/SELLER/Default/2021/10/JQ/QS/XB/8956187/2-1-5-1-domestic-travel-insurance-500x500.jpg" alt="Bảo Hiểm Du Lịch Nội Địa">
                    </div>
                    <span class="insurance-type">bảo hiểm nội địa</span>
                    <div class="insurance-name">Bảo Hiểm Du Lịch Nội Địa</div>
                    <div class="insurance-description">
                        Bảo vệ toàn diện cho chuyến du lịch trong nước với các quyền lợi phù hợp cho hành trình nội địa. Bảo hiểm bao gồm tử vong, thương tật, trách nhiệm cá nhân và nhiều quyền lợi khác.
                    </div>
                    <button class="view-details-btn">Mua Ngay</button>
                </a>

                <a href="purchase-insurance?type=international" class="insurance-card">
                    <div class="insurance-icon">
                        <img src="https://mma.prnewswire.com/media/1453034/Travel_Insured_Intl_Logo.jpg?p=twitter" alt="Bảo Hiểm Du Lịch Ngoại Địa">
                    </div>
                    <span class="insurance-type">bảo hiểm ngoại địa</span>
                    <div class="insurance-name">Bảo Hiểm Du Lịch Ngoại Địa</div>
                    <div class="insurance-description">
                        Bảo vệ toàn diện cho chuyến du lịch quốc tế với các quyền lợi mở rộng cho hành trình nước ngoài. Bao gồm chi phí y tế, hồi hương, hủy chuyến đi và nhiều quyền lợi khác.
                    </div>
                    <button class="view-details-btn">Mua Ngay</button>
                </a>
            </div>
        </div>
                <jsp:include page="./component/footer.jsp"></jsp:include>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="./JS/SweetAlert.js"></script>
    </body>
</html>
