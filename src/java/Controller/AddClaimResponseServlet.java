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
import java.io.File;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.Date;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "AddClaimResponseServlet", urlPatterns = {"/AddClaimResponseServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB per file
        maxRequestSize = 1024 * 1024 * 50)    // 50MB total
public class AddClaimResponseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để gửi phản hồi");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser.getRole() == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            session.setAttribute("error", "Bạn không có quyền thực hiện thao tác này");
            response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
            return;
        }
        
        // Get parameters
        String claimIdStr = request.getParameter("claimId");
        String description = request.getParameter("description");
        String submitType = request.getParameter("submitType"); // reply, approve, reject
        String action = request.getParameter("action"); // Hidden field for action
        String compensationAmountStr = request.getParameter("compensationAmount");
        
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
            BigDecimal compensationAmount = null;
            if (submitType.equals("approve") && compensationAmountStr != null && !compensationAmountStr.trim().isEmpty()) {
                try {
                    compensationAmount = new BigDecimal(compensationAmountStr.trim());
                    if (compensationAmount.compareTo(BigDecimal.ZERO) < 0) {
                        session.setAttribute("error", "Số tiền đền bù phải lớn hơn hoặc bằng 0");
                        response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
                        return;
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "Số tiền đền bù không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
                    return;
                }
            }
            handleApproveReject(request, response, claimId, submitType, description, compensationAmount, currentUser, session);
            return;
        }

        if (compensationAmountStr != null && !compensationAmountStr.trim().isEmpty()) {
            try {
                BigDecimal compensationAmount = new BigDecimal(compensationAmountStr.trim());
                if (compensationAmount.compareTo(BigDecimal.ZERO) < 0) {
                    session.setAttribute("error", "Số tiền đền bù phải lớn hơn hoặc bằng 0");
                    response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
                    return;
                }
                
                ClaimsDBContext claimsDB = new ClaimsDBContext();
                boolean updated = claimsDB.updateCompensationAmount(claimId, compensationAmount);
                
                if (updated) {
                    session.setAttribute("success", "Cập nhật số tiền đền bù thành công!");
                } else {
                    session.setAttribute("error", "Có lỗi xảy ra khi cập nhật số tiền đền bù");
                }
                
                response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId + "&scrollToBottom=true");
                return;
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Số tiền đền bù không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
                return;
            }
        }

        if (description == null || description.trim().isEmpty()) {
            session.setAttribute("error", "Vui lòng nhập nội dung phản hồi");
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
            return;
        }
        
        try {

            String relatedImgPath = handleFileUpload(request, "related_img", true);
            String relatedFilePath = handleFileUpload(request, "related_file", false);

            ClaimsRes claimRes = new ClaimsRes();
            claimRes.setClaim_id(claimId);
            claimRes.setUser_id(currentUser.getId());
            claimRes.setCreateDate(new Date());
            claimRes.setDescription(description);
            claimRes.setRelated_img(relatedImgPath);
            claimRes.setRelated_file(relatedFilePath);
            claimRes.setAction_type("review");

            ClaimsResDBContext claimsResDB = new ClaimsResDBContext();
            boolean success = claimsResDB.addClaimResponse(claimRes);
            
            if (success) {
                session.setAttribute("success", "Phản hồi đã được gửi thành công");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi gửi phản hồi");
            }

            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId + "&scrollToBottom=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId + "&scrollToBottom=true");
        }
    }
    
    private void handleApproveReject(HttpServletRequest request, HttpServletResponse response, 
                                      int claimId, String submitType, String description,
                                      BigDecimal compensationAmount, User currentUser, HttpSession session) 
            throws ServletException, IOException {
        try {
            String newStatus = submitType.equals("approve") ? "approved" : "rejected";
            String reason = description != null && !description.trim().isEmpty() 
                          ? description 
                          : (submitType.equals("approve") ? "Claim đã được chấp nhận" : "Claim đã bị từ chối");
            
            // Update claim status and compensation amount if approving
            ClaimsDBContext claimsDB = new ClaimsDBContext();
            boolean statusUpdated;
            if (submitType.equals("approve") && compensationAmount != null) {
                // Update both status and compensation amount
                statusUpdated = claimsDB.updateClaimStatusWithCompensation(claimId, newStatus, compensationAmount);
            } else {
                // Update only status
                statusUpdated = claimsDB.updateClaimStatusWithReason(claimId, newStatus, reason);
            }
            
            // Handle file uploads
            String relatedImgPath = handleFileUpload(request, "related_img", true); // image only
            String relatedFilePath = handleFileUpload(request, "related_file", false); // any file
            
            // Also add a response record with the reason
            ClaimsRes claimRes = new ClaimsRes();
            claimRes.setClaim_id(claimId);
            claimRes.setUser_id(currentUser.getId());
            claimRes.setCreateDate(new Date());
            claimRes.setDescription(reason);
            claimRes.setRelated_img(relatedImgPath);
            claimRes.setRelated_file(relatedFilePath);
            // Set action_type based on approve or reject
            claimRes.setAction_type(submitType.equals("approve") ? "approve" : "reject");
            
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
            
            // Redirect to claim detail page with scroll parameter
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId + "&scrollToBottom=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId + "&scrollToBottom=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getRole() == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }
        // Redirect to claim management if accessed via GET
        response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
    }
    
    /**
     * Handle file upload for ClaimsRes
     * @param request HttpServletRequest
     * @param partName Name of the part (e.g., "related_img", "related_file")
     * @param imageOnly If true, only accept image files
     * @return Relative path to the uploaded file, or null if no file uploaded
     */
    private String handleFileUpload(HttpServletRequest request, String partName, boolean imageOnly) 
            throws IOException, ServletException {
        Part filePart = request.getPart(partName);
        
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        String contentType = filePart.getContentType();
        
        // Validate file type
        if (imageOnly && !contentType.startsWith("image/")) {
            return null; // Silently ignore invalid image files
        }
        
        // Get original filename
        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        
        // Create safe filename with timestamp to avoid conflicts
        String safeFileName = System.currentTimeMillis() + "_" + originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
        
        // Determine upload path (similar to CreateProduct)
        String uploadPath = getServletContext().getRealPath("") + File.separator + "Image" + File.separator + "upload_imgs";
        File uploadDir = new File(uploadPath);
        
        // Create directory if it doesn't exist
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Write file
        String filePath = uploadPath + File.separator + safeFileName;
        filePart.write(filePath);
        
        // Return relative path for database (only folder name, not full path)
        // JSP will add /Image/ prefix when displaying
        return "upload_imgs/" + safeFileName;
    }

}
