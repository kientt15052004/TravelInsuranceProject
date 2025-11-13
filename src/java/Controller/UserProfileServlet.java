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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.time.LocalDate;


@WebServlet(name = "UserProfileServlet", urlPatterns = {"/UpdateProfileServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)    // 50MB
public class UserProfileServlet extends HttpServlet {

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

        // Lấy dữ liệu từ form
        user.setFullname(request.getParameter("fullname"));
        user.setMail(request.getParameter("mail"));
        user.setDob(request.getParameter("dob") != null && !request.getParameter("dob").isEmpty()
                ? LocalDate.parse(request.getParameter("dob")) : null);
        user.setAddress(request.getParameter("address"));
        user.setPhone(request.getParameter("phone"));
        user.setCccd(request.getParameter("cccd"));

        // Xử lý upload avatar
        Part avatarPart = request.getPart("avatar");
        if (avatarPart != null && avatarPart.getSize() > 0) {
            String contentType = avatarPart.getContentType();
            if (contentType.startsWith("image/")) { // chỉ nhận file image
                String avatarFileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/uploads/avatars/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                avatarPart.write(uploadPath + File.separator + avatarFileName);
                user.setAvatar("uploads/avatars/" + avatarFileName);
            } else {
                request.setAttribute("swalMessage", "Tệp ảnh đại diện phải là hình ảnh!");
                request.setAttribute("swalIcon", "error");
                request.getRequestDispatcher("home.jsp").forward(request, response);
                return;
            }
        }

        // Xử lý upload CCCD image
        Part cccdPart = request.getPart("cccd_img");
        if (cccdPart != null && cccdPart.getSize() > 0) {
            String contentType = cccdPart.getContentType();
            if (contentType.startsWith("image/")) { // chỉ nhận file image
                String cccdFileName = Paths.get(cccdPart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/uploads/cccd/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                cccdPart.write(uploadPath + File.separator + cccdFileName);
                user.setCccd_img("uploads/cccd/" + cccdFileName);
            } else {
                request.setAttribute("swalMessage", "Tệp CCCD phải là hình ảnh!");
                request.setAttribute("swalIcon", "error");
                request.getRequestDispatcher("home.jsp").forward(request, response);
                return;
            }
        }

        // Cập nhật DB
        UserDAO dao = new UserDAO();
        boolean success = dao.updateUserProfile(user);

        if (success) {
            session.setAttribute("user", user); // cập nhật session
            request.setAttribute("swalMessage", "Hồ sơ được cập nhật thành công!");
            request.setAttribute("swalIcon", "success");
        } else {
            request.setAttribute("swalMessage", "Không cập nhật được hồ sơ. Vui lòng thử lại.");
            request.setAttribute("swalIcon", "error");
        }
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
