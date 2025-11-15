/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Application;
import Model.ApplicationTraveler;
import Model.Contract;
import Model.Invoice;
import java.sql.PreparedStatement;
import java.sql.*;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
public class InvoiceDBContext extends DBContext {

    /**
     * Xử lý toàn bộ flow: Application -> Contract -> Invoice với transaction
     * Nếu bất kỳ bước nào thất bại, tất cả đều rollback
     */
    public int processInsurancePurchaseTransaction(
            Application app,
            List<ApplicationTraveler> travelers,
            Contract contract,
            Invoice invoice) throws Exception {

        String insertAppSql = "INSERT INTO applications "
                + "(purchaser_id, product_id, type, destination, startDate, endDate, travelers_quantity, total_price) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        String insertTravelerSql = "INSERT INTO application_traveler "
                + "(application_id, cccd_id, name, gender, dob, phone, email) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        String insertContractSql = "INSERT INTO contract "
                + "(current_benefit_id, application_id, description, contract_status) "
                + "VALUES (?, ?, ?, ?)";
        
        String insertInvoiceSql = "INSERT INTO invoices "
                + "(contract_id, base_amount, tax_rate, payment_method, payment_code, notes, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        int applicationId = -1;
        int contractId = -1;
        int invoiceId = -1;

        try {
            // Bắt đầu transaction
            connection.setAutoCommit(false);

            // ===== STEP 1: INSERT APPLICATION =====
            try (PreparedStatement stm = connection.prepareStatement(insertAppSql, Statement.RETURN_GENERATED_KEYS)) {
                stm.setInt(1, app.getPurchaser_id());
                stm.setInt(2, app.getProduct_id());
                stm.setString(3, app.getType());
                stm.setString(4, app.getDestination());
                stm.setDate(5, new java.sql.Date(app.getStartDate().getTime()));
                stm.setDate(6, new java.sql.Date(app.getEndDate().getTime()));
                stm.setInt(7, app.getTravelers_quantity());
                stm.setBigDecimal(8, app.getTotal_price());

                int affectedRows = stm.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Insert application failed, no rows affected.");
                }

                try (ResultSet generatedKeys = stm.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        applicationId = generatedKeys.getInt(1);
                        System.out.println("✅ Step 1: Application inserted with ID: " + applicationId);
                    } else {
                        throw new SQLException("Insert application failed, no ID obtained.");
                    }
                }
            }

            // ===== STEP 2: INSERT TRAVELERS =====
            if (travelers != null && !travelers.isEmpty()) {
                try (PreparedStatement stm = connection.prepareStatement(insertTravelerSql)) {
                    for (ApplicationTraveler traveler : travelers) {
                        stm.setInt(1, applicationId);
                        stm.setLong(2, traveler.getCccd_id());
                        stm.setString(3, traveler.getName());
                        stm.setString(4, traveler.getGender());
                        stm.setDate(5, new java.sql.Date(traveler.getDob().getTime()));
                        stm.setString(6, traveler.getPhone());
                        stm.setString(7, traveler.getEmail());
                        stm.addBatch();
                    }
                    int[] batchResults = stm.executeBatch();
                    System.out.println("✅ Step 2: " + batchResults.length + " travelers inserted");
                }
            }

