package Controller;

import Model.InsuranceBenefit1;
import Model.Product;
import dal.ProductDBController;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class EditProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDBController productDB = new ProductDBController();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int benefitId = Integer.parseInt(request.getParameter("id_benefit"));
            Product product = productDB.getProductById(id);
            InsuranceBenefit1 benefit = productDB.getInsuranceBenefitById(benefitId);
            if (product != null && benefit != null) {
                request.setAttribute("product", product);
                request.setAttribute("benefit", benefit);
                request.setAttribute("page", "edit_product.jsp");
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "ID sản phẩm không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/view_product");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi tải thông tin sản phẩm: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/view_product");
        }

    }
}
