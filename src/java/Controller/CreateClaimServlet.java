package Controller;

import Model.Claims;
import Model.User;
import dal.ClaimsDBContext;
import dal.ContractDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Date;

@WebServlet(name = "CreateClaimServlet", urlPatterns = {"/create-claim"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB    
public class CreateClaimServlet extends HttpServlet {

    private ClaimsDBContext claimsDB;
    private ContractDBContext contractDB;

    @Override
    public void init() throws ServletException {
        claimsDB = new ClaimsDBContext();
        contractDB = new ContractDBContext();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            String contractIdStr = request.getParameter("contractId");
            String claimType = request.getParameter("claimType");
            String description = request.getParameter("description");
            String paymentBank = request.getParameter("paymentBank");
            String paymentNumber = request.getParameter("paymentNumber");

            int contractId = Integer.parseInt(contractIdStr);
            
            // Kiểm tra xem contract có thuộc về customer không
            if (!contractDB.isContractOwnedByCustomer(contractId, user.getId())) {
                request.setAttribute("error", "Bạn không có quyền tạo khiếu nại cho hợp đồng này");
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }

            Claims claim = new Claims();
            claim.setContract_id(contractId);
            claim.setClaim_type(claimType);
            claim.setDescription(description);
            claim.setPayment_bank(paymentBank);
            claim.setPayment_number(paymentNumber);
            claim.setRequestDate(new Date());

            // Handle file uploads: save to webapp/uploads/claims/<userId>/
            String uploadBase = getServletContext().getRealPath("/uploads/claims/");
            File userDir = new File(uploadBase + File.separator + user.getId());
            if (!userDir.exists()) userDir.mkdirs();

            StringBuilder imgList = new StringBuilder();
            StringBuilder fileList = new StringBuilder();

            for (Part part : request.getParts()) {
                String name = part.getName();
                if (part.getSubmittedFileName() == null || part.getSubmittedFileName().isEmpty()) continue;
                String filename = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
                File out = new File(userDir, filename);
                try (InputStream in = part.getInputStream()) {
                    Files.copy(in, out.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                String relPath = "uploads/claims/" + user.getId() + "/" + filename;
                if (name.equals("imageFiles")) {
                    if (imgList.length() > 0) imgList.append(",");
                    imgList.append(relPath);
                } else if (name.equals("documentFiles")) {
                    if (fileList.length() > 0) fileList.append(",");
                    fileList.append(relPath);
                }
            }

            claim.setRelated_img(imgList.length() > 0 ? imgList.toString() : null);
            claim.setRelated_file(fileList.length() > 0 ? fileList.toString() : null);

            boolean created = claimsDB.createClaim(claim);
            if (created) {
                // Redirect back to MyClaims with success
                response.sendRedirect(request.getContextPath() + "/my-claims");
                return;
            } else {
                request.setAttribute("error", "Không thể tạo khiếu nại, vui lòng thử lại.");
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tạo khiếu nại: " + e.getMessage());
            request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
        }
    }
}
