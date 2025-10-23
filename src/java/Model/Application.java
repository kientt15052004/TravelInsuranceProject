/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import Model.Traveler;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import Model.BuyerInfo;

/**
 *
 * @author FPTSHOP
 */
public class Application {
    private int id;
    private int purchaser_id;
    private int product_id;
    private String type;
    private String destination;
    private Date startDate;
    private Date endDate;
    private int travelers_quantity;
    private BigDecimal total_price;
    private List<Traveler> travelers;
    private BuyerInfo buyerInfo;
    private InsuranceProduct insurance;
    private int benefit_id;

    public Application() {
    }

    public Application(int id, int purchaser_id, int product_id, String type, String destination, Date startDate, Date endDate, int travelers_quantity, BigDecimal total_price, List<Traveler> travelers, BuyerInfo buyerInfo, InsuranceProduct insurance, int benefit_id) {
        this.id = id;
        this.purchaser_id = purchaser_id;
        this.product_id = product_id;
        this.type = type;
        this.destination = destination;
        this.startDate = startDate;
        this.endDate = endDate;
        this.travelers_quantity = travelers_quantity;
        this.total_price = total_price;
        this.travelers = travelers;
        this.buyerInfo = buyerInfo;
        this.insurance = insurance;
        this.benefit_id = benefit_id;
    }

    public int getBenefit_id() {
        return benefit_id;
    }

    public void setBenefit_id(int benefit_id) {
        this.benefit_id = benefit_id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPurchaser_id() {
        return purchaser_id;
    }

    public void setPurchaser_id(int purchaser_id) {
        this.purchaser_id = purchaser_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
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

    public int getTravelers_quantity() {
        return travelers_quantity;
    }

    public void setTravelers_quantity(int travelers_quantity) {
        this.travelers_quantity = travelers_quantity;
    }

    public BigDecimal getTotal_price() {
        return total_price;
    }

    public void setTotal_price(BigDecimal total_price) {
        this.total_price = total_price;
    }

    public List<Traveler> getTravelers() {
        return travelers;
    }

    public void setTravelers(List<Traveler> travelers) {
        this.travelers = travelers;
    }

    public BuyerInfo getBuyerInfo() {
        return buyerInfo;
    }

    public void setBuyerInfo(BuyerInfo buyerInfo) {
        this.buyerInfo = buyerInfo;
    }

    public InsuranceProduct getInsurance() {
        return insurance;
    }

    public void setInsurance(InsuranceProduct insurance) {
        this.insurance = insurance;
    }

   
}
