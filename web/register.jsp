<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Register - Travel Insurance Tracker</title>
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
                border-radius: 12px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.12);
                padding: 35px 28px 22px 28px;
                transition: all 0.3s ease;
            }
            .register-container:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 36px rgba(0,0,0,0.2);
                background: #fffef5;
            }
            .register-icon {
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
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
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
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="register-container">
            <div class="register-icon"><i class="fa fa-user"></i></div>
            <div class="register-title">Create Your Account</div>
            <div class="register-text">Join us today and get started with your journey</div>


            <form>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label class="small">Username</label>
                        <input type="text" class="form-control" placeholder="Enter your username"/>
                    </div>
                    <div class="form-group col-md-6">
                        <label class="small">Full Name</label>
                        <input type="text" class="form-control" placeholder="Enter your full name"/>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label class="small">Email Address</label>
                        <input type="email" class="form-control" placeholder="Enter your email"/>
                    </div>
                    <div class="form-group col-md-6">
                        <label class="small">Phone Number</label>
                        <input type="text" class="form-control" placeholder="Enter your phone number"/>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label class="small">Password</label>
                        <input type="password" class="form-control" placeholder="Enter your password"/>
                    </div>
                    <div class="form-group col-md-6">
                        <label class="small">Date of Birth</label>
                        <input type="date" class="form-control"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="small">Address</label>
                    <input type="text" class="form-control" placeholder="Enter your full address"/>
                </div>

                <div class="form-check mb-3">
                    <input type="checkbox" class="form-check-input" id="agree"/>
                    <label class="form-check-label small" for="agree">
                        I agree to the <a href="#" class="sign-in-link">Terms of Service</a> and <a href="#" class="sign-in-link">Privacy Policy</a>
                    </label>
                </div>

                <button type="submit" class="btn btn-yellow btn-block">Create Account</button>

                <div class="text-center mt-3" style="font-size: 14px;">
                    Already have an account? <a href="login.jsp" class="sign-in-link">Sign in here</a>
                </div>

                <!-- Social login đưa vào trong form -->
                <div class="social-divider">Or register with</div>
                <div class="d-flex justify-content-between">
                    <button type="button" class="btn btn-social">
                        <img src="https://img.icons8.com/color/16/google-logo.png"/> Google
                    </button>
                    <button type="button" class="btn btn-social">
                        <img src="https://img.icons8.com/color/16/facebook.png"/> Facebook
                    </button>
                </div>
            </form>
        </div>

        <!-- Bootstrap JS & dependencies -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    </body>
</html>
