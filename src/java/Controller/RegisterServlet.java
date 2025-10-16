/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import util.Validation;
import Model.User;
import dal.UserDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String dob = request.getParameter("dob");
        String address = request.getParameter("address");

        boolean hasError = false;

        // giữ lại dữ liệu nhập
        request.setAttribute("username", username);
        request.setAttribute("fullname", fullname);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("password", password);
        request.setAttribute("dob", dob);
        request.setAttribute("address", address);
        
        //validate
        if (!Validation.isValidUsername(username)) {
            request.setAttribute("usernameError", "Tên đăng nhập không hợp lệ (6-20 ký tự, chỉ chữ và số).");
            hasError = true;
        }
        if (!Validation.isValidFullname(fullname)) {
            request.setAttribute("fullnameError", "Họ tên chỉ chứa chữ cái và khoảng trắng (2-50 ký tự).");
            hasError = true;
        }
        if (!Validation.isValidEmail(email)) {
            request.setAttribute("emailError", "Email không hợp lệ (Phải bao gồm @gmail.com).");
            hasError = true;
        }
        if (!Validation.isValidPhone(phone)) {
            request.setAttribute("phoneError", "Số điện thoại không hợp lệ.");
            hasError = true;
        }
        if (!Validation.isValidPassword(password)) {
            request.setAttribute("passwordError", "Mật khẩu phải >= 6 ký tự, có ít nhất 1 chữ và 1 số.");
            hasError = true;
        }
        if (!Validation.isValidDob(dob)) {
            request.setAttribute("dobError", "Ngày sinh không hợp lệ hoặc bạn chưa đủ 18 tuổi.");
            hasError = true;
        }
        if (!Validation.isValidAddress(address)) {
            request.setAttribute("addressError", "Địa chỉ phải có ít nhất 5 ký tự.");
            hasError = true;
        }

        // Nếu có lỗi =>> quay lại register.jsp
        if (hasError) {
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check trùng username
        UserDAO dao = new UserDAO();
        if (dao.checkUserExists(username)) {
            request.setAttribute("usernameError", "Tên đăng nhập đã tồn tại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Tạo user mới
        User u = new User();
        u.setUsername(username);
        u.setFullname(fullname);
        u.setMail(email);
        u.setPhone(phone);
        u.setPassword(password); // TODO: nên hash trước khi lưu
        u.setDob(LocalDate.parse(dob));
        u.setAddress(address);
        u.setRole("user");
        u.setStatus("active");

        dao.insertUser(u);

        // Sau khi đăng ký thành công -> redirect sang login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
