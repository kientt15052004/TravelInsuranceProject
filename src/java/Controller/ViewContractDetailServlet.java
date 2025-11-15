package Controller;

import Model.Contract;
import Model.Application;
import Model.ApplicationTraveler;
import Model.InsuranceProduct;
import Model.InsuranceBenefit;
import Model.Invoice;
import Model.User;
import dal.ContractDBContext;
import dal.ApplicationDBContext;
import dal.InsuranceDBContext;
import dal.InsuranceBenefitDBContext;
import dal.InvoiceDBContext;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet trả về JSON chi tiết hợp đồng để hiển thị trong modal
 */
@WebServlet(name = "ViewContractDetailServlet", urlPatterns = {"/view-contract-detail"})
public class ViewContractDetailServlet extends HttpServlet {

    private ContractDBContext contractDB;
    private ApplicationDBContext applicationDB;
    private InsuranceDBContext insuranceDB;
    private InsuranceBenefitDBContext benefitDB;
    private InvoiceDBContext invoiceDB;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        contractDB = new ContractDBContext();
        applicationDB = new ApplicationDBContext();
        insuranceDB = new InsuranceDBContext();
        benefitDB = new InsuranceBenefitDBContext();
        invoiceDB = new InvoiceDBContext();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        
        // Chỉ cho phép customer truy cập
        if (!"customer".equalsIgnoreCase(currentUser.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\":\"Forbidden\"}");
            return;
        }

        try {
            String contractIdStr = request.getParameter("contractId");
            if (contractIdStr == null || contractIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Contract ID is required\"}");
                return;
            }

            int contractId = Integer.parseInt(contractIdStr);

