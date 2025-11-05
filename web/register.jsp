<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng Ký - Bảo Hiểm Du Lịch</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            body {
                background: linear-gradient(0deg, #faf5c4 0%, #ffe17a 100%);
                min-height: 100vh;
            }
            .register-container {
                max-width: 480px;
                margin: 50px auto;
                background: #fff;
                padding: 35px 28px 22px 28px;
                transition: all 0.3s ease;
            }
            .register-container:hover {
                transform: translateY(-5px);
                background: #fffef5;
            }
            .register-icon {
                width: 48px;
                height: 48px;
                background: #ffd600;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 16px auto;
                font-size: 25px;
                color: #fff;
            }
            .register-title {
                font-size: 22px;
                text-align: center;
                font-weight: bold;
                margin-bottom: 5px;
                color: #ffbf00;
            }
            .register-text {
                text-align: center;
                color: #888;
                font-size: 15px;
                margin-bottom: 20px;
            }
            .btn-yellow {
                background: #ffd600;
                border: none;
                color: #000;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            .btn-yellow:hover {
                background: #e6b800;
                color: #fff;
                transform: translateY(-2px);
            }
            .social-divider {
                text-align: center;
                margin: 20px 0 12px 0;
                color: #bbb;
                font-size: 14px;
            }
            .btn-social {
                border: 1px solid #eee;
                background: #f9f9f9;
                color: #444;
                width: 49%;
                margin-bottom: 8px;
            }
            .footer-text {
                text-align: center;
                font-size: 13px;
                color: #bbb;
                margin-top: 18px;
            }
            .sign-in-link {
                color: #ffbf00;
                font-size: 15px;
                font-weight: bold;
            }
            .btn-register {
                background-color: #ffcc00;
                border: none;
                color: #333;
                font-weight: 600;
                transition: all 0.3s ease;
            }
        </style>
    </head>
    <body>
        <div class="register-container">
            <div class="register-icon"><i class="fa fa-user"></i></div>
            <div class="register-title">Tạo tài khoản mới</div>
            <div class="register-text">Điền thông tin để đăng ký tài khoản</div>
            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label for="username" class="small mb-1">Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" 
                           value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required/>
                    <% String usernameError = (String) request.getAttribute("usernameError");
                    if (usernameError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= usernameError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="password" class="small mb-1">Mật khẩu <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" 
                           required/>
                    <% String passwordError = (String) request.getAttribute("passwordError");
                    if (passwordError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= passwordError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="small mb-1">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" 
                           required/>
                    <% String confirmPasswordError = (String) request.getAttribute("confirmPasswordError");
                    if (confirmPasswordError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= confirmPasswordError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="fullname" class="small mb-1">Họ và tên <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fullname" name="fullname" placeholder="Nhập họ và tên" 
                           value="<%= request.getAttribute("fullname") != null ? request.getAttribute("fullname") : "" %>" required/>
                </div>
                
                <div class="form-group">
                    <label for="mail" class="small mb-1">Email <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" id="mail" name="mail" placeholder="Nhập email" 
                           value="<%= request.getAttribute("mail") != null ? request.getAttribute("mail") : "" %>" required/>
                    <% String mailError = (String) request.getAttribute("mailError");
                    if (mailError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= mailError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="phone" class="small mb-1">Số điện thoại <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="phone" name="phone" placeholder="Nhập số điện thoại" 
                           value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required/>
                </div>
                
                <div class="form-group">
                    <label for="dob" class="small mb-1">Ngày sinh</label>
                    <input type="date" class="form-control" id="dob" name="dob" 
                           value="<%= request.getAttribute("dob") != null ? request.getAttribute("dob") : "" %>"/>
                </div>
                
                <div class="form-group">
                    <label for="address" class="small mb-1">Địa chỉ</label>
                    <input type="text" class="form-control" id="address" name="address" placeholder="Nhập địa chỉ" 
                           value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>"/>
                </div>
                
                <% String registerError = (String) request.getAttribute("registerError");
                    if (registerError != null) { %>
                <div class="alert alert-danger mt-2"><%= registerError %></div>
                <% } %>
                
                <button class="btn btn-yellow btn-block mb-2 btn-register" type="submit">
                    <i class="fa fa-user-plus mr-1"></i> Đăng ký
                </button>
                <div class="text-center mt-2" style="font-size: 14px;">
                    Đã có tài khoản?
                    <a class="sign-in-link" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                </div>
            </form>
        </div>

        <!-- Bootstrap 4 JS & dependencies -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
        
        <script>
            // Validate password match
            document.getElementById('confirmPassword').addEventListener('blur', function() {
                var password = document.getElementById('password').value;
                var confirmPassword = this.value;
                
                if (password !== confirmPassword) {
                    this.setCustomValidity('Mật khẩu không khớp');
                } else {
                    this.setCustomValidity('');
                }
            });
        </script>
    </body>
</html>

