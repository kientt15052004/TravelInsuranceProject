/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.ApplicationDBContext;
import dal.ContractDBContext;
import dal.InsuranceDBContext;
import dal.TravelerDBContext;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.Application;
import Model.ApplicationTraveler;
import Model.Contract;
import Model.InsuranceProduct;
import Model.User;
import Model.Traveler;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "CreateContractServlet", urlPatterns = {"/CreateContractServlet"})
public class CreateContractServlet extends HttpServlet {

    private InsuranceDBContext insuranceDB = new InsuranceDBContext();
    private ApplicationDBContext applicationDB = new ApplicationDBContext();
    private ContractDBContext contractDB = new ContractDBContext();
    private TravelerDBContext travelerDB = new TravelerDBContext();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load available insurance products for the form
            List<InsuranceProduct> insuranceProducts = insuranceDB.getAll();
            request.setAttribute("insuranceProducts", insuranceProducts);
            
            request.getRequestDispatcher("CreateContract.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang tạo hợp đồng: " + e.getMessage());
            request.getRequestDispatcher("CreateContract.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters - Buyer Information
            String buyerName = request.getParameter("buyerName");
            String buyerId = request.getParameter("buyerId");
            String buyerPhone = request.getParameter("buyerPhone");
            String buyerEmail = request.getParameter("buyerEmail");
            String buyerAddress = request.getParameter("buyerAddress");
            
            // Get form parameters - Customer Information
            String customerName = request.getParameter("customerName");
            String customerId = request.getParameter("customerId");
            String customerPhone = request.getParameter("customerPhone");
            String customerEmail = request.getParameter("customerEmail");
            String customerGender = request.getParameter("customerGender");
            String customerBirthDate = request.getParameter("customerBirthDate");
            
            // Get form parameters - Contract Information
            String insuranceProductId = request.getParameter("insuranceProductId");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String destination = request.getParameter("destination");
            String contractDescription = request.getParameter("contractDescription");

            // Validate required fields
            List<String> errors = validateForm(buyerName, buyerId, buyerPhone, buyerEmail, buyerAddress,
                    customerName, customerId, customerPhone, customerEmail, customerGender, customerBirthDate,
                    insuranceProductId, startDate, endDate, destination);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("formData", request.getParameterMap());
                doGet(request, response);
                return;
            }

            // Parse dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDateParsed = new Date(sdf.parse(startDate).getTime());
            Date endDateParsed = new Date(sdf.parse(endDate).getTime());
            Date customerBirthDateParsed = new Date(sdf.parse(customerBirthDate).getTime());

            // Get insurance product details
            InsuranceProduct selectedProduct = insuranceDB.getById(Integer.parseInt(insuranceProductId));
            if (selectedProduct == null) {
                request.setAttribute("error", "Sản phẩm bảo hiểm không tồn tại");
                doGet(request, response);
                return;
            }

            // Calculate total price based on insurance type and duration
            BigDecimal totalPrice = calculatePrice(selectedProduct, startDateParsed, endDateParsed);

            // Check if BUYER exists by CCCD, if not create new user
            User buyer = userDAO.getUserByCccd(buyerId);
            int purchaserId;
            
            if (buyer == null) {
                // Create new buyer user
                buyer = new User();
                buyer.setUsername(buyerPhone); // Use phone as username
                buyer.setPassword("123456789a"); // Default password
                buyer.setFullname(buyerName);
                buyer.setMail(buyerEmail);
                buyer.setDob(null); // Buyer doesn't need birth date
                buyer.setAddress(buyerAddress);
                buyer.setPhone(buyerPhone);
                buyer.setCccd(buyerId);
                buyer.setAvatar(null);
                buyer.setRole("buyer"); // Set role as buyer
                buyer.setCccd_img(null);
                buyer.setStatus("active");
                
                purchaserId = userDAO.insertUser(buyer);
                if (purchaserId == -1) {
                    request.setAttribute("error", "Không thể tạo tài khoản người mua");
                    doGet(request, response);
                    return;
                }
            } else {
                purchaserId = buyer.getId();
            }

