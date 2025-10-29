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
@WebServlet(name = "ClaimApprovalServlet", urlPatterns = {"/ClaimApprovalServlet"})
public class ClaimApprovalServlet extends HttpServlet {

    private ClaimsDBContext claimsDB = new ClaimsDBContext();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số từ form
            String claimIdParam = request.getParameter("claimId");
            String action = request.getParameter("action"); // "approve" hoặc "reject"
            String reason = request.getParameter("reason"); // Lý do từ chối (nếu có)
            
            if (claimIdParam == null || claimIdParam.trim().isEmpty()) {
                request.setAttribute("error", "ID claim không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
                return;
            }
            
            if (action == null || (!action.equals("approve") && !action.equals("reject"))) {
                request.setAttribute("error", "Hành động không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
                return;
            }
            
            int claimId;
            try {
                claimId = Integer.parseInt(claimIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID claim phải là số");
                response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
                return;
            }
            
            // Kiểm tra xem claim có tồn tại và đang pending không
            Model.Claims claim = claimsDB.getClaimById(claimId);
            if (claim == null) {
                request.setAttribute("error", "Không tìm thấy claim với ID: " + claimId);
                response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
                return;
            }
            
            if (!"pending".equalsIgnoreCase(claim.getClaim_status())) {
                request.setAttribute("error", "Chỉ có thể xử lý các claim đang chờ duyệt");
                response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
                return;
            }
            
            // Cập nhật trạng thái claim
            String newStatus = action.equals("approve") ? "approved" : "rejected";
            boolean success = claimsDB.updateClaimStatus(claimId, newStatus, reason);
            
            if (success) {
                String message = action.equals("approve") ? 
                    "Đã chấp nhận claim thành công!" : 
                    "Đã từ chối claim thành công!";
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
}






