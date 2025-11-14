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

/**
 * Servlet để generate và download PDF hợp đồng
 * Tạm thời trả về HTML để user có thể print, sau này có thể nâng cấp thành PDF thật
 */
@WebServlet(name = "ContractPdfServlet", urlPatterns = {"/contract-pdf"})
public class ContractPdfServlet extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        
        // Chỉ cho phép customer truy cập
        if (currentUser.getRole() == null || !"customer".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            String contractIdStr = request.getParameter("contractId");
            if (contractIdStr == null || contractIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Contract ID is required");
                return;
            }

            int contractId = Integer.parseInt(contractIdStr);

            // Kiểm tra contract có thuộc về customer không
            if (!contractDB.isContractOwnedByCustomer(contractId, currentUser.getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Contract does not belong to this customer");
                return;
            }

            // Lấy contract
            Contract contract = contractDB.getContractById(contractId);
            if (contract == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Contract not found");
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

            // Generate HTML để print (tạm thời, sau này có thể nâng cấp thành PDF)
            response.setContentType("text/html;charset=UTF-8");
            response.setHeader("Content-Disposition", "inline; filename=hop-dong-TG-" + contractId + ".html");
            
            PrintWriter out = response.getWriter();
            generateContractHtml(out, contract, application, product, buyer, travelers, benefit, invoice);
            out.flush();

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid contract ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating contract: " + e.getMessage());
        }
    }

    private void generateContractHtml(PrintWriter out, Contract contract, Application application,
            InsuranceProduct product, User buyer, List<ApplicationTraveler> travelers,
            InsuranceBenefit benefit, Invoice invoice) {
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Hợp Đồng Bảo Hiểm - TG-" + contract.getContract_id() + "</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }");
        out.println(".header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 20px; margin-bottom: 30px; }");
        out.println(".section { margin-bottom: 30px; }");
        out.println(".section-title { font-size: 18px; font-weight: bold; color: #333; margin-bottom: 15px; border-bottom: 1px solid #ddd; padding-bottom: 5px; }");
        out.println(".info-row { margin-bottom: 10px; }");
        out.println(".info-label { font-weight: bold; display: inline-block; width: 200px; }");
        out.println("table { width: 100%; border-collapse: collapse; margin-top: 10px; }");
        out.println("table th, table td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("table th { background-color: #f2f2f2; }");
        out.println(".footer { margin-top: 50px; text-align: center; font-size: 12px; color: #666; }");
        out.println("@media print { body { margin: 0; } .no-print { display: none; } }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        // Header
        out.println("<div class='header'>");
        out.println("<h1>HỢP ĐỒNG BẢO HIỂM DU LỊCH</h1>");
        out.println("<p>Mã hợp đồng: <strong>TG-" + contract.getContract_id() + "</strong></p>");
        out.println("</div>");
        
        // Thông tin hợp đồng
        out.println("<div class='section'>");
        out.println("<div class='section-title'>1. THÔNG TIN HỢP ĐỒNG</div>");
        out.println("<div class='info-row'><span class='info-label'>Mã hợp đồng:</span> TG-" + contract.getContract_id() + "</div>");
        out.println("<div class='info-row'><span class='info-label'>Trạng thái:</span> " + getStatusText(contract.getContract_status()) + "</div>");
        if (contract.getDescription() != null) {
            out.println("<div class='info-row'><span class='info-label'>Mô tả:</span> " + escapeHtml(contract.getDescription()) + "</div>");
        }
        out.println("</div>");
        
        // Thông tin sản phẩm
        if (product != null) {
            out.println("<div class='section'>");
            out.println("<div class='section-title'>2. THÔNG TIN SẢN PHẨM BẢO HIỂM</div>");
            out.println("<div class='info-row'><span class='info-label'>Tên gói:</span> " + escapeHtml(product.getName()) + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Loại:</span> " + (product.getType().equals("domestic") ? "Trong nước" : "Quốc tế") + "</div>");
            if (product.getPackage_type() != null) {
                out.println("<div class='info-row'><span class='info-label'>Gói:</span> " + escapeHtml(product.getPackage_type()) + "</div>");
            }
            if (product.getDescription() != null) {
                out.println("<div class='info-row'><span class='info-label'>Mô tả:</span> " + escapeHtml(product.getDescription()) + "</div>");
            }
            out.println("</div>");
        }
        
        // Thông tin chuyến đi
        if (application != null) {
            out.println("<div class='section'>");
            out.println("<div class='section-title'>3. THÔNG TIN CHUYẾN ĐI</div>");
            out.println("<div class='info-row'><span class='info-label'>Điểm đến:</span> " + (application.getDestination() != null ? escapeHtml(application.getDestination()) : "Chưa xác định") + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Ngày bắt đầu:</span> " + (application.getStartDate() != null ? dateFormat.format(application.getStartDate()) : "-") + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Ngày kết thúc:</span> " + (application.getEndDate() != null ? dateFormat.format(application.getEndDate()) : "-") + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Số người được bảo hiểm:</span> " + application.getTravelers_quantity() + " người</div>");
            out.println("<div class='info-row'><span class='info-label'>Tổng giá trị:</span> " + formatCurrency(application.getTotal_price()) + "</div>");
            out.println("</div>");
        }
        
        // Thông tin người mua
        if (buyer != null) {
            out.println("<div class='section'>");
            out.println("<div class='section-title'>4. THÔNG TIN NGƯỜI MUA</div>");
            out.println("<div class='info-row'><span class='info-label'>Họ và tên:</span> " + escapeHtml(buyer.getFullname()) + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Số điện thoại:</span> " + (buyer.getPhone() != null ? escapeHtml(buyer.getPhone()) : "-") + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Email:</span> " + (buyer.getMail() != null ? escapeHtml(buyer.getMail()) : "-") + "</div>");
            out.println("<div class='info-row'><span class='info-label'>CCCD/CMND:</span> " + (buyer.getCccd() != null ? escapeHtml(buyer.getCccd()) : "-") + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Địa chỉ:</span> " + (buyer.getAddress() != null ? escapeHtml(buyer.getAddress()) : "-") + "</div>");
            out.println("</div>");
        }
        
        // Danh sách người được bảo hiểm
        if (travelers != null && !travelers.isEmpty()) {
            out.println("<div class='section'>");
            out.println("<div class='section-title'>5. DANH SÁCH NGƯỜI ĐƯỢC BẢO HIỂM</div>");
            out.println("<table>");
            out.println("<thead><tr><th>STT</th><th>Họ và tên</th><th>Giới tính</th><th>CCCD/CMND</th><th>Ngày sinh</th><th>Tuổi</th><th>SĐT</th><th>Email</th></tr></thead>");
            out.println("<tbody>");
            for (int i = 0; i < travelers.size(); i++) {
                ApplicationTraveler t = travelers.get(i);
                out.println("<tr>");
                out.println("<td>" + (i + 1) + "</td>");
                out.println("<td>" + escapeHtml(t.getName()) + "</td>");
                out.println("<td>" + (t.getGender().equals("Male") ? "Nam" : "Nữ") + "</td>");
                out.println("<td>" + t.getCccd_id() + "</td>");
                out.println("<td>" + (t.getDob() != null ? dateFormat.format(t.getDob()) : "-") + "</td>");
                out.println("<td>" + t.getAge() + "</td>");
                out.println("<td>" + (t.getPhone() != null ? escapeHtml(t.getPhone()) : "-") + "</td>");
                out.println("<td>" + (t.getEmail() != null ? escapeHtml(t.getEmail()) : "-") + "</td>");
                out.println("</tr>");
            }
            out.println("</tbody>");
            out.println("</table>");
            out.println("</div>");
        }
        
        // Quyền lợi bảo hiểm
        if (benefit != null) {
            out.println("<div class='section'>");
            out.println("<div class='section-title'>6. QUYỀN LỢI BẢO HIỂM</div>");
            out.println("<table>");
            out.println("<thead><tr><th>Quyền lợi</th><th>Số tiền bảo hiểm</th></tr></thead>");
            out.println("<tbody>");
            
            if (benefit.getMedical_cost() != null) {
                out.println("<tr><td>Chi phí y tế</td><td>" + formatCurrency(benefit.getMedical_cost()) + "</td></tr>");
            }
            if (benefit.getEmergency_transport() != null) {
                out.println("<tr><td>Vận chuyển cấp cứu</td><td>" + formatCurrency(benefit.getEmergency_transport()) + "</td></tr>");
            }
            if (benefit.getRepatriation_vn() != null) {
                out.println("<tr><td>Hồi hương trong nước</td><td>" + formatCurrency(benefit.getRepatriation_vn()) + "</td></tr>");
            }
            if (benefit.getRepatriation_abroad() != null) {
                out.println("<tr><td>Hồi hương nước ngoài</td><td>" + formatCurrency(benefit.getRepatriation_abroad()) + "</td></tr>");
            }
            if (benefit.getAccident_death_injury() != null) {
                out.println("<tr><td>Tử vong/thương tật do tai nạn</td><td>" + formatCurrency(benefit.getAccident_death_injury()) + "</td></tr>");
            }
            if (benefit.getTrip_cancellation() != null) {
                out.println("<tr><td>Hủy chuyến đi</td><td>" + formatCurrency(benefit.getTrip_cancellation()) + "</td></tr>");
            }
            if (benefit.getDeath_or_permanent_disability() != null) {
                out.println("<tr><td>Tử vong/thương tật vĩnh viễn</td><td>" + formatCurrency(benefit.getDeath_or_permanent_disability()) + "</td></tr>");
            }
            
            out.println("</tbody>");
            out.println("</table>");
            out.println("</div>");
        }
        
        // Thông tin thanh toán
        if (invoice != null) {
            out.println("<div class='section'>");
            out.println("<div class='section-title'>7. THÔNG TIN THANH TOÁN</div>");
            out.println("<div class='info-row'><span class='info-label'>Số tiền cơ bản:</span> " + formatCurrency(invoice.getBase_amount()) + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Thuế suất:</span> " + (invoice.getTax_rate() != null ? (invoice.getTax_rate().multiply(java.math.BigDecimal.valueOf(100)).toString() + "%") : "-") + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Phương thức thanh toán:</span> " + getPaymentMethodText(invoice.getPayment_method()) + "</div>");
            out.println("<div class='info-row'><span class='info-label'>Mã thanh toán:</span> " + (invoice.getPayment_code() != null ? escapeHtml(invoice.getPayment_code()) : "-") + "</div>");
            if (invoice.getNotes() != null) {
                out.println("<div class='info-row'><span class='info-label'>Ghi chú:</span> " + escapeHtml(invoice.getNotes()) + "</div>");
            }
            out.println("</div>");
        }
        
        // Footer
        out.println("<div class='footer'>");
        out.println("<p>Hợp đồng này được tạo tự động bởi hệ thống InsureTravel</p>");
        out.println("<p>Ngày tạo: " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date()) + "</p>");
        out.println("</div>");
        
        // Print button
        out.println("<div class='no-print' style='text-align: center; margin-top: 20px;'>");
        out.println("<button onclick='window.print()' style='padding: 10px 20px; font-size: 16px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer;'>In / Lưu PDF</button>");
        out.println("</div>");
        
        out.println("</body>");
        out.println("</html>");
    }

    private String getStatusText(String status) {
        if (status == null) return "-";
        switch (status.toLowerCase()) {
            case "active": return "Đang hoạt động";
            case "pending": return "Chờ duyệt";
            case "cancelled": return "Đã hủy";
            default: return status;
        }
    }

    private String getPaymentMethodText(String method) {
        if (method == null) return "-";
        switch (method.toLowerCase()) {
            case "credit_card": return "Thẻ tín dụng";
            case "bank_transfer": return "Chuyển khoản";
            case "cash": return "Tiền mặt";
            default: return method;
        }
    }

    private String formatCurrency(java.math.BigDecimal amount) {
        if (amount == null) return "0 VNĐ";
        java.text.NumberFormat formatter = java.text.NumberFormat.getNumberInstance(new java.util.Locale("vi", "VN"));
        return formatter.format(amount) + " VNĐ";
    }

    private String escapeHtml(String str) {
        if (str == null) return "";
        return str.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#39;");
    }
}

