/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author FPTSHOP
 */
public class Validation {

    // Trả về Integer (null nếu không hợp lệ)
    public static Integer validInt(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // Trả về Double (null nếu không hợp lệ)
    public static Double validDouble(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // Trả về String (null nếu rỗng hoặc null)
    public static String validString(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
    
    // Validate ID number (CCCD/CMND)
    public static boolean isValidIdNumber(String idNumber) {
        if (idNumber == null || idNumber.trim().isEmpty()) {
            return false;
        }
        // Vietnamese ID number validation: 9-12 digits
        return idNumber.matches("^[0-9]{9,12}$");
    }
    
    // Validate phone number
    public static boolean isValidPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return false;
        }
        // Vietnamese phone number validation: 10-11 digits starting with 0
        return phoneNumber.matches("^0[0-9]{9,10}$");
    }
    
    // Validate email
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        // Basic email validation
        return email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    }
    
    // Validate date format
    public static boolean isValidDateFormat(String date, String format) {
        if (date == null || date.trim().isEmpty()) {
            return false;
        }
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(format);
            sdf.setLenient(false);
            sdf.parse(date);
            return true;
        } catch (java.text.ParseException e) {
            return false;
        }
    }
}


