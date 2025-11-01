package Controller;

import dal.InsuranceDBContext;
import Model.InsuranceProduct;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.ArrayList;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author kient
 */
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        InsuranceDBContext dao = new InsuranceDBContext();
        ArrayList<InsuranceProduct> list = dao.getTopSellingProducts(4);

        HttpSession session = request.getSession(false);
        if (session != null) {
            Model.User user = (Model.User) session.getAttribute("user");
            if (user != null) {
                request.setAttribute("user", user); 
            }
        }

        request.setAttribute("products", list);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }

}
