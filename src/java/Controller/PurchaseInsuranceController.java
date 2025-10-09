/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import Model.InsuranceBenefit;
import Model.InsuranceProduct;
import Model.InsurancePurchase;
import Model.Traveler;
import Model.User;
import utils.Validation;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "PurchaseInsuranceController", urlPatterns = {"/PurchaseInsurance"})
public class PurchaseInsuranceController extends HttpServlet {

    private InsuranceDBContext insuranceDB;
    private InsuranceBenefitDBContext insuranceBenefitDB;

    @Override
    public void init() throws ServletException {
        insuranceDB = new InsuranceDBContext();
        insuranceBenefitDB = new InsuranceBenefitDBContext();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

//        HttpSession session = request.getSession();
//        User user = (User) session.getAttribute("user");
//        
//        if(user == null){
//            response.sendRedirect("./TestLoginServlet");
//            return;
//        }

        String idRaw = request.getParameter("id");
        Integer id = Validation.validInt(idRaw);

        ArrayList<InsuranceProduct> insurances = new ArrayList<>();
        ArrayList<InsuranceBenefit> benefits = new ArrayList<>();
        InsuranceProduct insurance = new InsuranceProduct();

        insurances = insuranceDB.getAllWithBenefit();
        benefits = insuranceBenefitDB.getAll();

        if (id != null) {
            insurance = insuranceDB.getByIdWithBenefit(id);
        }

        request.setAttribute("insurances", insurances);
        request.setAttribute("benefits", benefits);
        request.setAttribute("insurance", insurance);

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

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            // ===== VALIDATE VÀ PARSE =====
            int insuranceId = (insuranceIdStr != null && !insuranceIdStr.isEmpty())
                    ? Integer.parseInt(insuranceIdStr) : 0;

            int travelerQuantity = (travelerQuantityStr != null && !travelerQuantityStr.isEmpty())
                    ? Integer.parseInt(travelerQuantityStr) : 0;

            BigDecimal totalPrice = (totalPriceStr != null && !totalPriceStr.isEmpty())
                    ? new BigDecimal(totalPriceStr) : BigDecimal.ZERO;

            Date startDate = (startDateStr != null && !startDateStr.isEmpty())
                    ? java.sql.Date.valueOf(startDateStr) : null;

            Date endDate = (endDateStr != null && !endDateStr.isEmpty())
                    ? java.sql.Date.valueOf(endDateStr) : null;

            // ===== TẠO OBJECT APPLICATION =====
            Application app = new Application();

            if (user != null) {
                app.setPurchaser_id(user.getId());
            }

            app.setProduct_id(insuranceId);
            app.setType(type);
            app.setDestination(destination);
            app.setStartDate(startDate);
            app.setEndDate(endDate);
            app.setTravelers_quantity(travelerQuantity);
            app.setTotal_price(totalPrice);

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

// Tập hợp để check trùng lặp
            Set<Long> cccdSet = new HashSet<>();
            Set<String> emailSet = new HashSet<>();
            Set<String> phoneSet = new HashSet<>();

            for (int i = 0; i < travelerQuantity; i++) {
                ApplicationTraveler traveler = new ApplicationTraveler();

                // CCCD
                String cccdParam = request.getParameter("traveler[" + i + "].idNumber");
                if (cccdParam != null && !cccdParam.isEmpty()) {
                    Long cccd = Long.parseLong(cccdParam);
                    if (!cccdSet.add(cccd)) {
                        // Nếu add fail -> đã tồn tại
                        response.sendRedirect("InsuranceList?error=" + URLEncoder.encode("Duplicate CCCD found: " + cccd, "UTF-8"));
                        return; // Dừng hẳn
                    }
                    traveler.setCccd_id(cccd);
                }

                // Name + gender
                traveler.setName(request.getParameter("traveler[" + i + "].fullName"));
                traveler.setGender(request.getParameter("traveler[" + i + "].gender"));

                // Birthdate
                String birthDateParam = request.getParameter("traveler[" + i + "].birthDate");
                if (birthDateParam != null && !birthDateParam.isEmpty()) {
                    traveler.setDob(java.sql.Date.valueOf(birthDateParam));
                }

                // Phone
                String phone = request.getParameter("traveler[" + i + "].phoneNumber");
                if (phone != null && !phone.isEmpty()) {
                    if (!phoneSet.add(phone)) {
                        response.sendRedirect("InsuranceList?error=" + URLEncoder.encode("Duplicate phone number found: " + phone, "UTF-8"));
                        return;
                    }
                    traveler.setPhone(phone);
                }

                // Email
                String email = request.getParameter("traveler[" + i + "].email");
                if (email != null && !email.isEmpty()) {
                    if (!emailSet.add(email)) {
                        response.sendRedirect("InsuranceList?error=" + URLEncoder.encode("Duplicate email found: " + email, "UTF-8"));
                        return;
                    }
                    traveler.setEmail(email);
                }

                travelers.add(traveler);
            }

            // ===== INSERT DB =====
            ApplicationDBContext adb = new ApplicationDBContext();
            int appId = adb.insertApplicationWithTravelers(app, travelers); // đã insert cả app và travelers
            app.setId(appId);

            // REDIRECT (không dùng forward)
            response.sendRedirect("InsuranceList?success=true&id="+ appId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=" + e.getMessage());
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
