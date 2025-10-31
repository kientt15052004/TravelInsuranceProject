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
import jakarta.servlet.http.HttpSession;
import java.io.File;
import Model.User;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UpdateProduct extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        if (currentUser.getRole() == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        InsuranceDBContext insuranceDAO = new InsuranceDBContext();

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
                InsuranceProduct currentProduct = insuranceDAO.getById(productId);
                if (currentProduct != null) {
                    imgPath = currentProduct.getImg();
                }
            }

            // Kiểm tra xem benefit có thay đổi không
            InsuranceBenefit newBenefit = createInsuranceBenefit(request);
            InsuranceBenefit originalBenefit = createOriginalInsuranceBenefit(request);

            // DEBUG: IN RA MỘT SỐ TRƯỜNG ĐẠI DIỆN ĐỂ SO SÁNH
            System.out.println("=== DEBUG: SO SÁNH BENEFIT ===");
            System.out.println("DEBUG: deathOrDisability - NEW = " + newBenefit.getDeath_or_permanent_disability() + ", OLD = " + originalBenefit.getDeath_or_permanent_disability());
            System.out.println("DEBUG: deathByIllness - NEW = " + newBenefit.getDeath_due_to_illness() + ", OLD = " + originalBenefit.getDeath_due_to_illness());
            System.out.println("DEBUG: medical_cost - NEW = " + newBenefit.getMedical_cost() + ", OLD = " + originalBenefit.getMedical_cost());
            System.out.println("DEBUG: trip_delay - NEW = " + newBenefit.getTrip_delay() + ", OLD = " + originalBenefit.getTrip_delay());

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
                int newBenefitId = insuranceDAO.createBenefit(newBenefit);
                if (newBenefitId == -1) {
                    throw new Exception("Không thể tạo quyền lợi bảo hiểm mới");
                }
                finalBenefitId = newBenefitId;
                System.out.println("DEBUG: Đã tạo benefit mới với ID = " + newBenefitId);
            } else {
                System.out.println("DEBUG: Không có thay đổi, cập nhật benefit hiện tại");
                newBenefit.setId(benefitId);
                boolean benefitUpdated = insuranceDAO.updateBenefit(newBenefit);
                if (!benefitUpdated) {
                    throw new Exception("Không thể cập nhật quyền lợi bảo hiểm");
                }
            }

            // Cập nhật InsuranceProduct
            InsuranceProduct product = createInsuranceProduct(request, finalBenefitId, imgPath); // Bỏ qua ảnh cho debug
            product.setId(productId);

            boolean productUpdated = insuranceDAO.updateProduct(product);

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

    private InsuranceBenefit createOriginalInsuranceBenefit(HttpServletRequest request) {
        InsuranceBenefit benefit = new InsuranceBenefit();

        // Set các giá trị gốc từ hidden fields
        benefit.setDeath_or_permanent_disability(parseBigDecimal(request.getParameter("original_deathOrDisability")));
        benefit.setDeath_due_to_illness(parseBigDecimal(request.getParameter("original_deathByIllness")));
        benefit.setThird_party_liability(parseBigDecimal(request.getParameter("original_thirdPartyLiability")));
        benefit.setLost_bank_card(parseBigDecimal(request.getParameter("original_lostBankCard")));
        benefit.setKidnap_and_hostage(parseBigDecimal(request.getParameter("original_kidnapHostage")));
        benefit.setLost_or_damaged_golf_equipment(parseBigDecimal(request.getParameter("original_golfEquipLoss")));
        // Các benefits quốc tế
        benefit.setMedical_cost(parseBigDecimal(request.getParameter("original_medical_cost")));
        benefit.setEmergency_transport(parseBigDecimal(request.getParameter("original_emergency_transport")));
        benefit.setRepatriation_vn(parseBigDecimal(request.getParameter("original_repatriation_vn")));
        benefit.setRepatriation_abroad(parseBigDecimal(request.getParameter("original_repatriation_abroad")));
        benefit.setHospital_visit(parseBigDecimal(request.getParameter("original_hospital_visit")));
        benefit.setFuneral_arrangement(parseBigDecimal(request.getParameter("original_funeral_arrangement")));
        benefit.setChild_care(parseBigDecimal(request.getParameter("original_child_care")));
        benefit.setHospital_allowance(parseBigDecimal(request.getParameter("original_hospital_allowance")));
        benefit.setAccident_death_injury(parseBigDecimal(request.getParameter("original_accident_death_injury")));
        benefit.setTrip_cancellation(parseBigDecimal(request.getParameter("original_trip_cancellation")));
        benefit.setCompanion_support(parseBigDecimal(request.getParameter("original_companion_support")));
        benefit.setDelayed_baggage(parseBigDecimal(request.getParameter("original_delayed_baggage")));
        benefit.setTravel_documents(parseBigDecimal(request.getParameter("original_travel_documents")));
        benefit.setTrip_delay(parseBigDecimal(request.getParameter("original_trip_delay")));

        return benefit;
    }

    private boolean hasBenefitChanged(InsuranceBenefit newBenefit, InsuranceBenefit originalBenefit) {
        // So sánh từng trường của benefit bằng compareTo (so sánh giá trị số, bỏ qua scale)
        return newBenefit.getDeath_or_permanent_disability().compareTo(originalBenefit.getDeath_or_permanent_disability()) != 0
                || newBenefit.getDeath_due_to_illness().compareTo(originalBenefit.getDeath_due_to_illness()) != 0
                || newBenefit.getThird_party_liability().compareTo(originalBenefit.getThird_party_liability()) != 0
                || newBenefit.getLost_bank_card().compareTo(originalBenefit.getLost_bank_card()) != 0
                || newBenefit.getKidnap_and_hostage().compareTo(originalBenefit.getKidnap_and_hostage()) != 0
                || newBenefit.getLost_or_damaged_golf_equipment().compareTo(originalBenefit.getLost_or_damaged_golf_equipment()) != 0
                || newBenefit.getMedical_cost().compareTo(originalBenefit.getMedical_cost()) != 0
                || newBenefit.getEmergency_transport().compareTo(originalBenefit.getEmergency_transport()) != 0
                || newBenefit.getRepatriation_vn().compareTo(originalBenefit.getRepatriation_vn()) != 0
                || newBenefit.getRepatriation_abroad().compareTo(originalBenefit.getRepatriation_abroad()) != 0
                || newBenefit.getHospital_visit().compareTo(originalBenefit.getHospital_visit()) != 0
                || newBenefit.getFuneral_arrangement().compareTo(originalBenefit.getFuneral_arrangement()) != 0
                || newBenefit.getChild_care().compareTo(originalBenefit.getChild_care()) != 0
                || newBenefit.getHospital_allowance().compareTo(originalBenefit.getHospital_allowance()) != 0
                || newBenefit.getAccident_death_injury().compareTo(originalBenefit.getAccident_death_injury()) != 0
                || newBenefit.getTrip_cancellation().compareTo(originalBenefit.getTrip_cancellation()) != 0
                || newBenefit.getCompanion_support().compareTo(originalBenefit.getCompanion_support()) != 0
                || newBenefit.getDelayed_baggage().compareTo(originalBenefit.getDelayed_baggage()) != 0
                || newBenefit.getTravel_documents().compareTo(originalBenefit.getTravel_documents()) != 0
                || newBenefit.getTrip_delay().compareTo(originalBenefit.getTrip_delay()) != 0;
    }

    private InsuranceProduct createInsuranceProduct(HttpServletRequest request, int benefitId, String imgPath) {
        System.out.println("DEBUG: All request parameters:");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("  " + paramName + " = " + paramValue);
        }
        
        InsuranceProduct product = new InsuranceProduct();
        product.setBenefit_id(benefitId);
        product.setType(request.getParameter("choose"));
        product.setName(request.getParameter("name"));
        product.setImg(imgPath);
        product.setDescription(request.getParameter("description"));
        product.setPackage_type(request.getParameter("package_type"));
        System.out.println("DEBUG: package_type parameter = " + request.getParameter("package_type"));
        product.setPrice(parseBigDecimal(request.getParameter("price")));
        product.setDomestic_percentage_rate(parseBigDecimal(request.getParameter("domestic_percentage_rate")).multiply(new BigDecimal("100")));
        product.setInternational_rate_1_7(parseBigDecimal(request.getParameter("international_rate_1_7")));
        product.setInternational_rate_8_30(parseBigDecimal(request.getParameter("international_rate_8_30")));
        product.setInternational_rate_31_90(parseBigDecimal(request.getParameter("international_rate_31_90")));
        product.setInternational_rate_91_365(parseBigDecimal(request.getParameter("international_rate_91_180")));
        String activeParam = request.getParameter("active");
        product.setIs_active("true".equals(activeParam));
        product.setIs_delete(false); // Đảm bảo không bị xóa
        
        System.out.println("DEBUG: Created product data:");
        System.out.println("  - ID: " + product.getId());
        System.out.println("  - Benefit ID: " + product.getBenefit_id());
        System.out.println("  - Type: " + product.getType());
        System.out.println("  - Name: " + product.getName());
        System.out.println("  - Price: " + product.getPrice());
        System.out.println("  - Domestic rate: " + product.getDomestic_percentage_rate());
        System.out.println("  - International rate 1-7: " + product.getInternational_rate_1_7());
        System.out.println("  - International rate 8-30: " + product.getInternational_rate_8_30());
        System.out.println("  - International rate 31-90: " + product.getInternational_rate_31_90());
        System.out.println("  - International rate 91-365: " + product.getInternational_rate_91_365());
        System.out.println("  - Is active: " + product.getIs_active());
        
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

    private void setSuccessAttributes(HttpServletRequest request, InsuranceProduct product, String imgPath) {
        request.getSession().setAttribute("notification", "Cập nhật sản phẩm bảo hiểm thành công!");
        request.getSession().setAttribute("img_src", imgPath);
        request.getSession().setAttribute("name", product.getName());
        request.getSession().setAttribute("type", product.getType());
        request.getSession().setAttribute("package_type", product.getPackage_type());
        request.getSession().setAttribute("description", product.getDescription());
        request.getSession().setAttribute("price", product.getPrice() != null ? product.getPrice().toString() : "0");
    }
}
