/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author FPTSHOP
 */
public class Contract {
    private int contract_id;
    private int current_benefit_id;
    private int application_id;
    private String description;
    private String contract_status;
    
    // Thông tin sản phẩm
    private String productName;
    private String productType;
    
    // Thông tin ngày
    private Date startDate;
    private Date endDate;
    
    // Thông tin chuyến đi
    private String destination;
    private int travelers_quantity;
    
    // Thông tin người mua
    private String buyerName;
    private String buyerPhone;
    private String buyerEmail;
    
    // Tổng số tiền
    private BigDecimal totalPrice;

    public Contract() {
    }

    public Contract(int contract_id, int current_benefit_id, int application_id, String description, String contract_status) {
        this.contract_id = contract_id;
        this.current_benefit_id = current_benefit_id;
        this.application_id = application_id;
        this.description = description;
        this.contract_status = contract_status;
    }

    public int getContract_id() {
        return contract_id;
    }

    public void setContract_id(int contract_id) {
        this.contract_id = contract_id;
    }

    public int getCurrent_benefit_id() {
        return current_benefit_id;
    }

    public void setCurrent_benefit_id(int current_benefit_id) {
        this.current_benefit_id = current_benefit_id;
    }

    public int getApplication_id() {
        return application_id;
    }

    public void setApplication_id(int application_id) {
        this.application_id = application_id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getContract_status() {
        return contract_status;
    }

    public void setContract_status(String contract_status) {
        this.contract_status = contract_status;
    }

    // Getters and Setters for new fields
    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public String getBuyerPhone() {
        return buyerPhone;
    }

    public void setBuyerPhone(String buyerPhone) {
        this.buyerPhone = buyerPhone;
    }

    public String getBuyerEmail() {
        return buyerEmail;
    }

    public void setBuyerEmail(String buyerEmail) {
        this.buyerEmail = buyerEmail;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public int getTravelers_quantity() {
        return travelers_quantity;
    }

    public void setTravelers_quantity(int travelers_quantity) {
        this.travelers_quantity = travelers_quantity;
    }
}
