/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.InsuranceProduct;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import Model.InsuranceBenefit;
import Model.User;

/**
 *
 * @author FPTSHOP
 */
public class InsuranceDBContext extends DBContext {

    public ArrayList<InsuranceProduct> getAll() {
        String sql = "SELECT * FROM products WHERE is_delete = false";
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

    public ArrayList<InsuranceProduct> getAllPaging(
            int page, int pageSize, String searchName, String searchType,
            Double priceMin, Double priceMax) {

        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1 AND is_active = 1");
        ArrayList<InsuranceProduct> insurances = new ArrayList<>();

        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }

        if (searchType != null && !searchType.trim().isEmpty()) {
            sql.append(" AND type = ?");
        }

        if (priceMin != null) {
            sql.append(" AND price >= ?");
        }

        if (priceMax != null) {
            sql.append(" AND price <= ?");
        }

        sql.append(" ORDER BY id LIMIT ? OFFSET ?");

        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (searchName != null && !searchName.trim().isEmpty()) {
                String pattern = "%" + searchName.trim() + "%";
                stm.setString(paramIndex++, pattern);
                stm.setString(paramIndex++, pattern);
            }

            if (searchType != null && !searchType.trim().isEmpty()) {
                stm.setString(paramIndex++, searchType.trim());
            }

            if (priceMin != null) {
                stm.setDouble(paramIndex++, priceMin);
            }

            if (priceMax != null) {
                stm.setDouble(paramIndex++, priceMax);
            }

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
    public int getTotalRecords(String searchName, String searchType, Double priceMin, Double priceMax) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) as total FROM products WHERE 1=1 AND is_active = 1 ");

        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }

        if (searchType != null && !searchType.trim().isEmpty()) {
            sql.append(" AND type = ?");
        }

        if (priceMin != null) {
            sql.append(" AND price >= ?");
        }

        if (priceMax != null) {
            sql.append(" AND price <= ?");
        }
                //Gán tham số vào PreparedStatement
        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (searchName != null && !searchName.trim().isEmpty()) {
                String pattern = "%" + searchName.trim() + "%";
                stm.setString(paramIndex++, pattern);
                stm.setString(paramIndex++, pattern);
            }

            if (searchType != null && !searchType.trim().isEmpty()) {
                stm.setString(paramIndex++, searchType.trim());
            }

            if (priceMin != null) {
                stm.setDouble(paramIndex++, priceMin);
            }

            if (priceMax != null) {
                stm.setDouble(paramIndex++, priceMax);
            }
            
            //Thực thi truy vấn và đọc kết quả
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
        String sql = "SELECT p.id AS product_id, p.benefit_id, p.name, p.img, p.type, p.description, p.package_type, "
                + "p.price, p.domestic_percentage_rate, p.international_rate_1_7, p.international_rate_8_30, "
                + "p.international_rate_31_90, p.international_rate_91_365, p.is_active, p.is_delete, "
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
                insurance.setBenefit_id(rs.getInt("benefit_id"));
                insurance.setName(rs.getString("name"));
                insurance.setImg(rs.getString("img"));
                insurance.setType(rs.getString("type"));
                insurance.setDescription(rs.getString("description"));
                insurance.setPackage_type(rs.getString("package_type"));
                System.out.println("DEBUG: Loaded package_type from DB: " + rs.getString("package_type"));
                insurance.setPrice(rs.getBigDecimal("price"));
                insurance.setDomestic_percentage_rate(rs.getBigDecimal("domestic_percentage_rate"));
                insurance.setInternational_rate_1_7(rs.getBigDecimal("international_rate_1_7"));
                insurance.setInternational_rate_8_30(rs.getBigDecimal("international_rate_8_30"));
                insurance.setInternational_rate_31_90(rs.getBigDecimal("international_rate_31_90"));
                insurance.setInternational_rate_91_365(rs.getBigDecimal("international_rate_91_365"));
                insurance.setIs_active(rs.getBoolean("is_active"));
                insurance.setIs_delete(rs.getBoolean("is_delete"));

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

    public ArrayList<InsuranceProduct> getProductsByTypeWithBenefit(String type) {
        String sql = "SELECT p.id AS product_id, p.benefit_id, p.name, p.img, p.type, p.description, p.package_type, "
                + "p.price, p.domestic_percentage_rate, p.international_rate_1_7, p.international_rate_8_30, "
                + "p.international_rate_31_90, p.international_rate_91_365, p.is_active, p.is_delete, "
                + "b.id AS benefit_id, b.death_or_permanent_disability, b.death_due_to_illness, "
                + "b.third_party_liability, b.lost_bank_card, b.kidnap_and_hostage, "
                + "b.lost_or_damaged_golf_equipment, "
                + "b.medical_cost, b.emergency_transport, b.repatriation_vn, b.repatriation_abroad, "
                + "b.hospital_visit, b.funeral_arrangement, b.child_care, b.hospital_allowance, "
                + "b.accident_death_injury, b.trip_cancellation, b.companion_support, "
                + "b.delayed_baggage, b.travel_documents, b.trip_delay "
                + "FROM products p "
                + "LEFT JOIN insurance_benefits b ON p.benefit_id = b.id "
                + "WHERE p.type = ? AND p.is_active = 1 AND p.is_delete = 0";

        ArrayList<InsuranceProduct> products = new ArrayList<>();

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, type);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                InsuranceProduct product = new InsuranceProduct();
                product.setId(rs.getInt("product_id"));
                product.setBenefit_id(rs.getInt("benefit_id"));
                product.setName(rs.getString("name"));
                product.setImg(rs.getString("img"));
                product.setType(rs.getString("type"));
                product.setDescription(rs.getString("description"));
                product.setPackage_type(rs.getString("package_type"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setDomestic_percentage_rate(rs.getBigDecimal("domestic_percentage_rate"));
                product.setInternational_rate_1_7(rs.getBigDecimal("international_rate_1_7"));
                product.setInternational_rate_8_30(rs.getBigDecimal("international_rate_8_30"));
                product.setInternational_rate_31_90(rs.getBigDecimal("international_rate_31_90"));
                product.setInternational_rate_91_365(rs.getBigDecimal("international_rate_91_365"));
                product.setIs_active(rs.getBoolean("is_active"));
                product.setIs_delete(rs.getBoolean("is_delete"));

                int benefitId = rs.getInt("benefit_id");
                if (benefitId > 0) {
                    InsuranceBenefit benefit = mapResultSetToInsuranceBenefit(rs);
                    product.setBenefit(benefit);
                }

                products.add(product);
            }
            
            // Sort packages: Standard types first (Basic, Standard, Advanced, Comprehensive), then others alphabetically
            products.sort((p1, p2) -> {
                int order1 = utils.PackageType.getDisplayOrder(p1.getPackage_type());
                int order2 = utils.PackageType.getDisplayOrder(p2.getPackage_type());
                
                if (order1 != order2) {
                    return Integer.compare(order1, order2);
                }
                
                // If both are custom packages (order = 999), sort alphabetically
                if (order1 == 999) {
                    return p1.getPackage_type().compareToIgnoreCase(p2.getPackage_type());
                }
                
                return 0;
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
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

    public ArrayList<String> getAllPackageTypes() {
        ArrayList<String> packageTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT package_type FROM products WHERE package_type IS NOT NULL AND package_type != '' ORDER BY package_type";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                String packageType = rs.getString("package_type");
                if (packageType != null && !packageType.trim().isEmpty()) {
                    packageTypes.add(packageType);
                }
            }
        } catch (Exception e) {
            System.out.println("Error in getAllPackageTypes(): " + e.getMessage());
        }

        return packageTypes;
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
        insurance.setPackage_type(rs.getString("package_type"));
        insurance.setPrice(rs.getBigDecimal("price"));
        insurance.setIs_active(rs.getBoolean("is_active"));
        insurance.setIs_delete(rs.getBoolean("is_delete"));
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

    // ========== ADDITIONAL METHODS FOR COMPLETE CRUD OPERATIONS ==========
    
    public ArrayList<InsuranceProduct> getDomesticProducts() {
        String sql = "SELECT * FROM products WHERE type = 'domestic' AND is_delete = false ORDER BY id ASC";
        ArrayList<InsuranceProduct> products = new ArrayList<>();
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InsuranceProduct product = mapResultSetToInsuranceProduct(rs);
                products.add(product);
            }
        } catch (Exception e) {
            System.out.println("Error getting domestic products: " + e.getMessage());
        }
        return products;
    }

    public ArrayList<InsuranceProduct> getInternationalProducts() {
        String sql = "SELECT * FROM products WHERE type = 'international' AND is_delete = false ORDER BY id ASC";
        ArrayList<InsuranceProduct> products = new ArrayList<>();
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InsuranceProduct product = mapResultSetToInsuranceProduct(rs);
                products.add(product);
            }
        } catch (Exception e) {
            System.out.println("Error getting international products: " + e.getMessage());
        }
        return products;
    }

    public ArrayList<InsuranceProduct> getActiveProducts() {
        String sql = "SELECT * FROM products WHERE is_active = true AND is_delete = false ORDER BY id ASC";
        ArrayList<InsuranceProduct> products = new ArrayList<>();
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InsuranceProduct product = mapResultSetToInsuranceProduct(rs);
                products.add(product);
            }
        } catch (Exception e) {
            System.out.println("Error getting active products: " + e.getMessage());
        }
        return products;
    }

    public ArrayList<InsuranceProduct> getNonActiveProducts() {
        String sql = "SELECT * FROM products WHERE is_active = false AND is_delete = false ORDER BY id ASC";
        ArrayList<InsuranceProduct> products = new ArrayList<>();
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InsuranceProduct product = mapResultSetToInsuranceProduct(rs);
                products.add(product);
            }
        } catch (Exception e) {
            System.out.println("Error getting non-active products: " + e.getMessage());
        }
        return products;
    }

    public int createBenefit(InsuranceBenefit benefit) {
        String sql = "INSERT INTO insurance_benefits (death_or_permanent_disability, death_due_to_illness, " +
                    "third_party_liability, lost_bank_card, kidnap_and_hostage, lost_or_damaged_golf_equipment, " +
                    "medical_cost, emergency_transport, repatriation_vn, repatriation_abroad, hospital_visit, " +
                    "funeral_arrangement, child_care, hospital_allowance, accident_death_injury, trip_cancellation, " +
                    "companion_support, delayed_baggage, travel_documents, trip_delay) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setBigDecimal(1, benefit.getDeath_or_permanent_disability());
            stm.setBigDecimal(2, benefit.getDeath_due_to_illness());
            stm.setBigDecimal(3, benefit.getThird_party_liability());
            stm.setBigDecimal(4, benefit.getLost_bank_card());
            stm.setBigDecimal(5, benefit.getKidnap_and_hostage());
            stm.setBigDecimal(6, benefit.getLost_or_damaged_golf_equipment());
            stm.setBigDecimal(7, benefit.getMedical_cost());
            stm.setBigDecimal(8, benefit.getEmergency_transport());
            stm.setBigDecimal(9, benefit.getRepatriation_vn());
            stm.setBigDecimal(10, benefit.getRepatriation_abroad());
            stm.setBigDecimal(11, benefit.getHospital_visit());
            stm.setBigDecimal(12, benefit.getFuneral_arrangement());
            stm.setBigDecimal(13, benefit.getChild_care());
            stm.setBigDecimal(14, benefit.getHospital_allowance());
            stm.setBigDecimal(15, benefit.getAccident_death_injury());
            stm.setBigDecimal(16, benefit.getTrip_cancellation());
            stm.setBigDecimal(17, benefit.getCompanion_support());
            stm.setBigDecimal(18, benefit.getDelayed_baggage());
            stm.setBigDecimal(19, benefit.getTravel_documents());
            stm.setBigDecimal(20, benefit.getTrip_delay());
            
            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stm.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Error creating benefit: " + e.getMessage());
        }
        return -1;
    }

    public boolean createProduct(InsuranceProduct product) {
        String sql = "INSERT INTO products (benefit_id, type, name, img, description, package_type, price, " +
                    "domestic_percentage_rate, international_rate_1_7, international_rate_8_30, " +
                    "international_rate_31_90, international_rate_91_365, is_active, is_delete) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, product.getBenefit_id());
            stm.setString(2, product.getType());
            stm.setString(3, product.getName());
            stm.setString(4, product.getImg());
            stm.setString(5, product.getDescription());
            stm.setString(6, product.getPackage_type());
            stm.setBigDecimal(7, product.getPrice());
            stm.setBigDecimal(8, product.getDomestic_percentage_rate());
            stm.setBigDecimal(9, product.getInternational_rate_1_7());
            stm.setBigDecimal(10, product.getInternational_rate_8_30());
            stm.setBigDecimal(11, product.getInternational_rate_31_90());
            stm.setBigDecimal(12, product.getInternational_rate_91_365());
            stm.setBoolean(13, product.getIs_active());
            stm.setBoolean(14, product.getIs_delete());
            
            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error creating product: " + e.getMessage());
            e.printStackTrace();
            // Log chi tiết lỗi để debug
            if (e.getMessage() != null && e.getMessage().contains("package_type")) {
                System.out.println("ERROR: Package type issue. Current package_type value: " + product.getPackage_type());
                System.out.println("NOTE: If using custom package_type, make sure database column is VARCHAR, not ENUM.");
            }
            return false;
        }
    }

    public boolean updateBenefit(InsuranceBenefit benefit) {
        String sql = "UPDATE insurance_benefits SET death_or_permanent_disability=?, death_due_to_illness=?, " +
                    "third_party_liability=?, lost_bank_card=?, kidnap_and_hostage=?, lost_or_damaged_golf_equipment=?, " +
                    "medical_cost=?, emergency_transport=?, repatriation_vn=?, repatriation_abroad=?, hospital_visit=?, " +
                    "funeral_arrangement=?, child_care=?, hospital_allowance=?, accident_death_injury=?, trip_cancellation=?, " +
                    "companion_support=?, delayed_baggage=?, travel_documents=?, trip_delay=? WHERE id=?";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setBigDecimal(1, benefit.getDeath_or_permanent_disability());
            stm.setBigDecimal(2, benefit.getDeath_due_to_illness());
            stm.setBigDecimal(3, benefit.getThird_party_liability());
            stm.setBigDecimal(4, benefit.getLost_bank_card());
            stm.setBigDecimal(5, benefit.getKidnap_and_hostage());
            stm.setBigDecimal(6, benefit.getLost_or_damaged_golf_equipment());
            stm.setBigDecimal(7, benefit.getMedical_cost());
            stm.setBigDecimal(8, benefit.getEmergency_transport());
            stm.setBigDecimal(9, benefit.getRepatriation_vn());
            stm.setBigDecimal(10, benefit.getRepatriation_abroad());
            stm.setBigDecimal(11, benefit.getHospital_visit());
            stm.setBigDecimal(12, benefit.getFuneral_arrangement());
            stm.setBigDecimal(13, benefit.getChild_care());
            stm.setBigDecimal(14, benefit.getHospital_allowance());
            stm.setBigDecimal(15, benefit.getAccident_death_injury());
            stm.setBigDecimal(16, benefit.getTrip_cancellation());
            stm.setBigDecimal(17, benefit.getCompanion_support());
            stm.setBigDecimal(18, benefit.getDelayed_baggage());
            stm.setBigDecimal(19, benefit.getTravel_documents());
            stm.setBigDecimal(20, benefit.getTrip_delay());
            stm.setInt(21, benefit.getId());
            
            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error updating benefit: " + e.getMessage());
            return false;
        }
    }

    public boolean updateProduct(InsuranceProduct product) {
        String sql = "UPDATE products SET benefit_id=?, type=?, name=?, img=?, description=?, package_type=?, price=?, " +
                    "domestic_percentage_rate=?, international_rate_1_7=?, international_rate_8_30=?, " +
                    "international_rate_31_90=?, international_rate_91_365=?, is_active=?, is_delete=? WHERE id=?";
        
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            System.out.println("DEBUG: Updating product with ID: " + product.getId());
            System.out.println("DEBUG: Product data: " + product.toString());
            
            stm.setInt(1, product.getBenefit_id());
            stm.setString(2, product.getType());
            stm.setString(3, product.getName());
            stm.setString(4, product.getImg());
            stm.setString(5, product.getDescription());
            stm.setString(6, product.getPackage_type());
            stm.setBigDecimal(7, product.getPrice());
            stm.setBigDecimal(8, product.getDomestic_percentage_rate());
            stm.setBigDecimal(9, product.getInternational_rate_1_7());
            stm.setBigDecimal(10, product.getInternational_rate_8_30());
            stm.setBigDecimal(11, product.getInternational_rate_31_90());
            stm.setBigDecimal(12, product.getInternational_rate_91_365());
            stm.setBoolean(13, product.getIs_active());
            stm.setBoolean(14, product.getIs_delete());
            stm.setInt(15, product.getId());
            
            int rowsAffected = stm.executeUpdate();
            System.out.println("DEBUG: Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProduct(int id) {
        String sql = "UPDATE products SET is_delete = true WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            int rowsAffected = stm.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Error deleting product: " + e.getMessage());
            return false;
        }
    }
    
    public ArrayList<InsuranceProduct> getFilteredProducts(String searchTerm, String typeFilter, String packageFilter, String statusFilter) {
        ArrayList<InsuranceProduct> products = new ArrayList<>();
        
        // Xây dựng SQL query động
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE is_delete = false");
        ArrayList<Object> parameters = new ArrayList<>();
        
        // Thêm điều kiện search
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ? OR type LIKE ? OR package_type LIKE ?)");
            String searchPattern = "%" + searchTerm.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        // Thêm điều kiện type filter
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            sql.append(" AND type = ?");
            parameters.add(typeFilter.trim());
        }
        
        // Thêm điều kiện package filter
        if (packageFilter != null && !packageFilter.trim().isEmpty()) {
            sql.append(" AND package_type = ?");
            parameters.add(packageFilter.trim());
        }
        
        // Thêm điều kiện status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            if ("active".equals(statusFilter.trim())) {
                sql.append(" AND is_active = true");
            } else if ("inactive".equals(statusFilter.trim())) {
                sql.append(" AND is_active = false");
            }
        }
        
        sql.append(" ORDER BY id ASC");
        
        System.out.println("DEBUG: Filter SQL: " + sql.toString());
        System.out.println("DEBUG: Parameters: " + parameters);
        
        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                stm.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                InsuranceProduct product = new InsuranceProduct();
                product.setId(rs.getInt("id"));
                product.setBenefit_id(rs.getInt("benefit_id"));
                product.setName(rs.getString("name"));
                product.setImg(rs.getString("img"));
                product.setType(rs.getString("type"));
                product.setDescription(rs.getString("description"));
                product.setPackage_type(rs.getString("package_type"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setDomestic_percentage_rate(rs.getBigDecimal("domestic_percentage_rate"));
                product.setInternational_rate_1_7(rs.getBigDecimal("international_rate_1_7"));
                product.setInternational_rate_8_30(rs.getBigDecimal("international_rate_8_30"));
                product.setInternational_rate_31_90(rs.getBigDecimal("international_rate_31_90"));
                product.setInternational_rate_91_365(rs.getBigDecimal("international_rate_91_365"));
                product.setIs_active(rs.getBoolean("is_active"));
                product.setIs_delete(rs.getBoolean("is_delete"));
                products.add(product);
            }
        } catch (Exception e) {
            System.out.println("Error filtering products: " + e.getMessage());
            e.printStackTrace();
        }
        
        return products;
    }

    public ArrayList<InsuranceProduct> getTopSellingProducts(int limit) {
        String sql = "SELECT p.*, COUNT(a.id) as purchase_count " +
                    "FROM products p " +
                    "LEFT JOIN applications a ON p.id = a.product_id " +
                    "WHERE p.is_delete = false AND p.is_active = true " +
                    "GROUP BY p.id " +
                    "ORDER BY purchase_count DESC, p.id ASC " +
                    "LIMIT ?";
        
        ArrayList<InsuranceProduct> products = new ArrayList<>();
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, limit);
            ResultSet rs = stm.executeQuery();
            
            while (rs.next()) {
                InsuranceProduct product = mapResultSetToInsuranceProduct(rs);
                products.add(product);
            }
        } catch (Exception e) {
            System.out.println("Error getting top selling products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

}
