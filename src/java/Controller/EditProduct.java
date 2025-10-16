package Controller;

import Model.InsuranceProduct;
import dal.InsuranceDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class EditProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        InsuranceDBContext insuranceDAO = new InsuranceDBContext();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int benefitId = Integer.parseInt(request.getParameter("id_benefit"));
            
            InsuranceProduct product = insuranceDAO.getById(id);
            if (product != null) {
                request.setAttribute("product", product);
                request.setAttribute("page", "edit_product.jsp");
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy sản phẩm!");
                response.sendRedirect(request.getContextPath() + "/view_product");
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
