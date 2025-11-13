package Controller;

import Model.User;
import Model.Claims;
import dal.DashboardDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

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

        DashboardDBContext dashboardDB = new DashboardDBContext();

        int activeContractsCount = dashboardDB.getActiveContractsCount();
        int claimsLast30Days = dashboardDB.getClaimsLast30Days();
        Map<String, Object> approvedRejectedRatio = dashboardDB.getApprovedRejectedRatio();
        BigDecimal totalRevenue = dashboardDB.getTotalRevenue();
        BigDecimal totalCompensationAmount = dashboardDB.getTotalCompensationAmount();

        int defaultLimit = 5;
        String limitStr = request.getParameter("limit");
        if (limitStr != null && !limitStr.trim().isEmpty()) {
            try {
                defaultLimit = Integer.parseInt(limitStr);
            } catch (NumberFormatException e) {
                defaultLimit = 5;
            }
        }

        List<Map<String, Object>> revenueByProduct = dashboardDB.getRevenueByProduct(defaultLimit);

        List<Map<String, Object>> claimRateByProduct = dashboardDB.getClaimRateByProduct(defaultLimit);

        List<Claims> fraudAlertClaims = dashboardDB.getFraudAlertClaims(defaultLimit);

        List<Claims> unusualLargeContractClaims = dashboardDB.getUnusualLargeContractClaims(defaultLimit);

        List<Map<String, Object>> topRiskCustomers = dashboardDB.getTopRiskCustomers(2, 1, defaultLimit);

        List<Map<String, Object>> topSellingProducts = dashboardDB.getTopSellingProducts(defaultLimit);

        List<Map<String, Object>> productsWithMostClaims = dashboardDB.getProductsWithMostClaims(defaultLimit);

        List<Map<String, Object>> topRevenueProducts = dashboardDB.getTopRevenueProducts(defaultLimit);

        List<Claims> newCustomerRiskClaims = dashboardDB.getNewCustomerRiskClaims(defaultLimit);

        Date defaultFromDate = new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000);
        Date defaultToDate = new Date(System.currentTimeMillis());
        List<Map<String, Object>> staffApprovalStats = dashboardDB.getStaffApprovalStats(defaultFromDate, defaultToDate);

        List<Map<String, Object>> customersWithManyContracts = dashboardDB.getCustomersWithManyContracts(3, 7);

        request.setAttribute("activeContractsCount", activeContractsCount);
        request.setAttribute("claimsLast30Days", claimsLast30Days);
        request.setAttribute("approvedRejectedRatio", approvedRejectedRatio);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalCompensationAmount", totalCompensationAmount);
        request.setAttribute("revenueByProduct", revenueByProduct);
        request.setAttribute("claimRateByProduct", claimRateByProduct);
        request.setAttribute("fraudAlertClaims", fraudAlertClaims);
        request.setAttribute("unusualLargeContractClaims", unusualLargeContractClaims);
        request.setAttribute("topRiskCustomers", topRiskCustomers);
        request.setAttribute("topSellingProducts", topSellingProducts);
        request.setAttribute("productsWithMostClaims", productsWithMostClaims);
        request.setAttribute("topRevenueProducts", topRevenueProducts);
        request.setAttribute("newCustomerRiskClaims", newCustomerRiskClaims);
        request.setAttribute("staffApprovalStats", staffApprovalStats);
        request.setAttribute("customersWithManyContracts", customersWithManyContracts);
        request.setAttribute("defaultFromDate", defaultFromDate);
        request.setAttribute("defaultToDate", defaultToDate);
        request.setAttribute("selectedFromDate", defaultFromDate);
        request.setAttribute("selectedToDate", defaultToDate);
        request.setAttribute("defaultLimit", defaultLimit);

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        DashboardDBContext dashboardDB = new DashboardDBContext();
        String action = request.getParameter("action");

        if ("staffApproval".equals(action)) {
            // Handle staff approval filter
            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            String staffIdStr = request.getParameter("staffId");

            Date fromDate = null;
            Date toDate = null;

            try {
                if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    fromDate = new Date(sdf.parse(fromDateStr).getTime());
                }
                if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    toDate = new Date(sdf.parse(toDateStr).getTime());
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }

            // Default to last 30 days if not provided
            if (fromDate == null) {
                fromDate = new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000);
            }
            if (toDate == null) {
                toDate = new Date(System.currentTimeMillis());
            }

            List<Map<String, Object>> staffApprovalStats = dashboardDB.getStaffApprovalStats(fromDate, toDate);
            request.setAttribute("staffApprovalStats", staffApprovalStats);
            request.setAttribute("selectedFromDate", fromDate);
            request.setAttribute("selectedToDate", toDate);

            // If staffId is selected, get claims by that staff
            if (staffIdStr != null && !staffIdStr.trim().isEmpty()) {
                try {
                    int staffId = Integer.parseInt(staffIdStr);
                    List<Claims> claimsByStaff = dashboardDB.getClaimsByStaff(staffId, fromDate, toDate);
                    // Null safety check
                    if (claimsByStaff != null) {
                        request.setAttribute("claimsByStaff", claimsByStaff);
                        request.setAttribute("selectedStaffId", staffId);
                        System.out.println("Successfully loaded " + claimsByStaff.size() + " claims for staff " + staffId);
                    } else {
                        System.err.println("getClaimsByStaff returned null for staffId: " + staffId);
                        request.setAttribute("claimsByStaff", new ArrayList<Claims>());
                        request.setAttribute("selectedStaffId", staffId);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Invalid staffId format: " + staffIdStr);
                    e.printStackTrace();
                    request.setAttribute("error", "ID nhân viên không hợp lệ: " + staffIdStr);
                } catch (Exception e) {
                    System.err.println("Error getting claims by staff: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi khi tải danh sách claim: " + e.getMessage());
                    // Set empty list to prevent null pointer
                    request.setAttribute("claimsByStaff", new ArrayList<Claims>());
                }
            }

        } else if ("customerRisk".equals(action)) {
            // Handle customer risk search
            String minContractsStr = request.getParameter("minContracts");
            String daysStr = request.getParameter("days");

            int minContracts = 3; // default
            int days = 7; // default

            try {
                if (minContractsStr != null && !minContractsStr.trim().isEmpty()) {
                    minContracts = Integer.parseInt(minContractsStr);
                }
                if (daysStr != null && !daysStr.trim().isEmpty()) {
                    days = Integer.parseInt(daysStr);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }

            List<Map<String, Object>> customersWithManyContracts = dashboardDB.getCustomersWithManyContracts(minContracts, days);
            request.setAttribute("customersWithManyContracts", customersWithManyContracts);
            request.setAttribute("selectedMinContracts", minContracts);
            request.setAttribute("selectedDays", days);
        }

        // Re-fetch all basic metrics for display
        int activeContractsCount = dashboardDB.getActiveContractsCount();
        int claimsLast30Days = dashboardDB.getClaimsLast30Days();
        Map<String, Object> approvedRejectedRatio = dashboardDB.getApprovedRejectedRatio();
        BigDecimal totalRevenue = dashboardDB.getTotalRevenue();
        // Get default limit from request or use 5
        int defaultLimit = 5;
        String limitStr = request.getParameter("limit");
        if (limitStr != null && !limitStr.trim().isEmpty()) {
            try {
                defaultLimit = Integer.parseInt(limitStr);
            } catch (NumberFormatException e) {
                defaultLimit = 5;
            }
        }

        List<Map<String, Object>> revenueByProduct = dashboardDB.getRevenueByProduct(defaultLimit);
        List<Map<String, Object>> claimRateByProduct = dashboardDB.getClaimRateByProduct(defaultLimit);
        List<Claims> fraudAlertClaims = dashboardDB.getFraudAlertClaims(5);
        List<Claims> unusualLargeContractClaims = dashboardDB.getUnusualLargeContractClaims(5);
        List<Map<String, Object>> topRiskCustomers = dashboardDB.getTopRiskCustomers(2, 1, defaultLimit);
        List<Map<String, Object>> topSellingProducts = dashboardDB.getTopSellingProducts(5);
        List<Map<String, Object>> productsWithMostClaims = dashboardDB.getProductsWithMostClaims(5);
        List<Map<String, Object>> topRevenueProducts = dashboardDB.getTopRevenueProducts(5);

        request.setAttribute("activeContractsCount", activeContractsCount);
        request.setAttribute("claimsLast30Days", claimsLast30Days);
        request.setAttribute("approvedRejectedRatio", approvedRejectedRatio);
        request.setAttribute("totalRevenue", totalRevenue);
        BigDecimal totalCompensationAmount = dashboardDB.getTotalCompensationAmount();
        request.setAttribute("totalCompensationAmount", totalCompensationAmount);
        request.setAttribute("revenueByProduct", revenueByProduct);
        request.setAttribute("claimRateByProduct", claimRateByProduct);
        request.setAttribute("fraudAlertClaims", fraudAlertClaims);
        request.setAttribute("unusualLargeContractClaims", unusualLargeContractClaims);
        request.setAttribute("topRiskCustomers", topRiskCustomers);
        request.setAttribute("topSellingProducts", topSellingProducts);
        request.setAttribute("productsWithMostClaims", productsWithMostClaims);
        request.setAttribute("topRevenueProducts", topRevenueProducts);
        
        // Set default dates if not already set
        if (request.getAttribute("selectedFromDate") == null) {
            request.setAttribute("selectedFromDate", new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000));
        }
        if (request.getAttribute("selectedToDate") == null) {
            request.setAttribute("selectedToDate", new Date(System.currentTimeMillis()));
        }
        if (request.getAttribute("defaultFromDate") == null) {
            request.setAttribute("defaultFromDate", new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000));
        }
        if (request.getAttribute("defaultToDate") == null) {
            request.setAttribute("defaultToDate", new Date(System.currentTimeMillis()));
        }
        if (request.getAttribute("defaultLimit") == null) {
            request.setAttribute("defaultLimit", defaultLimit);
        }

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}

