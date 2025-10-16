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
public class UpdateProduct extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDBController productDB = new ProductDBController();

        System.out.println("=== DEBUG: BẮT ĐẦU UPDATE PRODUCT ===");
        System.out.println("DEBUG: price parameter = " + request.getParameter("price"));

        try {
            // Lấy product_id và benefit_id từ form
            String productIdStr = request.getParameter("product_id");
            String benefitIdStr = request.getParameter("benefit_id");

            System.out.println("DEBUG: product_id = " + productIdStr);
            System.out.println("DEBUG: benefit_id = " + benefitIdStr);

            if (productIdStr == null || benefitIdStr == null || productIdStr.isEmpty() || benefitIdStr.isEmpty()) {
                throw new Exception("Thiếu thông tin product_id hoặc benefit_id");
            }

            int productId = Integer.parseInt(productIdStr);
            int benefitId = Integer.parseInt(benefitIdStr);

            // XỬ LÝ UPLOAD ẢNH
            String imgPath = handleFileUpload(request);

            // Nếu không có ảnh mới, giữ ảnh cũ
            if (imgPath == null) {
                // Lấy sản phẩm hiện tại để giữ ảnh cũ
                Product currentProduct = productDB.getProductById(productId);
                if (currentProduct != null) {
                    imgPath = currentProduct.getImg();
                }
            }

            // Kiểm tra xem benefit có thay đổi không
            InsuranceBenefit1 newBenefit = createInsuranceBenefit(request);
            InsuranceBenefit1 originalBenefit = createOriginalInsuranceBenefit(request);

            // DEBUG: IN RA MỘT SỐ TRƯỜNG ĐẠI DIỆN ĐỂ SO SÁNH
            System.out.println("=== DEBUG: SO SÁNH BENEFIT ===");
            System.out.println("DEBUG: deathOrDisability - NEW = " + newBenefit.getDeathOrPermanentDisability() + ", OLD = " + originalBenefit.getDeathOrPermanentDisability());
            System.out.println("DEBUG: deathByIllness - NEW = " + newBenefit.getDeathDueToIllness() + ", OLD = " + originalBenefit.getDeathDueToIllness());
            System.out.println("DEBUG: medical_cost - NEW = " + newBenefit.getMedicalCost() + ", OLD = " + originalBenefit.getMedicalCost());
            System.out.println("DEBUG: trip_delay - NEW = " + newBenefit.getTripDelay() + ", OLD = " + originalBenefit.getTripDelay());

            // DEBUG: IN RA CÁC THAM SỐ TỪ REQUEST
            System.out.println("=== DEBUG: REQUEST PARAMETERS ===");
            System.out.println("DEBUG: deathOrDisability param = " + request.getParameter("deathOrDisability"));
            System.out.println("DEBUG: deathByIllness param = " + request.getParameter("deathByIllness"));
            System.out.println("DEBUG: medical_cost param = " + request.getParameter("medical_cost"));

            // DEBUG: IN RA CÁC HIDDEN FIELDS
            System.out.println("=== DEBUG: HIDDEN FIELDS ===");
            System.out.println("DEBUG: original_deathOrDisability = " + request.getParameter("original_deathOrDisability"));
            System.out.println("DEBUG: original_deathByIllness = " + request.getParameter("original_deathByIllness"));
            System.out.println("DEBUG: original_medical_cost = " + request.getParameter("original_medical_cost"));

            int finalBenefitId = benefitId;

            // DEBUG: KIỂM TRA KẾT QUẢ SO SÁNH
            boolean isBenefitChanged = hasBenefitChanged(newBenefit, originalBenefit);
            System.out.println("DEBUG: Kết quả hasBenefitChanged = " + isBenefitChanged);

            // So sánh benefit mới với benefit gốc
            if (isBenefitChanged) {
                System.out.println("DEBUG: Tạo benefit mới vì có thay đổi");
                int newBenefitId = productDB.createBenefit(newBenefit);
                if (newBenefitId == -1) {
                    throw new Exception("Không thể tạo quyền lợi bảo hiểm mới");
                }
                finalBenefitId = newBenefitId;
                System.out.println("DEBUG: Đã tạo benefit mới với ID = " + newBenefitId);
            } else {
                System.out.println("DEBUG: Không có thay đổi, cập nhật benefit hiện tại");
                newBenefit.setId(benefitId);
                boolean benefitUpdated = productDB.updateBenefit(newBenefit);
                if (!benefitUpdated) {
                    throw new Exception("Không thể cập nhật quyền lợi bảo hiểm");
                }
            }

            // Cập nhật Product
            Product product = createProduct(request, finalBenefitId, imgPath); // Bỏ qua ảnh cho debug
            product.setId(productId);

            boolean productUpdated = productDB.updateProduct(product);

            if (productUpdated) {
                System.out.println("DEBUG: Cập nhật sản phẩm thành công");
                setSuccessAttributes(request, product, imgPath);
                response.sendRedirect(request.getContextPath() + "/view_product");
            } else {
                throw new Exception("Không thể cập nhật sản phẩm");
            }

        } catch (Exception e) {
            System.out.println("DEBUG: Lỗi khi cập nhật sản phẩm: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi cập nhật sản phẩm: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/navigate?page=edit_product&id=" + request.getParameter("product_id"));
        }

        System.out.println("=== DEBUG: KẾT THÚC UPDATE PRODUCT ===");
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

    private InsuranceBenefit1 createOriginalInsuranceBenefit(HttpServletRequest request) {
        InsuranceBenefit1 benefit = new InsuranceBenefit1();

        // Set các giá trị gốc từ hidden fields
        benefit.setDeathOrPermanentDisability(parseBigDecimal(request.getParameter("original_deathOrDisability")));
        benefit.setDeathDueToIllness(parseBigDecimal(request.getParameter("original_deathByIllness")));
        benefit.setThirdPartyLiability(parseBigDecimal(request.getParameter("original_thirdPartyLiability")));
        benefit.setLostBankCard(parseBigDecimal(request.getParameter("original_lostBankCard")));
        benefit.setKidnapAndHostage(parseBigDecimal(request.getParameter("original_kidnapHostage")));
        benefit.setLostOrDamagedGolfEquipment(parseBigDecimal(request.getParameter("original_golfEquipLoss")));
        // Các benefits quốc tế
        benefit.setMedicalCost(parseBigDecimal(request.getParameter("original_medical_cost")));
        benefit.setEmergencyTransport(parseBigDecimal(request.getParameter("original_emergency_transport")));
        benefit.setRepatriationVn(parseBigDecimal(request.getParameter("original_repatriation_vn")));
        benefit.setRepatriationAbroad(parseBigDecimal(request.getParameter("original_repatriation_abroad")));
        benefit.setHospitalVisit(parseBigDecimal(request.getParameter("original_hospital_visit")));
        benefit.setFuneralArrangement(parseBigDecimal(request.getParameter("original_funeral_arrangement")));
        benefit.setChildCare(parseBigDecimal(request.getParameter("original_child_care")));
        benefit.setHospitalAllowance(parseBigDecimal(request.getParameter("original_hospital_allowance")));
        benefit.setAccidentDeathInjury(parseBigDecimal(request.getParameter("original_accident_death_injury")));
        benefit.setTripCancellation(parseBigDecimal(request.getParameter("original_trip_cancellation")));
        benefit.setCompanionSupport(parseBigDecimal(request.getParameter("original_companion_support")));
        benefit.setDelayedBaggage(parseBigDecimal(request.getParameter("original_delayed_baggage")));
        benefit.setTravelDocuments(parseBigDecimal(request.getParameter("original_travel_documents")));
        benefit.setTripDelay(parseBigDecimal(request.getParameter("original_trip_delay")));

        return benefit;
    }

    private boolean hasBenefitChanged(InsuranceBenefit1 newBenefit, InsuranceBenefit1 originalBenefit) {
        // So sánh từng trường của benefit bằng compareTo (so sánh giá trị số, bỏ qua scale)
        return newBenefit.getDeathOrPermanentDisability().compareTo(originalBenefit.getDeathOrPermanentDisability()) != 0
                || newBenefit.getDeathDueToIllness().compareTo(originalBenefit.getDeathDueToIllness()) != 0
                || newBenefit.getThirdPartyLiability().compareTo(originalBenefit.getThirdPartyLiability()) != 0
                || newBenefit.getLostBankCard().compareTo(originalBenefit.getLostBankCard()) != 0
                || newBenefit.getKidnapAndHostage().compareTo(originalBenefit.getKidnapAndHostage()) != 0
                || newBenefit.getLostOrDamagedGolfEquipment().compareTo(originalBenefit.getLostOrDamagedGolfEquipment()) != 0
                || newBenefit.getMedicalCost().compareTo(originalBenefit.getMedicalCost()) != 0
                || newBenefit.getEmergencyTransport().compareTo(originalBenefit.getEmergencyTransport()) != 0
                || newBenefit.getRepatriationVn().compareTo(originalBenefit.getRepatriationVn()) != 0
                || newBenefit.getRepatriationAbroad().compareTo(originalBenefit.getRepatriationAbroad()) != 0
                || newBenefit.getHospitalVisit().compareTo(originalBenefit.getHospitalVisit()) != 0
                || newBenefit.getFuneralArrangement().compareTo(originalBenefit.getFuneralArrangement()) != 0
                || newBenefit.getChildCare().compareTo(originalBenefit.getChildCare()) != 0
                || newBenefit.getHospitalAllowance().compareTo(originalBenefit.getHospitalAllowance()) != 0
                || newBenefit.getAccidentDeathInjury().compareTo(originalBenefit.getAccidentDeathInjury()) != 0
                || newBenefit.getTripCancellation().compareTo(originalBenefit.getTripCancellation()) != 0
                || newBenefit.getCompanionSupport().compareTo(originalBenefit.getCompanionSupport()) != 0
                || newBenefit.getDelayedBaggage().compareTo(originalBenefit.getDelayedBaggage()) != 0
                || newBenefit.getTravelDocuments().compareTo(originalBenefit.getTravelDocuments()) != 0
                || newBenefit.getTripDelay().compareTo(originalBenefit.getTripDelay()) != 0;
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
        product.setActive(request.getParameter("active").equals("true") ? true : false);
        return product;
    }

