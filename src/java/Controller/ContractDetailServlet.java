/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.ContractDBContext;
import dal.ApplicationDBContext;
import dal.InsuranceDBContext;
import Model.Contract;
import Model.Application;
import Model.InsuranceProduct;
import Model.ApplicationTraveler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ContractDetailServlet", urlPatterns = {"/ContractDetailServlet"})
public class ContractDetailServlet extends HttpServlet {

    private ContractDBContext contractDB = new ContractDBContext();
    private ApplicationDBContext applicationDB = new ApplicationDBContext();
    private InsuranceDBContext insuranceDB = new InsuranceDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String contractIdStr = request.getParameter("id");
            String userIdStr = request.getParameter("userId");
            
            if (contractIdStr == null || contractIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Contract ID is required");
                return;
            }
            
            int contractId = Integer.parseInt(contractIdStr);
            
            // Get contract details
            Contract contract = contractDB.getContractById(contractId);
            if (contract == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Contract not found");
                return;
            }
            
            // Get application details
            Application application = applicationDB.getById(contract.getApplication_id());
            
            // Get insurance product details
            InsuranceProduct product = null;
            if (application != null) {
                product = insuranceDB.getByIdWithBenefit(application.getProduct_id());
            }
            
            // Get application travelers
            List<ApplicationTraveler> travelers = new ArrayList<>();
            if (application != null) {
                travelers = applicationDB.getTravelersByApplicationId(application.getId());
            }
            
            // Set attributes for JSP
            request.setAttribute("contract", contract);
            request.setAttribute("application", application);
            request.setAttribute("product", product);
            request.setAttribute("travelers", travelers);
            request.setAttribute("userId", userIdStr); // Pass userId to JSP
            
            request.getRequestDispatcher("ContractDetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid contract ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading contract details: " + e.getMessage());
        }
    }
}
