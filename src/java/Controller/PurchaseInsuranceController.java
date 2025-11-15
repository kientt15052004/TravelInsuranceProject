package Controller;

import dal.ApplicationDBContext;
import dal.InsuranceBenefitDBContext;
import dal.InsuranceDBContext;
import dal.TravelerDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import Model.Application;
import Model.ApplicationTraveler;
import Model.BuyerInfo;
import Model.Contract;
import Model.InsuranceBenefit;
import Model.InsuranceProduct;
import Model.InsurancePurchase;
import Model.Invoice;
import Model.Traveler;
import Model.User;
import dal.ContractDBContext;
import dal.InvoiceDBContext;
import utils.Validation;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "PurchaseInsuranceController", urlPatterns = {"/PurchaseInsurance"})
public class PurchaseInsuranceController extends HttpServlet {

    private InsuranceDBContext insuranceDB;
    private InsuranceBenefitDBContext insuranceBenefitDB;
    private ContractDBContext contractDB;

    @Override
    public void init() throws ServletException {
        insuranceDB = new InsuranceDBContext();
        insuranceBenefitDB = new InsuranceBenefitDBContext();
        contractDB = new ContractDBContext();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("./login");
            return;
        }

        String idRaw = request.getParameter("id");
        String typeParam = request.getParameter("type");
        Integer id = Validation.validInt(idRaw);

        ArrayList<InsuranceProduct> insurances = new ArrayList<>();
        ArrayList<InsuranceBenefit> benefits = new ArrayList<>();
        InsuranceProduct insurance = new InsuranceProduct();

        insurances = insuranceDB.getAllWithBenefit();
        benefits = insuranceBenefitDB.getAll();

        // Nếu có parameter type, lấy sản phẩm đầu tiên của type đó
        if (typeParam != null && !typeParam.trim().isEmpty() && (typeParam.equals("domestic") || typeParam.equals("international"))) {
            ArrayList<InsuranceProduct> packagesByType = insuranceDB.getProductsByTypeWithBenefit(typeParam);
            if (packagesByType != null && !packagesByType.isEmpty()) {
                insurance = packagesByType.get(0); // Lấy sản phẩm đầu tiên
            }
        } else if (id != null) {
            insurance = insuranceDB.getByIdWithBenefit(id);
        }

        if (insurance == null || insurance.getId() == 0 || !insurance.getIs_active()) {
            response.sendRedirect("./InsuranceList");
            return;
        }

        // Lấy tất cả các packages cùng type với insurance đã chọn
        ArrayList<InsuranceProduct> packages = new ArrayList<>();
        if (insurance.getType() != null && !insurance.getType().isEmpty()) {
            packages = insuranceDB.getProductsByTypeWithBenefit(insurance.getType());
        }

        request.setAttribute("insurances", insurances);
        request.setAttribute("benefits", benefits);
        request.setAttribute("insurance", insurance);
        request.setAttribute("packages", packages);

        request.getRequestDispatcher("InsurancePurchase.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // ===== LẤY PARAM =====
            String insuranceIdStr = request.getParameter("insuranceId");
            String type = request.getParameter("type");
            String destination = request.getParameter("destination");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String totalPriceStr = request.getParameter("totalPrice");
            String travelerQuantityStr = request.getParameter("travelersCount");
            String benefitIdStr = request.getParameter("benefit-id");

            // ===== LẤY PARAM THANH TOÁN =====
            String paymentMethod = request.getParameter("paymentMethod");
            String cardholderName = request.getParameter("cardholderName");
            String cardNumber = request.getParameter("cardNumber");
            String expiryDate = request.getParameter("expiryDate");

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login");
                return;
            }

            // ===== VALIDATE VÀ PARSE =====
            int insuranceId = (insuranceIdStr != null && !insuranceIdStr.isEmpty())
                    ? Integer.parseInt(insuranceIdStr) : 0;

