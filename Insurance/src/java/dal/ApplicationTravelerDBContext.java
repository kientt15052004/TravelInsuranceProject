package dal;

import model.ApplicationTraveler;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ApplicationTravelerDBContext extends DBContext {
    
    public void insertTraveler(ApplicationTraveler traveler) {
        String sql = "INSERT INTO application_traveler (application_id, name, gender, cccd_id, dob, age, phone, email) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, traveler.getApplication_id());
            ps.setString(2, traveler.getName());
            ps.setString(3, traveler.getGender());
            ps.setLong(4, traveler.getCccd_id());
            ps.setDate(5, traveler.getDob());
            ps.setInt(6, traveler.getAge());
            ps.setString(7, traveler.getPhone());
            ps.setString(8, traveler.getEmail());
            
            ps.executeUpdate();
            
            ResultSet generatedKeys = ps.getGeneratedKeys();
            if (generatedKeys.next()) {
                traveler.setId(generatedKeys.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<ApplicationTraveler> getTravelersByApplicationId(int applicationId) {
        List<ApplicationTraveler> travelers = new ArrayList<>();
        String sql = "SELECT * FROM application_traveler WHERE application_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, applicationId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ApplicationTraveler traveler = new ApplicationTraveler();
                traveler.setId(rs.getInt("id"));
                traveler.setApplication_id(rs.getInt("application_id"));
                traveler.setName(rs.getString("name"));
                traveler.setGender(rs.getString("gender"));
                traveler.setCccd_id(rs.getLong("cccd_id"));
                traveler.setDob(rs.getDate("dob"));
                traveler.setAge(rs.getInt("age"));
                traveler.setPhone(rs.getString("phone"));
                traveler.setEmail(rs.getString("email"));
                travelers.add(traveler);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return travelers;
    }
    
    public ApplicationTraveler getTravelerById(int travelerId) {
        String sql = "SELECT * FROM application_traveler WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, travelerId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                ApplicationTraveler traveler = new ApplicationTraveler();
                traveler.setId(rs.getInt("id"));
                traveler.setApplication_id(rs.getInt("application_id"));
                traveler.setName(rs.getString("name"));
                traveler.setGender(rs.getString("gender"));
                traveler.setCccd_id(rs.getLong("cccd_id"));
                traveler.setDob(rs.getDate("dob"));
                traveler.setAge(rs.getInt("age"));
                traveler.setPhone(rs.getString("phone"));
                traveler.setEmail(rs.getString("email"));
                return traveler;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
