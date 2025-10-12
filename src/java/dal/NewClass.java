/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import Model.Application;
import Model.ApplicationTraveler;
import Model.User;
import utils.Validation;

/**
 *
 * @author FPTSHOP
 */
public class NewClass extends DBContext{
    public static void main(String[] args) {
        InsuranceDBContext rdb = new InsuranceDBContext();
        InsuranceBenefitDBContext db = new InsuranceBenefitDBContext();
        ApplicationDBContext adb = new ApplicationDBContext();
        TravelerDBContext tdb = new TravelerDBContext();
        System.out.println(rdb.getAllWithBenefit().get(0).getBenefit().getDeath_due_to_illness().toString());
        System.out.println(tdb.getAll().size());
        
        User u = new User();
        u = rdb.login("user01", "123456");
        
        
        
        List<ApplicationTraveler> list = new ArrayList<>();
        
        ApplicationTraveler at = new ApplicationTraveler();
        at.setApplication_id(1);
        at.setName("Manh");
        at.setGender("Male");
        at.setCccd_id(015204222111);
        at.setDob(new java.util.Date());
        at.setPhone("01234381689");
        at.setEmail("manh");
        
        list.add(at);
        
        System.out.println(tdb.insert(at));
        
        Application app = new Application();
        app.setPurchaser_id(1);
        app.setProduct_id(1);
        app.setType("Car");
        app.setDestination("Ha long");
        app.setStartDate(new java.util.Date());
        app.setEndDate(new java.util.Date());
        app.setTravelers_quantity(4);
        app.setTotal_price(BigDecimal.ONE);

        System.out.println(adb.insertApplicationWithTravelers(app, list));
    }
}
