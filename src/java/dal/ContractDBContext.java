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
    
    public void updateContractStatus(int contractId, String status) {
        String sql = "UPDATE Contract SET contract_status = ? WHERE contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, contractId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
