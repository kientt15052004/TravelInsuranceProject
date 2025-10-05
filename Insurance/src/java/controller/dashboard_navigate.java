package controller;


import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class dashboard_navigate extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String page = request.getParameter("page");
        String requestURI = request.getRequestURI();
        
        // Handle /Staff routes
        if (requestURI.endsWith("/Staff")) {
            request.getRequestDispatcher("/Staff.jsp").forward(request, response);
            return;
        } else if (requestURI.contains("/Staff/CreateContract")) {
            request.getRequestDispatcher("/CreateContract.jsp").forward(request, response);
            return;
        } else if (requestURI.contains("/Staff/ContractManagement")) {
            request.getRequestDispatcher("/ContractManagement.jsp").forward(request, response);
            return;
        }
        
        if ("home".equals(page)) {
            request.setAttribute("page", "home.jsp");
        } else if ("user".equals(page)) {
            request.setAttribute("page", "user.jsp");
        } else if ("report".equals(page)) {
            request.setAttribute("page", "report.jsp");
        } else if ("create".equals(page)) {
            request.setAttribute("page", "create_product.jsp");
        }
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }
    
}
