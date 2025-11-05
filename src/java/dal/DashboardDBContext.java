package dal;

import Model.Claims;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDBContext extends DBContext {

    /**
     * Tổng hợp đồng đang có hiệu lực
     */
    public int getActiveContractsCount() {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return 0;
        }

        String sql = "SELECT COUNT(*) FROM Contract WHERE contract_status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Doanh thu theo sản phẩm
     */
    public List<Map<String, Object>> getRevenueByProduct(int limit) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return results;
        }

        String sql = "SELECT p.id as productId, p.name as productName, "
                + "SUM(i.base_amount * (1 + i.tax_rate)) as revenue "
                + "FROM invoices i "
                + "JOIN Contract c ON i.contract_id = c.contract_id "
                + "JOIN applications a ON c.application_id = a.id "
                + "JOIN products p ON a.product_id = p.id "
                + "GROUP BY p.id, p.name "
                + "ORDER BY revenue DESC "
                + "LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("productId", rs.getInt("productId"));
                product.put("productName", rs.getString("productName"));
                product.put("revenue", rs.getBigDecimal("revenue"));
                results.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return results;
    }

    /**
     * Tổng doanh thu
     */
    public BigDecimal getTotalRevenue() {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return BigDecimal.ZERO;
        }

        String sql = "SELECT SUM(i.base_amount * (1 + i.tax_rate)) as totalRevenue "
                + "FROM invoices i";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal("totalRevenue");
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    /**
     * Tổng số tiền đã đền bù cho khách hàng
     */
    public BigDecimal getTotalCompensationAmount() {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return BigDecimal.ZERO;
        }

        String sql = "SELECT SUM(compensation_amount) as totalCompensation "
                + "FROM claims "
                + "WHERE claim_status = 'approved' AND compensation_amount IS NOT NULL";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal compensation = rs.getBigDecimal("totalCompensation");
                return compensation != null ? compensation : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    /**
     * Claim theo 30 ngày qua
     */
    public int getClaimsLast30Days() {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return 0;
        }

        String sql = "SELECT COUNT(*) FROM Claims "
                + "WHERE requestDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Tỷ lệ Approved/Rejected
     */
    public Map<String, Object> getApprovedRejectedRatio() {
        Map<String, Object> result = new HashMap<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return result;
        }

        String sql = "SELECT "
                + "COUNT(CASE WHEN claim_status = 'approved' THEN 1 END) as approved, "
                + "COUNT(CASE WHEN claim_status = 'rejected' THEN 1 END) as rejected, "
                + "COUNT(*) as total, "
                + "ROUND(COUNT(CASE WHEN claim_status = 'approved' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) as approvedRatio, "
                + "ROUND(COUNT(CASE WHEN claim_status = 'rejected' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) as rejectedRatio "
                + "FROM Claims";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result.put("approved", rs.getInt("approved"));
                result.put("rejected", rs.getInt("rejected"));
                result.put("total", rs.getInt("total"));
                result.put("approvedRatio", rs.getDouble("approvedRatio"));
                result.put("rejectedRatio", rs.getDouble("rejectedRatio"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return result;
    }

    /**
     * Claim được đền bù số tiền lớn - các claim đã approved có compensation_amount
     * Sắp xếp theo số tiền đền bù từ cao đến thấp
     */
    public List<Claims> getFraudAlertClaims(int limit) {
        return getHighCompensationClaims(limit);
    }
    
    /**
     * Claim được đền bù số tiền lớn - các claim đã approved có compensation_amount
     * Sắp xếp theo số tiền đền bù từ cao đến thấp
     */
    public List<Claims> getHighCompensationClaims(int limit) {
        List<Claims> claims = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims;
        }

        String sql = "SELECT c.* "
                + "FROM Claims c "
                + "WHERE c.claim_status = 'approved' "
                + "AND c.compensation_amount IS NOT NULL "
                + "AND c.compensation_amount > 0 "
                + "ORDER BY c.compensation_amount DESC "
                + "LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Claims claim = mapClaimFromResultSet(rs);
                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return claims;
    }

    /**
     * Claim của hợp đồng lớn bất thường (top 10% theo giá trị)
     */
    public List<Claims> getUnusualLargeContractClaims(int limit) {
        List<Claims> claims = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims;
        }

        String sql = "SELECT c.*, COALESCE(a.total_price, 0) as contract_total_price "
                + "FROM Claims c "
                + "INNER JOIN Contract ct ON c.contract_id = ct.contract_id "
                + "INNER JOIN applications a ON ct.application_id = a.id "
                + "WHERE c.claim_status = 'pending' "
                + "ORDER BY COALESCE(a.total_price, 0) DESC, c.requestDate ASC "
                + "LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Claims claim = mapClaimFromResultSet(rs);
                BigDecimal contractTotalPrice = rs.getBigDecimal("contract_total_price");
                claim.setContractTotalPrice(contractTotalPrice != null ? contractTotalPrice : BigDecimal.ZERO);
                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return claims;
    }

    /**
     * Staff chấp nhận nhiều claim trong khoảng thời gian
     * Chỉ đếm quyết định cuối cùng (mới nhất) cho mỗi claim để tránh đếm trùng khi thay đổi quyết định
     */
    public List<Map<String, Object>> getStaffApprovalStats(Date from, Date to) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return results;
        }

        // Subquery để lấy ClaimsRes mới nhất (quyết định cuối cùng) cho mỗi claim
        // Chỉ lấy những ClaimsRes có action_type = 'approve' hoặc 'reject'
        String sql = "SELECT u.id as staffId, u.fullname as staffName, "
                + "COUNT(CASE WHEN latest_res.action_type = 'approve' THEN 1 END) as approvedCount, "
                + "COUNT(CASE WHEN latest_res.action_type = 'reject' THEN 1 END) as rejectedCount "
                + "FROM users u "
                + "JOIN ("
                + "  SELECT cr1.* "
                + "  FROM ClaimsRes cr1 "
                + "  INNER JOIN ("
                + "    SELECT claim_id, MAX(createDate) as maxDate "
                + "    FROM ClaimsRes "
                + "    WHERE action_type IN ('approve', 'reject') "
                + "    GROUP BY claim_id"
                + "  ) cr2 ON cr1.claim_id = cr2.claim_id AND cr1.createDate = cr2.maxDate "
                + "  WHERE cr1.action_type IN ('approve', 'reject')"
                + ") latest_res ON u.id = latest_res.user_id "
                + "WHERE latest_res.createDate BETWEEN ? AND ? "
                + "AND u.role = 'staff' "
                + "GROUP BY u.id, u.fullname "
                + "ORDER BY approvedCount DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> staff = new HashMap<>();
                staff.put("staffId", rs.getInt("staffId"));
                staff.put("staffName", rs.getString("staffName"));
                staff.put("approvedCount", rs.getInt("approvedCount"));
                staff.put("rejectedCount", rs.getInt("rejectedCount"));
                results.add(staff);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return results;
    }

    /**
     * Danh sách claim theo staff đã duyệt
     */
    public List<Claims> getClaimsByStaff(int staffId, Date from, Date to) {
        List<Claims> claims = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims;
        }

        String sql = "SELECT DISTINCT cl.* "
                + "FROM Claims cl "
                + "JOIN ClaimsRes cr ON cl.id = cr.claim_id "
                + "WHERE cr.user_id = ? "
                + "AND cr.createDate BETWEEN ? AND ? "
                + "ORDER BY cl.requestDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            ps.setDate(2, from);
            ps.setDate(3, to);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Claims claim = mapClaimFromResultSet(rs);
                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return claims;
    }

    /**
     * Claim khách mới mua < 7 ngày (rủi ro cao)
     */
    public List<Claims> getNewCustomerRiskClaims(int limit) {
        return getFraudAlertClaims(limit); // Same logic
    }

    /**
     * Sản phẩm bán chạy (số lượng hợp đồng)
     */
    public List<Map<String, Object>> getTopSellingProducts(int limit) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return results;
        }

        String sql = "SELECT p.id as productId, p.name as productName, "
                + "COUNT(DISTINCT c.contract_id) as contractCount "
                + "FROM products p "
                + "LEFT JOIN applications a ON p.id = a.product_id "
                + "LEFT JOIN Contract c ON a.id = c.application_id "
                + "WHERE c.contract_id IS NOT NULL "
                + "GROUP BY p.id, p.name "
                + "ORDER BY contractCount DESC "
                + "LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("productId", rs.getInt("productId"));
                product.put("productName", rs.getString("productName"));
                product.put("contractCount", rs.getInt("contractCount"));
                results.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return results;
    }

    /**
     * Sản phẩm bị claim nhiều nhất
     */
    public List<Map<String, Object>> getProductsWithMostClaims(int limit) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return results;
        }

        String sql = "SELECT p.id as productId, p.name as productName, "
                + "COUNT(cl.id) as claimCount "
                + "FROM products p "
                + "JOIN applications a ON p.id = a.product_id "
                + "JOIN Contract c ON a.id = c.application_id "
                + "JOIN Claims cl ON c.contract_id = cl.contract_id "
                + "GROUP BY p.id, p.name "
                + "ORDER BY claimCount DESC "
                + "LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("productId", rs.getInt("productId"));
                product.put("productName", rs.getString("productName"));
                product.put("claimCount", rs.getInt("claimCount"));
                results.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return results;
    }

    /**
     * Tỷ lệ claim/hợp đồng theo sản phẩm
     */
    public List<Map<String, Object>> getClaimRateByProduct(int limit) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return results;
        }

        String sql = "SELECT p.id as productId, p.name as productName, "
                + "COUNT(DISTINCT c.contract_id) as totalContracts, "
                + "COUNT(cl.id) as totalClaims, "
                + "ROUND(COUNT(cl.id) * 100.0 / NULLIF(COUNT(DISTINCT c.contract_id), 0), 2) as claimRate "
                + "FROM products p "
                + "LEFT JOIN applications a ON p.id = a.product_id "
                + "LEFT JOIN Contract c ON a.id = c.application_id "
                + "LEFT JOIN Claims cl ON c.contract_id = cl.contract_id "
                + "GROUP BY p.id, p.name "
                + "HAVING totalContracts > 0 "
                + "ORDER BY claimRate DESC "
                + "LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("productId", rs.getInt("productId"));
                product.put("productName", rs.getString("productName"));
                product.put("totalContracts", rs.getInt("totalContracts"));
                product.put("totalClaims", rs.getInt("totalClaims"));
                product.put("claimRate", rs.getDouble("claimRate"));
                results.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return results;
    }

    /**
     * Top khách hàng rủi ro (nhiều claim, nhiều claim bị reject)
     */
    public List<Map<String, Object>> getTopRiskCustomers(int minClaims, int minRejectedClaims, int limit) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return results;
        }

        String sql = "SELECT u.id as customerId, u.fullname as customerName, "
                + "COUNT(cl.id) as totalClaims, "
                + "COUNT(CASE WHEN cl.claim_status = 'rejected' THEN 1 END) as rejectedClaims, "
                + "ROUND(COUNT(CASE WHEN cl.claim_status = 'rejected' THEN 1 END) * 100.0 / NULLIF(COUNT(cl.id), 0), 2) as riskScore "
                + "FROM users u "
                + "JOIN applications a ON u.id = a.purchaser_id "
                + "JOIN Contract c ON a.id = c.application_id "
                + "JOIN Claims cl ON c.contract_id = cl.contract_id "
                + "GROUP BY u.id, u.fullname "
                + "HAVING totalClaims >= ? AND rejectedClaims >= ? "
                + "ORDER BY riskScore DESC, totalClaims DESC "
                + "LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, minClaims);
            ps.setInt(2, minRejectedClaims);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> customer = new HashMap<>();
                customer.put("customerId", rs.getInt("customerId"));
                customer.put("customerName", rs.getString("customerName"));
                customer.put("totalClaims", rs.getInt("totalClaims"));
                customer.put("rejectedClaims", rs.getInt("rejectedClaims"));
                customer.put("riskScore", rs.getDouble("riskScore"));
                results.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return results;
    }

    /**
     * Sản phẩm có doanh thu cao nhất
     */
    public List<Map<String, Object>> getTopRevenueProducts(int limit) {
        return getRevenueByProduct(limit);
    }

    /**
     * Khách hàng mới mua nhiều hợp đồng trong thời gian ngắn
     */
    public List<Map<String, Object>> getCustomersWithManyContracts(int minContracts, int days) {
        List<Map<String, Object>> results = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return results;
        }

        String sql = "SELECT u.id as customerId, u.fullname as customerName, "
                + "COUNT(*) as contractCount, "
                + "MIN(a.startDate) as firstContractDate, "
                + "MAX(a.startDate) as lastContractDate "
                + "FROM users u "
                + "JOIN applications a ON u.id = a.purchaser_id "
                + "WHERE a.startDate >= DATE_SUB(CURDATE(), INTERVAL ? DAY) "
                + "GROUP BY u.id, u.fullname "
                + "HAVING contractCount >= ? "
                + "ORDER BY contractCount DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, days);
            ps.setInt(2, minContracts);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> customer = new HashMap<>();
                customer.put("customerId", rs.getInt("customerId"));
                customer.put("customerName", rs.getString("customerName"));
                customer.put("contractCount", rs.getInt("contractCount"));
                customer.put("firstContractDate", rs.getDate("firstContractDate"));
                customer.put("lastContractDate", rs.getDate("lastContractDate"));
                results.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        return results;
    }

    /**
     * Helper method to map ResultSet to Claims object
     */
    private Claims mapClaimFromResultSet(ResultSet rs) throws SQLException {
        Claims claim = new Claims();
        claim.setId(rs.getInt("id"));
        claim.setContract_id(rs.getInt("contract_id"));
        claim.setRequestDate(rs.getDate("requestDate"));
        claim.setClaim_type(rs.getString("claim_type"));
        claim.setDescription(rs.getString("description"));
        claim.setPayment_bank(rs.getString("payment_bank"));
        claim.setPayment_number(rs.getString("payment_number"));
        claim.setRelated_img(rs.getString("related_img"));
        claim.setRelated_file(rs.getString("related_file"));
        claim.setClaim_status(rs.getString("claim_status"));
        
        try {
            if (rs.findColumn("claim_amount") > 0) {
                claim.setClaim_amount(rs.getBigDecimal("claim_amount"));
            }
        } catch (SQLException e) {
            claim.setClaim_amount(null);
        }
        
        try {
            if (rs.findColumn("compensation_amount") > 0) {
                claim.setCompensation_amount(rs.getBigDecimal("compensation_amount"));
            }
        } catch (SQLException e) {
            claim.setCompensation_amount(null);
        }
        
        return claim;
    }
}

