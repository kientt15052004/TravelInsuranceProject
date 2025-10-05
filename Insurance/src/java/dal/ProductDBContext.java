package dal;

import model.Product;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDBContext extends DBContext{

    public void createProduct(int benefit_id, String type, String name, String img, String description, String package_type) {
        PreparedStatement prepare = null;
        int rs;
        try {
            if (connection == null) {
                System.out.println("Ko thể kết nối database!");
                return;
            }
            String sql = "INSERT INTO products (benefit_id, type, name, img, description, package) VALUES (?, ?, ?, ?, ?, ?)";
            prepare = connection.prepareStatement(sql);
            prepare.setInt(1, benefit_id);
            prepare.setString(2, type);
            prepare.setString(3, name);
            prepare.setString(4, img);
            prepare.setString(5, description);
            prepare.setString(6, package_type);
            rs = prepare.executeUpdate();
            if (rs > 0) {
                System.out.println("Có " + rs + " dòng được thêm!");
            }

        } catch (SQLException e) {
            System.out.println("Lỗi khi query database: " + e.getMessage());
        }
    }

    public int createBenefit(String deathOrDisability, String deathByIllness, String thirdPartyLiability, String lostBankCard, String kidnapHostag, String golfEquipLoss, boolean deleted, String medical_cost, String emergency_transport, String repatriation_vn, String repatriation_abroad, String hospital_visit, String funeral_arrangement, String child_care, String hospital_allowance, String accident_death_injury, String trip_cancellation, String companion_support, String delayed_baggage, String travel_documents, String trip_delay) {
        PreparedStatement prepare = null;
        int rows;
        int id = 0;
        try {
            if (connection == null) {
                System.out.println("Ko thể kết nối database!");
            }
            String sql = "INSERT INTO insurance_benefits (death_or_permanent_disability, death_due_to_illness, third_party_liability, lost_bank_card, kidnap_and_hostage, lost_or_damaged_golf_equipment, is_deleted, medical_cost, emergency_transport, repatriation_vn, repatriation_abroad, hospital_visit, funeral_arrangement, child_care, hospital_allowance, accident_death_injury, trip_cancellation, companion_support, delayed_baggage, travel_documents, trip_delay) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            prepare = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            prepare.setBigDecimal(1, new BigDecimal(deathOrDisability));
            prepare.setBigDecimal(2, new BigDecimal(deathByIllness));
            prepare.setBigDecimal(3, new BigDecimal(thirdPartyLiability));
            prepare.setBigDecimal(4, new BigDecimal(lostBankCard));
            prepare.setBigDecimal(5, new BigDecimal(kidnapHostag));
            prepare.setBigDecimal(6, new BigDecimal(golfEquipLoss));
            prepare.setBoolean(7, deleted);
            prepare.setBigDecimal(8, new BigDecimal(medical_cost));
            prepare.setBigDecimal(9, new BigDecimal(emergency_transport));
            prepare.setBigDecimal(10, new BigDecimal(repatriation_vn));
            prepare.setBigDecimal(11, new BigDecimal(repatriation_abroad));
            prepare.setBigDecimal(12, new BigDecimal(hospital_visit));
            prepare.setBigDecimal(13, new BigDecimal(funeral_arrangement));
            prepare.setBigDecimal(14, new BigDecimal(child_care));
            prepare.setBigDecimal(15, new BigDecimal(hospital_allowance));
            prepare.setBigDecimal(16, new BigDecimal(accident_death_injury));
            prepare.setBigDecimal(17, new BigDecimal(trip_cancellation));
            prepare.setBigDecimal(18, new BigDecimal(companion_support));
            prepare.setBigDecimal(19, new BigDecimal(delayed_baggage));
            prepare.setBigDecimal(20, new BigDecimal(travel_documents));
            prepare.setBigDecimal(21, new BigDecimal(trip_delay));

            rows = prepare.executeUpdate();
            if (rows > 0) {
                System.out.println("Có " + rows + " dòng được thêm!");
                try (ResultSet rs = prepare.getGeneratedKeys()) {
                    if (rs.next()) {
                        id = rs.getInt(1); //id của benefit vừa mới tạo
                        System.out.println("Benefit mới được tạo với ID = " + id);
                    }
                }
            }

        } catch (SQLException e) {
            System.out.println("Lỗi khi query database: " + e.getMessage());
        }
        return id;
    }
    
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setBenefit_id(rs.getInt("benefit_id"));
                product.setType(rs.getString("type"));
                product.setName(rs.getString("name"));
                product.setImg(rs.getString("img"));
                product.setDescription(rs.getString("description"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách products: " + e.getMessage());
        }
        return products;
    }
    
    public List<Product> getProductsByType(String type) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE type = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setBenefit_id(rs.getInt("benefit_id"));
                product.setType(rs.getString("type"));
                product.setName(rs.getString("name"));
                product.setImg(rs.getString("img"));
                product.setDescription(rs.getString("description"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách products theo loại: " + e.getMessage());
        }
        return products;
    }
    
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setBenefit_id(rs.getInt("benefit_id"));
                product.setType(rs.getString("type"));
                product.setName(rs.getString("name"));
                product.setImg(rs.getString("img"));
                product.setDescription(rs.getString("description"));
                return product;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy product theo ID: " + e.getMessage());
        }
        return null;
    }
}
