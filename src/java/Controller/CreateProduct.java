package Controller;

import dal.InsuranceDBContext;
import Model.InsuranceProduct;
import Model.InsuranceBenefit;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CreateProduct extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        InsuranceDBContext insuranceDAO = new InsuranceDBContext();

        try {
            // Lấy thông tin cơ bản
            String name = request.getParameter("name");
            String packageType = request.getParameter("package_type");
            String type = request.getParameter("choose");
            String description = request.getParameter("description");

            // Xử lý upload ảnh an toàn
            String relativePath = handleFileUpload(request);
            if (relativePath == null) {
                throw new Exception("Lỗi khi upload ảnh");
            }

            // Tạo InsuranceBenefit
            InsuranceBenefit benefit = createInsuranceBenefit(request);
            int benefitId = insuranceDAO.createBenefit(benefit);

            if (benefitId == -1) {
                throw new Exception("Không thể tạo quyền lợi bảo hiểm");
            }

            // Tạo InsuranceProduct
            InsuranceProduct product = createInsuranceProduct(request, benefitId, relativePath);
            boolean success = insuranceDAO.createProduct(product);

            setSuccessAttributes(request, product, relativePath);
//            response.sendRedirect(request.getContextPath() + "/navigate?page=create");
            request.setAttribute("page", "create_product.jsp");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi tạo sản phẩm: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/navigate?page=create");
        }
    }

private String handleFileUpload(HttpServletRequest request) throws IOException, ServletException {
    // 1. Thu thập File
    Part filePart = request.getPart("img");
    
    // 2. Kiểm tra File trống
    if (filePart == null || filePart.getSize() == 0) {
        return null;
    }

    // Lấy tên file gốc
    String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
    
    // Tạo tên file mới: Thêm thời gian hiện tại để tránh xung đột tên đơn giản
    String safeFileName = System.currentTimeMillis() + "_" + originalFileName;

    // 4. Xác định Đường dẫn Lưu trữ
    String uploadPath = getServletContext().getRealPath("") + File.separator + "Image" + File.separator + "upload_imgs";
    File uploadDir = new File(uploadPath);
    
    // 5. Tạo thư mục nếu chưa tồn tại
    if (!uploadDir.exists()) {
        uploadDir.mkdir();
    }

    // 6. Ghi File vật lý
    String filePath = uploadPath + File.separator + safeFileName;
    filePart.write(filePath);

    // 7. Trả về đường dẫn tương đối (để lưu DB và hiển thị)
    return "Image/upload_imgs/" + safeFileName;
}


    private InsuranceBenefit createInsuranceBenefit(HttpServletRequest request) {
        InsuranceBenefit benefit = new InsuranceBenefit();

        // Set các giá trị với default 0 nếu null
        benefit.setDeath_or_permanent_disability(parseBigDecimal(request.getParameter("deathOrDisability")));
        benefit.setDeath_due_to_illness(parseBigDecimal(request.getParameter("deathByIllness")));
        benefit.setThird_party_liability(parseBigDecimal(request.getParameter("thirdPartyLiability")));
        benefit.setLost_bank_card(parseBigDecimal(request.getParameter("lostBankCard")));
        benefit.setKidnap_and_hostage(parseBigDecimal(request.getParameter("kidnapHostage")));
        benefit.setLost_or_damaged_golf_equipment(parseBigDecimal(request.getParameter("golfEquipLoss")));
        // Các benefits quốc tế
        benefit.setMedical_cost(parseBigDecimal(request.getParameter("medical_cost")));
        benefit.setEmergency_transport(parseBigDecimal(request.getParameter("emergency_transport")));
        benefit.setRepatriation_vn(parseBigDecimal(request.getParameter("repatriation_vn")));
        benefit.setRepatriation_abroad(parseBigDecimal(request.getParameter("repatriation_abroad")));
        benefit.setHospital_visit(parseBigDecimal(request.getParameter("hospital_visit")));
        benefit.setFuneral_arrangement(parseBigDecimal(request.getParameter("funeral_arrangement")));
        benefit.setChild_care(parseBigDecimal(request.getParameter("child_care")));
        benefit.setHospital_allowance(parseBigDecimal(request.getParameter("hospital_allowance")));
        benefit.setAccident_death_injury(parseBigDecimal(request.getParameter("accident_death_injury")));
        benefit.setTrip_cancellation(parseBigDecimal(request.getParameter("trip_cancellation")));
        benefit.setCompanion_support(parseBigDecimal(request.getParameter("companion_support")));
        benefit.setDelayed_baggage(parseBigDecimal(request.getParameter("delayed_baggage")));
        benefit.setTravel_documents(parseBigDecimal(request.getParameter("travel_documents")));
        benefit.setTrip_delay(parseBigDecimal(request.getParameter("trip_delay")));

        return benefit;
    }

    private InsuranceProduct createInsuranceProduct(HttpServletRequest request, int benefitId, String imgPath) {
        InsuranceProduct product = new InsuranceProduct();
        product.setBenefit_id(benefitId);
        product.setType(request.getParameter("choose"));
        product.setName(request.getParameter("name"));
        product.setImg(imgPath);
        product.setDescription(request.getParameter("description"));
        product.setPackage_type(request.getParameter("package_type"));
        product.setPrice(parseBigDecimal(request.getParameter("price")));
        product.setDomestic_percentage_rate(parseBigDecimal(request.getParameter("domestic_percentage_rate")).multiply(new BigDecimal("100")));
        product.setInternational_rate_1_7(parseBigDecimal(request.getParameter("international_rate_1_7")));
        product.setInternational_rate_8_30(parseBigDecimal(request.getParameter("international_rate_8_30")));
        product.setInternational_rate_31_90(parseBigDecimal(request.getParameter("international_rate_31_90")));
        product.setInternational_rate_91_365(parseBigDecimal(request.getParameter("international_rate_91_180")));
        product.setIs_active(false); // Mặc định non active khi tạo mới
        product.setIs_delete(false);

        return product;
    }

    //Hàm chuyển những input rỗng về 0
    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(value);
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    private void setSuccessAttributes(HttpServletRequest request, InsuranceProduct product, String imgPath) {
        request.getSession().setAttribute("notification", "Thêm sản phẩm bảo hiểm thành công!");
        request.getSession().setAttribute("img_src", imgPath);
        request.getSession().setAttribute("name", product.getName());
        request.getSession().setAttribute("type", product.getType());
        request.getSession().setAttribute("package_type", product.getPackage_type());
        request.getSession().setAttribute("description", product.getDescription());
        request.getSession().setAttribute("price", product.getPrice() != null ? product.getPrice().toString() : "0");
    }
}
