/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import Model.InsuranceBenefit;
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
                InsuranceBenefit benefit = mapResultSetToInsuranceBenefit(rs);
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
                return mapResultSetToInsuranceBenefit(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // không tìm thấy
    }
    
    // Helper method to map ResultSet to InsuranceBenefit object
    private InsuranceBenefit mapResultSetToInsuranceBenefit(ResultSet rs) throws Exception {
        InsuranceBenefit benefit = new InsuranceBenefit();
        benefit.setId(rs.getInt("id"));
        benefit.setDeath_or_permanent_disability(rs.getBigDecimal("death_or_permanent_disability"));
        benefit.setDeath_due_to_illness(rs.getBigDecimal("death_due_to_illness"));
        benefit.setThird_party_liability(rs.getBigDecimal("third_party_liability"));
        benefit.setLost_bank_card(rs.getBigDecimal("lost_bank_card"));
        benefit.setKidnap_and_hostage(rs.getBigDecimal("kidnap_and_hostage"));
        benefit.setLost_or_damaged_golf_equipment(rs.getBigDecimal("lost_or_damaged_golf_equipment"));
        
        // Map new fields
        benefit.setMedical_cost(rs.getBigDecimal("medical_cost"));
        benefit.setEmergency_transport(rs.getBigDecimal("emergency_transport"));
        benefit.setRepatriation_vn(rs.getBigDecimal("repatriation_vn"));
        benefit.setRepatriation_abroad(rs.getBigDecimal("repatriation_abroad"));
        benefit.setHospital_visit(rs.getBigDecimal("hospital_visit"));
        benefit.setFuneral_arrangement(rs.getBigDecimal("funeral_arrangement"));
        benefit.setChild_care(rs.getBigDecimal("child_care"));
        benefit.setHospital_allowance(rs.getBigDecimal("hospital_allowance"));
        benefit.setAccident_death_injury(rs.getBigDecimal("accident_death_injury"));
        benefit.setTrip_cancellation(rs.getBigDecimal("trip_cancellation"));
        benefit.setCompanion_support(rs.getBigDecimal("companion_support"));
        benefit.setDelayed_baggage(rs.getBigDecimal("delayed_baggage"));
        benefit.setTravel_documents(rs.getBigDecimal("travel_documents"));
        benefit.setTrip_delay(rs.getBigDecimal("trip_delay"));
        
        return benefit;
    }
}