// Hàm chuyển những input rỗng về 0
    private BigDecimal parseBigDecimal(String value) {
        System.out.println("DEBUG parseBigDecimal: input = '" + value + "'");

        if (value == null || value.trim().isEmpty()) {
            System.out.println("DEBUG parseBigDecimal: trả về ZERO");
            return BigDecimal.ZERO;
        }
        try {
            BigDecimal result = new BigDecimal(value);
            System.out.println("DEBUG parseBigDecimal: trả về = " + result);
            return result;
        } catch (NumberFormatException e) {
            System.out.println("DEBUG parseBigDecimal: lỗi NumberFormat, trả về ZERO");
            return BigDecimal.ZERO;
        }
    }

    private void setSuccessAttributes(HttpServletRequest request, Product product, String imgPath) {
        request.getSession().setAttribute("notification", "Cập nhật sản phẩm bảo hiểm thành công!");
        request.getSession().setAttribute("img_src", imgPath);
        request.getSession().setAttribute("name", product.getName());
        request.getSession().setAttribute("type", product.getType());
        request.getSession().setAttribute("package_type", product.getPackageType());
        request.getSession().setAttribute("description", product.getDescription());
        request.getSession().setAttribute("price", product.getPrice() != null ? product.getPrice().toString() : "0");
    }
}
