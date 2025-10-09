/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.ContractDBContext;
import dal.InsuranceDBContext;
import dal.ApplicationDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.Contract;
import Model.InsuranceProduct;
import Model.Application;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ContractManagementServlet", urlPatterns = {"/ContractManagementServlet"})
public class ContractManagementServlet extends HttpServlet {

    private ContractDBContext contractDB = new ContractDBContext();
    private InsuranceDBContext insuranceDB = new InsuranceDBContext();
    private ApplicationDBContext applicationDB = new ApplicationDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        // Redirect về GET để tránh duplicate submission
        response.sendRedirect(request.getContextPath() + "/ContractManagementServlet");
    }
    
    private List<Contract> getFilteredContracts(String searchTerm, String statusFilter, String productFilter) {
        // Sử dụng phương thức mới để lọc với các điều kiện (không có ngày)
        return contractDB.getContractsWithFilters(searchTerm, statusFilter, productFilter, null, null);
    }
}
