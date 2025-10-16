package dal;

import Model.Claims;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClaimsDBContext extends DBContext {
    
    public List<Claims> getClaimsByContractId(int contractId) {
        System.out.println("Getting claims for contract ID: " + contractId);
        List<Claims> claims = new ArrayList<>();
        
        // Kiểm tra xem connection có null không
        if (connection == null) {
            System.err.println("Database connection is null!");
            return claims; // Trả về danh sách rỗng thay vì throw exception
        }
        
        String sql = "SELECT * FROM claims WHERE contract_id = ? ORDER BY requestDate DESC";
        
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
                // Không có cột claim_amount trong database thực tế
                
                claims.add(claim);
            }
            System.out.println("Found " + count + " claims for contract ID: " + contractId);
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL Error: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Vendor Error: " + e.getErrorCode());
            // Thay vì throw exception, chỉ log lỗi và trả về danh sách rỗng
            System.err.println("Returning empty claims list due to error");
        }
        
        return claims;
    }
    
    // Method để test connection và kiểm tra bảng claims
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
}
