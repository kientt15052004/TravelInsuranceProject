package controller;


import dal.ProductDBContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CreateProduct extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateProduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateProduct at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Đã truy cập get method!");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDBContext query_data = new ProductDBContext();
        String name = request.getParameter("name");
        String package_type = request.getParameter("package_type");
        String type = request.getParameter("choose");
        String description = request.getParameter("description");

        // Tạo và lưu ảnh vào folder rồi ném ra đường dẫn tương đối
        Part filePart = request.getPart("img");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "upload_imgs";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir(); // Nếu chưa tồn tại tạo thư mục mới
        }
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath); //Ghi hết dữ liệu của file chọn đến đường dẫn tương ứng   
        String relativePath = "upload_imgs/" + fileName; //Lấy đường dẫn tương đối

// Quyền lợi trong nước
        String deathOrDisability = request.getParameter("deathOrDisability");
        if (deathOrDisability == null || deathOrDisability.trim().isEmpty()) {
            deathOrDisability = "0";
        }
        System.out.println("deathOrDisability: " + deathOrDisability);

        String deathByIllness = request.getParameter("deathByIllness");
        if (deathByIllness == null || deathByIllness.trim().isEmpty()) {
            deathByIllness = "0";
        }

        String thirdPartyLiability = request.getParameter("thirdPartyLiability");
        if (thirdPartyLiability == null || thirdPartyLiability.trim().isEmpty()) {
            thirdPartyLiability = "0";
        }

        String lostBankCard = request.getParameter("lostBankCard");
        if (lostBankCard == null || lostBankCard.trim().isEmpty()) {
            lostBankCard = "0";
        }

        String kidnapHostage = request.getParameter("kidnapHostage");
        if (kidnapHostage == null || kidnapHostage.trim().isEmpty()) {
            kidnapHostage = "0";
        }

        String golfEquipLoss = request.getParameter("golfEquipLoss");
        if (golfEquipLoss == null || golfEquipLoss.trim().isEmpty()) {
            golfEquipLoss = "0";
        }

        // Quyền lợi ngoài nước
        String medical_cost = request.getParameter("medical_cost");
        if (medical_cost == null || medical_cost.trim().isEmpty()) {
            medical_cost = "0";
        }
        System.out.println("medical_cost: " + medical_cost);

        String emergency_transport = request.getParameter("emergency_transport");
        if (emergency_transport == null || emergency_transport.trim().isEmpty()) {
            emergency_transport = "0";
        }

        String repatriation_vn = request.getParameter("repatriation_vn");
        if (repatriation_vn == null || repatriation_vn.trim().isEmpty()) {
            repatriation_vn = "0";
        }

        String repatriation_abroad = request.getParameter("repatriation_abroad");
        if (repatriation_abroad == null || repatriation_abroad.trim().isEmpty()) {
            repatriation_abroad = "0";
        }

        String hospital_visit = request.getParameter("hospital_visit");
        if (hospital_visit == null || hospital_visit.trim().isEmpty()) {
            hospital_visit = "0";
        }

        String funeral_arrangement = request.getParameter("funeral_arrangement");
        if (funeral_arrangement == null || funeral_arrangement.trim().isEmpty()) {
            funeral_arrangement = "0";
        }

        String child_care = request.getParameter("child_care");
        if (child_care == null || child_care.trim().isEmpty()) {
            child_care = "0";
        }

        String hospital_allowance = request.getParameter("hospital_allowance");
        if (hospital_allowance == null || hospital_allowance.trim().isEmpty()) {
            hospital_allowance = "0";
        }

        String accident_death_injury = request.getParameter("accident_death_injury");
        if (accident_death_injury == null || accident_death_injury.trim().isEmpty()) {
            accident_death_injury = "0";
        }

        String trip_cancellation = request.getParameter("trip_cancellation");
        if (trip_cancellation == null || trip_cancellation.trim().isEmpty()) {
            trip_cancellation = "0";
        }

        String companion_support = request.getParameter("companion_support");
        if (companion_support == null || companion_support.trim().isEmpty()) {
            companion_support = "0";
        }

        String delayed_baggage = request.getParameter("delayed_baggage");
        if (delayed_baggage == null || delayed_baggage.trim().isEmpty()) {
            delayed_baggage = "0";
        }

        String travel_documents = request.getParameter("travel_documents");
        if (travel_documents == null || travel_documents.trim().isEmpty()) {
            travel_documents = "0";
        }

        String trip_delay = request.getParameter("trip_delay");
        if (trip_delay == null || trip_delay.trim().isEmpty()) {
            trip_delay = "0";
        }

        int benefit_id = query_data.createBenefit(deathOrDisability, deathByIllness, thirdPartyLiability, lostBankCard, kidnapHostage, golfEquipLoss, false, medical_cost, emergency_transport, repatriation_vn, repatriation_abroad, hospital_visit, funeral_arrangement, child_care, hospital_allowance, accident_death_injury, trip_cancellation, companion_support, delayed_baggage, travel_documents, trip_delay);
        query_data.createProduct(benefit_id, type, name, relativePath, description, package_type);
        // Lưu thông báo vào session
        request.getSession().setAttribute("notification", "Add Insurance product successfully!");
        request.getSession().setAttribute("img_src", relativePath);
        request.getSession().setAttribute("img_name", name);
        request.getSession().setAttribute("img_type", type);
        request.getSession().setAttribute("img_package_type", package_type);
        request.getSession().setAttribute("img_description", description);

        // Redirect về dashboard.jsp
        response.sendRedirect(request.getContextPath() + "/navigate?page=create"); //Sửa
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
