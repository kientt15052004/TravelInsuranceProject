package dal;

import Model.User;
import Model.Application;
import Model.Contract;
import Model.Claims;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class UserDAO extends DBContext {

    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            st.setString(2, password);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    u.setFullname(rs.getString("fullname"));
                    u.setMail(rs.getString("mail"));

                    Date dobSql = rs.getDate("dob"); // java.sql.Date
                    if (dobSql != null) {
                        LocalDate dobLocal = dobSql.toLocalDate();
                        u.setDob(dobLocal);
                    } else {
                        u.setDob(null);
                    }

                    u.setAddress(rs.getString("address"));
                    u.setPhone(rs.getString("phone"));
                    u.setCccd(rs.getString("cccd"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setRole(rs.getString("role"));
                    u.setCccd_img(rs.getString("cccd_img"));
                    u.setStatus(rs.getString("status"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean checkUserExists(String username) {
    String sql = "SELECT * FROM users WHERE username = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, username);
        ResultSet rs = st.executeQuery();
        return rs.next();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}


    
    // Get user by CCCD number
    public User getUserByCccd(String cccd) {
        String sql = "SELECT * FROM users WHERE cccd = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, cccd);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    u.setFullname(rs.getString("fullname"));
                    u.setMail(rs.getString("mail"));

                    Date dobSql = rs.getDate("dob");
                    if (dobSql != null) {
                        LocalDate dobLocal = dobSql.toLocalDate();
                        u.setDob(dobLocal);
                    } else {
                        u.setDob(null);
                    }

                    u.setAddress(rs.getString("address"));
                    u.setPhone(rs.getString("phone"));
                    u.setCccd(rs.getString("cccd"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setRole(rs.getString("role"));
                    u.setCccd_img(rs.getString("cccd_img"));
                    u.setStatus(rs.getString("status"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Check if user exists by CCCD
    public boolean userExistsByCccd(String cccd) {
        String sql = "SELECT COUNT(*) FROM users WHERE cccd = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, cccd);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
     //Insert new user into database
    public int insertUser(User user) {
        String sql = "INSERT INTO users (username, password, fullname, mail, dob, address, phone, cccd, avatar, role, cccd_img, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            st.setString(1, user.getUsername());
            st.setString(2, user.getPassword());
            st.setString(3, user.getFullname());
            st.setString(4, user.getMail());
            
            if (user.getDob() != null) {
                st.setDate(5, Date.valueOf(user.getDob()));
            } else {
                st.setNull(5, java.sql.Types.DATE);
            }
            
            st.setString(6, user.getAddress());
            st.setString(7, user.getPhone());
            st.setString(8, user.getCccd());
            st.setString(9, user.getAvatar());
            st.setString(10, user.getRole());
            st.setString(11, user.getCccd_img());
            st.setString(12, user.getStatus());
            
            int rowsAffected = st.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // Return the generated ID
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Failed to insert
    }
    
    // Get user by ID
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    u.setFullname(rs.getString("fullname"));
                    u.setMail(rs.getString("mail"));

                    Date dobSql = rs.getDate("dob");
                    if (dobSql != null) {
                        LocalDate dobLocal = dobSql.toLocalDate();
                        u.setDob(dobLocal);
                    } else {
                        u.setDob(null);
                    }

                    u.setAddress(rs.getString("address"));
                    u.setPhone(rs.getString("phone"));
                    u.setCccd(rs.getString("cccd"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setRole(rs.getString("role"));
                    u.setCccd_img(rs.getString("cccd_img"));
                    u.setStatus(rs.getString("status"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    u.setFullname(rs.getString("fullname"));
                    u.setMail(rs.getString("mail"));

                    Date dobSql = rs.getDate("dob");
                    if (dobSql != null) {
                        LocalDate dobLocal = dobSql.toLocalDate();
                        u.setDob(dobLocal);
                    } else {
                        u.setDob(null);
                    }

                    u.setAddress(rs.getString("address"));
                    u.setPhone(rs.getString("phone"));
                    u.setCccd(rs.getString("cccd"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setRole(rs.getString("role"));
                    u.setCccd_img(rs.getString("cccd_img"));
                    u.setStatus(rs.getString("status"));
                    users.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    // Get total insurance amount by user ID
    public BigDecimal getTotalInsuranceAmountByUserId(int userId) {
        String sql = "SELECT SUM(total_price) FROM applications WHERE purchaser_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal(1);
                    return total != null ? total : BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    // Get applications by user ID
    public List<Application> getApplicationsByUserId(int userId) {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT * FROM applications WHERE purchaser_id = ? ORDER BY id ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Application app = new Application();
                    app.setId(rs.getInt("id"));
                    app.setPurchaser_id(rs.getInt("purchaser_id"));
                    app.setProduct_id(rs.getInt("product_id"));
                    app.setTotal_price(rs.getBigDecimal("total_price"));
                    app.setStartDate(rs.getDate("startDate"));
                    app.setEndDate(rs.getDate("endDate"));
                    app.setTravelers_quantity(rs.getInt("travelers_quantity"));
                    app.setType(rs.getString("type"));
                    app.setDestination(rs.getString("destination"));
                    applications.add(app);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }
    
    // Get contracts by user ID
    public List<Contract> getContractsByUserId(int userId) {
        List<Contract> contracts = new ArrayList<>();
        String sql = "SELECT c.* FROM Contract c " +
                    "JOIN applications a ON c.application_id = a.id " +
                    "WHERE a.purchaser_id = ? ORDER BY c.contract_id ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Contract contract = new Contract();
                    contract.setContract_id(rs.getInt("contract_id"));
                    contract.setApplication_id(rs.getInt("application_id"));
                    contract.setContract_status(rs.getString("contract_status"));
                    contract.setDescription(rs.getString("description"));
                    contracts.add(contract);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }
    
    // Get claims by user ID
    public List<Claims> getClaimsByUserId(int userId) {
        List<Claims> claims = new ArrayList<>();
        String sql = "SELECT cl.* FROM claims cl " +
                    "JOIN Contract c ON cl.contract_id = c.contract_id " +
                    "JOIN applications a ON c.application_id = a.id " +
                    "WHERE a.purchaser_id = ? ORDER BY CASE cl.claim_status WHEN 'pending' THEN 1 WHEN 'approved' THEN 2 WHEN 'rejected' THEN 3 ELSE 4 END, cl.requestDate ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
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
                    
                    // Try to get claim_amount if column exists
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return claims;
    }
    
    // Search users with filters
    public List<User> searchUsers(String keyword, String role, String status) {
        List<User> users = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR fullname LIKE ? OR mail LIKE ? OR phone LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        if (role != null && !role.trim().isEmpty() && !role.equals("all")) {
            sql.append(" AND role = ?");
            parameters.add(role.trim());
        }
        
        if (status != null && !status.trim().isEmpty() && !status.equals("all")) {
            sql.append(" AND status = ?");
            parameters.add(status.trim());
        }
        
        sql.append(" ORDER BY id ASC");
        
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                st.setObject(i + 1, parameters.get(i));
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPassword(rs.getString("password"));
                    u.setFullname(rs.getString("fullname"));
                    u.setMail(rs.getString("mail"));

                    Date dobSql = rs.getDate("dob");
                    if (dobSql != null) {
                        LocalDate dobLocal = dobSql.toLocalDate();
                        u.setDob(dobLocal);
                    } else {
                        u.setDob(null);
                    }

                    u.setAddress(rs.getString("address"));
                    u.setPhone(rs.getString("phone"));
                    u.setCccd(rs.getString("cccd"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setRole(rs.getString("role"));
                    u.setCccd_img(rs.getString("cccd_img"));
                    u.setStatus(rs.getString("status"));
                    users.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    // Update user information (phone, address, status)
    public boolean updateUserInfo(User user) {
        String sql = "UPDATE users SET phone = ?, address = ?, status = ? WHERE id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, user.getPhone());
            st.setString(2, user.getAddress());
            st.setString(3, user.getStatus());
            st.setInt(4, user.getId());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
}
