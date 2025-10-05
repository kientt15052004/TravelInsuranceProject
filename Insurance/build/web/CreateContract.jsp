<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en" style="height: 100vh">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản Lý Hợp Đồng</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="CSS/Staff.css">
        <style>
            .sidebar {
                background: #f8f9fa;
                box-shadow: 2px 0 15px rgba(0, 0, 0, 0.1);
                border-right: 1px solid #e0e0e0;
                position: relative;
            }
            
            .sidebar::before {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                width: 1px;
                height: 100%;
                background: linear-gradient(to bottom, transparent, #e0e0e0, transparent);
            }
            
            .sidebar li {
                margin: 5px 10px;
                border-radius: 8px;
                transition: all 0.3s ease;
                position: relative;
            }
            
            .sidebar li:hover {
                background: #ffd700;
                color: #333;
                font-weight: 500;
                box-shadow: 0 2px 8px rgba(255, 215, 0, 0.3);
                transform: translateX(3px);
            }
            
            .sidebar li:hover::before {
                content: '';
                position: absolute;
                left: -10px;
                top: 50%;
                transform: translateY(-50%);
                width: 3px;
                height: 60%;
                background: #ffd700;
                border-radius: 0 3px 3px 0;
            }
        </style>
    </head>
    <body style="height: 100vh">
        <div class="container-fluid d-flex justify-content-between" style="position: fixed; background: #fff700; border-bottom: 1px solid #e0e0e0; z-index: 999">
            <h1 style="font-family: serif; font-style: italic; letter-spacing: 5px; color: #333"><i class="fas fa-suitcase mx-3" style="color: #ffd700"></i>TIS</h1>
            <div class="dropdown">
                <button type="button" class="btn dropdown-toggle" data-bs-toggle="dropdown" style="color: #666; border: none; background: transparent">
                    <i class="fa-solid fa-bars" style="font-size: 30px; text-align: end; color: #666"></i>
                </button>

                <ul class="dropdown-menu" style="z-index: 1000">
                    <li><a class="dropdown-item" href="#">Profile</a></li>
                    <li><a class="dropdown-item" href="#">Settings</a></li>
                    <li><a class="dropdown-item" href="#">Sign out</a></li>
                </ul>
            </div>
        </div>

        <div class="row" style="height: 100vh">
            <div class="col-2 position-fixed sidebar" style="margin-top: 57.5px; height: 100vh; padding: 0; z-index: 100">
                <ul class="list-unstyled">
                    <a class="text-decoration-none text-reset" href="/Insurance/Staff"><li class="py-3 text-center fs-5" style="color: #666; font-weight: 400;">Dashboard</li></a>
                    <a class="text-decoration-none text-reset" href="/Insurance/Staff/CreateContract"><li class="py-3 text-center fs-5" style="color: #333; font-weight: 600; background: #ffd700;">Tạo Hợp Đồng</li></a>
                    <a class="text-decoration-none text-reset" href="/Insurance/Staff/ContractManagement"><li class="py-3 text-center fs-5" style="color: #666; font-weight: 400">Quản Lý Hợp Đồng</li></a>
                </ul>
            </div>

            <div class="col-10 container px-5 position-relative" style="margin-top: 57.5px; height: calc(100vh -57.5px); margin-left: 308px; width: calc(100vw - 308px); background: white; z-index: 888; overflow-y: auto;">
                
                <div class="py-4">
                    <h2 class="mb-4"><i class="fas fa-file-contract me-3" style="color: #ffd700"></i>Tạo Hợp Đồng Bảo Hiểm</h2>
                    
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/CreateContractServlet" method="POST" class="needs-validation" novalidate>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0"><i class="fas fa-user me-2"></i>Thông tin khách hàng</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label for="fullname" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="fullname" name="fullname" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                            <input type="email" class="form-control" id="email" name="email" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="phone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                            <input type="tel" class="form-control" id="phone" name="phone" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="cccd" class="form-label">CCCD/CMND <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="cccd" name="cccd" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="address" class="form-label">Địa chỉ</label>
                                            <textarea class="form-control" id="address" name="address" rows="2"></textarea>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="dob" class="form-label">Ngày sinh</label>
                                            <input type="date" class="form-control" id="dob" name="dob">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header bg-success text-white">
                                        <h5 class="mb-0"><i class="fas fa-shield-alt me-2"></i>Thông tin bảo hiểm</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label for="productId" class="form-label">Sản phẩm bảo hiểm <span class="text-danger">*</span></label>
                                            <select class="form-select" id="productId" name="productId" required>
                                                <option value="">-- Chọn sản phẩm bảo hiểm --</option>
                                                <c:forEach var="product" items="${products}">
                                                    <option value="${product.id}">${product.name} - ${product.type}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="destination" class="form-label">Điểm đến</label>
                                            <input type="text" class="form-control" id="destination" name="destination" placeholder="Ví dụ: Thái Lan, Singapore...">
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="startDate" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                                <input type="date" class="form-control" id="startDate" name="startDate" required>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="endDate" class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                                <input type="date" class="form-control" id="endDate" name="endDate" required>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="travelersQuantity" class="form-label">Số lượng người tham gia <span class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="travelersQuantity" name="travelersQuantity" min="1" value="1" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="contractDescription" class="form-label">Mô tả hợp đồng</label>
                                            <textarea class="form-control" id="contractDescription" name="contractDescription" rows="3" placeholder="Mô tả chi tiết về hợp đồng bảo hiểm..."></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="text-center">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>Tạo Hợp Đồng
                            </button>
                            <button type="reset" class="btn btn-secondary btn-lg ms-3">
                                <i class="fas fa-undo me-2"></i>Làm mới
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    </body>
</html>