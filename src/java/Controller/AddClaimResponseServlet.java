/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import dal.ClaimsResDBContext;
import dal.ClaimsDBContext;
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
        String submitType = request.getParameter("submitType"); // reply, approve, reject
        String action = request.getParameter("action"); // Hidden field for action
        
        // Validate claimId
        if (claimIdStr == null || claimIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Claim ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
            return;
        }
        
        int claimId;
        try {
            claimId = Integer.parseInt(claimIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Claim ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
            return;
        }
        
        // Handle approve/reject actions
        if (submitType != null && (submitType.equals("approve") || submitType.equals("reject"))) {
            handleApproveReject(request, response, claimId, submitType, description, currentUser, session);
            return;
        }
        
        // Handle regular reply
        if (description == null || description.trim().isEmpty()) {
            session.setAttribute("error", "Vui lòng nhập nội dung phản hồi");
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
            return;
        }
        
        try {
            // Create ClaimsRes object for regular reply
            ClaimsRes claimRes = new ClaimsRes();
            claimRes.setClaim_id(claimId);
            claimRes.setUser_id(currentUser.getId()); // Set user from session
            claimRes.setCreateDate(new Date());
            claimRes.setDescription(description);
            claimRes.setRelated_img(null); // Can be extended later
            claimRes.setRelated_file(null); // Can be extended later
            
            // Insert to database
            ClaimsResDBContext claimsResDB = new ClaimsResDBContext();
            boolean success = claimsResDB.addClaimResponse(claimRes);
            
            if (success) {
                session.setAttribute("success", "Phản hồi đã được gửi thành công");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi gửi phản hồi");
            }
            
            // Redirect to claim detail page
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
        }
    }
    
    private void handleApproveReject(HttpServletRequest request, HttpServletResponse response, 
                                      int claimId, String submitType, String description,
                                      User currentUser, HttpSession session) 
            throws ServletException, IOException {
        try {
            String newStatus = submitType.equals("approve") ? "approved" : "rejected";
            String reason = description != null && !description.trim().isEmpty() 
                          ? description 
                          : (submitType.equals("approve") ? "Claim đã được chấp nhận" : "Claim đã bị từ chối");
            
            // Update claim status
            ClaimsDBContext claimsDB = new ClaimsDBContext();
            boolean statusUpdated = claimsDB.updateClaimStatusWithReason(claimId, newStatus, reason);
            
            // Also add a response record with the reason
            ClaimsRes claimRes = new ClaimsRes();
            claimRes.setClaim_id(claimId);
            claimRes.setUser_id(currentUser.getId());
            claimRes.setCreateDate(new Date());
            claimRes.setDescription(reason);
            claimRes.setRelated_img(null);
            claimRes.setRelated_file(null);
            
            ClaimsResDBContext claimsResDB = new ClaimsResDBContext();
            boolean responseAdded = claimsResDB.addClaimResponse(claimRes);
            
            if (statusUpdated && responseAdded) {
                String message = submitType.equals("approve") 
                    ? "Claim đã được chấp nhận thành công!" 
                    : "Claim đã bị từ chối!";
                session.setAttribute("success", message);
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái claim");
            }
            
            // Redirect to claim detail page
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to claim management if accessed via GET
        response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
    }

}
