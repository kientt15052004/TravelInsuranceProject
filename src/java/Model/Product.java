package Model;

import java.math.BigDecimal;

public class Product {

    private int id;
    private int benefitId;
    private String type;
    private String name;
    private String img;
    private String description;
    private String packageType;
    private BigDecimal price;
    private BigDecimal domesticPercentageRate;
    private BigDecimal internationalRate1_7;
    private BigDecimal internationalRate8_30;
    private BigDecimal internationalRate31_90;
    private BigDecimal internationalRate91_180;
    private boolean active;
    private boolean deleted;

    // Constructors
    public Product() {
    }

    public Product(int benefitId, String type, String name, String img, String description,
            String packageType, BigDecimal price, BigDecimal domesticPercentageRate,
            BigDecimal internationalRate1_7, BigDecimal internationalRate8_30,
            BigDecimal internationalRate31_90, BigDecimal internationalRate91_180,
            boolean active, boolean is_delete) {
        this.benefitId = benefitId;
        this.type = type;
        this.name = name;
        this.img = img;
        this.description = description;
        this.packageType = packageType;
        this.price = price;
        this.domesticPercentageRate = domesticPercentageRate;
        this.internationalRate1_7 = internationalRate1_7;
        this.internationalRate8_30 = internationalRate8_30;
        this.internationalRate31_90 = internationalRate31_90;
        this.internationalRate91_180 = internationalRate91_180;
        this.active = active;
    }
  
    // Business Methods
    public String getTypeDisplay() {
        return "domestic".equals(type) ? "Trong nước" : "Ngoài nước";
    }

    public String getPackageTypeDisplay() {
        switch (packageType) {
            case "basic":
                return "Cơ bản";
            case "standard":
                return "Tiêu chuẩn";
            case "advanced":
                return "Nâng cao";
            case "comprehensive":
                return "Toàn diện";
            default:
                return packageType;
        }
    }
    
    

    public String getFormattedPrice() {
        return String.format("%,d VNĐ", price != null ? price.intValue() : 0);
    }

    public boolean isDomestic() {
        return "domestic".equals(type);
    }

    public boolean isInternational() {
        return "international".equals(type);
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBenefitId() {
        return benefitId;
    }

    public void setBenefitId(int benefitId) {
        this.benefitId = benefitId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPackageType() {
        return packageType;
    }

    public void setPackageType(String packageType) {
        this.packageType = packageType;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDomesticPercentageRate() {
        return domesticPercentageRate;
    }

    public void setDomesticPercentageRate(BigDecimal domesticPercentageRate) {
        this.domesticPercentageRate = domesticPercentageRate;
    }

    public BigDecimal getInternationalRate1_7() {
        return internationalRate1_7;
    }

    public void setInternationalRate1_7(BigDecimal internationalRate1_7) {
        this.internationalRate1_7 = internationalRate1_7;
    }

    public BigDecimal getInternationalRate8_30() {
        return internationalRate8_30;
    }

    public void setInternationalRate8_30(BigDecimal internationalRate8_30) {
        this.internationalRate8_30 = internationalRate8_30;
    }

    public BigDecimal getInternationalRate31_90() {
        return internationalRate31_90;
    }

    public void setInternationalRate31_90(BigDecimal internationalRate31_90) {
        this.internationalRate31_90 = internationalRate31_90;
    }

    public BigDecimal getInternationalRate91_180() {
        return internationalRate91_180;
    }

    public void setInternationalRate91_180(BigDecimal internationalRate91_180) {
        this.internationalRate91_180 = internationalRate91_180;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

}
