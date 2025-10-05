package controller;

import dal.ProductDBContext;
import dal.ApplicationDBContext;
import dal.ContractDBContext;
import dal.ApplicationTravelerDBContext;
import model.Product;
import model.Application;
import model.Contract;
import model.ApplicationTraveler;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CreateContractServlet", urlPatterns = {"/CreateContractServlet"})
public class CreateContractServlet extends HttpServlet {
    
    private ProductDBContext productDAO;
    private ApplicationDBContext applicationDAO;
    private ContractDBContext contractDAO;
    private ApplicationTravelerDBContext applicationTravelerDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDBContext();
        applicationDAO = new ApplicationDBContext();
        contractDAO = new ContractDBContext();
        applicationTravelerDAO = new ApplicationTravelerDBContext();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load products for dropdown
            List<Product> products = productDAO.getAllProducts();
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
                endDateStr == null || endDateStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
                doGet(request, response);
                return;
            }
            
            // Parse parameters
            int productId = Integer.parseInt(productIdStr);
            Date dob = dobStr != null && !dobStr.trim().isEmpty() ? Date.valueOf(dobStr) : null;
            Date startDate = Date.valueOf(startDateStr);
            Date endDate = Date.valueOf(endDateStr);
            int travelersQuantity = Integer.parseInt(travelersQuantityStr);
            
            // Get product to calculate price
            Product product = productDAO.getProductById(productId);
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
            
            int applicationId = applicationDAO.insert(application);
            System.out.println("Application creation result: " + applicationId); // Debug log
            if (applicationId == -1) {
                request.setAttribute("error", "Không thể tạo đơn đăng ký");
                doGet(request, response);
                return;
            }
            
            // Create application traveler (customer information)
            ApplicationTraveler traveler = new ApplicationTraveler();
            traveler.setApplication_id(applicationId);
            traveler.setName(fullname);
            traveler.setGender(""); // Can be added to form if needed
            traveler.setCccd_id(0); // For manual contracts, we don't store CCCD as integer
            traveler.setDob(dob);
            traveler.setAge(calculateAge(dob));
            traveler.setPhone(phone);
            traveler.setEmail(email);
            
            applicationTravelerDAO.insertTraveler(traveler);
            System.out.println("Traveler creation completed"); // Debug log
            
            // Create contract
            Contract contract = new Contract();
            contract.setCurrent_benefit_id(product.getBenefit_id());
            contract.setApplication_id(applicationId);
            contract.setDescription(contractDescription != null ? contractDescription : "Hợp đồng bảo hiểm du lịch");
            contract.setContract_status("active");
            
            contractDAO.insertContract(contract);
            System.out.println("Contract creation completed"); // Debug log
            
            // Success - redirect to success page or show success message
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
     * This is a simplified calculation - you may need to implement more complex logic
     */
    private BigDecimal calculatePrice(Product product, int travelersQuantity, Date startDate, Date endDate) {
        // Calculate number of days
        long diffInMillies = endDate.getTime() - startDate.getTime();
        long diffInDays = diffInMillies / (24 * 60 * 60 * 1000);
        
        // Base price per day per person (simplified)
        BigDecimal basePricePerDay = new BigDecimal("50000"); // 50,000 VND per day
        
        // Calculate total price
        BigDecimal totalPrice = basePricePerDay
                .multiply(new BigDecimal(diffInDays))
                .multiply(new BigDecimal(travelersQuantity));
        
        return totalPrice;
    }
    
    /**
     * Calculate age from date of birth
     * @param dob
     * @return age in years
     */
    private int calculateAge(Date dob) {
        if (dob == null) {
            return 0;
        }
        
        java.util.Date currentDate = new java.util.Date();
        long diffInMillies = currentDate.getTime() - dob.getTime();
        long diffInDays = diffInMillies / (24 * 60 * 60 * 1000);
        return (int) (diffInDays / 365.25); // Account for leap years
    }
}
