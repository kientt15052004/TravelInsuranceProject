package dal;

import Model.Contract;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ContractDBContext extends DBContext {

    public void insertContract(Contract contract) {
        String sql = "INSERT INTO contract (current_benefit_id, application_id, description, contract_status) VALUES (?, ?, ?, ?)";
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
        String sql = "SELECT * FROM contract WHERE contract_id = ?";
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
        String sql = "SELECT * FROM contract";
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
        String sql = "SELECT * FROM contract WHERE description LIKE ? OR CAST(contract_id AS CHAR) LIKE ? OR CAST(application_id AS CHAR) LIKE ?";

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
        String sql = "SELECT * FROM contract WHERE contract_status = ?";

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
        String sql = "SELECT COUNT(*) FROM contract";
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

        StringBuilder sql = new StringBuilder("SELECT c.* FROM contract c ");
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
        String sql = "SELECT c.* FROM contract c "
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
        String sql = "SELECT c.* FROM contract c "
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
        String sql = "SELECT COUNT(*) FROM contract c "
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
        String sql = "SELECT COUNT(*) FROM contract c "
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
        String sql = "SELECT COUNT(*) FROM contract WHERE contract_status = ?";
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
        String sql = "INSERT INTO contract (current_benefit_id, application_id, description, contract_status) "
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

}
