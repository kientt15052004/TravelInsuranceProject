package Controller;

import dal.ProductDBController;
import Model.Product;
import Model.InsuranceBenefit1;
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
        ProductDBController productDB = new ProductDBController();

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
            InsuranceBenefit1 benefit = createInsuranceBenefit(request);
            int benefitId = productDB.createBenefit(benefit);

            if (benefitId == -1) {
                throw new Exception("Không thể tạo quyền lợi bảo hiểm");
            }

            // Tạo Product
            Product product = createProduct(request, benefitId, relativePath);
            boolean success = productDB.createProduct(product);

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
        Part filePart = request.getPart("img");
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        // Tạo tên file an toàn
        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String safeFileName = System.currentTimeMillis() + "_"
                + UUID.randomUUID().toString() + "_"
                + originalFileName.replaceAll("[^a-zA-Z0-9.-]", "_");

        String uploadPath = getServletContext().getRealPath("") + File.separator + "Image" + File.separator + "upload_imgs";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String filePath = uploadPath + File.separator + safeFileName;
        filePart.write(filePath);

        return "Image/upload_imgs/" + safeFileName;
    }

    private InsuranceBenefit1 createInsuranceBenefit(HttpServletRequest request) {
        InsuranceBenefit1 benefit = new InsuranceBenefit1();

        // Set các giá trị với default 0 nếu null
        benefit.setDeathOrPermanentDisability(parseBigDecimal(request.getParameter("deathOrDisability")));
        benefit.setDeathDueToIllness(parseBigDecimal(request.getParameter("deathByIllness")));
        benefit.setThirdPartyLiability(parseBigDecimal(request.getParameter("thirdPartyLiability")));
        benefit.setLostBankCard(parseBigDecimal(request.getParameter("lostBankCard")));
        benefit.setKidnapAndHostage(parseBigDecimal(request.getParameter("kidnapHostage")));
        benefit.setLostOrDamagedGolfEquipment(parseBigDecimal(request.getParameter("golfEquipLoss")));
        // Các benefits quốc tế
        benefit.setMedicalCost(parseBigDecimal(request.getParameter("medical_cost")));
        benefit.setEmergencyTransport(parseBigDecimal(request.getParameter("emergency_transport")));
        benefit.setRepatriationVn(parseBigDecimal(request.getParameter("repatriation_vn")));
        benefit.setRepatriationAbroad(parseBigDecimal(request.getParameter("repatriation_abroad")));
        benefit.setHospitalVisit(parseBigDecimal(request.getParameter("hospital_visit")));
        benefit.setFuneralArrangement(parseBigDecimal(request.getParameter("funeral_arrangement")));
        benefit.setChildCare(parseBigDecimal(request.getParameter("child_care")));
        benefit.setHospitalAllowance(parseBigDecimal(request.getParameter("hospital_allowance")));
        benefit.setAccidentDeathInjury(parseBigDecimal(request.getParameter("accident_death_injury")));
        benefit.setTripCancellation(parseBigDecimal(request.getParameter("trip_cancellation")));
        benefit.setCompanionSupport(parseBigDecimal(request.getParameter("companion_support")));
        benefit.setDelayedBaggage(parseBigDecimal(request.getParameter("delayed_baggage")));
        benefit.setTravelDocuments(parseBigDecimal(request.getParameter("travel_documents")));
        benefit.setTripDelay(parseBigDecimal(request.getParameter("trip_delay")));

        return benefit;
    }

    private Product createProduct(HttpServletRequest request, int benefitId, String imgPath) {
        Product product = new Product();
        product.setBenefitId(benefitId);
        product.setType(request.getParameter("choose"));
        product.setName(request.getParameter("name"));
        product.setImg(imgPath);
        product.setDescription(request.getParameter("description"));
        product.setPackageType(request.getParameter("package_type"));
        product.setPrice(parseBigDecimal(request.getParameter("price")));
        product.setDomesticPercentageRate(parseBigDecimal(request.getParameter("domestic_percentage_rate")));
        product.setInternationalRate1_7(parseBigDecimal(request.getParameter("international_rate_1_7")));
        product.setInternationalRate8_30(parseBigDecimal(request.getParameter("international_rate_8_30")));
        product.setInternationalRate31_90(parseBigDecimal(request.getParameter("international_rate_31_90")));
        product.setInternationalRate91_180(parseBigDecimal(request.getParameter("international_rate_91_180")));
        product.setActive(false); // Mặc định non active khi tạo mới
        product.setDeleted(false);

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

    private void setSuccessAttributes(HttpServletRequest request, Product product, String imgPath) {
        request.getSession().setAttribute("notification", "Thêm sản phẩm bảo hiểm thành công!");
        request.getSession().setAttribute("img_src", imgPath);
        request.getSession().setAttribute("name", product.getName());
        request.getSession().setAttribute("type", product.getType());
        request.getSession().setAttribute("package_type", product.getPackageType());
        request.getSession().setAttribute("description", product.getDescription());
        request.getSession().setAttribute("price", product.getPrice() != null ? product.getPrice().toString() : "0");
    }
}
