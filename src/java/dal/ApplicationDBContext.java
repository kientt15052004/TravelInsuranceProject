/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.util.ArrayList;
import Model.Application;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import Model.ApplicationTraveler;
import java.sql.*;

/**
 *
 * @author FPTSHOP
 */
public class ApplicationDBContext extends DBContext {

    public ArrayList<Application> getAll() {
        String sql = "SELECT * FROM applications";
        ArrayList<Application> applications = new ArrayList<>();

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Application app = new Application();
                app.setId(rs.getInt("id"));
                app.setPurchaser_id(rs.getInt("purchaser_id"));
                app.setInsuranceId(rs.getInt("product_id"));
                app.setType(rs.getString("type"));
                app.setDestination(rs.getString("destination"));
                app.setStartDate(rs.getDate("startDate"));
                app.setEndDate(rs.getDate("endDate"));
                app.setTraveler_quantity(rs.getInt("travelers_quantity"));
                app.setPrice(rs.getBigDecimal("total_price"));

                // Chưa load travelers và buyerInfo (vì có thể là bảng khác)
                app.setTravelers(new ArrayList<>());
                app.setBuyerInfo(null);
                app.setInsurance(null);

                applications.add(app);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return applications;
    }

    public int insert(Application app) {
        String sql = "INSERT INTO applications "
                + "(purchaser_id, product_id, type, destination, startDate, endDate, travelers_quantity, total_price) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, app.getPurchaser_id());
            stm.setInt(2, app.getInsuranceId());
            stm.setString(3, app.getType());
            stm.setString(4, app.getDestination());
            stm.setDate(5, new java.sql.Date(app.getStartDate().getTime()));
            stm.setDate(6, new java.sql.Date(app.getEndDate().getTime()));
            stm.setInt(7, app.getTraveler_quantity());
            stm.setBigDecimal(8, app.getPrice());

            int affectedRows = stm.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stm.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // trả về id của application vừa insert
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return -1; // thất bại
    }

    public int insertApplicationWithTravelers(Application app, List<ApplicationTraveler> travelers) {
        String appSql = "INSERT INTO applications "
                + "(purchaser_id, product_id, type, destination, startDate, endDate, travelers_quantity, total_price) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        String travelerSql = "INSERT INTO application_traveler "
                + "(application_id, cccd_id, name, gender, dob, phone, email) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        int applicationId = -1;

        try {
            connection.setAutoCommit(false); // bắt đầu transaction

            // 1. Insert Application
            try (PreparedStatement stm = connection.prepareStatement(appSql, Statement.RETURN_GENERATED_KEYS)) {
                stm.setInt(1, app.getPurchaser_id());
                stm.setInt(2, app.getInsuranceId());
                stm.setString(3, app.getType());
                stm.setString(4, app.getDestination());
                stm.setDate(5, new java.sql.Date(app.getStartDate().getTime()));
                stm.setDate(6, new java.sql.Date(app.getEndDate().getTime()));
                stm.setInt(7, app.getTraveler_quantity());
                stm.setBigDecimal(8, app.getPrice());

                int affectedRows = stm.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Insert application failed, no rows affected.");
                }

                try (ResultSet generatedKeys = stm.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        applicationId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Insert application failed, no ID obtained.");
                    }
                }
            }

            // 2. Insert Travelers với applicationId vừa lấy
            try (PreparedStatement stm = connection.prepareStatement(travelerSql)) {
                for (ApplicationTraveler traveler : travelers) {
                    stm.setInt(1, applicationId);
                    stm.setLong(2, traveler.getCccd());
                    stm.setString(3, traveler.getName());
                    stm.setString(4, traveler.getGender());
                    stm.setDate(5, new java.sql.Date(traveler.getBirthDate().getTime()));
                    stm.setString(6, traveler.getPhoneNumber());
                    stm.setString(7, traveler.getEmail());
                    stm.addBatch();
                }
                stm.executeBatch(); // chạy batch insert
            }

            connection.commit(); // commit transaction
            return applicationId;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback(); // rollback nếu có lỗi
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                connection.setAutoCommit(true); // bật lại auto commit
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return -1; // thất bại
    }

}
