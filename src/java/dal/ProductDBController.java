package dal;

import Model.Product;
import Model.InsuranceBenefit1;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ProductDBController extends DBContext {
    
    
public boolean updateProduct(Product product) {
    String sql = "UPDATE products SET benefit_id = ?, type = ?, name = ?, img = ?, description = ?, package = ?, price = ?, domestic_percentage_rate = ?, international_rate_1_7 = ?, international_rate_8_30 = ?, international_rate_31_90 = ?, international_rate_91_180 = ?, is_active = ? WHERE id = ? AND is_delete = false";

    try (PreparedStatement prepare = connection.prepareStatement(sql)) {
        prepare.setInt(1, product.getBenefitId());
        prepare.setString(2, product.getType());
        prepare.setString(3, product.getName());
        prepare.setString(4, product.getImg());
        prepare.setString(5, product.getDescription());
        prepare.setString(6, product.getPackageType());
        prepare.setBigDecimal(7, product.getPrice());
        prepare.setBigDecimal(8, product.getDomesticPercentageRate());
        prepare.setBigDecimal(9, product.getInternationalRate1_7());
        prepare.setBigDecimal(10, product.getInternationalRate8_30());
        prepare.setBigDecimal(11, product.getInternationalRate31_90());
        prepare.setBigDecimal(12, product.getInternationalRate91_180());
        prepare.setBoolean(13, product.isActive());
        prepare.setInt(14, product.getId());

        int rows = prepare.executeUpdate();
        return rows > 0;

    } catch (SQLException e) {
        System.out.println("Lỗi khi cập nhật sản phẩm: " + e.getMessage());
        return false;
    }
}

public boolean updateBenefit(InsuranceBenefit1 benefit) {
    String sql = "UPDATE insurance_benefits SET death_or_permanent_disability = ?, death_due_to_illness = ?, third_party_liability = ?, lost_bank_card = ?, kidnap_and_hostage = ?, lost_or_damaged_golf_equipment = ?, medical_cost = ?, emergency_transport = ?, repatriation_vn = ?, repatriation_abroad = ?, hospital_visit = ?, funeral_arrangement = ?, child_care = ?, hospital_allowance = ?, accident_death_injury = ?, trip_cancellation = ?, companion_support = ?, delayed_baggage = ?, travel_documents = ?, trip_delay = ? WHERE id = ?";

    try (PreparedStatement prepare = connection.prepareStatement(sql)) {
        prepare.setBigDecimal(1, benefit.getDeathOrPermanentDisability());
        prepare.setBigDecimal(2, benefit.getDeathDueToIllness());
        prepare.setBigDecimal(3, benefit.getThirdPartyLiability());
        prepare.setBigDecimal(4, benefit.getLostBankCard());
        prepare.setBigDecimal(5, benefit.getKidnapAndHostage());
        prepare.setBigDecimal(6, benefit.getLostOrDamagedGolfEquipment());
        prepare.setBigDecimal(7, benefit.getMedicalCost());
        prepare.setBigDecimal(8, benefit.getEmergencyTransport());
        prepare.setBigDecimal(9, benefit.getRepatriationVn());
        prepare.setBigDecimal(10, benefit.getRepatriationAbroad());
        prepare.setBigDecimal(11, benefit.getHospitalVisit());
        prepare.setBigDecimal(12, benefit.getFuneralArrangement());
        prepare.setBigDecimal(13, benefit.getChildCare());
        prepare.setBigDecimal(14, benefit.getHospitalAllowance());
        prepare.setBigDecimal(15, benefit.getAccidentDeathInjury());
        prepare.setBigDecimal(16, benefit.getTripCancellation());
        prepare.setBigDecimal(17, benefit.getCompanionSupport());
        prepare.setBigDecimal(18, benefit.getDelayedBaggage());
        prepare.setBigDecimal(19, benefit.getTravelDocuments());
        prepare.setBigDecimal(20, benefit.getTripDelay());
        prepare.setInt(21, benefit.getId());

        int rows = prepare.executeUpdate();
        return rows > 0;

    } catch (SQLException e) {
        System.out.println("Lỗi khi cập nhật quyền lợi bảo hiểm: " + e.getMessage());
        return false;
    }
}


    // Sửa phương thức createProduct để sử dụng Model
    public boolean createProduct(Product product) {
        String sql = "INSERT INTO products (benefit_id, type, name, img, description, package, price, domestic_percentage_rate, international_rate_1_7, international_rate_8_30, international_rate_31_90, international_rate_91_180, is_active, is_delete) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement prepare = connection.prepareStatement(sql)) {
            prepare.setInt(1, product.getBenefitId());
            prepare.setString(2, product.getType());
            prepare.setString(3, product.getName());
            prepare.setString(4, product.getImg());
            prepare.setString(5, product.getDescription());
            prepare.setString(6, product.getPackageType());
            prepare.setBigDecimal(7, product.getPrice());
            prepare.setBigDecimal(8, product.getDomesticPercentageRate());
            prepare.setBigDecimal(9, product.getInternationalRate1_7());
            prepare.setBigDecimal(10, product.getInternationalRate8_30());
            prepare.setBigDecimal(11, product.getInternationalRate31_90());
            prepare.setBigDecimal(12, product.getInternationalRate91_180());
            prepare.setBoolean(13, product.isActive());
            prepare.setBoolean(14, product.isDeleted());

            int rows = prepare.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm sản phẩm: " + e.getMessage());
            return false;
        }
    }

    //phương thức deleteProduct để xoá mềm sản phẩm
    public boolean deleteProduct(int id) {
        String sql = "UPDATE products SET is_delete = 1 WHERE id = ?";

        try (PreparedStatement prepare = connection.prepareStatement(sql)) {
            prepare.setInt(1, id);

            int rows = prepare.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.out.println("Lỗi khi xoá sản phẩm: " + e.getMessage());
            return false;
        }
    }


    // Sửa phương thức xoá mềm sản phẩm và benefit
    public int createBenefit(InsuranceBenefit1 benefit) {
        String sql = "INSERT INTO insurance_benefits (death_or_permanent_disability, death_due_to_illness, third_party_liability, lost_bank_card, kidnap_and_hostage, lost_or_damaged_golf_equipment, medical_cost, emergency_transport, repatriation_vn, repatriation_abroad, hospital_visit, funeral_arrangement, child_care, hospital_allowance, accident_death_injury, trip_cancellation, companion_support, delayed_baggage, travel_documents, trip_delay) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement prepare = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            prepare.setBigDecimal(1, benefit.getDeathOrPermanentDisability());
            prepare.setBigDecimal(2, benefit.getDeathDueToIllness());
            prepare.setBigDecimal(3, benefit.getThirdPartyLiability());
            prepare.setBigDecimal(4, benefit.getLostBankCard());
            prepare.setBigDecimal(5, benefit.getKidnapAndHostage());
            prepare.setBigDecimal(6, benefit.getLostOrDamagedGolfEquipment());
            prepare.setBigDecimal(7, benefit.getMedicalCost());
            prepare.setBigDecimal(8, benefit.getEmergencyTransport());
            prepare.setBigDecimal(9, benefit.getRepatriationVn());
            prepare.setBigDecimal(10, benefit.getRepatriationAbroad());
            prepare.setBigDecimal(11, benefit.getHospitalVisit());
            prepare.setBigDecimal(12, benefit.getFuneralArrangement());
            prepare.setBigDecimal(13, benefit.getChildCare());
            prepare.setBigDecimal(14, benefit.getHospitalAllowance());
            prepare.setBigDecimal(15, benefit.getAccidentDeathInjury());
            prepare.setBigDecimal(16, benefit.getTripCancellation());
            prepare.setBigDecimal(17, benefit.getCompanionSupport());
            prepare.setBigDecimal(18, benefit.getDelayedBaggage());
            prepare.setBigDecimal(19, benefit.getTravelDocuments());
            prepare.setBigDecimal(20, benefit.getTripDelay());

            int rows = prepare.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = prepare.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return -1;

        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm quyền lợi bảo hiểm: " + e.getMessage());
            return -1;
        }
    }

    // Thêm phương thức mới để lấy danh sách sản phẩm
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_delete = false ORDER BY id DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Product product = mapResultSetToProduct(rs);
                products.add(product);

            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách sản phẩm: " + e.getMessage());
        }
        return products;
    }

    public List<Product> getActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = true AND is_delete = false ORDER BY id DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy sản phẩm active: " + e.getMessage());
        }
        return products;
    }

    public List<Product> getNonActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active = false AND is_delete = false ORDER BY id DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy sản phẩm active: " + e.getMessage());
        }
        return products;
    }

    public List<Product> getDomesticProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE type = 'domestic' AND is_delete = false ORDER BY id DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy sản phẩm active: " + e.getMessage());
        }
        return products;
    }

    public List<Product> getInternationProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE type = 'international' AND is_delete = false ORDER BY id DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy sản phẩm active: " + e.getMessage());
        }
        return products;
    }

    //Phương thức lấy product theo id
    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ? AND is_delete = false";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy sản phẩm theo ID: " + e.getMessage());
        }
        return null;
    }

    
        //Phương thức lấy insuranceBenefit theo id
    public InsuranceBenefit1 getInsuranceBenefitById(int id) {
        String sql = "SELECT * FROM insurance_benefits WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInsuranceBenefit(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy sản phẩm theo ID: " + e.getMessage());
        }
        return null;
    }
    
    // Helper method để map ResultSet sang Product
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setBenefitId(rs.getInt("benefit_id"));
        product.setType(rs.getString("type"));
        product.setName(rs.getString("name"));
        product.setImg(rs.getString("img"));
        product.setDescription(rs.getString("description"));
        product.setPackageType(rs.getString("package"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setDomesticPercentageRate(rs.getBigDecimal("domestic_percentage_rate"));
        product.setInternationalRate1_7(rs.getBigDecimal("international_rate_1_7"));
        product.setInternationalRate8_30(rs.getBigDecimal("international_rate_8_30"));
        product.setInternationalRate31_90(rs.getBigDecimal("international_rate_31_90"));
        product.setInternationalRate91_180(rs.getBigDecimal("international_rate_91_180"));
        product.setActive(rs.getBoolean("is_active"));
        product.setDeleted(rs.getBoolean("is_delete"));
        return product;
    }
    
    // Helper method để map ResultSet sang InsuranceBenefit
private InsuranceBenefit1 mapResultSetToInsuranceBenefit(ResultSet rs) throws SQLException {
    InsuranceBenefit1 benefit = new InsuranceBenefit1();
    benefit.setId(rs.getInt("id"));
    benefit.setDeathOrPermanentDisability(rs.getBigDecimal("death_or_permanent_disability"));
    benefit.setDeathDueToIllness(rs.getBigDecimal("death_due_to_illness"));
    benefit.setThirdPartyLiability(rs.getBigDecimal("third_party_liability"));
    benefit.setLostBankCard(rs.getBigDecimal("lost_bank_card"));
    benefit.setKidnapAndHostage(rs.getBigDecimal("kidnap_and_hostage"));
    benefit.setLostOrDamagedGolfEquipment(rs.getBigDecimal("lost_or_damaged_golf_equipment"));
    benefit.setMedicalCost(rs.getBigDecimal("medical_cost"));
    benefit.setEmergencyTransport(rs.getBigDecimal("emergency_transport"));
    benefit.setRepatriationVn(rs.getBigDecimal("repatriation_vn"));
    benefit.setRepatriationAbroad(rs.getBigDecimal("repatriation_abroad"));
    benefit.setHospitalVisit(rs.getBigDecimal("hospital_visit"));
    benefit.setFuneralArrangement(rs.getBigDecimal("funeral_arrangement"));
    benefit.setChildCare(rs.getBigDecimal("child_care"));
    benefit.setHospitalAllowance(rs.getBigDecimal("hospital_allowance"));
    benefit.setAccidentDeathInjury(rs.getBigDecimal("accident_death_injury"));
    benefit.setTripCancellation(rs.getBigDecimal("trip_cancellation"));
    benefit.setCompanionSupport(rs.getBigDecimal("companion_support"));
    benefit.setDelayedBaggage(rs.getBigDecimal("delayed_baggage"));
    benefit.setTravelDocuments(rs.getBigDecimal("travel_documents"));
    benefit.setTripDelay(rs.getBigDecimal("trip_delay"));
    return benefit;
}
}
