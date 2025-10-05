/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

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
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Application;
import model.ApplicationTraveler;
import model.viewmodel.BuyerInfo;
import model.InsuranceBenefit;
import model.InsuranceProduct;
import model.viewmodel.InsurancePurchase;
import model.viewmodel.Traveler;
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
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        request.setCharacterEncoding("UTF-8");
//        response.setCharacterEncoding("UTF-8");
//
//        try {
//            String insuranceIdStr = request.getParameter("insuranceId");
//            String type = request.getParameter("type");
//            String destination = request.getParameter("destination"); // thêm nếu có
//            String startDateStr = request.getParameter("startDate");
//            String endDateStr = request.getParameter("endDate");
//            String totalPriceStr = request.getParameter("totalPrice");
//            String travelerQuantityStr = request.getParameter("travelerQuantity");
//
//            // Parse dữ liệu
//            int insuranceId = 0;
//            int travelerQuantity = 0;
//            BigDecimal totalPrice = BigDecimal.ZERO;
//            Date startDate = null;
//            Date endDate = null;
//
//// Tạo object Application
//            Application app = new Application();
//            app.setPurchaser_id(1); // lấy từ session
//            app.setInsuranceId(insuranceId);
//            app.setType("Car");
//            app.setDestination("Ha long");
//            app.setStartDate(startDate);
//            app.setEndDate(endDate);
//            app.setTraveler_quantity(4);
//            app.setPrice(totalPrice);
//
//            // Lấy thông tin người mua bảo hiểm
//            String buyerType = request.getParameter("buyerType");
//            BuyerInfo buyerInfo = new BuyerInfo();
//            buyerInfo.setType(buyerType);
//
//            if ("individual".equals(buyerType)) {
//                buyerInfo.setIdNumber(request.getParameter("buyerIdNumber"));
//                buyerInfo.setFullName(request.getParameter("buyerFullName"));
//                buyerInfo.setGender(request.getParameter("buyerGender"));
//                buyerInfo.setBirthDate(request.getParameter("buyerBirthDate"));
//                buyerInfo.setPhoneNumber(request.getParameter("buyerPhoneNumber"));
//                buyerInfo.setEmail(request.getParameter("buyerEmail"));
//                buyerInfo.setAddress(request.getParameter("buyerAddress"));
//            } else {
//                buyerInfo.setTaxCode(request.getParameter("buyerTaxCode"));
//                buyerInfo.setOrgName(request.getParameter("buyerOrgName"));
//                buyerInfo.setRepresentative(request.getParameter("buyerRepresentative"));
//                buyerInfo.setPhoneNumber(request.getParameter("buyerPhoneNumber"));
//                buyerInfo.setEmail(request.getParameter("buyerEmail"));
//                buyerInfo.setAddress(request.getParameter("buyerAddress"));
//            }
//
//            // Lấy danh sách người được bảo hiểm
//            int travelersCount = Integer.parseInt(request.getParameter("travelersCount"));
//            List<ApplicationTraveler> travelers = new ArrayList<>();
//
//            for (int i = 0; i < travelersCount; i++) {
//                ApplicationTraveler traveler = new ApplicationTraveler();
//
//                // cccd có thể là số => parse sang long
//                String cccdParam = request.getParameter("traveler[" + i + "].cccd");
//                if (cccdParam != null && !cccdParam.isEmpty()) {
//                    traveler.setCccd(Long.parseLong(cccdParam));
//                }
//
//                traveler.setName(request.getParameter("traveler[" + i + "].name"));
//                traveler.setGender(request.getParameter("traveler[" + i + "].gender"));
//
//                // birthDate là Date => parse từ String
//                String birthDateParam = request.getParameter("traveler[" + i + "].birthDate");
//                if (birthDateParam != null && !birthDateParam.isEmpty()) {
//                    java.sql.Date birthDate = java.sql.Date.valueOf(birthDateParam); // format yyyy-MM-dd
//                    traveler.setBirthDate(birthDate);
//                }
//
//                traveler.setPhoneNumber(request.getParameter("traveler[" + i + "].phoneNumber"));
//                traveler.setEmail(request.getParameter("traveler[" + i + "].email"));
//
//                travelers.add(traveler);
//            }
//
//            //Insert data
//            ApplicationDBContext adb = new ApplicationDBContext();
//            TravelerDBContext tdb = new TravelerDBContext();
//            tdb.insert(travelers.get(0));
//            adb.insertApplicationWithTravelers(app, travelers);
//
//            request.setAttribute("purchase", app);
//            request.getRequestDispatcher("success.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect("error.jsp?message=" + e.getMessage());
//        }
//    }
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
            app.setPurchaser_id(1); // TODO: lấy từ session user
            app.setInsuranceId(insuranceId);
            app.setType(type);
            app.setDestination(destination);
            app.setStartDate(startDate);
            app.setEndDate(endDate);
            app.setTraveler_quantity(travelerQuantity);
            app.setPrice(totalPrice);

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
            for (int i = 0; i < travelerQuantity; i++) {
                ApplicationTraveler traveler = new ApplicationTraveler();

                String cccdParam = request.getParameter("traveler[" + i + "].idNumber");
                if (cccdParam != null && !cccdParam.isEmpty()) {
                    traveler.setCccd(Long.parseLong(cccdParam));
                }

                traveler.setName(request.getParameter("traveler[" + i + "].fullName"));
                traveler.setGender(request.getParameter("traveler[" + i + "].gender"));

                String birthDateParam = request.getParameter("traveler[" + i + "].birthDate");
                if (birthDateParam != null && !birthDateParam.isEmpty()) {
                    traveler.setBirthDate(java.sql.Date.valueOf(birthDateParam));
                }

                traveler.setPhoneNumber(request.getParameter("traveler[" + i + "].phoneNumber"));
                traveler.setEmail(request.getParameter("traveler[" + i + "].email"));

                travelers.add(traveler);
            }

            // ===== INSERT DB =====
            ApplicationDBContext adb = new ApplicationDBContext();
            int appId = adb.insertApplicationWithTravelers(app, travelers); // đã insert cả app và travelers
            app.setId(appId);

            // ===== TRẢ VỀ =====
            request.setAttribute("purchase", app);
            request.setAttribute("buyer", buyerInfo);
            request.setAttribute("travelers", travelers);
            request.getRequestDispatcher("success.jsp").forward(request, response);

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
