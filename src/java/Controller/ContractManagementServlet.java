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

            String searchTerm = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String productFilter = request.getParameter("product");
            
            List<Contract> contracts = getFilteredContracts(searchTerm, statusFilter, productFilter);

            List<InsuranceProduct> products = insuranceDB.getAllWithBenefit();

            request.setAttribute("contracts", contracts);
            request.setAttribute("products", products);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("productFilter", productFilter);
            
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

        response.sendRedirect(request.getContextPath() + "/ContractManagementServlet");
    }
    
    private List<Contract> getFilteredContracts(String searchTerm, String statusFilter, String productFilter) {

        List<Contract> contracts = contractDB.getContractsWithFilters(searchTerm, statusFilter, productFilter, null, null);

        for (Contract contract : contracts) {
            try {

                Application application = applicationDB.getApplicationById(contract.getApplication_id());
                if (application != null) {

                    InsuranceProduct product = insuranceDB.getById(application.getProduct_id());
                    if (product != null) {
                        contract.setProductName(product.getName());
                        contract.setProductType(product.getType());
                    }

                    contract.setStartDate(application.getStartDate());
                    contract.setEndDate(application.getEndDate());

                    contract.setTotalPrice(application.getTotal_price());
                    
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
