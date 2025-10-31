/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import Model.User;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/ChangePasswordServlet"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("swalMessage", "New password and confirm password do not match!");
            request.setAttribute("swalIcon", "error");
            request.getRequestDispatcher("home.jsp").forward(request, response);
            return;
        }

        // Gọi DAO đổi mật khẩu
        UserDAO dao = new UserDAO();
        boolean success = dao.changePassword(user.getId(), currentPassword, newPassword);

        if (success) {
            user.setPassword(newPassword); // cập nhật session
            session.setAttribute("user", user);

            request.setAttribute("swalMessage", "Password changed successfully!");
            request.setAttribute("swalIcon", "success");
        } else {
            request.setAttribute("swalMessage", "Current password is incorrect!");
            request.setAttribute("swalIcon", "error");
        }

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
