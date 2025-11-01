package Controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Get parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String cccd = request.getParameter("cccd");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation flags
        boolean hasError = false;
        
        // Validate username
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("usernameError", "Vui lòng nhập tên đăng nhập");
            hasError = true;
        }
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("emailError", "Vui lòng nhập email");
            hasError = true;
        }
        
        // Validate phone
        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("phoneError", "Vui lòng nhập số điện thoại");
            hasError = true;
        }
        
        // Validate CCCD
        if (cccd == null || cccd.trim().isEmpty()) {
            request.setAttribute("cccdError", "Vui lòng nhập số căn cước");
            hasError = true;
        }
        
        // Validate password
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("passwordError", "Mật khẩu không được để trống");
            hasError = true;
        } else if (newPassword.length() < 6) {
            request.setAttribute("passwordError", "Mật khẩu phải có ít nhất 6 ký tự");
            hasError = true;
        }
        
        // Validate confirm password
        if (confirmPassword == null || !confirmPassword.equals(newPassword)) {
            request.setAttribute("confirmPasswordError", "Mật khẩu xác nhận không khớp");
            hasError = true;
        }
        
        // If validation errors, return to forgot password page
        if (hasError) {
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("cccd", cccd);
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Check if user exists and matches all information
        UserDAO userDAO = new UserDAO();
        if (!userDAO.verifyUserInfo(username.trim(), email.trim(), phone.trim(), cccd.trim())) {
            request.setAttribute("forgotPasswordError", "Thông tin không chính xác. Vui lòng kiểm tra lại.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("cccd", cccd);
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Reset password
        boolean success = userDAO.resetPasswordByInfo(username.trim(), email.trim(), phone.trim(), cccd.trim(), newPassword);
        
        if (success) {
            // Password reset successful
            request.setAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Password reset failed
            request.setAttribute("forgotPasswordError", "Có lỗi xảy ra khi đặt lại mật khẩu. Vui lòng thử lại.");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("cccd", cccd);
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}

