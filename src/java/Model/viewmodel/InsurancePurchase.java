/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.viewmodel;

import model.viewmodel.BuyerInfo;
import java.util.List;
import model.ApplicationTraveler;

/**
 *
 * @author FPTSHOP
 */
public class InsurancePurchase {

    private String insuranceId;
    private String type;
    private String startDate;
    private String endDate;
    private double totalPrice;
    private BuyerInfo buyerInfo;
    private List<ApplicationTraveler> travelers;

    // Getters and Setters
    public String getInsuranceId() {
        return insuranceId;
    }

    public void setInsuranceId(String insuranceId) {
        this.insuranceId = insuranceId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public BuyerInfo getBuyerInfo() {
        return buyerInfo;
    }

    public void setBuyerInfo(BuyerInfo buyerInfo) {
        this.buyerInfo = buyerInfo;
    }

    public List<ApplicationTraveler> getTravelers() {
        return travelers;
    }

    public void setTravelers(List<ApplicationTraveler> travelers) {
        this.travelers = travelers;
    }
}
