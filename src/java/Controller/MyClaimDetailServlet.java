package Controller;

import Model.User;
import Model.Claims;
import Model.Contract;
import Model.ClaimsRes;
import dal.ClaimsDBContext;
import dal.ContractDBContext;
import dal.ClaimsResDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý trang chi tiết claim cho customer
 * @author FPTSHOP
 */
@WebServlet(name = "MyClaimDetailServlet", urlPatterns = {"/my-claim-detail"})
public class MyClaimDetailServlet extends HttpServlet {

    private ClaimsDBContext claimsDB;
    private ContractDBContext contractDB;
    private ClaimsResDBContext claimsResDB;

    @Override
    public void init() throws ServletException {
        claimsDB = new ClaimsDBContext();
        contractDB = new ContractDBContext();
        claimsResDB = new ClaimsResDBContext();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        // Chỉ cho phép customer truy cập
        if (!"customer".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            String claimIdParam = request.getParameter("id");
            
            if (claimIdParam == null || claimIdParam.trim().isEmpty()) {
                request.setAttribute("error", "ID claim không hợp lệ");
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }
            
            int claimId;
            try {
                claimId = Integer.parseInt(claimIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID claim phải là số");
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }

            // Lấy claim
            Claims claim = claimsDB.getClaimById(claimId);
            
            if (claim == null) {
                request.setAttribute("error", "Không tìm thấy claim với ID: " + claimId);
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra xem claim có thuộc về customer không
            if (!claimsDB.isClaimOwnedByCustomer(claimId, currentUser.getId())) {
                request.setAttribute("error", "Bạn không có quyền xem claim này");
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin contract
            Contract contract = contractDB.getContractById(claim.getContract_id());

            // Lấy danh sách phản hồi của staff
            List<ClaimsRes> claimResponses = claimsResDB.getClaimResponsesByClaimId(claimId);
            
            // Lấy thông báo từ session
            String success = (String) session.getAttribute("success");
            String error = (String) session.getAttribute("error");
            
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }
            
            // Set attributes cho JSP
            request.setAttribute("claim", claim);
            request.setAttribute("contract", contract);
            request.setAttribute("claimResponses", claimResponses);
            
            // Forward đến JSP
            request.getRequestDispatcher("MyClaimDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải chi tiết claim: " + e.getMessage());
            request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
        }
    }
}

