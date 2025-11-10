package dal;

import Model.Claims;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClaimsDBContext extends DBContext {

    public List<Claims> getClaimsByContractId(int contractId) {
        System.out.println("Getting claims for contract ID: " + contractId);
        List<Claims> claims = new ArrayList<>();

        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims;
        }

        String sql = "SELECT * FROM claims WHERE contract_id = ? ORDER BY CASE claim_status "
                + "WHEN 'pending' THEN 1 WHEN 'in_progress' THEN 2 WHEN 'need_info' THEN 3 "
                + "WHEN 'approved' THEN 4 WHEN 'paid' THEN 5 WHEN 'rejected' THEN 6 ELSE 7 END, requestDate ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            System.out.println("Executing SQL: " + sql + " with contractId: " + contractId);
            ResultSet rs = ps.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
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

                claims.add(claim);
            }
            System.out.println("Found " + count + " claims for contract ID: " + contractId);
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Vendor Error: " + e.getErrorCode());

            System.err.println("Returning empty claims list due to error");
        }

        return claims;
    }

    public List<Claims> getAllClaimsWithFilters(String searchTerm, String statusFilter, String typeFilter) {
        List<Claims> claims = new ArrayList<>();

        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.* FROM claims c ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (c.contract_id LIKE ? OR c.description LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append("AND c.claim_status = ? ");
            parameters.add(statusFilter);
        }

        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql.append("AND c.claim_type = ? ");
            parameters.add(typeFilter);
        }

        sql.append("ORDER BY CASE c.claim_status WHEN 'pending' THEN 1 WHEN 'in_progress' THEN 2 WHEN 'need_info' THEN 3 "
                + "WHEN 'approved' THEN 4 WHEN 'paid' THEN 5 WHEN 'rejected' THEN 6 ELSE 7 END, c.requestDate ASC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            System.out.println("Executing SQL: " + sql.toString());
            ResultSet rs = ps.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
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

                claims.add(claim);
            }
            System.out.println("Found " + count + " claims with filters");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }

        return claims;
    }

    public List<String> getAllClaimTypes() {
        List<String> claimTypes = new ArrayList<>();

        if (connection == null) {
            System.err.println("Database connection is null!");
            return claimTypes;
        }

        String sql = "SELECT DISTINCT claim_type FROM claims WHERE claim_type IS NOT NULL ORDER BY claim_type";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String claimType = rs.getString("claim_type");
                if (claimType != null && !claimType.trim().isEmpty()) {
                    claimTypes.add(claimType);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }

        return claimTypes;
    }

    public boolean updateClaimStatusWithReason(int claimId, String newStatus, String reason) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return false;
        }

        String sql = "UPDATE claims SET claim_status = ? WHERE id = ?";

        try {
            // Read old status
            String oldStatus = null;
            String selectSql = "SELECT claim_status FROM claims WHERE id = ?";
            try (PreparedStatement sel = connection.prepareStatement(selectSql)) {
                sel.setInt(1, claimId);
                ResultSet rs = sel.executeQuery();
                if (rs.next()) {
                    oldStatus = rs.getString("claim_status");
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, newStatus);
                ps.setInt(2, claimId);

                int rowsAffected = ps.executeUpdate();
                System.out.println("Updated claim " + claimId + " status to " + newStatus + ". Rows affected: " + rowsAffected);

                if (rowsAffected > 0) {
                    // Insert into history
                    String historySql = "INSERT INTO ClaimStatusHistory (claim_id, old_status, new_status, changed_by, note) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement hs = connection.prepareStatement(historySql)) {
                        hs.setInt(1, claimId);
                        if (oldStatus != null) {
                            hs.setString(2, oldStatus);
                        } else {
                            hs.setNull(2, java.sql.Types.VARCHAR);
                        }
                        hs.setString(3, newStatus);
                        hs.setNull(4, java.sql.Types.INTEGER); // changed_by unknown in this context
                        if (reason != null && !reason.trim().isEmpty()) {
                            hs.setString(5, reason);
                        } else {
                            hs.setNull(5, java.sql.Types.VARCHAR);
                        }
                        hs.executeUpdate();
                    }
                }

                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error updating claim status: " + e.getMessage());
            return false;
        }
    }

    public boolean updateClaimStatus(int claimId, String newStatus, String reason) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return false;
        }

        String sql = "UPDATE claims SET claim_status = ? WHERE id = ?";

        try {
            // Read old status
            String oldStatus = null;
            String selectSql = "SELECT claim_status FROM claims WHERE id = ?";
            try (PreparedStatement sel = connection.prepareStatement(selectSql)) {
                sel.setInt(1, claimId);
                ResultSet rs = sel.executeQuery();
                if (rs.next()) {
                    oldStatus = rs.getString("claim_status");
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, newStatus);
                ps.setInt(2, claimId);

                int rowsAffected = ps.executeUpdate();
                System.out.println("Updated claim " + claimId + " status to " + newStatus + ". Rows affected: " + rowsAffected);

                if (rowsAffected > 0) {
                    // Insert into history
                    String historySql = "INSERT INTO ClaimStatusHistory (claim_id, old_status, new_status, changed_by, note) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement hs = connection.prepareStatement(historySql)) {
                        hs.setInt(1, claimId);
                        if (oldStatus != null) {
                            hs.setString(2, oldStatus);
                        } else {
                            hs.setNull(2, java.sql.Types.VARCHAR);
                        }
                        hs.setString(3, newStatus);
                        hs.setNull(4, java.sql.Types.INTEGER); // changed_by unknown in this context
                        if (reason != null && !reason.trim().isEmpty()) {
                            hs.setString(5, reason);
                        } else {
                            hs.setNull(5, java.sql.Types.VARCHAR);
                        }
                        hs.executeUpdate();
                    }
                }

                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error updating claim status: " + e.getMessage());
            return false;
        }
    }

    public Claims getClaimById(int claimId) {
        Claims claim = null;

        if (connection == null) {
            System.err.println("Database connection is null!");
            return claim;
        }

        String sql = "SELECT * FROM claims WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            System.out.println("Executing SQL: " + sql + " with claimId: " + claimId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                claim = new Claims();
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
                    } else {
                        claim.setClaim_amount(null);
                    }
                } catch (SQLException e) {
                    claim.setClaim_amount(null);
                }

                System.out.println("Found claim with ID: " + claimId);
            } else {
                System.out.println("No claim found with ID: " + claimId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }

        return claim;
    }

    public boolean testConnection() {
        try {
            String sql = "SELECT COUNT(*) FROM claims";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Claims table exists with " + count + " records");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error testing claims table: " + e.getMessage());
            return false;
        }
        return false;
    }

    public int getTotalClaims() {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return 0;
        }

        String sql = "SELECT COUNT(*) FROM claims";
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

    public int getClaimsByStatusCount(String status) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return 0;
        }

        String sql = "SELECT COUNT(*) FROM claims WHERE claim_status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
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

    public int getRecentClaimsCount(int days) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return 0;
        }

        // Lấy số lượng bồi thường mới trong X ngày vừa qua
        String sql = "SELECT COUNT(*) FROM claims WHERE requestDate >= DATE_SUB(CURDATE(), INTERVAL ? DAY)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, days);
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

    public List<Claims> getRecentClaims(int limit) {
        List<Claims> claims = new ArrayList<>();

        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims;
        }

        String sql = "SELECT * FROM claims ORDER BY CASE claim_status WHEN 'pending' THEN 1 WHEN 'in_progress' THEN 2 WHEN 'need_info' THEN 3 "
                + "WHEN 'approved' THEN 4 WHEN 'paid' THEN 5 WHEN 'rejected' THEN 6 ELSE 7 END, requestDate DESC LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
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
                    } else {
                        claim.setClaim_amount(null);
                    }
                } catch (SQLException e) {
                    claim.setClaim_amount(null);
                }

                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }

        return claims;
    }

    public List<Claims> getRecentPendingClaims(int limit) {
        List<Claims> claims = new ArrayList<>();

        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims;
        }

        String sql = "SELECT * FROM claims WHERE claim_status = 'pending' ORDER BY requestDate DESC LIMIT ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
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
                    } else {
                        claim.setClaim_amount(null);
                    }
                } catch (SQLException e) {
                    claim.setClaim_amount(null);
                }

                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }

        return claims;
    }

    public List<Claims> getOverduePendingClaims(int limit) {
        List<Claims> claims = new ArrayList<>();

        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims;
        }

        String sql = "SELECT c.*, COALESCE(a.total_price, 0) as contract_total_price "
                + "FROM claims c "
                + "INNER JOIN contract ct ON c.contract_id = ct.contract_id "
                + "INNER JOIN applications a ON ct.application_id = a.id "
                + "WHERE c.claim_status = 'pending' "
                + "ORDER BY COALESCE(a.total_price, 0) DESC, c.requestDate ASC";

        if (limit > 0) {
            sql += " LIMIT ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (limit > 0) {
                ps.setInt(1, limit);
            }
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
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

                // Lấy total_price từ application
                try {
                    BigDecimal contractTotalPrice = rs.getBigDecimal("contract_total_price");
                    claim.setContractTotalPrice(contractTotalPrice != null ? contractTotalPrice : BigDecimal.ZERO);
                } catch (SQLException e) {
                    claim.setContractTotalPrice(BigDecimal.ZERO);
                }

                try {
                    if (rs.findColumn("claim_amount") > 0) {
                        claim.setClaim_amount(rs.getBigDecimal("claim_amount"));
                    } else {
                        claim.setClaim_amount(null);
                    }
                } catch (SQLException e) {
                    claim.setClaim_amount(null);
                }

                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }

        return claims;
    }

    /**
     * Lấy danh sách claims của customer với thông tin chi tiết
     *
     * @param customerId ID của customer
     * @param searchTerm Từ khóa tìm kiếm
     * @param statusFilter Lọc theo trạng thái
     * @param typeFilter Lọc theo loại sự cố
     * @param page Trang hiện tại
     * @param pageSize Số record mỗi trang
     * @return Danh sách claims với thông tin chi tiết
     */
    public List<Claims> getCustomerClaims(int customerId, String searchTerm,
            String statusFilter, String typeFilter, int page, int pageSize) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.*, p.name as product_name, p.type as product_type, ");
        sql.append("a.destination, ct.contract_id ");
        sql.append("FROM Claims c ");
        sql.append("JOIN Contract ct ON c.contract_id = ct.contract_id ");
        sql.append("JOIN applications a ON ct.application_id = a.id ");
        sql.append("JOIN products p ON a.product_id = p.id ");
        sql.append("WHERE a.purchaser_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (c.claim_type LIKE ? OR c.description LIKE ? OR c.id LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Lọc theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql.append("AND c.claim_status = ? ");
            params.add(statusFilter);
        }

        // Lọc theo loại
        if (typeFilter != null && !typeFilter.trim().isEmpty() && !"all".equalsIgnoreCase(typeFilter)) {
            sql.append("AND c.claim_type = ? ");
            params.add(typeFilter);
        }

        // Sắp xếp theo ngày tạo mới nhất
        sql.append("ORDER BY c.requestDate DESC ");

        // Phân trang
        if (page > 0 && pageSize > 0) {
            int offset = (page - 1) * pageSize;
            sql.append("LIMIT ? OFFSET ? ");
            params.add(pageSize);
            params.add(offset);
        }

        List<Claims> claims = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
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
                    claim.setClaim_amount(rs.getBigDecimal("claim_amount"));
                } catch (SQLException e) {
                    claim.setClaim_amount(null);
                }

                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get customer claims", e);
        }

        return claims;
    }

    /**
     * Đếm tổng số claims của customer
     */
    public int getCustomerClaimsCount(int customerId, String searchTerm, String statusFilter, String typeFilter) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Claims c ");
        sql.append("JOIN Contract ct ON c.contract_id = ct.contract_id ");
        sql.append("JOIN applications a ON ct.application_id = a.id ");
        sql.append("WHERE a.purchaser_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (c.claim_type LIKE ? OR c.description LIKE ? OR c.id LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Lọc theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql.append("AND c.claim_status = ? ");
            params.add(statusFilter);
        }

        // Lọc theo loại
        if (typeFilter != null && !typeFilter.trim().isEmpty() && !"all".equalsIgnoreCase(typeFilter)) {
            sql.append("AND c.claim_type = ? ");
            params.add(typeFilter);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Kiểm tra xem claim có thuộc về customer không
     */
    public boolean isClaimOwnedByCustomer(int claimId, int customerId) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return false;
        }

        String sql = "SELECT COUNT(*) FROM Claims c "
                + "JOIN Contract ct ON c.contract_id = ct.contract_id "
                + "JOIN applications a ON ct.application_id = a.id "
                + "WHERE c.id = ? AND a.purchaser_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            ps.setInt(2, customerId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Tạo claim mới cho customer
     */
    public boolean createClaim(Claims claim) {
        String sql = "INSERT INTO Claims (contract_id, requestDate, claim_type, description, "
                + "payment_bank, payment_number, related_img, related_file, claim_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending')";

        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, claim.getContract_id());
            ps.setDate(2, new java.sql.Date(claim.getRequestDate().getTime()));
            ps.setString(3, claim.getClaim_type());
            ps.setString(4, claim.getDescription());
            ps.setString(5, claim.getPayment_bank());
            ps.setString(6, claim.getPayment_number());
            ps.setString(7, claim.getRelated_img());
            ps.setString(8, claim.getRelated_file());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    claim.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