            // Create Application
            Application application = new Application();
            application.setPurchaser_id(purchaserId); // Use actual purchaser ID
            application.setProduct_id(selectedProduct.getId());
            application.setType(selectedProduct.getType());
            application.setDestination(destination);
            application.setStartDate(startDateParsed);
            application.setEndDate(endDateParsed);
            application.setTravelers_quantity(1);
            application.setTotal_price(totalPrice);

            // Create ApplicationTraveler (Customer information)
            ApplicationTraveler traveler = new ApplicationTraveler();
            traveler.setCccd_id(Long.parseLong(customerId));
            traveler.setName(customerName);
            traveler.setGender(customerGender);
            traveler.setDob(customerBirthDateParsed);
            traveler.setPhone(customerPhone);
            traveler.setEmail(customerEmail);

            List<ApplicationTraveler> travelers = new ArrayList<>();
            travelers.add(traveler);

            // Insert application with travelers
            int applicationId = applicationDB.insertApplicationWithTravelers(application, travelers);
            if (applicationId == -1) {
                request.setAttribute("error", "Không thể tạo đơn đăng ký");
                doGet(request, response);
                return;
            }

            // Create Contract
            Contract contract = new Contract();
            contract.setCurrent_benefit_id(selectedProduct.getBenefit_id());
            contract.setApplication_id(applicationId);
            contract.setDescription(contractDescription != null ? contractDescription : 
                    "Hợp đồng bảo hiểm du lịch cho " + customerName);
            contract.setContract_status("ACTIVE");

            contractDB.insertContract(contract);

            // Set success attributes
            request.setAttribute("success", true);
            request.setAttribute("contractId", contract.getContract_id());
            request.setAttribute("customerName", customerName);
            request.setAttribute("insuranceProduct", selectedProduct);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("destination", destination);

