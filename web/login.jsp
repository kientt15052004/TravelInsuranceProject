<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Login - Travel Insurance Tracker</title>
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
                border-radius: 12px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.12);
                padding: 38px 28px 18px 28px;
                transition: all 0.3s ease; /* thêm hiệu ứng mượt */
            }
            .login-container:hover {
                transform: translateY(-5px); /* nổi lên */
                box-shadow: 0 12px 36px rgba(0,0,0,0.2); /* bóng đổ đậm hơn */
                background: #fffef5; /* hơi sáng hơn 1 chút */
            }

            .login-icon {
                width: 48px;
                height: 48px;
                background: #ffd600;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 16px auto;
                font-size: 25px;
                color: #fff;
                box-shadow: 0 2px 8px rgba(31, 38, 135, 0.08);
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
            .btn-yellow:hover, .btn-yellow:focus {
                background: #ffcf00;
                color: #111;
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
            .forgot-link:hover {
                text-decoration: underline;
                color: #ffcf00;
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
                transition: all 0.3s ease; /* hiệu ứng mượt */
            }

            .btn-signin:hover {
                background-color: #e6b800; /* đổi màu khi hover */
                color: #fff;               /* đổi màu chữ */
                transform: translateY(-2px); /* nổi lên nhẹ */
                box-shadow: 0 4px 12px rgba(0,0,0,0.2); /* thêm bóng đổ */
            }

        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-icon"><span>&#9889;</span></div>
            <div class="login-title">Welcome Back</div>
            <div class="login-text">Sign in to your account to continue</div>
            <form>
                <div class="form-group">
                    <label for="username" class="small mb-1">Username</label>
                    <input type="username" class="form-control" id="username" placeholder="Enter your username"/>
                </div>
                <div class="form-group">
                    <label for="password" class="small mb-1">Password</label>
                    <div class="input-group">
                        <input type="password" class="form-control" id="password" placeholder="Enter your password"/>
                        <div class="input-group-append">
                            <span class="input-group-text" style="background: #fff;"><i class="fa fa-eye"></i></span>
                        </div>
                    </div>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="rememberMe"/>
                        <label class="form-check-label small" for="rememberMe">Remember me</label>
                    </div>
                    <a class="forgot-link" href="#">Forgot password?</a>
                </div>
                <button class="btn btn-yellow btn-block mb-2 btn-signin" type="submit">
                    <i class="fa fa-sign-in mr-1"></i> Sign in
                </button>
                <div class="login-divider">Or continue with</div>
                <div class="d-flex justify-content-between">
                    <button type="button" class="btn btn-social"><img src="https://img.icons8.com/color/16/000000/google-logo.png"/> Google</button>
                    <button type="button" class="btn btn-social"><img src="https://img.icons8.com/ios-glyphs/16/000000/github.png"/> GitHub</button>
                </div>
                <div class="text-center mt-2" style="font-size: 14px;">
                    Don't have an account?
                    <a class="sign-up-link" href="#">Sign up</a>
                </div>
            </form>
        </div>
        <div class="footer-text">
            By signing in, you agree to our <a href="#" class="sign-up-link">Terms of Service</a> and <a href="#" class="sign-up-link">Privacy Policy</a>.
        </div>

        <!-- Bootstrap 4 JS & dependencies -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    </body>
</html>
