package model;

import java.math.BigDecimal;
import java.sql.Date;

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

    public Application() {
    }

    public Application(int id, int purchaser_id, int product_id, String type, String destination, Date startDate, Date endDate, int travelers_quantity, BigDecimal total_price) {
        this.id = id;
        this.purchaser_id = purchaser_id;
        this.product_id = product_id;
        this.type = type;
        this.destination = destination;
        this.startDate = startDate;
        this.endDate = endDate;
        this.travelers_quantity = travelers_quantity;
        this.total_price = total_price;
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
}