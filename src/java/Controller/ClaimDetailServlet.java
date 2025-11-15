/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.ClaimsDBContext;
import dal.ContractDBContext;
import dal.ClaimsResDBContext;
import Model.Claims;
import Model.Contract;
import Model.ClaimsRes;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ClaimDetailServlet", urlPatterns = {"/ClaimDetailServlet"})
public class ClaimDetailServlet extends HttpServlet {

    private ClaimsDBContext claimsDB = new ClaimsDBContext();
    private ContractDBContext contractDB = new ContractDBContext();
    private ClaimsResDBContext claimsResDB = new ClaimsResDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        // Allow both admin and staff to view claim details
        if (currentUser.getRole() == null || 
            (!"staff".equalsIgnoreCase(currentUser.getRole()) && !"admin".equalsIgnoreCase(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }
        
        
        
        try {
            String claimIdParam = request.getParameter("id");
            
            if (claimIdParam == null || claimIdParam.trim().isEmpty()) {
                request.setAttribute("error", "ID claim không hợp lệ");
                request.getRequestDispatcher("ClaimsManagement.jsp").forward(request, response);
                return;
            }
            
            int claimId;
            try {
                claimId = Integer.parseInt(claimIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID claim phải là số");
                request.getRequestDispatcher("ClaimsManagement.jsp").forward(request, response);
                return;
            }

            Claims claim = claimsDB.getClaimById(claimId);
            
            if (claim == null) {
                request.setAttribute("error", "Không tìm thấy claim với ID: " + claimId);
                request.getRequestDispatcher("ClaimsManagement.jsp").forward(request, response);
                return;
            }

            Contract contract = contractDB.getContractById(claim.getContract_id());

            List<ClaimsRes> claimResponses = claimsResDB.getClaimResponsesByClaimId(claimId);
            
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

            request.setAttribute("claim", claim);
            request.setAttribute("contract", contract);
            request.setAttribute("claimResponses", claimResponses);
            
            request.getRequestDispatcher("ClaimDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải chi tiết claim: " + e.getMessage());
            request.getRequestDispatcher("ClaimsManagement.jsp").forward(request, response);
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

        if (currentUser.getRole() == null || 
            (!"staff".equalsIgnoreCase(currentUser.getRole()) && !"admin".equalsIgnoreCase(currentUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }
        try {

            String success = request.getParameter("success");
            String error = request.getParameter("error");
            
            String claimId = request.getParameter("id");
            if (claimId == null) {
                claimId = request.getParameter("claimId");
            }
            
            if (claimId != null) {

                request.setAttribute("success", success);
                request.setAttribute("error", error);
                response.sendRedirect(request.getContextPath() + "/ClaimDetailServlet?id=" + claimId);
            } else {
                response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
        }
    }
}
