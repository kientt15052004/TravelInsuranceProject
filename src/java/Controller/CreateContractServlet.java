package Controller;

import dal.InsuranceDBContext;
import dal.ApplicationDBContext;
import dal.ContractDBContext;
import Model.InsuranceProduct;
import Model.Application;
import Model.Contract;
import Model.ApplicationTraveler;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CreateContractServlet", urlPatterns = {"/CreateContractServlet"})
public class CreateContractServlet extends HttpServlet {
    
    private InsuranceDBContext insuranceDAO;
    private ApplicationDBContext applicationDAO;
    private ContractDBContext contractDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        insuranceDAO = new InsuranceDBContext();
        applicationDAO = new ApplicationDBContext();
        contractDAO = new ContractDBContext();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load insurance products for dropdown
            List<InsuranceProduct> products = insuranceDAO.getAll();
            request.setAttribute("products", products);
            
            // Forward to JSP page
            request.getRequestDispatcher("/CreateContract.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang: " + e.getMessage());
            request.getRequestDispatcher("/CreateContract.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        try {
            // Get form parameters
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String cccd = request.getParameter("cccd");
            String address = request.getParameter("address");
            String dobStr = request.getParameter("dob");
            String productIdStr = request.getParameter("productId");
            String destination = request.getParameter("destination");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String travelersQuantityStr = request.getParameter("travelersQuantity");
            String contractDescription = request.getParameter("contractDescription");
            
            
            // Validate required fields
            if (fullname == null || fullname.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                cccd == null || cccd.trim().isEmpty() ||
                productIdStr == null || productIdStr.trim().isEmpty() ||
                startDateStr == null || startDateStr.trim().isEmpty() ||
                endDateStr == null || endDateStr.trim().isEmpty() ||
                travelersQuantityStr == null || travelersQuantityStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
                doGet(request, response);
                return;
            }
            
            // Parse parameters
            int productId = Integer.parseInt(productIdStr);
            Date dob = dobStr != null && !dobStr.trim().isEmpty() ? Date.valueOf(dobStr) : Date.valueOf("1990-01-01");
            Date startDate = Date.valueOf(startDateStr);
            Date endDate = Date.valueOf(endDateStr);
            int travelersQuantity = Integer.parseInt(travelersQuantityStr);
            
            
            // Get insurance product to calculate price
            InsuranceProduct product = insuranceDAO.getById(productId);
            if (product == null) {
                request.setAttribute("error", "Không tìm thấy sản phẩm bảo hiểm");
                doGet(request, response);
                return;
            }
            
            // Calculate total price (simplified - you may need to implement proper pricing logic)
            BigDecimal totalPrice = calculatePrice(product, travelersQuantity, startDate, endDate);
            
            // Create application (using default user ID for manual contracts)
            Application application = new Application();
            application.setPurchaser_id(1); // Use a default user ID for manual contracts
            application.setProduct_id(productId);
            application.setType("manual"); // Mark as manual creation
            application.setDestination(destination);
            application.setStartDate(startDate);
            application.setEndDate(endDate);
            application.setTravelers_quantity(travelersQuantity);
            application.setTotal_price(totalPrice);
            
            // Create application traveler (customer information)
            ApplicationTraveler traveler = new ApplicationTraveler();
            traveler.setName(fullname);
            traveler.setGender("Male"); // Default gender
            traveler.setCccd_id(Long.parseLong(cccd)); // Convert CCCD to long
            traveler.setDob(dob);
            traveler.setPhone(phone);
            traveler.setEmail(email);
            
            List<ApplicationTraveler> travelers = new ArrayList<>();
            travelers.add(traveler);
            
            
            int applicationId = applicationDAO.insertApplicationWithTravelers(application, travelers);
            
            if (applicationId <= 0) {
                request.setAttribute("error", "Không thể tạo đơn đăng ký - có thể do lỗi database hoặc transaction");
                doGet(request, response);
                return;
            }
            
            
            // Create contract
            Contract contract = new Contract();
            contract.setCurrent_benefit_id(product.getBenefit_id());
            contract.setApplication_id(applicationId);
            contract.setDescription(contractDescription != null ? contractDescription : "Hợp đồng bảo hiểm du lịch");
            contract.setContract_status("active");
            
            
            contractDAO.insertContract(contract);
            
            // Success
            request.setAttribute("success", "Tạo hợp đồng bảo hiểm thành công!");
            request.setAttribute("contractId", contract.getContract_id());
            request.setAttribute("applicationId", applicationId);
            
            // Forward to success page or back to form
            request.getRequestDispatcher("/CreateContract.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * Calculate insurance price based on product, travelers, and duration
     * Now uses actual price from database instead of hardcoded value
     */
    private BigDecimal calculatePrice(InsuranceProduct product, int travelersQuantity, Date startDate, Date endDate) {
        // Calculate number of days
        long diffInMillies = endDate.getTime() - startDate.getTime();
        long diffInDays = diffInMillies / (24 * 60 * 60 * 1000);
        
        // Use actual price from database if available, otherwise fallback to default
        BigDecimal basePricePerDay = product.getPrice();
        if (basePricePerDay == null) {
            basePricePerDay = new BigDecimal("50000"); // Fallback to 50,000 VND per day
        }
        
        // Calculate total price
        BigDecimal totalPrice = basePricePerDay
                .multiply(new BigDecimal(diffInDays))
                .multiply(new BigDecimal(travelersQuantity));
        
        return totalPrice;
    }
    
}
