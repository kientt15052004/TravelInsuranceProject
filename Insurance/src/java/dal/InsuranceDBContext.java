
package dal;

import model.Product;
import model.InsuranceProduct;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.InsuranceBenefit;

/**
 *
 * @author FPTSHOP
 */
public class InsuranceDBContext extends DBContext {

    public ArrayList<Product> getAll() {
        String sql = "select * from products";
        ArrayList<Product> insurances = new ArrayList<>();
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Product insurance = new Product();
                insurance.setId(rs.getInt("id"));
                insurance.setBenefit_id(rs.getInt("benefit_id"));
                insurance.setName(rs.getString("name"));
                insurance.setImg(rs.getString("img"));
                insurance.setType(rs.getString("type"));
                insurance.setDescription(rs.getString("description"));

                insurances.add(insurance);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return insurances;
    }

    public ArrayList<InsuranceProduct> getAllWithBenefit() {
        String sql = "SELECT p.id AS product_id, p.name, p.img, p.type, p.description, "
                + "b.id AS benefit_id, b.death_or_permanent_disability, b.death_due_to_illness, "
                + "b.third_party_liability, b.lost_bank_card, b.kidnap_and_hostage, "
                + "b.lost_or_damaged_golf_equipment, b.is_deleted "
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

                int benefitId = rs.getInt("benefit_id");
                if (benefitId > 0) {
                    InsuranceBenefit benefit = new InsuranceBenefit();
                    benefit.setId(benefitId);
                    benefit.setDeath_or_permanent_disability(rs.getBigDecimal("death_or_permanent_disability"));
                    benefit.setDeath_due_to_illness(rs.getBigDecimal("death_due_to_illness"));
                    benefit.setThird_party_liability(rs.getBigDecimal("third_party_liability"));
                    benefit.setLost_bank_card(rs.getBigDecimal("lost_bank_card"));
                    benefit.setKidnap_and_hostage(rs.getBigDecimal("kidnap_and_hostage"));
                    benefit.setLost_or_damaged_golf_equipment(rs.getBigDecimal("lost_or_damaged_golf_equipment"));
                    benefit.setIs_deleted(rs.getBoolean("is_deleted"));

                    insurance.setBenefit(benefit); // chỉ set 1 object
                }

                insurances.add(insurance);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return insurances;
    }

    public Product getById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                Product insurance = new Product();
                insurance.setId(rs.getInt("id"));
                insurance.setBenefit_id(rs.getInt("benefit_id"));
                insurance.setName(rs.getString("name"));
                insurance.setImg(rs.getString("img"));
                insurance.setType(rs.getString("type"));
                insurance.setDescription(rs.getString("description"));

                return insurance;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public InsuranceProduct getByIdWithBenefit(int id) {
        String sql = "SELECT p.id AS product_id, p.name, p.img, p.type, p.description, "
                + "b.id AS benefit_id, b.death_or_permanent_disability, b.death_due_to_illness, "
                + "b.third_party_liability, b.lost_bank_card, b.kidnap_and_hostage, "
                + "b.lost_or_damaged_golf_equipment, b.is_deleted "
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

                int benefitId = rs.getInt("benefit_id");
                if (benefitId > 0) {
                    InsuranceBenefit benefit = new InsuranceBenefit();
                    benefit.setId(benefitId);
                    benefit.setDeath_or_permanent_disability(rs.getBigDecimal("death_or_permanent_disability"));
                    benefit.setDeath_due_to_illness(rs.getBigDecimal("death_due_to_illness"));
                    benefit.setThird_party_liability(rs.getBigDecimal("third_party_liability"));
                    benefit.setLost_bank_card(rs.getBigDecimal("lost_bank_card"));
                    benefit.setKidnap_and_hostage(rs.getBigDecimal("kidnap_and_hostage"));
                    benefit.setLost_or_damaged_golf_equipment(rs.getBigDecimal("lost_or_damaged_golf_equipment"));
                    benefit.setIs_deleted(rs.getBoolean("is_deleted"));

                    insurance.setBenefit(benefit); // chỉ set 1 object
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return insurance;
    }
    
}
