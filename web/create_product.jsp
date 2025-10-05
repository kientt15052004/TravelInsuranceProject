<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>FAQ Management</title>
    </head>

    <body>
        <div class="container">
            <!--Hiển thị thông báo thêm product thành công-->
            <c:if test="${not empty notification && not empty img_src 
                          && not empty img_name && not empty img_type
                          && not empty img_package_type && not empty img_description}">
                  <div class="alert alert-success alert-dismissible d-flex justify-content-around align-items-start p-3" role="alert" style="max-width: 100%; overflow-wrap: break-word;">
                      <div class="d-flex flex-column align-items-start me-4" style="max-width: 40%;">
                          <div class="d-flex align-items-center mb-2">
                              <img src="${img_src}" class="img-fluid img-thumbnail me-3" alt="${img_name}" style="max-width: 80px; max-height: 80px; object-fit: cover;">
                              <div>
                                  <p class="mb-1"><strong>Tên sản phẩm:</strong> ${img_name}</p>
                                  <p class="mb-1"><strong>Loại hình:</strong> ${img_type}</p>
                                  <p class="mb-1"><strong>Gói:</strong> ${img_package_type}</p>
                                  <p class="mb-0"><strong>Mô tả:</strong> ${img_description}</p>
                              </div>
                          </div>
                      </div>
                      <div class="text-center d-flex flex-column justify-content-center" style="max-width: 50%;">
                          <h3 class="text-success mb-2" style="word-break: break-word;">${notification}</h3>
                          <button type="button" class="btn-close align-self-end" data-bs-dismiss="alert" aria-label="Close"></button>
                      </div>
                  </div>
            </c:if>
            <form class="form-control" action="${pageContext.request.contextPath}/create_product" enctype="multipart/form-data" method="POST" style=" background: linear-gradient(90deg, #1a1a1a, #3c3c3c); border: none; z-index: 1">
                <div class="p-4  my-5" style="box-shadow: 5px 5px 15px 5px #666666; background: black; border-radius: 25px">
                    <h2 class=" text-primary fw-bold">Thông tin cơ bản</h2>
                    <hr>
                    <div class="row">
                        <div class="col-10 mb-4">
                            <label class="form-label fw-bold text-light" for="name">Tên sản phẩm <span class="text-danger">*</span></label>
                            <input name="name" type="text" class='op0 form-control' id="name" placeholder="Nhập tên sản phẩm...." required="bắt buộc">
                        </div>

                        <div class="col-2 mb-4">
                            <label class="form-label fw-bold text-light">Chọn gói sản phẩm <span class="text-danger">*</span></label>
                            <select name="package_type" class='package_type form-select'>
                                <option value="basic">Cơ bản</option>
                                <option value="standard">Tiêu chuẩn</option>
                                <option value="advanced">Nâng cao</option>
                                <option value="comprehensive">Toàn diện</option>
                            </select>
                        </div>

                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold text-light">Loại sản phẩm <span class="text-danger">*</span></label>
                        <div class="d-flex justify-content-start gap-4 text-light">
                            <div>
                                <input class="domestic_option" type="radio" name="choose" id="option1" value="domestic" checked>
                                <label class="form-label" for="option1">Trong nước</label>
                            </div>

                            <div>
                                <input class="international_option" type="radio" name="choose" id="option2" value="international">
                                <label class="form-label" for="option2">Ngoài nước</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="textarea" class="form-label fw-bold text-light">Mô tả sản phẩm <span class="text-danger">*</span></label>
                        <textarea name="description" class="op01 form-control" rows='8' id="textarea" placeholder="Nhập mô tả cho sản phẩm...." required="Không được bỏ trống"></textarea>
                    </div>

                    <div>
                        <label class="form-label fw-bold text-light" for="formFile">Hình ảnh sản phẩm <span class="text-danger">*</span></label>
                        <input name="img" class='form-control' type="file" id="formFile" accept='image/png, image/jpeg, /image/gif' required>
                        <div class="form-text text-light">Hỗ trợ JPG, PNG, GIF (tối đa 5MB)</div>
                    </div>
                </div>

                <!--Quyền lợi trong nước-->
                <div class="domestic p-4 my-5" style="box-shadow: 5px 5px 15px 5px #666666; background: black; border-radius: 25px">
                    <h2 class=" text-primary fw-bold">Cấu hình quyền lợi bảo hiểm trong nước</h2>
                    <hr>

                    <div class="row  mb-4 g-5">
                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Tử vong, thương tật vĩnh viễn <span class="text-danger">*</span></label>
                            <input name="deathOrDisability" type="number" class='op1 form-control domestic_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Tử vong do ốm đau, bệnh tật <span class="text-danger">*</span></label>
                            <input name="deathByIllness" type="number" class='op2 form-control domestic_required' min="0"  step='1000000'>
                        </div>

                    </div>

                    <div class="row mb-4 g-5">

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Trách nhiệm cá nhân đối với bên thứ ba <span class="text-danger">*</span></label>
                            <input name="thirdPartyLiability" type="number" class='op3 form-control domestic_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Bảo hiểm thất lạc thẻ ngân hàng <span class="text-danger">*</span></label>
                            <input name="lostBankCard" type="number" class='op4 form-control domestic_required' min="0"  step='1000000'>
                        </div>

                    </div>

                    <div class="row mb-4 g-5">

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Bắt cóc và con tin <span class="text-danger">*</span></label>
                            <input name="kidnapHostage" type="number" class='op5 form-control domestic_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Mất hoặc hư hỏng dụng cụ chơi Golf <span class="text-danger">*</span></label>
                            <input name="golfEquipLoss" type="number" class='op6 form-control domestic_required' min="0"  step='1000000'>
                        </div>

                    </div>
                </div>

                <!--Quyền lợi ngoài nước-->
                <div class="international p-4 my-5" style="box-shadow: 5px 5px 15px 5px #666666; background: black; border-radius: 25px">
                    <h2 class=" text-primary fw-bold">Cấu hình quyền lợi bảo hiểm ngoài nước</h2>
                    <hr>

                    <div class="row  mb-4 g-5">
                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Chi phí y tế <span class="text-danger">*</span></label>
                            <input name="medical_cost" type="number" class='op7 form-control international_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Chi phí vận chuyển y tế khẩn cấp<span class="text-danger">*</span></label>
                            <input name="emergency_transport" type="number" class='op8 form-control international_required' min="0"  step='1000000'>
                        </div>

                    </div>

                    <div class="row mb-4 g-5">

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Hồi hương thi hài về Việt Nam<span class="text-danger">*</span></label>
                            <input name="repatriation_vn" type="number" class='op9 form-control international_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Hồi hương thi hài về quê hương (ngoài VN)<span class="text-danger">*</span></label>
                            <input name="repatriation_abroad" type="number" class='op10 form-control international_required' min="0"  step='1000000'>
                        </div>

                    </div>

                    <div class="row mb-4 g-5">

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Thăm Người được bảo hiểm tại bệnh viện<span class="text-danger">*</span></label>
                            <input name="hospital_visit" type="number" class='op11 form-control international_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Thăm viếng để thu xếp tang lễ<span class="text-danger">*</span></label>
                            <input name="funeral_arrangement" type="number" class='op12 form-control international_required' min="0"  step='1000000'>
                        </div>

                    </div>

                    <div class="row  mb-4 g-5">
                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Chăm sóc trẻ em<span class="text-danger">*</span></label>
                            <input name="child_care" type="number" class='op13 form-control international_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Trợ cấp nằm viện<span class="text-danger">*</span></label>
                            <input name="hospital_allowance" type="number" class='op14 form-control international_required' min="0"  step='1000000'>
                        </div>

                    </div>

                    <div class="row mb-4 g-5">

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Tử vong và thương tật do tai nạn<span class="text-danger">*</span></label>
                            <input name="accident_death_injury" type="number" class='op15 form-control international_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Hủy bỏ chuyến đi<span class="text-danger">*</span></label>
                            <input name="trip_cancellation" type="number" class='op15 form-control international_required' min="0"  step='1000000'>
                        </div>

                    </div>

                    <div class="row mb-4 g-5">

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Hỗ trợ người đi cùng<span class="text-danger">*</span></label>
                            <input name="companion_support" type="number" class='op16 form-control international_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Hành lý đến chậm<span class="text-danger">*</span></label>
                            <input name="delayed_baggage" type="number" class='op17 form-control international_required' min="0"  step='1000000'>
                        </div>

                    </div>

                    <div class="row mb-4 g-5">

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Giấy tờ đi đường<span class="text-danger">*</span></label>
                            <input name="travel_documents" type="number" class='op18 form-control international_required' min="0"  step='1000000'>
                        </div>

                        <div class="col-6">
                            <label class="form-label fw-bold text-light">Chuyến đi bị trì hoãn<span class="text-danger">*</span></label>
                            <input name="trip_delay" type="number" class='op19 form-control international_required' min="0"  step='1000000'>
                        </div>

                    </div>
                </div>

                <div class="domestic_preview p-4 my-5" style="box-shadow: 5px 5px 15px 5px #666666;  background: black; border-radius: 25px">
                    <h2 class=" text-primary fw-bold">Tính phí và Preview</h2>
                    <hr> 
                    <div class="rounded text-center text-light border py-3 pt-4 mb-4">
                        <h4>Công thức tính phí</h4>
                        <p>Phí = 0.01% × STBH × Số ngày × Số người</p>
                    </div>

                    <div class="row">
                        <div class="col-6 text-light">
                            <label class="form-label fw-bold">Số ngày</label>
                            <input class="op20 form-control" type="number" min="0" step="1" placeholder="Nhập vào số ngày....">
                        </div>

                        <div class="col-6 text-light">
                            <label class="form-label fw-bold">Số người</label>
                            <input class="op21 form-control" type="number" min="0" " step="1" placeholder="Nhập vào số người...">
                        </div>

                        <div class="col-12 mt-3 text-light">
                            <label class="form-label text-primary fw-bold">Phí dự kiến</label>
                            <p><span class="result">0</span> VNĐ</p>
                            <label class="form-label text-primary fw-bold">Các mục: </label>
                            <p class="result1"></p>
                            <p class="result2"></p>
                            <p class="result3"></p>
                        </div>
                    </div>
                </div>

                <div class="international_preview p-4 my-5" style="box-shadow: 5px 5px 15px 5px #666666;  background: black; border-radius: 25px">
                    <h2 class=" text-primary fw-bold">Tính phí và Preview</h2>
                    <hr> 
                    <div class="rounded text-center text-light border py-3 pt-4 mb-4">
                        <h4>Công thức tính phí</h4>
                        <p>Phí bảo hiểm = Biểu phí theo ngày/người x số ngày x số người</p>
                    </div>
                    <div class="bg-dark p-3 rounded" style="box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);">
                        <table class="table table-dark table-striped table-hover">
                            <thead>
                                <tr>
                                    <th scope="col" class="text-center bg-primary">Khoảng thời gian</th>
                                    <th scope="col" class="text-center bg-primary">Gói Cơ bản</th>
                                    <th scope="col" class="text-center bg-primary">Gói Tiêu chuẩn</th>
                                    <th scope="col" class="text-center bg-primary">Gói Nâng cao</th>
                                    <th scope="col" class="text-center bg-primary">Gói Toàn diện</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-center">1-7 ngày</td>
                                    <td class="text-center">12.500 VND</td>
                                    <td class="text-center">17.500 VND</td>
                                    <td class="text-center">22.500 VND</td>
                                    <td class="text-center">25.000 VND</td>
                                </tr>
                                <tr>
                                    <td class="text-center">8-30 ngày</td>
                                    <td class="text-center">7.500 VND</td>
                                    <td class="text-center">12.500 VND</td>
                                    <td class="text-center">17.500 VND</td>
                                    <td class="text-center">20.000 VND</td>
                                </tr>
                                <tr>
                                    <td class="text-center">31-90 ngày</td>
                                    <td class="text-center">5.000 VND</td>
                                    <td class="text-center">10.000 VND</td>
                                    <td class="text-center">12.500 VND</td>
                                    <td class="text-center">15.000 VND</td>
                                </tr>
                                <tr>
                                    <td class="text-center">91-365 ngày</td>
                                    <td class="text-center">3.750 VND</td>
                                    <td class="text-center">7.500 VND</td>
                                    <td class="text-center">10.000 VND</td>
                                    <td class="text-center">12.500 VND</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="row">
                        <div class="col-6 text-light">
                            <label class="form-label fw-bold">Số ngày</label>
                            <input class="op22 form-control" type="number" min="0" step="1" placeholder="Nhập vào số ngày....">
                        </div>

                        <div class="col-6 text-light">
                            <label class="form-label fw-bold">Số người</label>
                            <input class="op23 form-control" type="number" min="0" step="1" placeholder="Nhập vào số người....">
                        </div>

                        <div class="col-12 mt-3 text-light">
                            <label class="form-label text-primary fw-bold">Phí dự kiến</label>
                            <p><span class="result0">0</span> VNĐ</p>
                            <label class="form-label text-primary fw-bold">Các mục: </label>
                            <p class="result4"></p>
                            <p class="result5"></p>
                            <p class="result6"></p>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-around">
                    <button class="create btn btn-primary fw-bold" type="submit">Tạo sản phẩm</button>
                    <button class="reset btn btn-primary fw-bold" type="button">Làm mới trang</button>
                    <button class="btn-result mx-3 btn btn-primary fw-bold" type="button">Tính phí</button>
                </div>

            </form>
        </div>

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
            const result = document.querySelector('.result');
            const result0 = document.querySelector('.result0');
            const result1 = document.querySelector('.result1');
            const result2 = document.querySelector('.result2');
            const result3 = document.querySelector('.result3');
            const result4 = document.querySelector('.result4');
            const result5 = document.querySelector('.result5');
            const result6 = document.querySelector('.result6');
            const clear = document.querySelector('.reset');
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
                
                if ('${notification}' && '${img_src}'
                        && '${img_name}' && '${img_type}'
                        && '${img_package_type}' && '${img_description}') {
            <% session.removeAttribute("notification"); %>
            <% session.removeAttribute("img_src"); %>
            <% session.removeAttribute("img_name"); %>
            <% session.removeAttribute("img_type"); %>
            <% session.removeAttribute("img_package_type"); %>
            <% session.removeAttribute("img_description"); %>
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
            
//Hàm tính phí (preview)
            btn.addEventListener('click', (e) => {
            e.preventDefault();
                    if (domestic_option.checked) {
            const value1 = isNaN(Number(op1.value)) ? 0 : Number(op1.value);
                    const value2 = isNaN(Number(op2.value)) ? 0 : Number(op2.value);
                    const value3 = isNaN(Number(op3.value)) ? 0 : Number(op3.value);
                    const value4 = isNaN(Number(op4.value)) ? 0 : Number(op4.value);
                    const value5 = isNaN(Number(op5.value)) ? 0 : Number(op5.value);
                    const value6 = isNaN(Number(op6.value)) ? 0 : Number(op6.value);
                    const value20 = isNaN(Number(op20.value)) ? 0 : Number(op20.value);
                    const value21 = isNaN(Number(op21.value)) ? 0 : Number(op21.value);
                    let max = Math.max(value1, value2, value3, value4, value5, value6);
                    let fee = Number(0.0001 * max * value20 * value21);
                    if (value1 !== 0 && value2 !== 0 && value3 !== 0 && value4 !== 0
                            && value5 !== 0 && value6 !== 0 && value20 !== 0 && value20 <= 365 && value21 !== 0 && value21 <= 100) {
            result.textContent = formatNumber(fee);
                    result1.innerText = `Số tiền bảo hiểm(STBH): ` + formatNumber(max) + ' VNĐ';
                    console.log(max);
                    result2.textContent = `Số ngày: ` + formatNumber(value20);
                    console.log(value20);
                    result3.textContent = `Số người đi: ` + formatNumber(value21);
                    console.log(value21);
            } else {
             alert('Vui lòng nhập đầy đủ các trường và đảm bảo số ngày từ 1-365, số người từ 1-100.');
                    result.textContent = '0';
            }
            } else if (international_option.checked) {
            const value7 = isNaN(Number(op7.value)) ? 0 : Number(op7.value);
                    const value8 = isNaN(Number(op8.value)) ? 0 : Number(op8.value);
                    const value9 = isNaN(Number(op9.value)) ? 0 : Number(op9.value);
                    const value10 = isNaN(Number(op10.value)) ? 0 : Number(op10.value);
                    const value11 = isNaN(Number(op11.value)) ? 0 : Number(op11.value);
                    const value12 = isNaN(Number(op12.value)) ? 0 : Number(op12.value);
                    const value13 = isNaN(Number(op13.value)) ? 0 : Number(op13.value);
                    const value14 = isNaN(Number(op14.value)) ? 0 : Number(op14.value);
                    const value15 = isNaN(Number(op15.value)) ? 0 : Number(op15.value);
                    const value16 = isNaN(Number(op16.value)) ? 0 : Number(op16.value);
                    const value17 = isNaN(Number(op17.value)) ? 0 : Number(op17.value);
                    const value18 = isNaN(Number(op18.value)) ? 0 : Number(op18.value);
                    const value19 = isNaN(Number(op19.value)) ? 0 : Number(op19.value);
                    const value22 = isNaN(Number(op22.value)) ? 0 : Number(op22.value);
                    const value23 = isNaN(Number(op23.value)) ? 0 : Number(op23.value);
                    let fee = 0;
                    let per_day_premium = 0;
                    console.log("fee: " + fee + " and per day_peremium: " + per_day_premium);
                    const per_day_premium_basic = (value22 >= 1 && value22 <= 7) ? 12500 : 
                                                  (value22 >= 8 && value22 <= 30) ? 7500 :
                                                  (value22 >= 31 && value22 <= 90) ? 5000 : 
                                                  (value22 >= 91 && value22 <= 365) ? 3750 : 0;

                    const per_day_premium_standard = (value22 >= 1 && value22 <= 7) ? 17500 : 
                                                     (value22 >= 8 && value22 <= 30) ? 12500 :
                                                     (value22 >= 31 && value22 <= 90) ? 10000 : 
                                                     (value22 >= 91 && value22 <= 365) ? 7500 : 0;

                    const per_day_premium_advanced = (value22 >= 1 && value22 <= 7) ? 22500 : 
                                                     (value22 >= 8 && value22 <= 30) ? 17500 :
                                                     (value22 >= 31 && value22 <= 90) ? 12500 : 
                                                     (value22 >= 91 && value22 <= 365) ? 10000 : 0;

                    const per_day_premium_comprehensive = (value22 >= 1 && value22 <= 7) ? 25000 : 
                                                          (value22 >= 8 && value22 <= 30) ? 20000 :
                                                          (value22 >= 31 && value22 <= 90) ? 15000 : 
                                                          (value22 >= 91 && value22 <= 365) ? 12500 : 0;
                    if (package_type.value === 'basic') {
            fee = per_day_premium_basic * value22 * value23;
                    per_day_premium = per_day_premium_basic;
            }
            else if (package_type.value === 'standard'){
            fee = per_day_premium_standard * value22 * value23;
                    per_day_premium = per_day_premium_standard;
            }
            else if (package_type.value === 'advanced'){
            fee = per_day_premium_advanced * value22 * value23;
                    per_day_premium = per_day_premium_advanced;
            }
            else if (package_type.value === 'comprehensive'){
            fee = per_day_premium_comprehensive * value22 * value23;
                    per_day_premium = per_day_premium_comprehensive;
            }

            if (value7 !== 0 && value8 !== 0 && value9 !== 0 && value10 !== 0
                    && value11 !== 0 && value12 !== 0 && value13 !== 0 && value14 !== 0
                    && value15 !== 0 && value16 !== 0 && value17 !== 0 && value18 !== 0
                    && value19 !== 0 && value22 !== 0 && value22 <= 365 && value23 !== 0 && value23 <= 100) {
            result0.textContent = formatNumber(fee);
                    result4.innerText = `Biểu phí theo ngày/người: ` + formatNumber(per_day_premium) + ' VNĐ';
                    console.log(formatNumber(per_day_premium));
                    result5.textContent = `Số ngày: ` + formatNumber(value22);
                    console.log(value22);
                    result6.textContent = `Số người đi: ` + formatNumber(value23);
                    console.log(value23);
            } else {
             alert('Vui lòng nhập đầy đủ các trường và đảm bảo số ngày từ 1-365, số người từ 1-100.');
                    result.textContent = '0';
            }
            }
            }
            );
     
//Clear hết tất cả các trường
                    clear.addEventListener('click', (e) => {
                    e.preventDefault();
                            op0.value = '';
                            op01.value = '';
                            op1.value = '';
                            op2.value = '';
                            op3.value = '';
                            op4.value = '';
                            op5.value = '';
                            op6.value = '';
                            op7.value = '';
                            op8.value = '';
                            op9.value = '';
                            op10.value = '';
                            op11.value = '';
                            op12.value = '';
                            op13.value = '';
                            op14.value = '';
                            op15.value = '';
                            op16.value = '';
                            op17.value = '';
                            op18.value = '';
                            op19.value = '';
                            op20.value = '';
                            op21.value = '';
                            op22.value = '';
                            op23.value = '';
                    });
        </script>
    </body>
</html>
