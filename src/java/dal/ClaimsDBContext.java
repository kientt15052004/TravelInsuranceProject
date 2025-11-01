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
        
        String sql = "SELECT * FROM claims WHERE contract_id = ? ORDER BY CASE claim_status WHEN 'pending' THEN 1 WHEN 'approved' THEN 2 WHEN 'rejected' THEN 3 ELSE 4 END, requestDate ASC";
        
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
        
        sql.append("ORDER BY CASE c.claim_status WHEN 'pending' THEN 1 WHEN 'approved' THEN 2 WHEN 'rejected' THEN 3 ELSE 4 END, c.requestDate ASC");
        
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
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, claimId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Updated claim " + claimId + " status to " + newStatus + 
                             (reason != null && !reason.trim().isEmpty() ? " with reason: " + reason : "") + 
                             ". Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
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
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, claimId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Updated claim " + claimId + " status to " + newStatus + ". Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
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
        
        String sql = "SELECT * FROM claims ORDER BY CASE claim_status WHEN 'pending' THEN 1 WHEN 'approved' THEN 2 WHEN 'rejected' THEN 3 ELSE 4 END, requestDate DESC LIMIT ?";
        
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
        

        String sql = "SELECT c.*, COALESCE(a.total_price, 0) as contract_total_price " +
                     "FROM claims c " +
                     "INNER JOIN contract ct ON c.contract_id = ct.contract_id " +
                     "INNER JOIN applications a ON ct.application_id = a.id " +
                     "WHERE c.claim_status = 'pending' " +
                     "ORDER BY COALESCE(a.total_price, 0) DESC, c.requestDate ASC";
        
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
}
