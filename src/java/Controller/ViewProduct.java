package Controller;

import dal.InsuranceDBContext;
import Model.InsuranceProduct;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ViewProduct extends HttpServlet {   

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        InsuranceDBContext insuranceDAO = new InsuranceDBContext();
        
        // Lấy các parameter từ form search
        String searchTerm = request.getParameter("search");
        String typeFilter = request.getParameter("type");
        String packageFilter = request.getParameter("package_type");
        String statusFilter = request.getParameter("status");
        
        System.out.println("DEBUG: Search parameters - search: " + searchTerm + 
                          ", type: " + typeFilter + 
                          ", package: " + packageFilter + 
                          ", status: " + statusFilter);
        
        // Lấy danh sách sản phẩm dựa trên filter
        ArrayList<InsuranceProduct> products = insuranceDAO.getFilteredProducts(searchTerm, typeFilter, packageFilter, statusFilter);
        
        // Set attributes cho JSP
        request.setAttribute("products", products);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("packageFilter", packageFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("page", "view_product.jsp");
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);            
    }
}