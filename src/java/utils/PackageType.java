package utils;

import java.util.Arrays;
import java.util.List;

public class PackageType {
    // Các giá trị package type cố định
    public static final String BASIC = "Basic";
    public static final String STANDARD = "Standard";
    public static final String ADVANCED = "Advanced";
    public static final String COMPREHENSIVE = "Comprehensive";
    
    // Danh sách tất cả package types cố định
    private static final List<String> STANDARD_TYPES = Arrays.asList(
        BASIC, STANDARD, ADVANCED, COMPREHENSIVE
    );
    
    // Mapping từ form value (chữ thường) sang database value (chữ hoa đầu)
    public static String normalize(String packageType) {
        if (packageType == null || packageType.trim().isEmpty()) {
            return null;
        }
        String normalized = packageType.trim();
        // Chuyển "basic" -> "Basic", "standard" -> "Standard", etc.
        if (normalized.length() > 0) {
            normalized = normalized.substring(0, 1).toUpperCase() + 
                        normalized.substring(1).toLowerCase();
        }
        return normalized;
    }
    
    // Validate package type format (chỉ chứa chữ cái, số, khoảng trắng)
    public static boolean isValidFormat(String packageType) {
        if (packageType == null || packageType.trim().isEmpty()) {
            return false;
        }
        // Chỉ cho phép chữ cái, số, khoảng trắng, tối đa 50 ký tự
        return packageType.matches("^[a-zA-Z0-9\\s]{1,50}$");
    }
    
    // Kiểm tra xem package type có trong danh sách cố định không
    public static boolean isStandardType(String packageType) {
        if (packageType == null) return false;
        String normalized = normalize(packageType);
        return STANDARD_TYPES.contains(normalized);
    }
    
    // Lấy danh sách tất cả package types cố định
    public static List<String> getStandardTypes() {
        return STANDARD_TYPES;
    }
    
    // Lấy display name (tiếng Việt) cho package type cố định
    public static String getDisplayName(String packageType) {
        if (packageType == null) return "";
        String normalized = normalize(packageType);
        switch (normalized) {
            case BASIC: return "Cơ bản";
            case STANDARD: return "Tiêu chuẩn";
            case ADVANCED: return "Nâng cao";
            case COMPREHENSIVE: return "Toàn diện";
            default: return normalized; // Trả về tên gốc nếu không có trong danh sách
        }
    }
    
    // Lấy thứ tự sắp xếp cho package type
    public static int getDisplayOrder(String packageType) {
        if (packageType == null) return 999;
        String normalized = normalize(packageType);
        switch (normalized) {
            case BASIC: return 1;
            case STANDARD: return 2;
            case ADVANCED: return 3;
            case COMPREHENSIVE: return 4;
            default: return 999; // Các package khác sắp xếp sau, theo tên
        }
    }
}

