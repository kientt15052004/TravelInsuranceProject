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
        ArrayList<InsuranceProduct> products = insuranceDAO.getAll();
        
        request.setAttribute("products", products);
        request.setAttribute("page", "view_product.jsp");
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);            
    }
}