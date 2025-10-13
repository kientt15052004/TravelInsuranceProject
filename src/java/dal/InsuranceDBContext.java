/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.InsuranceProduct;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import Model.InsuranceBenefit;
import Model.User;

/**
 *
 * @author FPTSHOP
 */
public class InsuranceDBContext extends DBContext {

    public ArrayList<InsuranceProduct> getAll() {
        String sql = "select * from products";
        ArrayList<InsuranceProduct> insurances = new ArrayList<>();
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                InsuranceProduct insurance = mapResultSetToInsuranceProduct(rs);
                insurances.add(insurance);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return insurances;
    }

    public ArrayList<InsuranceProduct> getAllWithBenefit() {
        String sql = "SELECT p.id AS product_id, p.name, p.img, p.type, p.description, p.price, "
                + "b.id AS benefit_id, b.death_or_permanent_disability, b.death_due_to_illness, "
                + "b.third_party_liability, b.lost_bank_card, b.kidnap_and_hostage, "
                + "b.lost_or_damaged_golf_equipment, "
                + "b.medical_cost, b.emergency_transport, b.repatriation_vn, b.repatriation_abroad, "
                + "b.hospital_visit, b.funeral_arrangement, b.child_care, b.hospital_allowance, "
                + "b.accident_death_injury, b.trip_cancellation, b.companion_support, "
                + "b.delayed_baggage, b.travel_documents, b.trip_delay "
                + "FROM products p "
                + "LEFT JOIN insurance_benefits b ON p.benefit_id = b.id";

        ArrayList<InsuranceProduct> insurances = new ArrayList<>();

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InsuranceProduct insurance = new InsuranceProduct();
                insurance.setId(rs.getInt("product_id"));
                insurance.setName(rs.getString("name"));
                insurance.setImg(rs.getString("img"));
                insurance.setType(rs.getString("type"));
                insurance.setDescription(rs.getString("description"));
                insurance.setPrice(rs.getBigDecimal("price"));

                int benefitId = rs.getInt("benefit_id");
                if (benefitId > 0) {
                    InsuranceBenefit benefit = mapResultSetToInsuranceBenefit(rs);
                    insurance.setBenefit(benefit);
                }

                insurances.add(insurance);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return insurances;
    }

    public ArrayList<InsuranceProduct> getAllPaging(int page, int pageSize, String searchName, String searchType) {
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        ArrayList<InsuranceProduct> insurances = new ArrayList<>();

        // Thêm điều kiện search by name (tìm trong cả description)
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }

        // Thêm điều kiện search by type
        if (searchType != null && !searchType.trim().isEmpty()) {
            sql.append(" AND type = ?");
        }

        // Thêm phân trang
        sql.append(" ORDER BY id LIMIT ? OFFSET ?");

        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            // Set parameters cho search name
            if (searchName != null && !searchName.trim().isEmpty()) {
                String searchPattern = "%" + searchName.trim() + "%";
                stm.setString(paramIndex++, searchPattern);
                stm.setString(paramIndex++, searchPattern);
            }

            // Set parameter cho search type
            if (searchType != null && !searchType.trim().isEmpty()) {
                stm.setString(paramIndex++, searchType.trim());
            }

            // Set parameters cho paging
            stm.setInt(paramIndex++, pageSize);
            stm.setInt(paramIndex++, (page - 1) * pageSize);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InsuranceProduct insurance = mapResultSetToInsuranceProduct(rs);
                insurances.add(insurance);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return insurances;
    }

// Hàm hỗ trợ để đếm tổng số records (cần cho pagination)
    public int getTotalRecords(String searchName, String searchType) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) as total FROM products WHERE 1=1");

        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }

        if (searchType != null && !searchType.trim().isEmpty()) {
            sql.append(" AND type = ?");
        }

        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (searchName != null && !searchName.trim().isEmpty()) {
                String searchPattern = "%" + searchName.trim() + "%";
                stm.setString(paramIndex++, searchPattern);
                stm.setString(paramIndex++, searchPattern);
            }

            if (searchType != null && !searchType.trim().isEmpty()) {
                stm.setString(paramIndex++, searchType.trim());
            }

            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0;
    }

    public InsuranceProduct getById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                return mapResultSetToInsuranceProduct(rs);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public InsuranceProduct getByIdWithBenefit(int id) {
        String sql = "SELECT p.id AS product_id, p.name, p.img, p.type, p.description, p.price, "
                + "b.id AS benefit_id, b.death_or_permanent_disability, b.death_due_to_illness, "
                + "b.third_party_liability, b.lost_bank_card, b.kidnap_and_hostage, "
                + "b.lost_or_damaged_golf_equipment, "
                + "b.medical_cost, b.emergency_transport, b.repatriation_vn, b.repatriation_abroad, "
                + "b.hospital_visit, b.funeral_arrangement, b.child_care, b.hospital_allowance, "
                + "b.accident_death_injury, b.trip_cancellation, b.companion_support, "
                + "b.delayed_baggage, b.travel_documents, b.trip_delay "
                + "FROM products p "
                + "LEFT JOIN insurance_benefits b ON p.benefit_id = b.id "
                + "WHERE p.id = ?";

        InsuranceProduct insurance = null;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                insurance = new InsuranceProduct();
                insurance.setId(rs.getInt("product_id"));
                insurance.setName(rs.getString("name"));
                insurance.setImg(rs.getString("img"));
                insurance.setType(rs.getString("type"));
                insurance.setDescription(rs.getString("description"));
                insurance.setPrice(rs.getBigDecimal("price"));

                int benefitId = rs.getInt("benefit_id");
                if (benefitId > 0) {
                    InsuranceBenefit benefit = mapResultSetToInsuranceBenefit(rs);
                    insurance.setBenefit(benefit);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return insurance;
    }

    public ArrayList<String> getAllType() {
        ArrayList<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT type FROM products";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                types.add(rs.getString("type"));
            }
        } catch (Exception e) {
            System.out.println("Error in getAllType(): " + e.getMessage());
        }

        return types;
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            stm.setString(2, password);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setFullname(rs.getString("fullname"));
                u.setMail(rs.getString("mail"));
                u.setDob(rs.getDate("dob").toLocalDate());
                u.setAddress(rs.getString("address"));
                u.setPhone(rs.getString("phone"));
                u.setCccd(rs.getString("cccd"));
                u.setAvatar(rs.getString("avatar"));
                u.setRole(rs.getString("role"));
                u.setCccd_img(rs.getString("cccd_img"));
                u.setStatus(rs.getString("status"));
                
                return u;
            }
        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
        }
        return null;
    }
    
    // Helper method to map ResultSet to InsuranceProduct object
    private InsuranceProduct mapResultSetToInsuranceProduct(ResultSet rs) throws Exception {
        InsuranceProduct insurance = new InsuranceProduct();
        insurance.setId(rs.getInt("id"));
        insurance.setBenefit_id(rs.getInt("benefit_id"));
        insurance.setName(rs.getString("name"));
        insurance.setImg(rs.getString("img"));
        insurance.setType(rs.getString("type"));
        insurance.setDescription(rs.getString("description"));
        insurance.setPrice(rs.getBigDecimal("price"));
        return insurance;
    }
    
    // Helper method to map ResultSet to InsuranceBenefit object
    private InsuranceBenefit mapResultSetToInsuranceBenefit(ResultSet rs) throws Exception {
        InsuranceBenefit benefit = new InsuranceBenefit();
        benefit.setId(rs.getInt("benefit_id"));
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
