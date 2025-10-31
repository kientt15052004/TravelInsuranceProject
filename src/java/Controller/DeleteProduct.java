package Controller;

import dal.InsuranceDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.User;

public class DeleteProduct extends HttpServlet {

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
