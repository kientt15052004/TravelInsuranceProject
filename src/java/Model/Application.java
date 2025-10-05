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
    private int insuranceId;
    private String type;
    private String destination;
    private Date startDate;
    private Date endDate;
    private int traveler_quantity;
    private BigDecimal price;
    private List<Traveler> travelers;
    private BuyerInfo buyerInfo;
    private InsuranceProduct insurance;

    public Application() {
    }

    public Application(int id, int purchaser_id, int insuranceId, String type, String destination, Date startDate, Date endDate, int traveler_quantity, BigDecimal price, List<Traveler> travelers, BuyerInfo buyerInfo, InsuranceProduct insurance) {
        this.id = id;
        this.purchaser_id = purchaser_id;
        this.insuranceId = insuranceId;
        this.type = type;
        this.destination = destination;
        this.startDate = startDate;
        this.endDate = endDate;
        this.traveler_quantity = traveler_quantity;
        this.price = price;
        this.travelers = travelers;
        this.buyerInfo = buyerInfo;
        this.insurance = insurance;
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

    public int getInsuranceId() {
        return insuranceId;
    }

    public void setInsuranceId(int insuranceId) {
        this.insuranceId = insuranceId;
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

    public int getTraveler_quantity() {
        return traveler_quantity;
    }

    public void setTraveler_quantity(int traveler_quantity) {
        this.traveler_quantity = traveler_quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
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
