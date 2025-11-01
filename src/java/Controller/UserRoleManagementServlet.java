package Controller;

import Model.User;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

@WebServlet(name = "UserRoleManagementServlet", urlPatterns = {"/user-role-management"})
public class UserRoleManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        UserDAO userDAO = new UserDAO();

        String keyword = request.getParameter("keyword");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        
        List<User> users;

        if ((keyword != null && !keyword.trim().isEmpty()) || 
            (role != null && !role.trim().isEmpty() && !role.equals("all")) ||
            (status != null && !status.trim().isEmpty() && !status.equals("all"))) {
            users = userDAO.searchUsers(keyword, role, status);
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("searchRole", role);
            request.setAttribute("searchStatus", status);
        } else {
            users = userDAO.getAllUsers();
        }

        List<String> allowedRoles = new ArrayList<>(UserDAO.getAllowedRoles());
        List<String> orderedRoles = Arrays.asList("admin", "staff", "customer");
        allowedRoles.sort(Comparator.comparingInt(roleItem -> {
            int index = orderedRoles.indexOf(roleItem);
            return index >= 0 ? index : Integer.MAX_VALUE;
        }));

        transferFlashMessage(session, request, "roleUpdateMessage");
        transferFlashMessage(session, request, "roleUpdateError");

        request.setAttribute("users", users);
        request.setAttribute("allowedRoles", allowedRoles);

        request.getRequestDispatcher("/user-role-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");
        String userIdParam = request.getParameter("userId");

        String keyword = request.getParameter("keyword");
        String roleFilter = request.getParameter("roleFilter");
        String statusFilter = request.getParameter("statusFilter");

        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            session.setAttribute("roleUpdateError", "Thiếu thông tin người dùng.");
            String redirectUrl = buildRedirectUrl(request.getContextPath(), keyword, roleFilter, statusFilter);
            response.sendRedirect(redirectUrl);
            return;
        }

        int targetUserId;
        try {
            targetUserId = Integer.parseInt(userIdParam);
        } catch (NumberFormatException ex) {
            session.setAttribute("roleUpdateError", "ID người dùng không hợp lệ.");
            String redirectUrl = buildRedirectUrl(request.getContextPath(), keyword, roleFilter, statusFilter);
            response.sendRedirect(redirectUrl);
            return;
        }

        if (currentUser != null && currentUser.getId() == targetUserId) {
            session.setAttribute("roleUpdateError", "Bạn không thể tự chỉnh sửa vai trò và trạng thái của chính mình.");
            String redirectUrl = buildRedirectUrl(request.getContextPath(), keyword, roleFilter, statusFilter);
            response.sendRedirect(redirectUrl);
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean updated = false;
        boolean roleUpdated = false;
        boolean statusUpdated = false;
        String message = "";

        if (!"updateBoth".equals(action)) {
            session.setAttribute("roleUpdateError", "Hành động không hợp lệ.");
            String redirectUrl = buildRedirectUrl(request.getContextPath(), keyword, roleFilter, statusFilter);
            response.sendRedirect(redirectUrl);
            return;
        }

        // Xử lý action "updateBoth"
        String roleParam = request.getParameter("role");
        String statusParam = request.getParameter("status");
        
        if (roleParam == null || roleParam.trim().isEmpty()) {
            session.setAttribute("roleUpdateError", "Thiếu thông tin vai trò.");
            String redirectUrl = buildRedirectUrl(request.getContextPath(), keyword, roleFilter, statusFilter);
            response.sendRedirect(redirectUrl);
            return;
        }
        if (statusParam == null || statusParam.trim().isEmpty()) {
            session.setAttribute("roleUpdateError", "Thiếu thông tin trạng thái.");
            String redirectUrl = buildRedirectUrl(request.getContextPath(), keyword, roleFilter, statusFilter);
            response.sendRedirect(redirectUrl);
            return;
        }
        
        roleUpdated = userDAO.updateUserRole(targetUserId, roleParam);
        statusUpdated = userDAO.updateUserStatus(targetUserId, statusParam);
        
        if (roleUpdated && statusUpdated) {
            message = "Cập nhật vai trò và trạng thái thành công.";
            updated = true;
        } else if (roleUpdated) {
            message = "Cập nhật vai trò thành công nhưng không thể cập nhật trạng thái.";
            updated = true;
        } else if (statusUpdated) {
            message = "Cập nhật trạng thái thành công nhưng không thể cập nhật vai trò.";
            updated = true;
        } else {
            message = "Không thể cập nhật vai trò và trạng thái. Vui lòng thử lại.";
            updated = false;
        }

        if (updated) {
            session.setAttribute("roleUpdateMessage", message);
        } else {
            session.setAttribute("roleUpdateError", message);
        }

        String redirectUrl = buildRedirectUrl(request.getContextPath(), keyword, roleFilter, statusFilter);
        response.sendRedirect(redirectUrl);
    }

    private User getCurrentUser(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object userObj = session.getAttribute("user");
        if (userObj instanceof User) {
            return (User) userObj;
        }
        return null;
    }

    private void transferFlashMessage(HttpSession session, HttpServletRequest request, String attribute) {
        if (session == null) {
            return;
        }
        Object value = session.getAttribute(attribute);
        if (value != null) {
            request.setAttribute(attribute, value);
            session.removeAttribute(attribute);
        }
    }
    
    private String buildRedirectUrl(String contextPath, String keyword, String roleFilter, String statusFilter) {
        StringBuilder url = new StringBuilder(contextPath + "/user-role-management");
        boolean hasParams = false;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("keyword=").append(java.net.URLEncoder.encode(keyword, java.nio.charset.StandardCharsets.UTF_8));
            hasParams = true;
        }
        
        if (roleFilter != null && !roleFilter.trim().isEmpty() && !roleFilter.equals("all")) {
            url.append(hasParams ? "&" : "?").append("role=").append(java.net.URLEncoder.encode(roleFilter, java.nio.charset.StandardCharsets.UTF_8));
            hasParams = true;
        }
        
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("all")) {
            url.append(hasParams ? "&" : "?").append("status=").append(java.net.URLEncoder.encode(statusFilter, java.nio.charset.StandardCharsets.UTF_8));
            hasParams = true;
        }
        
        return url.toString();
    }
}


