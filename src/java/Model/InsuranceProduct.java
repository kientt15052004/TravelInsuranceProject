/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.math.BigDecimal;

/**
 *
 * @author FPTSHOP
 */
public class InsuranceProduct {
    private int id;
    private int benefit_id ;
    private String type;
    private String name;
    private String img;
    private String description;
    private BigDecimal price;
    private BigDecimal domestic_percentage_rate;
    private BigDecimal international_rate_1_7;
    private BigDecimal international_rate_8_30;
    private BigDecimal international_rate_31_90;
    private BigDecimal international_rate_91_365;
    private Boolean is_active;
    private Boolean is_delete;
    private InsuranceBenefit benefit = new InsuranceBenefit();

    public InsuranceProduct() {
    }

    public InsuranceProduct(int id, int benefit_id, String type, String name, String img, String description) {
        this.id = id;
        this.benefit_id = benefit_id;
        this.type = type;
        this.name = name;
        this.img = img;
        this.description = description;
    }
    
    public InsuranceProduct(int id, int benefit_id, String type, String name, String img, String description, BigDecimal price) {
        this.id = id;
        this.benefit_id = benefit_id;
        this.type = type;
        this.name = name;
        this.img = img;
        this.description = description;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBenefit_id() {
        return benefit_id;
    }

    public void setBenefit_id(int benefit_id) {
        this.benefit_id = benefit_id;
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

    public InsuranceBenefit getBenefit() {
        return benefit;
    }

    public void setBenefit(InsuranceBenefit benefit) {
        this.benefit = benefit;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDomestic_percentage_rate() {
        return domestic_percentage_rate;
    }

    public void setDomestic_percentage_rate(BigDecimal domestic_percentage_rate) {
        this.domestic_percentage_rate = domestic_percentage_rate;
    }

    public BigDecimal getInternational_rate_1_7() {
        return international_rate_1_7;
    }

    public void setInternational_rate_1_7(BigDecimal international_rate_1_7) {
        this.international_rate_1_7 = international_rate_1_7;
    }

    public BigDecimal getInternational_rate_8_30() {
        return international_rate_8_30;
    }

    public void setInternational_rate_8_30(BigDecimal international_rate_8_30) {
        this.international_rate_8_30 = international_rate_8_30;
    }

    public BigDecimal getInternational_rate_31_90() {
        return international_rate_31_90;
    }

    public void setInternational_rate_31_90(BigDecimal international_rate_31_90) {
        this.international_rate_31_90 = international_rate_31_90;
    }

    public BigDecimal getInternational_rate_91_365() {
        return international_rate_91_365;
    }

    public void setInternational_rate_91_365(BigDecimal international_rate_91_365) {
        this.international_rate_91_365 = international_rate_91_365;
    }

    public Boolean getIs_active() {
        return is_active;
    }

    public void setIs_active(Boolean is_active) {
        this.is_active = is_active;
    }

    public Boolean getIs_delete() {
        return is_delete;
    }

    public void setIs_delete(Boolean is_delete) {
        this.is_delete = is_delete;
    }

   
}
