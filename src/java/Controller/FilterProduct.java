package Controller;

import Model.Product;
import dal.ProductDBController;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

public class FilterProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDBController productDB = new ProductDBController();
        String filter = request.getParameter("filter");
        if (filter.equals("all")) {
            List<Product> products = productDB.getAllProducts();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } else if (filter.equals("domestic")) {
            List<Product> products = productDB.getDomesticProducts();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } else if (filter.equals("international")) {
            List<Product> products = productDB.getInternationProducts();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } else if (filter.equals("nonactive")) {
            List<Product> products = productDB.getNonActiveProducts();
            request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
            request.setAttribute("page", "view_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } else if (filter.equals("active")) {
            List<Product> products = productDB.getActiveProducts();
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
