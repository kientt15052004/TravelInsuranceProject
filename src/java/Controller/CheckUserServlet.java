/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.UserDAO;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "CheckUserServlet", urlPatterns = {"/CheckUserServlet"})
public class CheckUserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String cccd = request.getParameter("cccd");
        
        try (PrintWriter out = response.getWriter()) {
            StringBuilder jsonResponse = new StringBuilder();
            
            if (cccd == null || cccd.trim().isEmpty()) {
                jsonResponse.append("{\"exists\": false, \"message\": \"CCCD không được để trống\"}");
            } else {
                User user = userDAO.getUserByCccd(cccd.trim());
                
                if (user != null) {
                    jsonResponse.append("{");
                    jsonResponse.append("\"exists\": true,");
                    jsonResponse.append("\"fullname\": \"").append(escapeJson(user.getFullname())).append("\",");
                    jsonResponse.append("\"phone\": \"").append(escapeJson(user.getPhone())).append("\",");
                    jsonResponse.append("\"email\": \"").append(escapeJson(user.getMail())).append("\",");
                    jsonResponse.append("\"address\": \"").append(escapeJson(user.getAddress())).append("\",");
                    
                    if (user.getDob() != null) {
                        jsonResponse.append("\"dob\": \"").append(user.getDob().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))).append("\",");
                    } else {
                        jsonResponse.append("\"dob\": \"\",");
                    }
                    
                    jsonResponse.append("\"message\": \"Tìm thấy thông tin khách hàng\"");
                    jsonResponse.append("}");
                } else {
                    jsonResponse.append("{\"exists\": false, \"message\": \"Không tìm thấy khách hàng với CCCD này\"}");
                }
            }
            
            out.print(jsonResponse.toString());
        } catch (Exception e) {
            e.printStackTrace();
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"exists\": false, \"message\": \"Có lỗi xảy ra khi kiểm tra thông tin khách hàng\"}");
            }
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
