package dal;

import Model.ClaimsRes;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClaimsResDBContext extends DBContext {
    
    // Method để lấy tất cả claim responses theo claim ID với thông tin user
    public List<ClaimsRes> getClaimResponsesByClaimId(int claimId) {
        List<ClaimsRes> claimResponses = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null!");
            return claimResponses;
        }
        
        // Query với JOIN để lấy thông tin user
        String sql = "SELECT cr.*, u.username as user_name, u.fullname as user_fullname " +
                     "FROM claimsres cr " +
                     "LEFT JOIN users u ON cr.user_id = u.id " +
                     "WHERE cr.claim_id = ? " +
                     "ORDER BY cr.id ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            System.out.println("Executing SQL: " + sql + " with claimId: " + claimId);
            ResultSet rs = ps.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                count++;
                ClaimsRes claimRes = new ClaimsRes();
                claimRes.setClaimRes_id(rs.getInt("id"));
                claimRes.setClaim_id(rs.getInt("claim_id"));
                
                // Handle user_id (may be null for existing records)
                try {
                    claimRes.setUser_id(rs.getInt("user_id"));
                    claimRes.setUser_name(rs.getString("user_name"));
                    claimRes.setUser_fullname(rs.getString("user_fullname"));
                } catch (SQLException e) {
                    claimRes.setUser_id(0); // Default to 0 if column doesn't exist or is null
                    claimRes.setUser_name("Unknown");
                    claimRes.setUser_fullname("Unknown User");
                }
                
                claimRes.setCreateDate(rs.getTimestamp("createDate"));
                claimRes.setDescription(rs.getString("description"));
                claimRes.setRelated_img(rs.getString("related_img"));
                claimRes.setRelated_file(rs.getString("related_file"));
                claimRes.setStatus(rs.getString("status"));
                
                claimResponses.add(claimRes);
            }
            System.out.println("Found " + count + " claim responses for claim ID: " + claimId);
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
        }
        
        return claimResponses;
    }
    
    // Method để thêm claim response mới
    public boolean addClaimResponse(ClaimsRes claimRes) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return false;
        }
        
        String sql = "INSERT INTO ClaimsRes (claim_id, user_id, createDate, description, related_img, related_file, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, claimRes.getClaim_id());
            
            // Set user_id if provided, otherwise set to NULL
            if (claimRes.getUser_id() > 0) {
                ps.setInt(2, claimRes.getUser_id());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            
            ps.setTimestamp(3, new java.sql.Timestamp(claimRes.getCreateDate().getTime()));
            ps.setString(4, claimRes.getDescription());
            ps.setString(5, claimRes.getRelated_img());
            ps.setString(6, claimRes.getRelated_file());
            ps.setString(7, claimRes.getStatus());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Added claim response. Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error adding claim response: " + e.getMessage());
            return false;
        }
    }
    
    // Overloaded method without user_id for backward compatibility
    public boolean addClaimResponse(int claimId, java.util.Date createDate, String description, String related_img, String related_file, String status) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return false;
        }
        
        String sql = "INSERT INTO ClaimsRes (claim_id, createDate, description, related_img, related_file, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, claimId);
            ps.setTimestamp(2, new java.sql.Timestamp(createDate.getTime()));
            ps.setString(3, description);
            ps.setString(4, related_img);
            ps.setString(5, related_file);
            ps.setString(6, status);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Added claim response (legacy method). Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error adding claim response: " + e.getMessage());
            return false;
        }
    }
    
    // Method để cập nhật status của claim response
    public boolean updateClaimResponseStatus(int claimResId, String newStatus) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return false;
        }
        
        String sql = "UPDATE ClaimsRes SET status = ? WHERE id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, claimResId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Updated claim response " + claimResId + " status to " + newStatus + ". Rows affected: " + rowsAffected);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error updating claim response status: " + e.getMessage());
            return false;
        }
    }
    
    // Method để test connection và kiểm tra bảng ClaimsRes
    public boolean testConnection() {
        try {
            String sql = "SELECT COUNT(*) FROM ClaimsRes";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("ClaimsRes table exists with " + count + " records");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error testing ClaimsRes table: " + e.getMessage());
            return false;
        }
        return false;
    }
}