            // ===== STEP 3: INSERT CONTRACT =====
            contract.setApplication_id(applicationId);
            try (PreparedStatement ps = connection.prepareStatement(insertContractSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, contract.getCurrent_benefit_id());
                ps.setInt(2, contract.getApplication_id());
                ps.setString(3, contract.getDescription());
                ps.setString(4, contract.getContract_status());

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Insert contract failed, no rows affected.");
                }

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        contractId = generatedKeys.getInt(1);
                        contract.setContract_id(contractId);
                        System.out.println("✅ Step 3: Contract created with ID: " + contractId);
                    } else {
                        throw new SQLException("Insert contract failed, no ID obtained.");
                    }
                }
            }

            // ===== STEP 4: INSERT INVOICE =====
            invoice.setContract_id(contractId);
            try (PreparedStatement stm = connection.prepareStatement(insertInvoiceSql, Statement.RETURN_GENERATED_KEYS)) {
                stm.setInt(1, invoice.getContract_id());
                stm.setBigDecimal(2, invoice.getBase_amount());
                stm.setBigDecimal(3, invoice.getTax_rate());
                stm.setString(4, invoice.getPayment_method());
                stm.setString(5, invoice.getPayment_code());
                stm.setString(6, invoice.getNotes());
                stm.setTimestamp(7, invoice.getCreated_at());

                int affectedRows = stm.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Insert invoice failed, no rows affected.");
                }

                try (ResultSet rs = stm.getGeneratedKeys()) {
                    if (rs.next()) {
                        invoiceId = rs.getInt(1);
                        System.out.println("✅ Step 4: Invoice inserted with ID: " + invoiceId);
                    } else {
                        throw new SQLException("Insert invoice failed, no ID obtained.");
                    }
                }
            }

            // ===== COMMIT TRANSACTION =====
            connection.commit();
            System.out.println("✅ Transaction committed successfully!");
            System.out.println("   Application ID: " + applicationId);
            System.out.println("   Contract ID: " + contractId);
            System.out.println("   Invoice ID: " + invoiceId);

            return invoiceId;

        } catch (SQLException e) {
            System.err.println("❌ Error in transaction: " + e.getMessage());
            System.err.println("   SQLState: " + e.getSQLState());
            e.printStackTrace();

            // ROLLBACK khi có lỗi
            try {
                connection.rollback();
                System.out.println("⚠️ Transaction rolled back!");
            } catch (SQLException ex) {
                System.err.println("❌ Error during rollback: " + ex.getMessage());
                ex.printStackTrace();
            }

            throw new Exception("Transaction failed: " + e.getMessage(), e);

        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("❌ Error resetting autoCommit: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    /**
     * Insert invoice riêng lẻ (nếu cần)
     */
    public int insertInvoice(Invoice invoice) {
        String sql = "INSERT INTO invoices (contract_id, base_amount, tax_rate, payment_method, payment_code, notes, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stm.setInt(1, invoice.getContract_id());
            stm.setBigDecimal(2, invoice.getBase_amount());
            stm.setBigDecimal(3, invoice.getTax_rate());
            stm.setString(4, invoice.getPayment_method());
            stm.setString(5, invoice.getPayment_code());
            stm.setString(6, invoice.getNotes());
            stm.setTimestamp(7, invoice.getCreated_at());

            int rowsAffected = stm.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = stm.getGeneratedKeys()) {
                    if (rs.next()) {
                        int generatedId = rs.getInt(1);
                        System.out.println("✅ Invoice inserted with ID: " + generatedId);
                        return generatedId;
                    }
                }
            }
            return -1;
        } catch (Exception e) {
            System.out.println("❌ Error inserting invoice: " + e.getMessage());
            return -1;
        }
    }

    /**
     * Create contract riêng lẻ (nếu cần)
     */
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
                        contract.setContract_id(contractId);
                        System.out.println("✅ Contract created with ID: " + contractId);
                        return contractId;
                    }
                }
            }
            return -1;
        } catch (SQLException e) {
            System.err.println("❌ Error creating contract: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Lấy invoice theo contract_id
     */
    public Invoice getInvoiceByContractId(int contractId) {
        String sql = "SELECT * FROM invoices WHERE contract_id = ? LIMIT 1";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, contractId);
            ResultSet rs = stm.executeQuery();
            
            if (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
                invoice.setContract_id(rs.getInt("contract_id"));
                invoice.setBase_amount(rs.getBigDecimal("base_amount"));
                invoice.setTax_rate(rs.getBigDecimal("tax_rate"));
                invoice.setPayment_method(rs.getString("payment_method"));
                invoice.setPayment_code(rs.getString("payment_code"));
                invoice.setNotes(rs.getString("notes"));
                invoice.setCreated_at(rs.getTimestamp("created_at"));
                return invoice;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}