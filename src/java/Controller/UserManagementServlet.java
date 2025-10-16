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
import java.util.List;
import java.math.BigDecimal;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/usermanagement"})
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"staff".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();
        
        if ("detail".equals(action)) {
            // Show user detail page
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                try {
                    int userId = Integer.parseInt(userIdStr);
                    User user = userDAO.getUserById(userId);
                    if (user != null) {
                        request.setAttribute("user", user);
                        request.setAttribute("applications", userDAO.getApplicationsByUserId(userId));
                        request.setAttribute("contracts", userDAO.getContractsByUserId(userId));
                        request.setAttribute("claims", userDAO.getClaimsByUserId(userId));
                        request.setAttribute("totalInsuranceAmount", userDAO.getTotalInsuranceAmountByUserId(userId));
                        request.getRequestDispatcher("/UserDetail.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            // If user not found or invalid ID, redirect to user list
            response.sendRedirect(request.getContextPath() + "/usermanagement");
            return;
        }
        
        // Default action: show user list with optional search
        String keyword = request.getParameter("keyword");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        
        List<User> users;
        
        if ((keyword != null && !keyword.trim().isEmpty()) || 
            (role != null && !role.trim().isEmpty() && !role.equals("all")) ||
            (status != null && !status.trim().isEmpty() && !status.equals("all"))) {
            // Search users with filters
            users = userDAO.searchUsers(keyword, role, status);
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("searchRole", role);
            request.setAttribute("searchStatus", status);
        } else {
            // Get all users
            users = userDAO.getAllUsers();
        }
        
        // Calculate total insurance amount for each user
        for (User user : users) {
            BigDecimal totalAmount = userDAO.getTotalInsuranceAmountByUserId(user.getId());
            user.setTotalInsuranceAmount(totalAmount);
        }
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/UserManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