            int benefitId = (benefitIdStr != null && !benefitIdStr.isEmpty())
                    ? Integer.parseInt(benefitIdStr) : 0;

            int travelerQuantity = (travelerQuantityStr != null && !travelerQuantityStr.isEmpty())
                    ? Integer.parseInt(travelerQuantityStr) : 0;

            BigDecimal totalPrice = (totalPriceStr != null && !totalPriceStr.isEmpty())
                    ? new BigDecimal(totalPriceStr) : BigDecimal.ZERO;

            Date startDate = (startDateStr != null && !startDateStr.isEmpty())
                    ? java.sql.Date.valueOf(startDateStr) : null;

            Date endDate = (endDateStr != null && !endDateStr.isEmpty())
                    ? java.sql.Date.valueOf(endDateStr) : null;

            // ===== VALIDATE THÔNG TIN THANH TOÁN =====
            if (paymentMethod == null || paymentMethod.isEmpty()) {
                response.sendRedirect("insurance-list?error=" + URLEncoder.encode("Payment method is required", "UTF-8"));
                return;
            }

            if ("bank_card".equalsIgnoreCase(paymentMethod)) {
                if (cardholderName == null || cardholderName.trim().isEmpty()) {
                    response.sendRedirect("insurance-list?error=" + URLEncoder.encode("Cardholder name is required", "UTF-8"));
                    return;
                }
                if (cardNumber == null || cardNumber.length() != 16) {
                    response.sendRedirect("insurance-list?error=" + URLEncoder.encode("Invalid card number", "UTF-8"));
                    return;
                }
                if (expiryDate == null || !expiryDate.matches("\\d{2}/\\d{2}")) {
                    response.sendRedirect("insurance-list?error=" + URLEncoder.encode("Invalid expiry date format", "UTF-8"));
                    return;
                }
            }

            // ===== TẠO OBJECT APPLICATION =====
            Application app = new Application();
            app.setPurchaser_id(user.getId());
            app.setProduct_id(insuranceId);
            app.setType(type);
            app.setDestination(destination);
            app.setStartDate(startDate);
            app.setEndDate(endDate);
            app.setTravelers_quantity(travelerQuantity);
            app.setTotal_price(totalPrice);
            app.setBenefit_id(benefitId);

            // ===== TẠO OBJECT BUYER =====
            String buyerType = request.getParameter("buyerType");
            BuyerInfo buyerInfo = new BuyerInfo();
            buyerInfo.setType(buyerType);

            if ("individual".equalsIgnoreCase(buyerType)) {
                buyerInfo.setIdNumber(request.getParameter("buyerIdNumber"));
                buyerInfo.setFullName(request.getParameter("buyerFullName"));
                buyerInfo.setGender(request.getParameter("buyerGender"));
                buyerInfo.setBirthDate(request.getParameter("buyerBirthDate"));
                buyerInfo.setPhoneNumber(request.getParameter("buyerPhoneNumber"));
                buyerInfo.setEmail(request.getParameter("buyerEmail"));
                buyerInfo.setAddress(request.getParameter("buyerAddress"));
            } else {
                buyerInfo.setTaxCode(request.getParameter("buyerTaxCode"));
                buyerInfo.setOrgName(request.getParameter("buyerOrgName"));
                buyerInfo.setRepresentative(request.getParameter("buyerRepresentative"));
                buyerInfo.setPhoneNumber(request.getParameter("buyerPhoneNumber"));
                buyerInfo.setEmail(request.getParameter("buyerEmail"));
                buyerInfo.setAddress(request.getParameter("buyerAddress"));
            }

            // ===== LẤY DANH SÁCH TRAVELERS =====
            List<ApplicationTraveler> travelers = new ArrayList<>();
            Set<Long> cccdSet = new HashSet<>();
            Set<String> emailSet = new HashSet<>();
            Set<String> phoneSet = new HashSet<>();

