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

    private static final int DEFAULT_PAGE_SIZE = 6; // Số sản phẩm mỗi trang
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy parameters từ request
        String searchName = request.getParameter("searchName");
        String searchType = request.getParameter("searchType");
        String pageParam = request.getParameter("page");
        
        // Xử lý page number
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
        
        // Khởi tạo DAO
        InsuranceDBContext insuranceDAO = new InsuranceDBContext();
        
        // Lấy tổng số records để tính số trang
        int totalRecords = insuranceDAO.getTotalRecords(searchName, searchType);
        int totalPages = (int) Math.ceil((double) totalRecords / DEFAULT_PAGE_SIZE);
        
        // Đảm bảo currentPage không vượt quá totalPages
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        // Lấy danh sách insurance products
        ArrayList<InsuranceProduct> insurances = insuranceDAO.getAllPaging(
            currentPage, 
            DEFAULT_PAGE_SIZE, 
            searchName, 
            searchType
        );
        
        ArrayList<String> types = insuranceDAO.getAllType();
        
        // Set attributes để truyền sang JSP
        request.setAttribute("types", types);
        request.setAttribute("insurances", insurances);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", DEFAULT_PAGE_SIZE);
        
        // Giữ lại search parameters
        request.setAttribute("searchName", searchName != null ? searchName : "");
        request.setAttribute("searchType", searchType != null ? searchType : "");
        
        // Forward đến JSP
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