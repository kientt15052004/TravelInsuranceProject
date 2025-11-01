package Controller;

import Model.InsuranceProduct;
import dal.InsuranceDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import Model.User;

public class FilterProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getRole() == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        InsuranceDBContext insuranceDAO = new InsuranceDBContext();
        String filter = request.getParameter("filter");
        if (filter.equals("all")) {
            ArrayList<InsuranceProduct> products = insuranceDAO.getAll();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } else if (filter.equals("domestic")) {
            ArrayList<InsuranceProduct> products = insuranceDAO.getDomesticProducts();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } else if (filter.equals("international")) {
            ArrayList<InsuranceProduct> products = insuranceDAO.getInternationalProducts();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } else if (filter.equals("nonactive")) {
            ArrayList<InsuranceProduct> products = insuranceDAO.getNonActiveProducts();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } else if (filter.equals("active")) {
            ArrayList<InsuranceProduct> products = insuranceDAO.getActiveProducts();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