            for (int i = 0; i < travelerQuantity; i++) {
                ApplicationTraveler traveler = new ApplicationTraveler();

                String cccdParam = request.getParameter("traveler[" + i + "].idNumber");
                if (cccdParam != null && !cccdParam.isEmpty()) {
                    Long cccd = Long.parseLong(cccdParam);
                    if (!cccdSet.add(cccd)) {
                        response.sendRedirect("insurance-list?error=" + URLEncoder.encode("Duplicate CCCD: " + cccd, "UTF-8"));
                        return;
                    }
                    traveler.setCccd_id(cccd);
                }

                traveler.setName(request.getParameter("traveler[" + i + "].fullName"));
                traveler.setGender(request.getParameter("traveler[" + i + "].gender"));

                String birthDateParam = request.getParameter("traveler[" + i + "].birthDate");
                if (birthDateParam != null && !birthDateParam.isEmpty()) {
                    traveler.setDob(java.sql.Date.valueOf(birthDateParam));
                }

                String phone = request.getParameter("traveler[" + i + "].phoneNumber");
                if (phone != null && !phone.isEmpty()) {
                    if (!phoneSet.add(phone)) {
                        response.sendRedirect("insurance-list?error=" + URLEncoder.encode("Duplicate phone: " + phone, "UTF-8"));
                        return;
                    }
                    traveler.setPhone(phone);
                }

                String email = request.getParameter("traveler[" + i + "].email");
                if (email != null && !email.isEmpty()) {
                    if (!emailSet.add(email)) {
                        response.sendRedirect("insurance-list?error=" + URLEncoder.encode("Duplicate email: " + email, "UTF-8"));
                        return;
                    }
                    traveler.setEmail(email);
                }

                travelers.add(traveler);
            }

            // ===== TẠO CONTRACT =====
            Contract contract = new Contract();
            contract.setCurrent_benefit_id(benefitId);
            contract.setDescription("Insurance Contract for purchase");
            contract.setContract_status("active");
            contract.setProductName(type);
            contract.setProductType(type);
            contract.setStartDate(startDate);
            contract.setEndDate(endDate);

            if ("individual".equalsIgnoreCase(buyerType)) {
                contract.setBuyerName(buyerInfo.getFullName());
            } else {
                contract.setBuyerName(buyerInfo.getOrgName());
            }

            contract.setBuyerPhone(buyerInfo.getPhoneNumber());
            contract.setBuyerEmail(buyerInfo.getEmail());
            contract.setTotalPrice(totalPrice);

            // ===== TẠO INVOICE =====
            Invoice invoice = new Invoice();
            invoice.setBase_amount(totalPrice);
            invoice.setTax_rate(new BigDecimal("0.1")); // 10% VAT
            invoice.setPayment_method("bank_transfer");
            invoice.setPayment_code("PAY_" + System.currentTimeMillis() + "_" + insuranceId);

            String maskedCard = "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
            String notes = "Cardholder: " + cardholderName + " | Card: " + maskedCard + " | Expiry: " + expiryDate;
            invoice.setNotes(notes);
            invoice.setCreated_at(new java.sql.Timestamp(System.currentTimeMillis()));

            // ===== THỰC HIỆN TRANSACTION =====
            InvoiceDBContext pdb = new InvoiceDBContext();
            int result = -1;
            String errorMessage = null;

            try {
                result = pdb.processInsurancePurchaseTransaction(app, travelers, contract, invoice);
            } catch (Exception e) {
                errorMessage = e.getMessage();
                System.err.println("Transaction failed: " + errorMessage);
            }

            if (result > 0) {
                int contractId = contract.getContract_id();
                response.sendRedirect("insurance-list?success=true&contractId=" + contractId + "&paymentId=" + result);
            } else {
                String error = errorMessage != null ? errorMessage : "Payment processing failed";
                response.sendRedirect("insurance-list?error=" + URLEncoder.encode(error, "UTF-8"));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + URLEncoder.encode("Invalid input format: " + e.getMessage(), "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
