package dal;

import Model.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;

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
        return null; // login thất bại
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
    
    // Insert new user into database
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
    
}
