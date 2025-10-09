/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller;

import dal.ContractDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.Contract;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author FPTSHOP
 */
@WebServlet(name = "ContractManagementServlet", urlPatterns = {"/ContractManagementServlet"})
public class ContractManagementServlet extends HttpServlet {

    private ContractDBContext contractDB = new ContractDBContext();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            
            request.getRequestDispatcher("ContractManagement.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách hợp đồng: " + e.getMessage());
            request.getRequestDispatcher("ContractManagement.jsp").forward(request, response);
        }
    }
}
