package Controller;

import dal.InsuranceDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeleteProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        InsuranceDBContext insuranceDAO = new InsuranceDBContext();
        try {
            String id = request.getParameter("id");
            String benefitId = request.getParameter("id_benefit");
            System.out.println("id: " + id);
            System.out.println("benefit_id: " + benefitId);
            insuranceDAO.deleteProduct(Integer.parseInt(id));

            response.sendRedirect(request.getContextPath() + "/view_product");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi xoá sản phẩm hoặc quyền lợi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/view_product");
        }
    }

}
