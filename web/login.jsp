<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Đăng Nhập - Bảo Hiểm Du Lịch</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap 4 CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            body {
                background: linear-gradient(0deg, #faf5c4 0%, #ffe17a 100%);
                min-height: 100vh;
            }
            .login-container {
                max-width: 380px;
                margin: 60px auto;
                background: #fff;
                padding: 38px 28px 18px 28px;
                transition: all 0.3s ease;
            }

            .login-icon {
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
            .login-title {
                font-size: 20px;
                text-align: center;
                font-weight: bold;
                margin-bottom: 5px;
                color: #ffbf00;
            }
            .login-text {
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
            .login-divider {
                text-align: center;
                margin: 17px 0 12px 0;
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
                margin-top: 21px;
                margin-bottom: 3px;
            }
            .forgot-link {
                color: #ffd600;
                font-weight: 500;
                font-size: 14px;
            }
            .sign-up-link {
                color: #ffbf00;
                font-size: 15px;
                font-weight: bold;
            }
            .btn-signin {
                background-color: #ffcc00;
                border: none;
                color: #333;
                font-weight: 600;
                transition: all 0.3s ease;
            }

        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-icon"><i class="fa fa-user"></i></div>
            <div class="login-title">Chào mừng trở lại</div>
            <div class="login-text">Đăng nhập vào tài khoản của bạn để tiếp tục</div>
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label for="username" class="small mb-1">Tên đăng nhập</label>
                    <input type="username" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập của bạn" 
                           value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"/>
                    <% String usernameError = (String) request.getAttribute("usernameError");
                    if (usernameError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= usernameError %></div>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="password" class="small mb-1">Mật khẩu</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu của bạn" 
                               value="<%= request.getAttribute("password") != null ? request.getAttribute("password") : "" %>"/>
                        

                    </div>
                    <% String passwordError = (String) request.getAttribute("passwordError");
                        if (passwordError != null) { %>
                    <div class="text-danger" style="font-size: 13px;"><%= passwordError %></div>
                    <% } %>

                </div>
                <% String loginError = (String) request.getAttribute("loginError");
                    if (loginError != null) { %>
                <div class="alert alert-danger mt-2"><%= loginError %></div>
                <% } %>
                <% String success = (String) request.getAttribute("success");
                    if (success != null) { %>
                <div class="alert alert-success mt-2"><%= success %></div>
                <% } %>
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <a class="forgot-link" href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                </div>
                <button class="btn btn-yellow btn-block mb-2 btn-signin" type="submit">
                    <i class="fa fa-sign-in mr-1"></i> Đăng nhập
                </button>
                <div class="text-center mt-2" style="font-size: 14px;">
                    Chưa có tài khoản?
                    <a class="sign-up-link" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                </div>
            </form>
        </div>

        <!-- Bootstrap 4 JS & dependencies -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    </body>
</html>
