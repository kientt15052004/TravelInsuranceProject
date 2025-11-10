package Controller;

import Model.User;
import Model.Claims;
import Model.Contract;
import dal.ClaimsDBContext;
import dal.ContractDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý trang "Khiếu Nại Của Tôi" cho customer
 * @author FPTSHOP
 */
@WebServlet(name = "MyClaimsServlet", urlPatterns = {"/my-claims"})
public class MyClaimsServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;
    private ClaimsDBContext claimsDB;
    private ContractDBContext contractDB;

    @Override
    public void init() throws ServletException {
        claimsDB = new ClaimsDBContext();
        contractDB = new ContractDBContext();
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
            // Lấy parameters từ request
            String searchTerm = request.getParameter("q");
            String statusFilter = request.getParameter("status");
            String typeFilter = request.getParameter("type");
            String pageParam = request.getParameter("page");
            
            // Xử lý phân trang
            int currentPage = 1;
            try {
                if (pageParam != null && !pageParam.trim().isEmpty()) {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
            
            // Lấy danh sách claims của customer
            List<Claims> claims = claimsDB.getCustomerClaims(
                currentUser.getId(), searchTerm, statusFilter, typeFilter, 
                currentPage, DEFAULT_PAGE_SIZE
            );
            
            // Đếm tổng số claims cho phân trang
            int totalRecords = claimsDB.getCustomerClaimsCount(
                currentUser.getId(), searchTerm, statusFilter, typeFilter
            );
            
            int totalPages = (int) Math.ceil((double) totalRecords / DEFAULT_PAGE_SIZE);
            
            // Điều chỉnh trang hiện tại nếu vượt quá
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }
            
            // Lấy danh sách hợp đồng ACTIVE của customer để tạo claim mới
            List<Contract> activeContracts = contractDB.getCustomerPurchasedInsurance(
                currentUser.getId(), null, "active", null, null, 1, 100
            );
            
            // Lấy danh sách loại claims để filter
            List<String> claimTypes = claimsDB.getAllClaimTypes();
            
            // Set attributes cho JSP
            request.setAttribute("claims", claims);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("pageSize", DEFAULT_PAGE_SIZE);
            request.setAttribute("activeContracts", activeContracts);
            request.setAttribute("claimTypes", claimTypes);
            
            // Giữ lại giá trị filter
            request.setAttribute("searchTerm", searchTerm != null ? searchTerm : "");
            request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
            request.setAttribute("typeFilter", typeFilter != null ? typeFilter : "");
            
            // Forward đến JSP
            request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách khiếu nại: " + e.getMessage());
            request.getRequestDispatcher("MyClaims.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển POST sang GET để xử lý
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý trang Khiếu Nại Của Tôi cho customer";
    }
}
