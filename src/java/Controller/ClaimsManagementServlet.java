/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.ClaimsDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.Claims;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ClaimsManagementServlet", urlPatterns = {"/ClaimsManagementServlet"})
public class ClaimsManagementServlet extends HttpServlet {

    private ClaimsDBContext claimsDB = new ClaimsDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số tìm kiếm và lọc
            String searchTerm = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String typeFilter = request.getParameter("type");
            
            // Lấy danh sách claims dựa trên các bộ lọc
            List<Claims> claims = claimsDB.getAllClaimsWithFilters(searchTerm, statusFilter, typeFilter);
            
            // Lấy danh sách các loại claim để hiển thị trong dropdown
            List<String> claimTypes = claimsDB.getAllClaimTypes();
            
            // Set attributes cho JSP
            request.setAttribute("claims", claims);
            request.setAttribute("claimTypes", claimTypes);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("typeFilter", typeFilter);
            
            request.getRequestDispatcher("ClaimsManagement.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách bồi thường: " + e.getMessage());
            request.getRequestDispatcher("ClaimsManagement.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect về GET để tránh duplicate submission
        response.sendRedirect(request.getContextPath() + "/ClaimsManagementServlet");
    }
}
