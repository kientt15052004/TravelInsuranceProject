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
    
}
