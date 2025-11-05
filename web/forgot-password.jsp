<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quên Mật Khẩu - Bảo Hiểm Du Lịch</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            body {
                background: linear-gradient(0deg, #faf5c4 0%, #ffe17a 100%);
                min-height: 100vh;
            }
            .forgot-password-container {
                max-width: 480px;
                margin: 40px auto;
                background: #fff;
                padding: 38px 28px 18px 28px;
                transition: all 0.3s ease;
            }

            .forgot-password-icon {
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
            .forgot-password-title {
                font-size: 20px;
                text-align: center;
                font-weight: bold;
                margin-bottom: 5px;
                color: #ffbf00;
            }
            .forgot-password-text {
                text-align: center;
                color: #888;
                font-size: 15px;
                margin-bottom: 17px;
            }
            .btn-yellow {
                background: #ffd600;
                border: none;
                color: #000;
                font-weight: 600;
            }
            .sign-in-link {
                color: #ffbf00;
                font-size: 15px;
                font-weight: bold;
            }
            .btn-reset {
                background-color: #ffcc00;
                border: none;
                color: #333;
                font-weight: 600;
                transition: all 0.3s ease;
            }
        </style>
    </head>
    <body>
        <div class="forgot-password-container">
            <div class="forgot-password-title">Quên Mật Khẩu</div>
            <div class="forgot-password-text">Nhập thông tin tài khoản để đặt lại mật khẩu</div>
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <div class="form-group">
                    <label for="username" class="small mb-1">Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="username" name="username" 
                           placeholder="Nhập tên đăng nhập" 
                           value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required/>
                    <% String usernameError = (String) request.getAttribute("usernameError");
                    if (usernameError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= usernameError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="email" class="small mb-1">Email <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" id="email" name="email" 
                           placeholder="Nhập email" 
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required/>
                    <% String emailError = (String) request.getAttribute("emailError");
                    if (emailError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= emailError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="phone" class="small mb-1">Số điện thoại <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="phone" name="phone" 
                           placeholder="Nhập số điện thoại" 
                           value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required/>
                    <% String phoneError = (String) request.getAttribute("phoneError");
                    if (phoneError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= phoneError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="cccd" class="small mb-1">Số căn cước <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="cccd" name="cccd" 
                           placeholder="Nhập số căn cước" 
                           value="<%= request.getAttribute("cccd") != null ? request.getAttribute("cccd") : "" %>" required/>
                    <% String cccdError = (String) request.getAttribute("cccdError");
                    if (cccdError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= cccdError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="newPassword" class="small mb-1">Mật khẩu mới <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                           placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" required/>
                    <% String passwordError = (String) request.getAttribute("passwordError");
                    if (passwordError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= passwordError %></div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="small mb-1">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                           placeholder="Nhập lại mật khẩu mới" required/>
                    <% String confirmPasswordError = (String) request.getAttribute("confirmPasswordError");
                    if (confirmPasswordError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= confirmPasswordError %></div>
                    <% } %>
                </div>
                
                <% String forgotPasswordError = (String) request.getAttribute("forgotPasswordError");
                    if (forgotPasswordError != null) { %>
                <div class="alert alert-danger mt-2"><%= forgotPasswordError %></div>
                <% } %>
                
                <button class="btn btn-yellow btn-block mb-2 btn-reset" type="submit">
                    Đặt Lại Mật Khẩu
                </button>
                <div class="text-center mt-2" style="font-size: 14px;">
                    <a class="sign-in-link" href="${pageContext.request.contextPath}/login.jsp">
                        Quay lại đăng nhập
                    </a>
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
                var password = document.getElementById('newPassword').value;
                var confirmPassword = this.value;
                
                if (password !== confirmPassword) {
                    this.setCustomValidity('Mật khẩu không khớp');
                } else {
                    this.setCustomValidity('');
                }
            });
            
            // Validate password length
            document.getElementById('newPassword').addEventListener('input', function() {
                if (this.value.length > 0 && this.value.length < 6) {
                    this.setCustomValidity('Mật khẩu phải có ít nhất 6 ký tự');
                } else {
                    this.setCustomValidity('');
                }
            });
        </script>
    </body>
</html>

