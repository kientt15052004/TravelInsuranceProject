package dal;

import Model.Contract;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ContractDBContext extends DBContext {

    public void insertContract(Contract contract) {
        String sql = "INSERT INTO Contract (current_benefit_id, application_id, description, contract_status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, contract.getCurrent_benefit_id());
            ps.setInt(2, contract.getApplication_id());
            ps.setString(3, contract.getDescription());
            ps.setString(4, contract.getContract_status());

            ps.executeUpdate();

            ResultSet generatedKeys = ps.getGeneratedKeys();
            if (generatedKeys.next()) {
                contract.setContract_id(generatedKeys.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to insert contract", e);
        }
    }

    public Contract getContractById(int contractId) {
        String sql = "SELECT * FROM Contract WHERE contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));
                return contract;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Contract> getAllContracts() {
        List<Contract> contracts = new ArrayList<>();
        String sql = "SELECT * FROM Contract";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));
                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    public List<Contract> searchContracts(String searchTerm) {
        List<Contract> contracts = new ArrayList<>();
        String sql = "SELECT * FROM Contract WHERE description LIKE ? OR CAST(contract_id AS CHAR) LIKE ? OR CAST(application_id AS CHAR) LIKE ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));
                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    public List<Contract> getContractsByStatus(String status) {
        List<Contract> contracts = new ArrayList<>();
        String sql = "SELECT * FROM Contract WHERE contract_status = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));
                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    public int getTotalContracts() {
        String sql = "SELECT COUNT(*) FROM Contract";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Contract> getContractsWithFilters(String searchTerm, String statusFilter, String productFilter, String dateFrom, String dateTo) {
        List<Contract> contracts = new ArrayList<>();

        // Nếu không có bộ lọc nào, trả về tất cả hợp đồng
        if ((searchTerm == null || searchTerm.trim().isEmpty())
                && (statusFilter == null || statusFilter.trim().isEmpty())
                && (productFilter == null || productFilter.trim().isEmpty())
                && (dateFrom == null || dateFrom.trim().isEmpty())
                && (dateTo == null || dateTo.trim().isEmpty())) {
            return getAllContracts();
        }

        StringBuilder sql = new StringBuilder("SELECT c.* FROM Contract c ");
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();

        // Join với Application và các bảng liên quan để tìm kiếm
        boolean needJoin = (productFilter != null && !productFilter.trim().isEmpty())
                || (dateFrom != null && !dateFrom.trim().isEmpty())
                || (dateTo != null && !dateTo.trim().isEmpty())
                || (searchTerm != null && !searchTerm.trim().isEmpty());

        if (needJoin) {
            sql.append("LEFT JOIN applications a ON c.application_id = a.id ");
            sql.append("LEFT JOIN products p ON a.product_id = p.id ");
            sql.append("LEFT JOIN users u ON a.purchaser_id = u.id ");
        }

        // Điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            conditions.add("(c.description LIKE ? OR CAST(c.contract_id AS CHAR) LIKE ? OR CAST(c.application_id AS CHAR) LIKE ? OR p.name LIKE ? OR u.fullname LIKE ?)");
            String searchPattern = "%" + searchTerm + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        // Điều kiện lọc theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            conditions.add("c.contract_status = ?");
            parameters.add(statusFilter);
        }

        // Điều kiện lọc theo sản phẩm
        if (productFilter != null && !productFilter.trim().isEmpty()) {
            try {
                int productId = Integer.parseInt(productFilter);
                conditions.add("a.product_id = ?");
                parameters.add(productId);
            } catch (NumberFormatException e) {
                // Bỏ qua nếu productFilter không phải là số hợp lệ
                System.err.println("Invalid product filter: " + productFilter);
            }
        }

        // Điều kiện lọc theo ngày tháng
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            conditions.add("a.startDate >= ?");
            parameters.add(java.sql.Date.valueOf(dateFrom));
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            conditions.add("a.endDate <= ?");
            parameters.add(java.sql.Date.valueOf(dateTo));
        }

        // Thêm điều kiện WHERE nếu có
        if (!conditions.isEmpty()) {
            sql.append("WHERE ").append(String.join(" AND ", conditions));
        }

        sql.append(" ORDER BY c.contract_id DESC");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));
                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Nếu có lỗi, fallback về getAllContracts()
            return getAllContracts();
        }
        return contracts;
    }

    public List<Contract> getContractsByDateRange(String dateFrom, String dateTo) {
        List<Contract> contracts = new ArrayList<>();
        String sql = "SELECT c.* FROM Contract c "
                + "LEFT JOIN applications a ON c.application_id = a.id "
                + "WHERE a.startDate >= ? AND a.endDate <= ? "
                + "ORDER BY c.contract_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(dateFrom));
            ps.setDate(2, java.sql.Date.valueOf(dateTo));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));
                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    public List<Contract> getContractsByProduct(int productId) {
        List<Contract> contracts = new ArrayList<>();
        String sql = "SELECT c.* FROM Contract c "
                + "LEFT JOIN applications a ON c.application_id = a.id "
                + "WHERE a.product_id = ? "
                + "ORDER BY c.contract_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));
                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    public int getContractsByProductCount(int productId) {
        String sql = "SELECT COUNT(*) FROM Contract c "
                + "LEFT JOIN applications a ON c.application_id = a.id "
                + "WHERE a.product_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getContractsByDateRangeCount(String dateFrom, String dateTo) {
        String sql = "SELECT COUNT(*) FROM Contract c "
                + "LEFT JOIN applications a ON c.application_id = a.id "
                + "WHERE a.startDate >= ? AND a.endDate <= ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(dateFrom));
            ps.setDate(2, java.sql.Date.valueOf(dateTo));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getContractsByStatusCount(String status) {
        String sql = "SELECT COUNT(*) FROM Contract WHERE contract_status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int createContract(Contract contract) {
        String sql = "INSERT INTO Contract (current_benefit_id, application_id, description, contract_status) "
                + "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, contract.getCurrent_benefit_id());
            ps.setInt(2, contract.getApplication_id());
            ps.setString(3, contract.getDescription());
            ps.setString(4, contract.getContract_status());

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int contractId = generatedKeys.getInt(1);
                        contract.setContract_id(contractId); // gán lại vào object nếu muốn dùng tiếp
                        System.out.println("✅ Contract created with ID: " + contractId);
                        return contractId;
                    }
                }
            }
            return -1; // không có ID được trả về
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("❌ Failed to create contract", e);
        }
    }

    public List<Contract> getRecentContracts(int limit) {
        List<Contract> contracts = new ArrayList<>();
        String sql = "SELECT * FROM Contract ORDER BY contract_id DESC LIMIT ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));
                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    /**
     * Lấy danh sách hợp đồng đã mua của customer với thông tin chi tiết
     *
     * @param customerId ID của customer
     * @param searchTerm Từ khóa tìm kiếm (tên sản phẩm, contract ID)
     * @param statusFilter Lọc theo trạng thái (active, pending, cancelled)
     * @param typeFilter Lọc theo loại (domestic, international)
     * @param page Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số record mỗi trang
     * @return Danh sách hợp đồng với thông tin chi tiết
     */
    public List<Contract> getCustomerPurchasedInsurance(int customerId, String searchTerm,
            String statusFilter, String typeFilter, String sortBy, int page, int pageSize) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.contract_id, c.current_benefit_id, c.application_id, c.description, c.contract_status, ");
        sql.append("p.name as product_name, p.type as product_type, p.package_type, ");
        sql.append("a.destination, a.startDate, a.endDate, a.travelers_quantity, a.total_price, ");
        sql.append("u.fullname as buyer_name, u.phone as buyer_phone, u.mail as buyer_email ");
        sql.append("FROM Contract c ");
        sql.append("JOIN applications a ON c.application_id = a.id ");
        sql.append("JOIN products p ON a.product_id = p.id ");
        sql.append("JOIN users u ON a.purchaser_id = u.id ");
        sql.append("WHERE a.purchaser_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR c.contract_id LIKE ? OR a.destination LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Lọc theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql.append("AND c.contract_status = ? ");
            params.add(statusFilter);
        }

        // Lọc theo loại
        if (typeFilter != null && !typeFilter.trim().isEmpty() && !"all".equalsIgnoreCase(typeFilter)) {
            sql.append("AND p.type = ? ");
            params.add(typeFilter);
        }

        // Sắp xếp theo yêu cầu
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy.toLowerCase()) {
                case "newest":
                    sql.append("ORDER BY c.contract_id DESC ");
                    break;
                case "expiring":
                    sql.append("ORDER BY a.endDate ASC ");
                    break;
                case "price_desc":
                    sql.append("ORDER BY a.total_price DESC ");
                    break;
                case "price_asc":
                    sql.append("ORDER BY a.total_price ASC ");
                    break;
                default:
                    sql.append("ORDER BY c.contract_id DESC ");
            }
        } else {
            sql.append("ORDER BY c.contract_id DESC ");
        }

        // Phân trang
        if (page > 0 && pageSize > 0) {
            int offset = (page - 1) * pageSize;
            sql.append("LIMIT ? OFFSET ? ");
            params.add(pageSize);
            params.add(offset);
        }

        List<Contract> contracts = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Contract contract = new Contract();
                contract.setContract_id(rs.getInt("contract_id"));
                contract.setCurrent_benefit_id(rs.getInt("current_benefit_id"));
                contract.setApplication_id(rs.getInt("application_id"));
                contract.setDescription(rs.getString("description"));
                contract.setContract_status(rs.getString("contract_status"));

                // Thông tin sản phẩm
                contract.setProductName(rs.getString("product_name"));
                contract.setProductType(rs.getString("product_type"));

                // Thông tin ngày
                contract.setStartDate(rs.getDate("startDate"));
                contract.setEndDate(rs.getDate("endDate"));

                // Thông tin chuyến đi
                contract.setDestination(rs.getString("destination"));
                contract.setTravelers_quantity(rs.getInt("travelers_quantity"));

                // Thông tin người mua
                contract.setBuyerName(rs.getString("buyer_name"));
                contract.setBuyerPhone(rs.getString("buyer_phone"));
                contract.setBuyerEmail(rs.getString("buyer_email"));

                // Tổng số tiền
                contract.setTotalPrice(rs.getBigDecimal("total_price"));

                contracts.add(contract);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get customer purchased insurance", e);
        }

        return contracts;
    }

    /**
     * Đếm tổng số hợp đồng của customer (cho phân trang)
     */
    public int getCustomerContractCount(int customerId, String searchTerm, String statusFilter, String typeFilter) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Contract c ");
        sql.append("JOIN applications a ON c.application_id = a.id ");
        sql.append("JOIN products p ON a.product_id = p.id ");
        sql.append("WHERE a.purchaser_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR c.contract_id LIKE ? OR a.destination LIKE ?) ");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Lọc theo trạng thái
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
            sql.append("AND c.contract_status = ? ");
            params.add(statusFilter);
        }

        // Lọc theo loại
        if (typeFilter != null && !typeFilter.trim().isEmpty() && !"all".equalsIgnoreCase(typeFilter)) {
            sql.append("AND p.type = ? ");
            params.add(typeFilter);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Kiểm tra xem contract có thuộc về customer không
     */
    public boolean isContractOwnedByCustomer(int contractId, int customerId) {
        if (connection == null) {
            System.err.println("Database connection is null!");
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM Contract c " +
                    "JOIN applications a ON c.application_id = a.id " +
                    "WHERE c.contract_id = ? AND a.purchaser_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.setInt(2, customerId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

}