            request.getRequestDispatcher("CreateContract.jsp").forward(request, response);

        } catch (ParseException e) {
            request.setAttribute("error", "Định dạng ngày không hợp lệ");
            doGet(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu số không hợp lệ");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tạo hợp đồng: " + e.getMessage());
            doGet(request, response);
        }
    }

    private List<String> validateForm(String buyerName, String buyerId, String buyerPhone, String buyerEmail, String buyerAddress,
            String customerName, String customerId, String customerPhone, String customerEmail, String customerGender, 
            String customerBirthDate, String insuranceProductId, String startDate, String endDate, String destination) {
        
        List<String> errors = new ArrayList<>();

        // Validate Buyer Information
        if (buyerName == null || buyerName.trim().isEmpty()) {
            errors.add("Tên người mua không được để trống");
        }

        if (buyerId == null || buyerId.trim().isEmpty()) {
            errors.add("Số CCCD/CMND người mua không được để trống");
        } else if (!isValidIdNumber(buyerId)) {
            errors.add("Số CCCD/CMND người mua không hợp lệ");
        }

        if (buyerPhone == null || buyerPhone.trim().isEmpty()) {
            errors.add("Số điện thoại người mua không được để trống");
        } else if (!isValidPhoneNumber(buyerPhone)) {
            errors.add("Số điện thoại người mua không hợp lệ");
        }

        if (buyerEmail == null || buyerEmail.trim().isEmpty()) {
            errors.add("Email người mua không được để trống");
        } else if (!isValidEmail(buyerEmail)) {
            errors.add("Email người mua không hợp lệ");
        }

        if (buyerAddress == null || buyerAddress.trim().isEmpty()) {
            errors.add("Địa chỉ người mua không được để trống");
        }

        // Validate Customer Information
        if (customerName == null || customerName.trim().isEmpty()) {
            errors.add("Tên khách hàng không được để trống");
        }

        if (customerId == null || customerId.trim().isEmpty()) {
            errors.add("Số CCCD/CMND khách hàng không được để trống");
        } else if (!isValidIdNumber(customerId)) {
            errors.add("Số CCCD/CMND khách hàng không hợp lệ");
        }

        if (customerPhone == null || customerPhone.trim().isEmpty()) {
            errors.add("Số điện thoại khách hàng không được để trống");
        } else if (!isValidPhoneNumber(customerPhone)) {
            errors.add("Số điện thoại khách hàng không hợp lệ");
        }

        if (customerEmail == null || customerEmail.trim().isEmpty()) {
            errors.add("Email khách hàng không được để trống");
        } else if (!isValidEmail(customerEmail)) {
            errors.add("Email khách hàng không hợp lệ");
        }

        if (customerGender == null || customerGender.trim().isEmpty()) {
            errors.add("Giới tính khách hàng không được để trống");
        }

        if (customerBirthDate == null || customerBirthDate.trim().isEmpty()) {
            errors.add("Ngày sinh không được để trống");
        }

        if (insuranceProductId == null || insuranceProductId.trim().isEmpty()) {
            errors.add("Vui lòng chọn gói bảo hiểm");
        }

        if (startDate == null || startDate.trim().isEmpty()) {
            errors.add("Ngày bắt đầu không được để trống");
        }

        if (endDate == null || endDate.trim().isEmpty()) {
            errors.add("Ngày kết thúc không được để trống");
        }

        if (destination == null || destination.trim().isEmpty()) {
            errors.add("Điểm đến không được để trống");
        }

        // Validate date range
        if (startDate != null && endDate != null && !startDate.trim().isEmpty() && !endDate.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date start = new Date(sdf.parse(startDate).getTime());
                Date end = new Date(sdf.parse(endDate).getTime());
                
                if (end.before(start)) {
                    errors.add("Ngày kết thúc phải sau ngày bắt đầu");
                }
                
                // Check if start date is not in the past
                Date today = new Date(System.currentTimeMillis());
                if (start.before(today)) {
                    errors.add("Ngày bắt đầu không được trong quá khứ");
                }
            } catch (ParseException e) {
                errors.add("Định dạng ngày không hợp lệ");
            }
        }

        return errors;
    }

    private BigDecimal calculatePrice(InsuranceProduct product, Date startDate, Date endDate) {
        // Calculate number of days
        long diffInMillies = endDate.getTime() - startDate.getTime();
        int days = (int) (diffInMillies / (1000 * 60 * 60 * 24)) + 1;

        BigDecimal basePrice = product.getPrice();
        
        // Apply rate based on product type and duration
        if ("domestic".equalsIgnoreCase(product.getType())) {
            // Domestic insurance - use percentage rate
            BigDecimal rate = product.getDomestic_percentage_rate();
            if (rate != null) {
                return basePrice.multiply(rate).multiply(new BigDecimal(days));
            }
        } else if ("international".equalsIgnoreCase(product.getType())) {
            // International insurance - use different rates based on duration
            BigDecimal rate;
            if (days <= 7) {
                rate = product.getInternational_rate_1_7();
            } else if (days <= 30) {
                rate = product.getInternational_rate_8_30();
            } else if (days <= 90) {
                rate = product.getInternational_rate_31_90();
            } else {
                rate = product.getInternational_rate_91_365();
            }
            
            if (rate != null) {
                return basePrice.multiply(rate).multiply(new BigDecimal(days));
            }
        }
        
        // Default calculation if no specific rate is found
        return basePrice.multiply(new BigDecimal(days));
    }
    
    // Validation helper methods
    private boolean isValidIdNumber(String idNumber) {
        if (idNumber == null || idNumber.trim().isEmpty()) {
            return false;
        }
        return idNumber.matches("^[0-9]{9,12}$");
    }
    
    private boolean isValidPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return false;
        }
        return phoneNumber.matches("^0[0-9]{9,10}$");
    }
    
    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    }
}
