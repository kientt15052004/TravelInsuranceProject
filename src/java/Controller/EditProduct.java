package Controller;

import Model.InsuranceProduct;
import dal.InsuranceDBContext;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.User;

public class EditProduct extends HttpServlet {

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
            int id = Integer.parseInt(request.getParameter("id"));
            int benefitId = Integer.parseInt(request.getParameter("id_benefit"));
            
            InsuranceProduct product = insuranceDAO.getByIdWithBenefit(id);
            if (product != null) {
                System.out.println("DEBUG: Product loaded - package_type: " + product.getPackage_type());
                // Load all package types from database for dropdown
                java.util.ArrayList<String> packageTypes = insuranceDAO.getAllPackageTypes();
                request.setAttribute("packageTypes", packageTypes);
                request.setAttribute("product", product);
                request.getRequestDispatcher("/edit_product.jsp").forward(request, response);
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
