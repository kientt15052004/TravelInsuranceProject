package Controller;

import dal.ProductDBController;
import Model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ViewProduct extends HttpServlet {   

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDBController productDB = new ProductDBController();
        List<Product> products = productDB.getAllProducts();
        request.setAttribute("products", products); //Trả về danh sách sản phẩm còn tồn tại
        request.setAttribute("page", "view_product.jsp");
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);            
}
}