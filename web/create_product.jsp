    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Thêm Sản Phẩm Bảo Hiểm Du Lịch</title>
            <style>
                :root {
                    --primary-yellow: #FFD700;
                    --light-yellow: #FFF9C4;
                    --dark-yellow: #FFC107;
                    --white: #FFFFFF;
                    --text-dark: #333333;
                }

                body {
                    background: linear-gradient(135deg, var(--light-yellow) 0%, var(--white) 100%);
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    color: var(--text-dark);
                    padding: 0;
                }

                .container {
                    max-width: 1200px;
                }

                /* Alert styling - giữ nguyên structure */
                .alert-success {
                    background: linear-gradient(135deg, var(--light-yellow) 0%, #d4edda 100%);
                    border: 2px solid var(--primary-yellow);
                    border-radius: 15px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                }

                /* Form sections - giữ nguyên tất cả class gốc */
                .form-control {
                    border-radius: 8px;
                    border: 1px solid #E0E0E0;
                    padding: 12px 15px;
                    transition: all 0.3s;
                }

                .form-control:focus, .form-select:focus {
                    border-color: var(--primary-yellow);
                    box-shadow: 0 0 0 0.25rem rgba(255, 215, 0, 0.25);
                }

                .form-label {
                    font-weight: 600;
                    color: var(--text-dark);
                }

                /* Custom section styling - THÊM class mới nhưng GIỮ NGUYÊN class cũ */
                .section-wrapper {
                    background: var(--white);
                    border-radius: 15px;
                    padding: 30px;
                    margin-bottom: 25px;
                    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
                    border-left: 4px solid var(--primary-yellow);
                }

                .section-title {
                    color: var(--dark-yellow);
                    font-weight: 700;
                    margin-bottom: 20px;
                    padding-bottom: 10px;
                    border-bottom: 2px solid var(--light-yellow);
                }

                /* Radio button styling */
                .radio-group-custom {
                    display: flex;
                    gap: 20px;
                }

                .radio-group-custom input[type="radio"] {
                    display: none;
                }

                .radio-group-custom label {
                    padding: 10px 25px;
                    border: 2px solid #E0E0E0;
                    border-radius: 8px;
                    cursor: pointer;
                    transition: all 0.3s;
                    font-weight: 500;
                    background: var(--white);
                }

                .radio-group-custom input[type="radio"]:checked + label {
                    border-color: var(--primary-yellow);
                    background-color: var(--light-yellow);
                    color: var(--text-dark);
                }

                /* Button styling */
                .btn-custom {
                    background: linear-gradient(135deg, var(--dark-yellow) 0%, var(--primary-yellow) 100%);
                    border: none;
                    border-radius: 10px;
                    padding: 14px 30px;
                    font-weight: 600;
                    color: var(--text-dark);
                    transition: all 0.3s;
                    box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
                }

                .btn-custom:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(255, 193, 7, 0.4);
                }

                /* Table styling */
                .table-custom {
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                }

                .table-custom thead th {
                    background-color: var(--dark-yellow);
                    color: var(--text-dark);
                    font-weight: 600;
                    border: none;
                    padding: 15px;
                    text-align: center;
                }

                .table-custom tbody td {
                    padding: 12px 15px;
                    vertical-align: middle;
                    border-color: #f0f0f0;
                }

                /* Preview boxes */
                .preview-box {
                    background-color: var(--light-yellow);
                    border-radius: 10px;
                    padding: 20px;
                    margin-top: 15px;
                }

                .coefficient-input {
                    width: 150px;
                    display: inline-block;
                    margin: 0 5px;
                }

                .formula-box {
                    background: #f8f9fa;
                    border-radius: 10px;
                    padding: 20px;
                    margin-bottom: 20px;
                    border-left: 4px solid var(--primary-yellow);
                }


            </style>
        </head>

        <body>
            <div class="container">
                <!--Hiển thị thông báo thêm product thành công - GIỮ NGUYÊN CẤU TRÚC -->
                <c:if test="${not empty notification && not empty img_src 
                              && not empty name && not empty type
                              && not empty package_type && not empty description && not empty price}">
                      <div class="alert alert-success alert-dismissible d-flex justify-content-around align-items-start p-3" role="alert" style="max-width: 100%; overflow-wrap: break-word;">
                          <div class="d-flex flex-column align-items-start me-4" style="max-width: 40%;">
                              <div class="d-flex align-items-center mb-2">
                                  <img src="${img_src}" class="img-fluid img-thumbnail me-3" alt="${img_name}" style="max-width: 80px; max-height: 80px; object-fit: cover;">
                                  <div>
                                      <p class="mb-1"><strong>Tên sản phẩm:</strong> ${name}</p>
                                      <p class="mb-1"><strong>Loại hình:</strong> ${type}</p>
                                      <p class="mb-1"><strong>Gói:</strong> ${package_type}</p>
                                      <p class="mb-0"><strong>Mô tả:</strong> ${description}</p>
                                      <p class="mb-0"><strong>Giá tiền:</strong> ${price} VNĐ</p>
                                  </div>
                              </div>
                          </div>
                          <div class="text-center d-flex flex-column justify-content-center" style="max-width: 50%;">
                              <h3 class="text-success mb-2" style="word-break: break-word;">${notification}</h3>
                              <button type="button" class="btn-close align-self-end" data-bs-dismiss="alert" aria-label="Close"></button>
                          </div>
                      </div>
                </c:if>

                <form class="form form-control" action="${pageContext.request.contextPath}/create_product" enctype="multipart/form-data" method="POST" style="border: none; z-index: 1; background: transparent;">
                    
                    <div class="section-wrapper">
                        <h2 class="section-title"><i class="fas fa-info-circle"></i> Thông tin cơ bản</h2>
                        <div class="row">
                            <div class="col-9 mb-4">
                                <label class="form-label fw-bold text-black" for="name">Tên sản phẩm <span class="text-danger">*</span></label>
                                <input name="name" type="text" class='op0 form-control' id="name" placeholder="Nhập tên sản phẩm...." required="bắt buộc">
                            </div>

                            <div class="col-3 mb-4">
                                <label class="form-label fw-bold text-black">Chọn gói <span class="text-danger">*</span></label>
                                <select name="package_type" class='package_type form-select'>
                                    <option value="basic">Cơ bản</option>
                                    <option value="standard">Tiêu chuẩn</option>
                                    <option value="advanced">Nâng cao</option>
                                    <option value="comprehensive">Toàn diện</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-black">Loại sản phẩm <span class="text-danger">*</span></label>
                            <div class="radio-group-custom">
                                <div>
                                    <input class="domestic_option" type="radio" name="choose" id="option1" value="domestic" checked>
                                    <label for="option1"><i class="fas fa-home"></i> Trong nước</label>
                                </div>
                                <div>
                                    <input class="international_option" type="radio" name="choose" id="option2" value="international">
                                    <label for="option2"><i class="fas fa-globe"></i> Ngoài nước</label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="textarea" class="form-label fw-bold text-black">Mô tả sản phẩm <span class="text-danger">*</span></label>
                            <textarea name="description" class="op01 form-control" rows='8' id="textarea" placeholder="Nhập mô tả cho sản phẩm...." required="Không được bỏ trống"></textarea>
                        </div>

                        <div>
                            <label class="form-label fw-bold text-black" for="formFile">Hình ảnh sản phẩm <span class="text-danger">*</span></label>
                            <input name="img" class='form-control' type="file" id="formFile" accept='image/png, image/jpeg, /image/gif' required>
                            <div class="form-text text-black">Hỗ trợ JPG, PNG, GIF (tối đa 5MB)</div>
                        </div>
                    </div>

                    <!--Quyền lợi trong nước - GIỮ NGUYÊN CLASS, THÊM section-wrapper -->
                    <div class="domestic section-wrapper">
                        <h2 class="section-title"><i class="fas fa-shield-alt"></i> Cấu hình quyền lợi bảo hiểm trong nước</h2>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Tử vong, thương tật vĩnh viễn <span class="text-danger">*</span></label>
                                <input name="deathOrDisability" type="number" class='op1 form-control domestic_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Tử vong do ốm đau, bệnh tật <span class="text-danger">*</span></label>
                                <input name="deathByIllness" type="number" class='op2 form-control domestic_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Trách nhiệm cá nhân đối với bên thứ ba <span class="text-danger">*</span></label>
                                <input name="thirdPartyLiability" type="number" class='op3 form-control domestic_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Bảo hiểm thất lạc thẻ ngân hàng <span class="text-danger">*</span></label>
                                <input name="lostBankCard" type="number" class='op4 form-control domestic_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Bắt cóc và con tin <span class="text-danger">*</span></label>
                                <input name="kidnapHostage" type="number" class='op5 form-control domestic_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Mất hoặc hư hỏng dụng cụ chơi Golf <span class="text-danger">*</span></label>
                                <input name="golfEquipLoss" type="number" class='op6 form-control domestic_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>
                    </div>

                    <!--Quyền lợi ngoài nước - GIỮ NGUYÊN CLASS, THÊM section-wrapper -->
                    <div class="international section-wrapper">
                        <h2 class="section-title"><i class="fas fa-globe-americas"></i> Cấu hình quyền lợi bảo hiểm ngoài nước</h2>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Chi phí y tế <span class="text-danger">*</span></label>
                                <input name="medical_cost" type="number" class='op7 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Chi phí vận chuyển y tế khẩn cấp<span class="text-danger">*</span></label>
                                <input name="emergency_transport" type="number" class='op8 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Hồi hương thi hài về Việt Nam<span class="text-danger">*</span></label>
                                <input name="repatriation_vn" type="number" class='op9 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Hồi hương thi hài về quê hương (ngoài VN)<span class="text-danger">*</span></label>
                                <input name="repatriation_abroad" type="number" class='op10 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Thăm Người được bảo hiểm tại bệnh viện<span class="text-danger">*</span></label>
                                <input name="hospital_visit" type="number" class='op11 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Thăm viếng để thu xếp tang lễ<span class="text-danger">*</span></label>
                                <input name="funeral_arrangement" type="number" class='op12 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Chăm sóc trẻ em<span class="text-danger">*</span></label>
                                <input name="child_care" type="number" class='op13 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Trợ cấp nằm viện<span class="text-danger">*</span></label>
                                <input name="hospital_allowance" type="number" class='op14 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Tử vong và thương tật do tai nạn<span class="text-danger">*</span></label>
                                <input name="accident_death_injury" type="number" class='op15 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Hủy bỏ chuyến đi<span class="text-danger">*</span></label>
                                <input name="trip_cancellation" type="number" class='op15 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Hỗ trợ người đi cùng<span class="text-danger">*</span></label>
                                <input name="companion_support" type="number" class='op16 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Hành lý đến chậm<span class="text-danger">*</span></label>
                                <input name="delayed_baggage" type="number" class='op17 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>

                        <div class="row mb-4 g-5">
                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Giấy tờ đi đường<span class="text-danger">*</span></label>
                                <input name="travel_documents" type="number" class='op18 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>

                            <div class="col-6">
                                <label class="form-label fw-bold text-black">Chuyến đi bị trì hoãn<span class="text-danger">*</span></label>
                                <input name="trip_delay" type="number" class='op19 form-control international_required' min="0" step='100000' placeholder="Nhập số tiền...">
                            </div>
                        </div>
                    </div>

                    <!-- Tính phí trong nước - GIỮ NGUYÊN CLASS, THÊM section-wrapper -->
                    <div class="domestic_preview section-wrapper">
                        <h2 class="section-title"><i class="fas fa-calculator"></i> Tính phí</h2>
                        <div class="formula-box text-center">
                            <h4>Công thức tính phí</h4>
                            <p>Phí = <input class="coefficient_1 form-control coefficient-input" name="coefficient_1" placeholder="Nhập vào hệ số....">% × STBH × Số ngày × Số người</p>
                        </div>

                        <div class="row mt-4">
                            <div class="col-6 text-black">
                                <label class="form-label fw-bold">Số ngày</label>
                                <input class="op20 form-control" type="number" min="0" step="1" placeholder="Nhập vào số ngày....">
                            </div>

                            <div class="col-6 text-black">
                                <label class="form-label fw-bold">Số người</label>
                                <input class="op21 form-control" type="number" min="0" step="1" placeholder="Nhập vào số người...">
                            </div>

                            <div class="col-12 mt-3 text-black">
                                <label class="form-label text-primary fw-bold">Phí dự kiến</label>
                                <p><span class="result">0</span> VNĐ</p>
                                <label class="form-label text-primary fw-bold">Các mục: </label>
                                <p class="result1"></p>
                                <p class="result2"></p>
                                <p class="result3"></p>
                            </div>
                        </div>
                    </div>

                    <!-- Tính phí ngoài nước - GIỮ NGUYÊN CLASS, THÊM section-wrapper -->
                    <div class="international_preview section-wrapper">
                        <h2 class="section-title"><i class="fas fa-calculator"></i> Tính phí</h2>
                        <div class="formula-box text-center">
                            <h4>Công thức tính phí</h4>
                            <p>Phí bảo hiểm = Biểu phí theo ngày x số ngày x số người</p>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-custom">
                                <thead>
                                    <tr>
                                        <th scope="col" class="text-center">Khoảng thời gian</th>
                                        <th scope="col" class="text-center">Gói Cơ bản</th>
                                        <th scope="col" class="text-center">Gói Tiêu chuẩn</th>
                                        <th scope="col" class="text-center">Gói Nâng cao</th>
                                        <th scope="col" class="text-center">Gói Toàn diện</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-center">1-7 ngày</td>
                                        <td class="text-center"><input class="coefficient_2 form-control" name="coefficient_2" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_3 form-control" name="coefficient_3" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_4 form-control" name="coefficient_4" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_5 form-control" name="coefficient_5" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                    </tr>
                                    <tr>
                                        <td class="text-center">8-30 ngày</td>
                                        <td class="text-center"><input class="coefficient_6 form-control" name="coefficient_6" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_7 form-control" name="coefficient_7" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_8 form-control" name="coefficient_8" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_9 form-control" name="coefficient_9" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                    </tr>
                                    <tr>
                                        <td class="text-center">31-90 ngày</td>
                                        <td class="text-center"><input class="coefficient_10 form-control" name="coefficient_10" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_11 form-control" name="coefficient_11" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_12 form-control" name="coefficient_12" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_13 form-control" name="coefficient_13" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                    </tr>
                                    <tr>
                                        <td class="text-center">91-180 ngày</td>
                                        <td class="text-center"><input class="coefficient_14 form-control" name="coefficient_14" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_15 form-control" name="coefficient_15" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_16 form-control" name="coefficient_16" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                        <td class="text-center"><input class="coefficient_17 form-control" name="coefficient_17" placeholder="Nhập vào biểu phí..." step="1000" type="number"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="row mt-4">
                            <div class="col-6 text-black">
                                <label class="form-label fw-bold">Số ngày</label>
                                <input class="op22 form-control" type="number" min="0" step="1" placeholder="Nhập vào số ngày....">
                            </div>

                            <div class="col-6 text-black">
                                <label class="form-label fw-bold">Số người</label>
                                <input class="op23 form-control" type="number" min="0" step="1" placeholder="Nhập vào số người....">
                            </div>

                            <div class="col-12 mt-3 text-black">
                                <label class="form-label text-primary fw-bold">Phí dự kiến</label>
                                <p><span class="result0">0</span> VNĐ</p>
                                <label class="form-label text-primary fw-bold">Các mục: </label>
                                <p class="result4"></p>
                                <p class="result5"></p>
                                <p class="result6"></p>
                            </div>
                        </div>
                    </div>

                    <!-- Nút hành động - GIỮ NGUYÊN CLASS -->
                    <div class="d-flex justify-content-center gap-5 py-3" style="margin: 0 auto; max-width: 600px;">
                        <button type="submit" class="create btn btn-custom fw-bold">
                            Tạo sản phẩm
                        </button>

                        <button type="button" class="btn-result btn btn-custom fw-bold">
                            Tính phí
                        </button>

                        <!--Các input để lấy giá trị-->
                        <input type="hidden" name="price" class="price">
                        <input type="hidden" name="domestic_percentage_rate" class="domestic_percentage_rate">
                        <input type="hidden" name="international_rate_1_7" class="international_rate_1_7">
                        <input type="hidden" name="international_rate_8_30" class="international_rate_8_30">
                        <input type="hidden" name="international_rate_31_90" class="international_rate_31_90">
                        <input type="hidden" name="international_rate_91_180" class="international_rate_91_180">
                    </div>
                </form>
            </div>


            <!-- Xoá các attribute cũ-->
            <%
                if (session.getAttribute("notification") != null &&
                    session.getAttribute("img_src") != null &&
                    session.getAttribute("name") != null &&
                    session.getAttribute("type") != null &&
                    session.getAttribute("package_type") != null &&
                    session.getAttribute("description") != null &&
                    session.getAttribute("price") != null) {
                    session.removeAttribute("notification");
                    session.removeAttribute("img_src");
                    session.removeAttribute("name");
                    session.removeAttribute("type");
                    session.removeAttribute("package_type");
                    session.removeAttribute("description");
                    session.removeAttribute("price");
                }
            %>

            <script>
                const op0 = document.querySelector('.op0');
                const op01 = document.querySelector('.op01');
                const op1 = document.querySelector('.op1');
                const op2 = document.querySelector('.op2');
                const op3 = document.querySelector('.op3');
                const op4 = document.querySelector('.op4');
                const op5 = document.querySelector('.op5');
                const op6 = document.querySelector('.op6');
                const op7 = document.querySelector('.op7');
                const op8 = document.querySelector('.op8');
                const op9 = document.querySelector('.op9');
                const op10 = document.querySelector('.op10');
                const op11 = document.querySelector('.op11');
                const op12 = document.querySelector('.op12');
                const op13 = document.querySelector('.op13');
                const op14 = document.querySelector('.op14');
                const op15 = document.querySelector('.op15');
                const op16 = document.querySelector('.op16');
                const op17 = document.querySelector('.op17');
                const op18 = document.querySelector('.op18');
                const op19 = document.querySelector('.op19');
                const op20 = document.querySelector('.op20');
                const op21 = document.querySelector('.op21');
                const op22 = document.querySelector('.op22');
                const op23 = document.querySelector('.op23');
                const package_type = document.querySelector('.package_type');
                const domestic_option = document.querySelector('.domestic_option');
                const international_option = document.querySelector('.international_option');
                const domestic_div = document.querySelector('.domestic');
                const international_div = document.querySelector('.international');
                const domestic_required = document.querySelectorAll('.domestic_required');
                const international_required = document.querySelectorAll('.international_required');
                const domestic_preview = document.querySelector('.domestic_preview');
                const international_preview = document.querySelector('.international_preview');
                const btn = document.querySelector('.btn-result');
                const form = document.querySelector('.form');
                const result = document.querySelector('.result');
                const result0 = document.querySelector('.result0');
                const result1 = document.querySelector('.result1');
                const result2 = document.querySelector('.result2');
                const result3 = document.querySelector('.result3');
                const result4 = document.querySelector('.result4');
                const result5 = document.querySelector('.result5');
                const result6 = document.querySelector('.result6');
                const coefficient_1 = document.querySelector('.coefficient_1');
                const coefficient_2 = document.querySelector('.coefficient_2');
                const coefficient_3 = document.querySelector('.coefficient_3');
                const coefficient_4 = document.querySelector('.coefficient_4');
                const coefficient_5 = document.querySelector('.coefficient_5');
                const coefficient_6 = document.querySelector('.coefficient_6');
                const coefficient_7 = document.querySelector('.coefficient_7');
                const coefficient_8 = document.querySelector('.coefficient_8');
                const coefficient_9 = document.querySelector('.coefficient_9');
                const coefficient_10 = document.querySelector('.coefficient_10');
                const coefficient_11 = document.querySelector('.coefficient_11');
                const coefficient_12 = document.querySelector('.coefficient_12');
                const coefficient_13 = document.querySelector('.coefficient_13');
                const coefficient_14 = document.querySelector('.coefficient_14');
                const coefficient_15 = document.querySelector('.coefficient_15');
                const coefficient_16 = document.querySelector('.coefficient_16');
                const coefficient_17 = document.querySelector('.coefficient_17');
                let fee = 0;
                let base_price = 0;
                const price = document.querySelector('.price');
                const domestic_percentage_rate = document.querySelector('.domestic_percentage_rate');
                const international_rate_1_7 = document.querySelector('.international_rate_1_7');
                const international_rate_8_30 = document.querySelector('.international_rate_8_30');
                const international_rate_31_90 = document.querySelector('.international_rate_31_90');
                const international_rate_91_180 = document.querySelector('.international_rate_91_180');
    // Hàm thiết lập khi load trang     
                window.onload = function () {
                    // Ẩn tất cả các phần domestic và international
                    domestic_div.style.display = "none";
                    international_div.style.display = "none";
                    domestic_preview.style.display = "none";
                    international_preview.style.display = "none";
                    // Kiểm tra xem cái nào được chọn
                    if (domestic_option.checked) {
                        domestic_div.style.display = "block";
                        domestic_preview.style.display = "block";
                    } else {
                        international_div.style.display = "block";
                        international_preview.style.display = "block";
                    }
                };
                function formatNumber(num) {
                    return num.toLocaleString('vi-VN');
                }


    // Hàm thêm/xóa required cho input
                function setRequired(inputs, isRequired) {
                    inputs.forEach(input => {
                        input.required = isRequired;
                    });
                }


    // Hàm hiển thị form nhập quyền lợi trong nước và ngoài nước
                domestic_option.addEventListener('change', () => {
                    if (domestic_option.checked) {
                        domestic_div.style.display = "block";
                        international_div.style.display = "none";
                        domestic_preview.style.display = "block";
                        international_preview.style.display = "none";
                        setRequired(domestic_required, true);
                        setRequired(international_required, false);
                    }
                });
                international_option.addEventListener('change', () => {
                    if (international_option.checked) {
                        domestic_div.style.display = "none";
                        international_div.style.display = "block";
                        domestic_preview.style.display = "none";
                        international_preview.style.display = "block";
                        setRequired(international_required, true);
                        setRequired(domestic_required, false);
                    }
                });
                
                // Hàm tính toán         
                function calculate() {
                    if (domestic_option.checked) {
                        const value1 = Number(op1.value) === 0 ? 0 : Number(op1.value);
                        const value2 = Number(op2.value) === 0 ? 0 : Number(op2.value);
                        const value3 = Number(op3.value) === 0 ? 0 : Number(op3.value);
                        const value4 = Number(op4.value) === 0 ? 0 : Number(op4.value);
                        const value5 = Number(op5.value) === 0 ? 0 : Number(op5.value);
                        const value6 = Number(op6.value) === 0 ? 0 : Number(op6.value);
                        const value20 = Number(op20.value) === 0 ? 1 : (Number(op20.value));
                        const value21 = Number(op21.value) === 0 ? 1 : Number(op21.value);
                        const coefficient_value_1 = Number(coefficient_1.value) === 0 ? 0 : Number(coefficient_1.value / 100);
                        console.log(coefficient_value_1);
                        if (value1 > 0 && value2 > 0 && value3 > 0 && value4 > 0
                                && value5 > 0 && value6 > 0 && value20 <= 180 && value21 <= 100 && value20 > 0 && value21 > 0
                                && coefficient_value_1 >= 0.0001 && coefficient_value_1 <= 0.1) {
                            let max = Math.max(value1, value2, value3, value4, value5, value6);
                            fee = Number(coefficient_value_1 * max * value20 * value21);
                            base_price = coefficient_value_1 * max;
                            domestic_percentage_rate.value = coefficient_value_1 * 100; // để lại thành giá trị %
                            console.log(domestic_percentage_rate.value);
                            result.textContent = formatNumber(fee);
                            result1.innerText = `Số tiền bảo hiểm(STBH): ` + formatNumber(max) + ' VNĐ';
                            result2.textContent = `Số ngày: ` + formatNumber(value20);
                            result3.textContent = `Số người đi: ` + formatNumber(value21);
                        } else {
                            alert('Vui lòng nhập đầy đủ các trường và đảm bảo số ngày từ 1-180, số người từ 1-100, hệ số từ 0.01% - 10%!');
                            result.textContent = '0';
                            fee = 0; // reset lại
                            base_price = 0;
                        }
                    } else if (international_option.checked) {
                        const value7 = (Number(op7.value) === 0) ? 0 : Number(op7.value);
                        const value8 = (Number(op8.value) === 0) ? 0 : Number(op8.value);
                        const value9 = (Number(op9.value) === 0) ? 0 : Number(op9.value);
                        const value10 = (Number(op10.value) === 0) ? 0 : Number(op10.value);
                        const value11 = (Number(op11.value) === 0) ? 0 : Number(op11.value);
                        const value12 = (Number(op12.value) === 0) ? 0 : Number(op12.value);
                        const value13 = (Number(op13.value) === 0) ? 0 : Number(op13.value);
                        const value14 = (Number(op14.value) === 0) ? 0 : Number(op14.value);
                        const value15 = (Number(op15.value) === 0) ? 0 : Number(op15.value);
                        const value16 = (Number(op16.value) === 0) ? 0 : Number(op16.value);
                        const value17 = (Number(op17.value) === 0) ? 0 : Number(op17.value);
                        const value18 = (Number(op18.value) === 0) ? 0 : Number(op18.value);
                        const value19 = (Number(op19.value) === 0) ? 0 : Number(op19.value);
                        const value22 = (Number(op22.value) === 0) ? 1 : Number(op22.value);
                        const value23 = (Number(op23.value) === 0) ? 1 : Number(op23.value);
                        const coefficient_value_2 = (Number(coefficient_2.value) === 0) ? 0 : Number(coefficient_2.value);
                        const coefficient_value_3 = (Number(coefficient_3.value) === 0) ? 0 : Number(coefficient_3.value);
                        const coefficient_value_4 = (Number(coefficient_4.value) === 0) ? 0 : Number(coefficient_4.value);
                        const coefficient_value_5 = (Number(coefficient_5.value) === 0) ? 0 : Number(coefficient_5.value);
                        const coefficient_value_6 = (Number(coefficient_6.value) === 0) ? 0 : Number(coefficient_6.value);
                        const coefficient_value_7 = (Number(coefficient_7.value) === 0) ? 0 : Number(coefficient_7.value);
                        const coefficient_value_8 = (Number(coefficient_8.value) === 0) ? 0 : Number(coefficient_8.value);
                        const coefficient_value_9 = (Number(coefficient_9.value) === 0) ? 0 : Number(coefficient_9.value);
                        const coefficient_value_10 = (Number(coefficient_10.value) === 0) ? 0 : Number(coefficient_10.value);
                        const coefficient_value_11 = (Number(coefficient_11.value) === 0) ? 0 : Number(coefficient_11.value);
                        const coefficient_value_12 = (Number(coefficient_12.value) === 0) ? 0 : Number(coefficient_12.value);
                        const coefficient_value_13 = (Number(coefficient_13.value) === 0) ? 0 : Number(coefficient_13.value);
                        const coefficient_value_14 = (Number(coefficient_14.value) === 0) ? 0 : Number(coefficient_14.value);
                        const coefficient_value_15 = (Number(coefficient_15.value) === 0) ? 0 : Number(coefficient_15.value);
                        const coefficient_value_16 = (Number(coefficient_16.value) === 0) ? 0 : Number(coefficient_16.value);
                        const coefficient_value_17 = (Number(coefficient_17.value) === 0) ? 0 : Number(coefficient_17.value);
                        let per_day_premium = 0;
                        console.log("fee: " + fee + " and per day_peremium: " + per_day_premium);
                        const per_day_premium_basic = (value22 >= 1 && value22 <= 7) ? coefficient_value_2 :
                                (value22 >= 8 && value22 <= 30) ? coefficient_value_6 :
                                (value22 >= 31 && value22 <= 90) ? coefficient_value_10 :
                                (value22 >= 91 && value22 <= 180) ? 3750 : coefficient_value_14;
                        const per_day_premium_standard = (value22 >= 1 && value22 <= 7) ? coefficient_value_3 :
                                (value22 >= 8 && value22 <= 30) ? coefficient_value_7 :
                                (value22 >= 31 && value22 <= 90) ? coefficient_value_11 :
                                (value22 >= 91 && value22 <= 180) ? coefficient_value_15 : 0;
                        const per_day_premium_advanced = (value22 >= 1 && value22 <= 7) ? coefficient_value_4 :
                                (value22 >= 8 && value22 <= 30) ? coefficient_value_8 :
                                (value22 >= 31 && value22 <= 90) ? coefficient_value_12 :
                                (value22 >= 91 && value22 <= 180) ? coefficient_value_16 : 0;
                        const per_day_premium_comprehensive = (value22 >= 1 && value22 <= 7) ? coefficient_value_5 :
                                (value22 >= 8 && value22 <= 30) ? coefficient_value_9 :
                                (value22 >= 31 && value22 <= 90) ? coefficient_value_13 :
                                (value22 >= 91 && value22 <= 180) ? coefficient_value_17 : 0;
                        if (package_type.value === 'basic') {
                            fee = per_day_premium_basic * value22 * value23;
                            base_price = per_day_premium_basic;
                            international_rate_1_7.value = coefficient_value_2;
                            international_rate_8_30.value = coefficient_value_6;
                            international_rate_31_90.value = coefficient_value_10;
                            international_rate_91_180.value = coefficient_value_14;
                        } else if (package_type.value === 'standard') {
                            fee = per_day_premium_standard * value22 * value23;
                            base_price = per_day_premium_standard;
                             international_rate_1_7.value = coefficient_value_3;
                            international_rate_8_30.value = coefficient_value_7;
                            international_rate_31_90.value = coefficient_value_11;
                            international_rate_91_180.value = coefficient_value_15;
                        } else if (package_type.value === 'advanced') {
                            fee = per_day_premium_advanced * value22 * value23;
                            base_price = per_day_premium_advanced;
                             international_rate_1_7.value = coefficient_value_4;
                            international_rate_8_30.value = coefficient_value_8;
                            international_rate_31_90.value = coefficient_value_12;
                            international_rate_91_180.value = coefficient_value_16;
                        } else if (package_type.value === 'comprehensive') {
                            fee = per_day_premium_comprehensive * value22 * value23;
                            base_price = per_day_premium_comprehensive;
                            international_rate_1_7.value = coefficient_value_5;
                            international_rate_8_30.value = coefficient_value_9;
                            international_rate_31_90.value = coefficient_value_13;
                            international_rate_91_180.value = coefficient_value_17;
                        }

                        if (value7 > 0 && value8 > 0 && value9 > 0 && value10 > 0
                                && value11 > 0 && value12 > 0 && value13 > 0 && value14 > 0
                                && value15 > 0 && value16 > 0 && value17 > 0 && value18 > 0
                                && value19 > 0 && value22 <= 180 && value22 > 0 && value23 > 0
                                && value23 <= 100 && coefficient_value_2 > 0 && coefficient_value_3 > 0
                                && coefficient_value_4 > 0 && coefficient_value_5 > 0 && coefficient_value_6 > 0
                                && coefficient_value_7 > 0 && coefficient_value_8 > 0 && coefficient_value_9 > 0
                                && coefficient_value_10 > 0 && coefficient_value_11 > 0 && coefficient_value_12 > 0
                                && coefficient_value_13 > 0 && coefficient_value_14 > 0 && coefficient_value_15 > 0
                                && coefficient_value_16 > 0 && coefficient_value_17 > 0) {
                            result0.textContent = formatNumber(fee);
                            result4.innerText = `Biểu phí theo ngày/người: ` + formatNumber(base_price) + ' VNĐ';
                            console.log(formatNumber(base_price));
                            result5.textContent = `Số ngày: ` + formatNumber(value22);
                            console.log(value22);
                            result6.textContent = `Số người đi: ` + formatNumber(value23);
                            console.log(value23);
                        } else {
                            alert('Vui lòng nhập đầy đủ các trường và đảm bảo số ngày từ 1-180, số người từ 1-100, Các hệ số phải lớn hơn 0');
                            result.textContent = '0';
                            fee = 0; // reset lại
                            base_price = 0;
                            international_rate_1_7.value = "";
                            international_rate_8_30.value = "";
                            international_rate_31_90.value = "";
                            international_rate_91_180.value = "";
                        }
                    }
                }

    //Hàm tính phí (preview)
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    calculate();
                }
                );

    // Kiểm tra trước khi submit
                form.addEventListener("submit", (e) => {
                    calculate();
                    if (base_price !== 0) {
                        price.value = base_price; // gán giá trị để gửi về servlet
                    } else if (base_price === 0) {
                        e.preventDefault(); // chặn submit
                        alert('Vui lòng nhập đầy đủ các trường và đảm bảo số ngày từ 1-180, số người từ 1-100, Các hệ số phải lớn hơn 0');
                    }
                });

            </script>
        </body>
    </html>
