package Controller;

import dal.UserDAO;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UpdateUserServlet", urlPatterns = {"/updateuser"})
public class UpdateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"staff".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }
        
        // Get parameters
        String userIdStr = request.getParameter("userId");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String status = request.getParameter("status");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/usermanagement");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            UserDAO userDAO = new UserDAO();
            
            // Get the user to update
            User user = userDAO.getUserById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/usermanagement");
                return;
            }
            
            // Update only allowed fields (phone, address, status)
            user.setPhone(phone != null ? phone.trim() : "");
            user.setAddress(address != null ? address.trim() : "");
            user.setStatus(status != null ? status.trim() : "active");
            
            // Validate status
            if (!"active".equals(user.getStatus()) && !"inactive".equals(user.getStatus())) {
                user.setStatus("active");
            }
            
            // Update in database
            boolean success = userDAO.updateUserInfo(user);
            
            if (success) {
                // Redirect to user detail page with success message
                response.sendRedirect(request.getContextPath() + "/usermanagement?action=detail&userId=" + userId + "&success=true");
            } else {
                // Redirect to user detail page with error message
                response.sendRedirect(request.getContextPath() + "/usermanagement?action=detail&userId=" + userId + "&error=true");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/usermanagement");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to user management
        response.sendRedirect(request.getContextPath() + "/usermanagement");
    }
}