            // Kiểm tra contract có thuộc về customer không
            if (!contractDB.isContractOwnedByCustomer(contractId, currentUser.getId())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\":\"Contract does not belong to this customer\"}");
                return;
            }

            // Lấy contract
            Contract contract = contractDB.getContractById(contractId);
            if (contract == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Contract not found\"}");
                return;
            }

            // Lấy application
            Application application = applicationDB.getById(contract.getApplication_id());
            
            // Lấy product
            InsuranceProduct product = null;
            if (application != null) {
                product = insuranceDB.getByIdWithBenefit(application.getProduct_id());
            }

            // Lấy buyer info
            User buyer = null;
            if (application != null) {
                buyer = userDAO.getUserById(application.getPurchaser_id());
            }

            // Lấy travelers
            List<ApplicationTraveler> travelers = null;
            if (application != null) {
                travelers = applicationDB.getTravelersByApplicationId(application.getId());
            }

            // Lấy benefit
            InsuranceBenefit benefit = null;
            if (contract.getCurrent_benefit_id() > 0) {
                benefit = benefitDB.getById(contract.getCurrent_benefit_id());
            }

            // Lấy invoice
            Invoice invoice = invoiceDB.getInvoiceByContractId(contractId);

            // Tạo response JSON
            Map<String, Object> responseData = new HashMap<>();
            
            // Contract info
            Map<String, Object> contractInfo = new HashMap<>();
            contractInfo.put("contractId", contract.getContract_id());
            contractInfo.put("contractCode", "TG-" + contract.getContract_id());
            contractInfo.put("status", contract.getContract_status());
            contractInfo.put("description", contract.getDescription());
            responseData.put("contract", contractInfo);

            // Application info
            if (application != null) {
                Map<String, Object> appInfo = new HashMap<>();
                appInfo.put("id", application.getId());
                appInfo.put("destination", application.getDestination());
                appInfo.put("startDate", formatDate(application.getStartDate()));
                appInfo.put("endDate", formatDate(application.getEndDate()));
                appInfo.put("travelersQuantity", application.getTravelers_quantity());
                appInfo.put("totalPrice", application.getTotal_price());
                responseData.put("application", appInfo);
            }

            // Product info
            if (product != null) {
                Map<String, Object> productInfo = new HashMap<>();
                productInfo.put("id", product.getId());
                productInfo.put("name", product.getName());
                productInfo.put("type", product.getType());
                productInfo.put("packageType", product.getPackage_type());
                productInfo.put("description", product.getDescription());
                productInfo.put("price", product.getPrice());
                responseData.put("product", productInfo);
            }

            // Buyer info
            if (buyer != null) {
                Map<String, Object> buyerInfo = new HashMap<>();
                buyerInfo.put("id", buyer.getId());
                buyerInfo.put("fullname", buyer.getFullname());
                buyerInfo.put("phone", buyer.getPhone());
                buyerInfo.put("email", buyer.getMail());
                buyerInfo.put("address", buyer.getAddress());
                buyerInfo.put("cccd", buyer.getCccd());
                responseData.put("buyer", buyerInfo);
            }

            // Travelers
            if (travelers != null && !travelers.isEmpty()) {
                List<Map<String, Object>> travelersList = new java.util.ArrayList<>();
                for (ApplicationTraveler traveler : travelers) {
                    Map<String, Object> travelerInfo = new HashMap<>();
                    travelerInfo.put("name", traveler.getName());
                    travelerInfo.put("gender", traveler.getGender());
                    travelerInfo.put("cccdId", traveler.getCccd_id());
                    travelerInfo.put("dob", formatDate(traveler.getDob()));
                    travelerInfo.put("age", traveler.getAge());
                    travelerInfo.put("phone", traveler.getPhone());
                    travelerInfo.put("email", traveler.getEmail());
                    travelersList.add(travelerInfo);
                }
                responseData.put("travelers", travelersList);
            }

            // Benefit info
            if (benefit != null) {
                Map<String, Object> benefitInfo = new HashMap<>();
                benefitInfo.put("id", benefit.getId());
                benefitInfo.put("medicalCost", benefit.getMedical_cost());
                benefitInfo.put("emergencyTransport", benefit.getEmergency_transport());
                benefitInfo.put("repatriationVn", benefit.getRepatriation_vn());
                benefitInfo.put("repatriationAbroad", benefit.getRepatriation_abroad());
                benefitInfo.put("hospitalVisit", benefit.getHospital_visit());
                benefitInfo.put("funeralArrangement", benefit.getFuneral_arrangement());
                benefitInfo.put("childCare", benefit.getChild_care());
                benefitInfo.put("hospitalAllowance", benefit.getHospital_allowance());
                benefitInfo.put("accidentDeathInjury", benefit.getAccident_death_injury());
                benefitInfo.put("tripCancellation", benefit.getTrip_cancellation());
                benefitInfo.put("companionSupport", benefit.getCompanion_support());
                benefitInfo.put("delayedBaggage", benefit.getDelayed_baggage());
                benefitInfo.put("travelDocuments", benefit.getTravel_documents());
                benefitInfo.put("tripDelay", benefit.getTrip_delay());
                benefitInfo.put("deathOrPermanentDisability", benefit.getDeath_or_permanent_disability());
                benefitInfo.put("deathDueToIllness", benefit.getDeath_due_to_illness());
                benefitInfo.put("thirdPartyLiability", benefit.getThird_party_liability());
                benefitInfo.put("lostBankCard", benefit.getLost_bank_card());
                benefitInfo.put("kidnapAndHostage", benefit.getKidnap_and_hostage());
                benefitInfo.put("lostOrDamagedGolfEquipment", benefit.getLost_or_damaged_golf_equipment());
                responseData.put("benefit", benefitInfo);
            }

            // Invoice info
            if (invoice != null) {
                Map<String, Object> invoiceInfo = new HashMap<>();
                invoiceInfo.put("id", invoice.getId());
                invoiceInfo.put("baseAmount", invoice.getBase_amount());
                invoiceInfo.put("taxRate", invoice.getTax_rate());
                invoiceInfo.put("paymentMethod", invoice.getPayment_method());
                invoiceInfo.put("paymentCode", invoice.getPayment_code());
                invoiceInfo.put("notes", invoice.getNotes());
                invoiceInfo.put("createdAt", formatDateTime(invoice.getCreated_at()));
                responseData.put("invoice", invoiceInfo);
            }

            // Convert to JSON manually
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            PrintWriter out = response.getWriter();
            out.print(buildJsonString(responseData));
            out.flush();

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid contract ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private String formatDate(java.util.Date date) {
        if (date == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(date);
    }

    private String formatDateTime(java.sql.Timestamp timestamp) {
        if (timestamp == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        return sdf.format(timestamp);
    }

    private String buildJsonString(Map<String, Object> data) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        
        boolean first = true;
        for (Map.Entry<String, Object> entry : data.entrySet()) {
            if (!first) json.append(",");
            first = false;
            
            json.append("\"").append(entry.getKey()).append("\":");
            Object value = entry.getValue();
            
            if (value == null) {
                json.append("null");
            } else if (value instanceof String) {
                json.append("\"").append(escapeJson((String) value)).append("\"");
            } else if (value instanceof Number || value instanceof Boolean) {
                json.append(value);
            } else if (value instanceof Map) {
                json.append(buildJsonObject((Map<String, Object>) value));
            } else if (value instanceof List) {
                json.append(buildJsonArray((List<?>) value));
            } else {
                json.append("\"").append(escapeJson(value.toString())).append("\"");
            }
        }
        
        json.append("}");
        return json.toString();
    }

    private String buildJsonObject(Map<String, Object> map) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        
        boolean first = true;
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            if (!first) json.append(",");
            first = false;
            
            json.append("\"").append(entry.getKey()).append("\":");
            Object value = entry.getValue();
            
            if (value == null) {
                json.append("null");
            } else if (value instanceof String) {
                json.append("\"").append(escapeJson((String) value)).append("\"");
            } else if (value instanceof Number || value instanceof Boolean) {
                json.append(value);
            } else if (value instanceof Map) {
                json.append(buildJsonObject((Map<String, Object>) value));
            } else if (value instanceof List) {
                json.append(buildJsonArray((List<?>) value));
            } else {
                json.append("\"").append(escapeJson(value.toString())).append("\"");
            }
        }
        
        json.append("}");
        return json.toString();
    }

    private String buildJsonArray(List<?> list) {
        StringBuilder json = new StringBuilder();
        json.append("[");
        
        boolean first = true;
        for (Object item : list) {
            if (!first) json.append(",");
            first = false;
            
            if (item == null) {
                json.append("null");
            } else if (item instanceof String) {
                json.append("\"").append(escapeJson((String) item)).append("\"");
            } else if (item instanceof Number || item instanceof Boolean) {
                json.append(item);
            } else if (item instanceof Map) {
                json.append(buildJsonObject((Map<String, Object>) item));
            } else {
                json.append("\"").append(escapeJson(item.toString())).append("\"");
            }
        }
        
        json.append("]");
        return json.toString();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f");
    }
}

