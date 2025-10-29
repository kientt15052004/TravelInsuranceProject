/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.ClaimsDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ClaimStatusUpdateServlet", urlPatterns = {"/ClaimStatusUpdateServlet"})
public class ClaimStatusUpdateServlet extends HttpServlet {

    private ClaimsDBContext claimsDB = new ClaimsDBContext();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số từ form
            String claimIdParam = request.getParameter("claimId");
            String newStatus = request.getParameter("newStatus");
            String reason = request.getParameter("reason");
            
            if (claimIdParam == null || claimIdParam.trim().isEmpty()) {
                request.getSession().setAttribute("error", "ID claim không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
                return;
            }
            
            if (newStatus == null || newStatus.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Trạng thái mới không được để trống");
                response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimIdParam);
                return;
            }
            
            // Validate status values
            if (!isValidStatus(newStatus)) {
                request.getSession().setAttribute("error", "Trạng thái không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimIdParam);
                return;
            }
            
            int claimId;
            try {
                claimId = Integer.parseInt(claimIdParam);
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "ID claim phải là số");
                response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
                return;
            }
            
            // Kiểm tra xem claim có tồn tại không
            Model.Claims claim = claimsDB.getClaimById(claimId);
            if (claim == null) {
                request.getSession().setAttribute("error", "Không tìm thấy claim với ID: " + claimId);
                response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
                return;
            }
            
            // Kiểm tra xem trạng thái có thay đổi không
            if (newStatus.equalsIgnoreCase(claim.getClaim_status())) {
                request.getSession().setAttribute("error", "Trạng thái mới giống với trạng thái hiện tại");
                response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
                return;
            }
            
            // Cập nhật trạng thái claim
            boolean success = claimsDB.updateClaimStatusWithReason(claimId, newStatus, reason);
            
            if (success) {
                String message = "Đã cập nhật trạng thái claim từ '" + claim.getClaim_status() + 
                               "' thành '" + newStatus + "' thành công!";
                request.getSession().setAttribute("success", message);
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái claim");
            }
            
            // Redirect về trang chi tiết claim
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect về POST để tránh duplicate submission
        response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
    }
    
    // Method để validate status values
    private boolean isValidStatus(String status) {
        if (status == null) return false;
        
        String[] validStatuses = {"pending", "approved", "rejected"};
        for (String validStatus : validStatuses) {
            if (validStatus.equalsIgnoreCase(status)) {
                return true;
            }
        }
        return false;
    }
}






