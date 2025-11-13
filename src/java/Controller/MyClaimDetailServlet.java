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
            System.out.println("MyClaimDetailServlet - claimIdParam: " + claimIdParam);
            System.out.println("MyClaimDetailServlet - currentUser: " + currentUser.getId() + ", role: " + currentUser.getRole());
            
            if (claimIdParam == null || claimIdParam.trim().isEmpty()) {
                System.out.println("MyClaimDetailServlet - Error: ID claim không hợp lệ");
                request.setAttribute("error", "ID claim không hợp lệ");
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }
            
            int claimId;
            try {
                claimId = Integer.parseInt(claimIdParam);
                System.out.println("MyClaimDetailServlet - Parsed claimId: " + claimId);
            } catch (NumberFormatException e) {
                System.out.println("MyClaimDetailServlet - Error: ID claim phải là số");
                request.setAttribute("error", "ID claim phải là số");
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }

            // Lấy claim
            Claims claim = claimsDB.getClaimById(claimId);
            System.out.println("MyClaimDetailServlet - Claim retrieved: " + (claim != null ? "Found" : "Not found"));
            
            if (claim == null) {
                System.out.println("MyClaimDetailServlet - Error: Không tìm thấy claim với ID: " + claimId);
                request.setAttribute("error", "Không tìm thấy claim với ID: " + claimId);
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra xem claim có thuộc về customer không
            boolean isOwned = claimsDB.isClaimOwnedByCustomer(claimId, currentUser.getId());
            System.out.println("MyClaimDetailServlet - Ownership check: " + isOwned);
            
            if (!isOwned) {
                System.out.println("MyClaimDetailServlet - Error: Bạn không có quyền xem claim này");
                request.setAttribute("error", "Bạn không có quyền xem claim này");
                request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin contract
            System.out.println("MyClaimDetailServlet - Getting contract for contract_id: " + claim.getContract_id());
            Contract contract = contractDB.getContractById(claim.getContract_id());
            System.out.println("MyClaimDetailServlet - Contract retrieved: " + (contract != null ? "Found" : "Not found"));

            // Lấy danh sách phản hồi của staff
            System.out.println("MyClaimDetailServlet - Getting claim responses for claimId: " + claimId);
            List<ClaimsRes> claimResponses = claimsResDB.getClaimResponsesByClaimId(claimId);
            System.out.println("MyClaimDetailServlet - Claim responses retrieved: " + (claimResponses != null ? claimResponses.size() : 0) + " responses");
            
            // Đảm bảo claimResponses không null
            if (claimResponses == null) {
                claimResponses = new java.util.ArrayList<>();
            }
            
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
            
            System.out.println("MyClaimDetailServlet - All data retrieved successfully. Forwarding to MyClaimDetail.jsp");
            System.out.println("MyClaimDetailServlet - claim: " + (claim != null ? "not null" : "null"));
            System.out.println("MyClaimDetailServlet - contract: " + (contract != null ? "not null" : "null"));
            System.out.println("MyClaimDetailServlet - claimResponses size: " + (claimResponses != null ? claimResponses.size() : 0));
            
            // Forward đến JSP
            try {
                System.out.println("MyClaimDetailServlet - Attempting to forward to MyClaimDetail.jsp");
                request.getRequestDispatcher("MyClaimDetail.jsp").forward(request, response);
                System.out.println("MyClaimDetailServlet - Forward successful");
            } catch (Exception forwardException) {
                System.err.println("MyClaimDetailServlet - Forward exception: " + forwardException.getClass().getName());
                System.err.println("MyClaimDetailServlet - Forward exception message: " + forwardException.getMessage());
                forwardException.printStackTrace();
                throw forwardException; // Re-throw để catch block bên ngoài xử lý
            }
            
        } catch (Exception e) {
            System.err.println("MyClaimDetailServlet - EXCEPTION OCCURRED: " + e.getClass().getName());
            System.err.println("MyClaimDetailServlet - Exception message: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải chi tiết claim: " + e.getMessage());
            request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
        }
    }
}

