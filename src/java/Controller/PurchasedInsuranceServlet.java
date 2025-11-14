package Controller;

import Model.User;
import Model.Contract;
import dal.ContractDBContext;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet xử lý trang xem danh sách bảo hiểm đã mua của customer
 *
 * @author FPTSHOP
 */
@WebServlet(name = "PurchasedInsuranceServlet", urlPatterns = {"/purchased-insurance"})
public class PurchasedInsuranceServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10; // Số record mỗi trang
    private ContractDBContext contractDB;

    @Override
    public void init() throws ServletException {
        contractDB = new ContractDBContext();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        // Chỉ cho phép customer truy cập
        if (currentUser.getRole() == null || !"customer".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            // Lấy parameters từ request
            String searchTerm = request.getParameter("q");
            String statusFilter = request.getParameter("status");
            String typeFilter = request.getParameter("type");
            String pageParam = request.getParameter("page");
            String sortParam = request.getParameter("sort");
            

            // Xử lý phân trang
            int currentPage = 1;
            try {
                if (pageParam != null && !pageParam.trim().isEmpty()) {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }

            // Lấy dữ liệu từ database
            List<Contract> contracts = contractDB.getCustomerPurchasedInsurance(
                    currentUser.getId(), searchTerm, statusFilter, typeFilter, sortParam,
                    currentPage, DEFAULT_PAGE_SIZE
            );

            // Đếm tổng số records cho phân trang (sort không ảnh hưởng count)
            int totalRecords = contractDB.getCustomerContractCount(
                    currentUser.getId(), searchTerm, statusFilter, typeFilter
            );

            int totalPages = (int) Math.ceil((double) totalRecords / DEFAULT_PAGE_SIZE);

            // Điều chỉnh trang hiện tại nếu vượt quá
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
            }

            // Set attributes cho JSP
            request.setAttribute("contracts", contracts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("pageSize", DEFAULT_PAGE_SIZE);

            // Giữ lại giá trị filter để hiển thị lại
            request.setAttribute("searchTerm", searchTerm != null ? searchTerm : "");
            request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
            request.setAttribute("typeFilter", typeFilter != null ? typeFilter : "");
            request.setAttribute("sortParam", sortParam != null ? sortParam : "newest");

            // Forward đến JSP
            request.getRequestDispatcher("PurchasedInsurance.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách bảo hiểm: " + e.getMessage());
            request.getRequestDispatcher("PurchasedInsurance.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển POST sang GET để xử lý
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý danh sách bảo hiểm đã mua của customer";
    }
}
