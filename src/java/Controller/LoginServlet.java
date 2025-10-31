/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.User;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.UserDAO;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        //pass thì k nên lưu (optional)
        String password = request.getParameter("password");

        boolean hasError = false;

        request.setAttribute("username", username);
        request.setAttribute("password", password);

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("usernameError", "Vui lòng nhập tên đăng nhập.");
            hasError = true;
        }
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Vui lòng nhập mật khẩu.");
            hasError = true;
        }

        if (hasError) {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        User user = dao.getUserByCredentials(username, password);

        if (user == null) {
            request.setAttribute("loginError", "Sai tên đăng nhập hoặc mật khẩu.");
            request.setAttribute("username", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (!"active".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("loginError", "Tài khoản của bạn chưa được kích hoạt. Vui lòng liên hệ quản trị viên.");
            request.setAttribute("username", username);
            request.setAttribute("password", password);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("loginMessage", "Chào mừng, " + user.getFullname() + "!");

        // Redirect based on user role
        if ("staff".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staff");
        } else if ("admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin?tab=home");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
