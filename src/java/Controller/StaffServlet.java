package Controller;

import Model.User;
import Model.Claims;
import dal.ClaimsDBContext;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffServlet", urlPatterns = {"/staff"})
public class StaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"staff".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        ClaimsDBContext claimsDB = new ClaimsDBContext();
        

        int totalClaims = claimsDB.getTotalClaims();
        int pendingClaims = claimsDB.getClaimsByStatusCount("pending");
        int approvedClaims = claimsDB.getClaimsByStatusCount("approved");

        int recentClaimsCount = claimsDB.getRecentClaimsCount(2);
        

        List<Claims> recentClaims = claimsDB.getRecentClaims(10);

        List<Claims> overduePendingClaims = claimsDB.getOverduePendingClaims(10);
        
        // Set attributes for JSP
        request.setAttribute("totalClaims", totalClaims);
        request.setAttribute("pendingClaims", pendingClaims);
        request.setAttribute("approvedClaims", approvedClaims);
        request.setAttribute("recentClaimsCount", recentClaimsCount);
        request.setAttribute("recentClaims", recentClaims);
        request.setAttribute("pendingClaimsList", overduePendingClaims);

        request.getRequestDispatcher("/staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
