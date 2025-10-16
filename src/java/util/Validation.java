package util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class Validation {
    // Username: 6-20 ký tự, chỉ chữ + số
    public static boolean isValidUsername(String username) {
        if (username == null) return false;
        return username.matches("^[a-zA-Z0-9]{6,20}$");
    }

    // Password: >= 6 ký tự, ít nhất 1 chữ và 1 số
    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        return password.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!@#$%^&*]{6,}$");
    }

    // Fullname: chỉ chữ cái (có dấu hoặc không), khoảng trắng
    public static boolean isValidFullname(String fullname) {
        if (fullname == null) return false;
        return fullname.matches("^[\\p{L} ]{2,50}$");
    }

    // Email: format chuẩn email
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return email.matches("^[A-Za-z0-9+_.-]+@gmail.com");
    }

    // Date of Birth: yyyy-MM-dd, không vượt quá ngày hiện tại, >= 18 tuổi (optional)
    public static boolean isValidDob(String dobStr) {
        if (dobStr == null) return false;
        try {
            LocalDate dob = LocalDate.parse(dobStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            LocalDate today = LocalDate.now();
            if (dob.isAfter(today)) return false;
            if (dob.plusYears(18).isAfter(today)) return false; // chưa đủ 18 tuổi
            return true;
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    // Address: ít nhất 5 ký tự
    public static boolean isValidAddress(String address) {
        if (address == null) return false;
        return address.trim().length() >= 5;
    }

    // Phone: Việt Nam (bắt đầu bằng 0, 10 số)
    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        return phone.matches("^0\\d{9}$");
    }

    // CCCD: đúng 12 số
    public static boolean isValidCCCD(String cccd) {
        if (cccd == null) return false;
        return cccd.matches("^\\d{12}$");
    }

    // Role: ...
    public static boolean isValidRole(String role) {
        
        return false;
    }
}
