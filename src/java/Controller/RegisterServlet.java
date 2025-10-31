package Controller;

import dal.UserDAO;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Get parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullname = request.getParameter("fullname");
        String mail = request.getParameter("mail");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");
        String address = request.getParameter("address");
        
        // Validation flags
        boolean hasError = false;
        
        // Validate username
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("usernameError", "Tên đăng nhập không được để trống");
            hasError = true;
        }
        
        // Validate password
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Mật khẩu không được để trống");
            hasError = true;
        } else if (password.length() < 6) {
            request.setAttribute("passwordError", "Mật khẩu phải có ít nhất 6 ký tự");
            hasError = true;
        }
        
        // Validate confirm password
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            request.setAttribute("confirmPasswordError", "Mật khẩu xác nhận không khớp");
            hasError = true;
        }
        
        // Validate fullname
        if (fullname == null || fullname.trim().isEmpty()) {
            request.setAttribute("fullnameError", "Họ và tên không được để trống");
            hasError = true;
        }
        
        // Validate email
        if (mail == null || mail.trim().isEmpty()) {
            request.setAttribute("mailError", "Email không được để trống");
            hasError = true;
        }
        
        // Validate phone
        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("phoneError", "Số điện thoại không được để trống");
            hasError = true;
        }
        
        // If validation errors, return to register page
        if (hasError) {
            // Keep form values
            request.setAttribute("username", username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("mail", mail);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("address", address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if username already exists
        UserDAO userDAO = new UserDAO();
        if (userDAO.checkUserExists(username)) {
            request.setAttribute("usernameError", "Tên đăng nhập đã tồn tại");
            request.setAttribute("username", username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("mail", mail);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("address", address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userDAO.checkEmailExists(mail)) {
            request.setAttribute("mailError", "Email đã được sử dụng");
            request.setAttribute("username", username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("mail", mail);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("address", address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Parse date of birth
        LocalDate dob = null;
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                dob = LocalDate.parse(dobStr);
            } catch (Exception e) {
                // Invalid date format, continue without DOB
            }
        }
        
        // Create new user
        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password);
        newUser.setFullname(fullname.trim());
        newUser.setMail(mail.trim());
        newUser.setDob(dob);
        newUser.setPhone(phone.trim());
        newUser.setAddress(address != null ? address.trim() : null);
        newUser.setCccd(null); // CCCD is optional during registration
        newUser.setAvatar(null);
        newUser.setRole("customer"); // Default role is customer
        newUser.setCccd_img(null);
        newUser.setStatus("active"); // New users are active by default
        
        // Insert user into database
        int userId = userDAO.insertUser(newUser);
        
        if (userId > 0) {
            // Registration successful
            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Registration failed
            request.setAttribute("registerError", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại.");
            request.setAttribute("username", username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("mail", mail);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("address", address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

