/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author ACER
 */
public class NewClass extends DBContext{
    public static void main(String[] args) {
        InsuranceDBContext rdb = new InsuranceDBContext();
        System.out.println(rdb.getAll().size());
    }
}