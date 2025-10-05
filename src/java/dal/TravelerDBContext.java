/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import model.ApplicationTraveler;

/**
 *
 * @author FPTSHOP
 */
public class TravelerDBContext extends DBContext {

    public ArrayList<ApplicationTraveler> getAll() {
        String sql = "SELECT * FROM application_traveler";
        ArrayList<ApplicationTraveler> travelers = new ArrayList<>();

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                ApplicationTraveler traveler = new ApplicationTraveler();
                traveler.setId(rs.getInt("id"));
                traveler.setApplication_id(rs.getInt("application_id"));
                traveler.setCccd_id(rs.getLong("cccd_id"));
                traveler.setName(rs.getString("name"));
                traveler.setGender(rs.getString("gender"));
                traveler.setDob(rs.getDate("dob"));
                traveler.setPhone(rs.getString("phone"));
                traveler.setEmail(rs.getString("email"));

                travelers.add(traveler);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return travelers;
    }

    public int insert(ApplicationTraveler traveler) {
        String sql = "INSERT INTO application_traveler "
                + "(application_id, cccd_id, name, gender, dob, phone, email) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, traveler.getApplication_id());
            stm.setLong(2, traveler.getCccd_id());
            stm.setString(3, traveler.getName());
            stm.setString(4, traveler.getGender());
            stm.setDate(5, traveler.getDob());
            stm.setString(6, traveler.getPhone());
            stm.setString(7, traveler.getEmail());

            int affectedRows = stm.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stm.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về id vừa insert
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // thất bại
    }

}
