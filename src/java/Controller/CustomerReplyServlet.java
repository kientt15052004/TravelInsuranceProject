package Controller;

import dal.ClaimsResDBContext;
import dal.ClaimsDBContext;
import Model.ClaimsRes;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import java.util.Date;

/**
 * Servlet xử lý phản hồi của customer cho staff
 * @author FPTSHOP
 */
@WebServlet(name = "CustomerReplyServlet", urlPatterns = {"/customer-reply"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB per file
        maxRequestSize = 1024 * 1024 * 50)    // 50MB total
public class CustomerReplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            session.setAttribute("error", "Bạn cần đăng nhập để gửi phản hồi");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        // Chỉ cho phép customer
        if (!"customer".equalsIgnoreCase(currentUser.getRole())) {
            session.setAttribute("error", "Bạn không có quyền thực hiện thao tác này");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        // Get parameters
        String claimIdStr = request.getParameter("claimId");
        String description = request.getParameter("description");
        
        // Validate claimId
        if (claimIdStr == null || claimIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Claim ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/my-claims");
            return;
        }
        
        int claimId;
        try {
            claimId = Integer.parseInt(claimIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Claim ID không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/my-claims");
            return;
        }
        
        // Kiểm tra xem claim có thuộc về customer không
        ClaimsDBContext claimsDB = new ClaimsDBContext();
        if (!claimsDB.isClaimOwnedByCustomer(claimId, currentUser.getId())) {
            session.setAttribute("error", "Bạn không có quyền phản hồi cho claim này");
            response.sendRedirect(request.getContextPath() + "/my-claims");
            return;
        }
        
        // Validate description
        if (description == null || description.trim().isEmpty()) {
            session.setAttribute("error", "Vui lòng nhập nội dung phản hồi");
            response.sendRedirect(request.getContextPath() + "/my-claim-detail?id=" + claimId);
            return;
        }
        
        try {
            // Handle file uploads
            String relatedImgPath = handleFileUpload(request, "related_img", true); // image only
            String relatedFilePath = handleFileUpload(request, "related_file", false); // any file
            
            // Create ClaimsRes object
            ClaimsRes claimRes = new ClaimsRes();
            claimRes.setClaim_id(claimId);
            claimRes.setUser_id(currentUser.getId());
            claimRes.setCreateDate(new Date());
            claimRes.setDescription(description);
            claimRes.setRelated_img(relatedImgPath);
            claimRes.setRelated_file(relatedFilePath);
            claimRes.setAction_type("review"); // Customer reply is also a review
            
            // Insert to database
            ClaimsResDBContext claimsResDB = new ClaimsResDBContext();
            boolean success = claimsResDB.addClaimResponse(claimRes);
            
            if (success) {
                session.setAttribute("success", "Phản hồi đã được gửi thành công");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi gửi phản hồi");
            }
            
            // Redirect to claim detail page with scroll parameter
            response.sendRedirect(request.getContextPath() + "/my-claim-detail?id=" + claimId + "&scrollToBottom=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/my-claim-detail?id=" + claimId + "&scrollToBottom=true");
        }
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
        
        // Determine upload path
        String uploadPath = getServletContext().getRealPath("") + File.separator + "Image" + File.separator + "upload_imgs";
        File uploadDir = new File(uploadPath);
        
        // Create directory if it doesn't exist
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Write file
        String filePath = uploadPath + File.separator + safeFileName;
        filePart.write(filePath);
        
        // Return relative path for database
        return "upload_imgs/" + safeFileName;
    }
}

