package Controller;

import dal.InsuranceDBContext;
import Model.InsuranceProduct;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet for handling insurance list with pagination, search, and filter
 */
@WebServlet(name = "InsuranceListServlet", urlPatterns = {"/InsuranceList"})
public class InsuranceListController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 8; // Số sản phẩm mỗi trang

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchName = request.getParameter("searchName"); // lấy gt người dùng nhập ở input trên form jsp rồi lưu vào biến searchName trong servlet để handle
        
        String searchType = request.getParameter("searchType");
        String pageParam = request.getParameter("page");
        String priceMinParam = request.getParameter("minPrice");
        String priceMaxParam = request.getParameter("maxPrice");

        Double priceMin = null;
        Double priceMax = null;

        try {
            if (priceMinParam != null && !priceMinParam.trim().isEmpty()) {  // Chỉ xử lý khi người dùng thật sự nhập
                                                                             // giá trị (không để trống, không toàn khoảng trắng, và không null).
                priceMin = Double.parseDouble(priceMinParam); // Chuyển "1000" → 1000.0
            }
            if (priceMaxParam != null && !priceMaxParam.trim().isEmpty()) {
                priceMax = Double.parseDouble(priceMaxParam); // Chuyển "5000" → 5000.0
            }
        } catch (NumberFormatException e) {
            // bỏ qua nếu không hợp lệ
        }

        int currentPage = 1; // Mặc định là trang 1
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

        InsuranceDBContext insuranceDAO = new InsuranceDBContext();

        int totalRecords = insuranceDAO.getTotalRecords(searchName, searchType, priceMin, priceMax); //đếm tổng số bản ghi
        int totalPages = (int) Math.ceil((double) totalRecords / DEFAULT_PAGE_SIZE);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        ArrayList<InsuranceProduct> insurances = insuranceDAO.getAllPaging(
                currentPage, DEFAULT_PAGE_SIZE, searchName, searchType, priceMin, priceMax
        ); // truy vấn dữ liệu chính để hiển thị.

        ArrayList<String> types = insuranceDAO.getAllType(); //Lấy danh sách tất cả các loại bảo hiểm

        request.setAttribute("types", types); // Gắn dữ liệu types vào request để JSP có thể dùng hiển thị.
        request.setAttribute("insurances", insurances);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", DEFAULT_PAGE_SIZE);

        // giữ lại giá trị filter để hiển thị lại
        request.setAttribute("searchName", searchName != null ? searchName : "");
        request.setAttribute("searchType", searchType != null ? searchType : "");
        request.setAttribute("priceMin", priceMinParam != null ? priceMinParam : "");
        request.setAttribute("priceMax", priceMaxParam != null ? priceMaxParam : "");

        request.getRequestDispatcher("InsuranceList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển POST sang GET để xử lý
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Insurance List Servlet with Pagination, Search and Filter";
    }
}
