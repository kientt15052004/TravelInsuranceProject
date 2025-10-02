/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.InsuranceProduct;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author FPTSHOP
 */
public class InsuranceDBContext extends DBContext{
    public ArrayList<InsuranceProduct> getAll(){
        String sql = "select * from products";
        ArrayList<InsuranceProduct> insurances = new ArrayList<>();
        try(PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            
            while (rs.next()) {                
                InsuranceProduct insurance = new InsuranceProduct();
                insurance.setId(rs.getInt("id"));
                insurance.setBenefit_id(rs.getInt("benefit_id"));
                
                insurances.add(insurance);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return insurances;
    }
}
