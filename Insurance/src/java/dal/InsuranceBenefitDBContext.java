/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.InsuranceBenefit;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author FPTSHOP
 */
public class InsuranceBenefitDBContext extends DBContext {

    // Lấy tất cả InsuranceBenefit
    public ArrayList<InsuranceBenefit> getAll() {
        ArrayList<InsuranceBenefit> list = new ArrayList<>();
        String sql = "SELECT * FROM insurance_benefits";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InsuranceBenefit benefit = new InsuranceBenefit();
                benefit.setId(rs.getInt("id"));
                benefit.setDeath_or_permanent_disability(rs.getBigDecimal("death_or_permanent_disability"));
                benefit.setDeath_due_to_illness(rs.getBigDecimal("death_due_to_illness"));
                benefit.setThird_party_liability(rs.getBigDecimal("third_party_liability"));
                benefit.setLost_bank_car(rs.getBigDecimal("lost_bank_card")); // chú ý tên cột
                benefit.setKidnap_and_hostage(rs.getBigDecimal("kidnap_and_hostage"));
                benefit.setLost_or_damaged_golf_equipment(rs.getBigDecimal("lost_or_damaged_golf_equipment"));
                benefit.setIs_deleted(rs.getBoolean("is_deleted"));
                
                list.add(benefit);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy 1 InsuranceBenefit theo id
    public InsuranceBenefit getById(int id) {
        String sql = "SELECT * FROM insurance_benefits WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                InsuranceBenefit benefit = new InsuranceBenefit();
                benefit.setId(rs.getInt("id"));
                benefit.setDeath_or_permanent_disability(rs.getBigDecimal("death_or_permanent_disability"));
                benefit.setDeath_due_to_illness(rs.getBigDecimal("death_due_to_illness"));
                benefit.setThird_party_liability(rs.getBigDecimal("third_party_liability"));
                benefit.setLost_bank_car(rs.getBigDecimal("lost_bank_card"));
                benefit.setKidnap_and_hostage(rs.getBigDecimal("kidnap_and_hostage"));
                benefit.setLost_or_damaged_golf_equipment(rs.getBigDecimal("lost_or_damaged_golf_equipment"));
                benefit.setIs_deleted(rs.getBoolean("is_deleted"));
                return benefit;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // không tìm thấy
    }
}

