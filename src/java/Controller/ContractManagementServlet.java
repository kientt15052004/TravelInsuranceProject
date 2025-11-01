/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.ContractDBContext;
import dal.InsuranceDBContext;
import dal.ApplicationDBContext;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.Contract;
import Model.InsuranceProduct;
import Model.Application;
import Model.User;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ContractManagementServlet", urlPatterns = {"/ContractManagementServlet"})
public class ContractManagementServlet extends HttpServlet {

    private ContractDBContext contractDB = new ContractDBContext();
    private InsuranceDBContext insuranceDB = new InsuranceDBContext();
    private ApplicationDBContext applicationDB = new ApplicationDBContext();
    private UserDAO userDAO = new UserDAO();

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
        try {
            // Lấy các tham số tìm kiếm và lọc
            String searchTerm = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String productFilter = request.getParameter("product");
            
            // Lấy danh sách hợp đồng dựa trên các bộ lọc
            List<Contract> contracts = getFilteredContracts(searchTerm, statusFilter, productFilter);
            
            // Lấy danh sách sản phẩm bảo hiểm để hiển thị trong dropdown
            List<InsuranceProduct> products = insuranceDB.getAllWithBenefit();
            
            // Lấy thống kê tổng quan
            int totalContracts = contractDB.getTotalContracts();
            int activeContracts = contractDB.getContractsByStatusCount("Active");
            int pendingContracts = contractDB.getContractsByStatusCount("Pending");
            int expiredContracts = contractDB.getContractsByStatusCount("Expired");
            
            // Set attributes cho JSP
            request.setAttribute("contracts", contracts);
            request.setAttribute("products", products);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("productFilter", productFilter);
            request.setAttribute("totalContracts", totalContracts);
            request.setAttribute("activeContracts", activeContracts);
            request.setAttribute("pendingContracts", pendingContracts);
            request.setAttribute("expiredContracts", expiredContracts);
            
            // Chỉ hiển thị messages từ request scope, xóa session messages không liên quan
            // Để tránh hiển thị messages từ các trang khác (như Claims)
            if (session.getAttribute("success") != null && request.getAttribute("success") == null) {
                session.removeAttribute("success");
            }
            if (session.getAttribute("error") != null && request.getAttribute("error") == null) {
                session.removeAttribute("error");
            }
            
            request.getRequestDispatcher("ContractManagement.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách hợp đồng: " + e.getMessage());
            request.getRequestDispatcher("ContractManagement.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        // Redirect về GET để tránh duplicate submission
        response.sendRedirect(request.getContextPath() + "/ContractManagementServlet");
    }
    
    private List<Contract> getFilteredContracts(String searchTerm, String statusFilter, String productFilter) {
        // Lấy danh sách contracts cơ bản
        List<Contract> contracts = contractDB.getContractsWithFilters(searchTerm, statusFilter, productFilter, null, null);
        
        // Bổ sung thông tin chi tiết cho mỗi contract
        for (Contract contract : contracts) {
            try {
                // Lấy thông tin application
                Application application = applicationDB.getApplicationById(contract.getApplication_id());
                if (application != null) {
                    // Lấy thông tin sản phẩm
                    InsuranceProduct product = insuranceDB.getById(application.getProduct_id());
                    if (product != null) {
                        contract.setProductName(product.getName());
                        contract.setProductType(product.getType());
                    }
                    
                    // Lấy thông tin ngày
                    contract.setStartDate(application.getStartDate());
                    contract.setEndDate(application.getEndDate());
                    
                    // Lấy tổng số tiền
                    contract.setTotalPrice(application.getTotal_price());
                    
                    // Lấy thông tin người mua
                    User buyer = userDAO.getUserById(application.getPurchaser_id());
                    if (buyer != null) {
                        contract.setBuyerName(buyer.getFullname());
                        contract.setBuyerPhone(buyer.getPhone());
                        contract.setBuyerEmail(buyer.getMail());
                    }
                }
            } catch (Exception e) {
                System.err.println("Error loading details for contract " + contract.getContract_id() + ": " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        return contracts;
    }
}
