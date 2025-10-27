/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import dal.ClaimsResDBContext;
import Model.ClaimsRes;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "AddClaimResponseServlet", urlPatterns = {"/AddClaimResponseServlet"})
public class AddClaimResponseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Check if user is logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để gửi phản hồi");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Get parameters
        String claimIdStr = request.getParameter("claimId");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        
        // Validate parameters
        if (claimIdStr == null || claimIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Claim ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
            return;
        }
        
        if (description == null || description.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập nội dung phản hồi");
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimIdStr);
            return;
        }
        
        try {
            int claimId = Integer.parseInt(claimIdStr);
            
            // Create ClaimsRes object
            ClaimsRes claimRes = new ClaimsRes();
            claimRes.setClaim_id(claimId);
            claimRes.setUser_id(currentUser.getId()); // Set user from session
            claimRes.setCreateDate(new Date());
            claimRes.setDescription(description);
            claimRes.setRelated_img(null); // Can be extended later
            claimRes.setRelated_file(null); // Can be extended later
            claimRes.setStatus(status != null && !status.trim().isEmpty() ? status : "open");
            
            // Insert to database
            ClaimsResDBContext claimsResDB = new ClaimsResDBContext();
            boolean success = claimsResDB.addClaimResponse(claimRes);
            
            if (success) {
                request.setAttribute("success", "Phản hồi đã được gửi thành công");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi gửi phản hồi");
            }
            
            // Redirect to claim detail page
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Claim ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimIdStr);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to claim management if accessed via GET
        response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
    }

}
