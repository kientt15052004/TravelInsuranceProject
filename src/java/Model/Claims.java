/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;
import java.math.BigDecimal;

/**
 *
 * @author FPTSHOP
 */
public class Claims {
    private int id;
    private int contract_id;
    private Date requestDate;
    private String claim_type;
    private String description;
    private String payment_bank;
    private String payment_number;
    private String related_img;
    private String related_file;
    private String claim_status;
    private BigDecimal claim_amount;
    private BigDecimal compensation_amount;
    private BigDecimal contractTotalPrice; // Total price từ application của contract

    public Claims() {
    }

    public Claims(int id, int contract_id, Date requestDate, String claim_type, String description, String payment_bank, String payment_number, String related_img, String related_file, String claim_status, BigDecimal claim_amount) {
        this.id = id;
        this.contract_id = contract_id;
        this.requestDate = requestDate;
        this.claim_type = claim_type;
        this.description = description;
        this.payment_bank = payment_bank;
        this.payment_number = payment_number;
        this.related_img = related_img;
        this.related_file = related_file;
        this.claim_status = claim_status;
        this.claim_amount = claim_amount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getContract_id() {
        return contract_id;
    }

    public void setContract_id(int contract_id) {
        this.contract_id = contract_id;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public String getClaim_type() {
        return claim_type;
    }

    public void setClaim_type(String claim_type) {
        this.claim_type = claim_type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPayment_bank() {
        return payment_bank;
    }

    public void setPayment_bank(String payment_bank) {
        this.payment_bank = payment_bank;
    }

    public String getPayment_number() {
        return payment_number;
    }

    public void setPayment_number(String payment_number) {
        this.payment_number = payment_number;
    }

    public String getRelated_img() {
        return related_img;
    }

    public void setRelated_img(String related_img) {
        this.related_img = related_img;
    }

    public String getRelated_file() {
        return related_file;
    }

    public void setRelated_file(String related_file) {
        this.related_file = related_file;
    }

    public String getClaim_status() {
        return claim_status;
    }

    public void setClaim_status(String claim_status) {
        this.claim_status = claim_status;
    }
    
    public BigDecimal getClaim_amount() {
        return claim_amount;
    }

    public void setClaim_amount(BigDecimal claim_amount) {
        this.claim_amount = claim_amount;
    }
    
    public BigDecimal getCompensation_amount() {
        return compensation_amount;
    }
    
    public void setCompensation_amount(BigDecimal compensation_amount) {
        this.compensation_amount = compensation_amount;
    }
    
    public BigDecimal getContractTotalPrice() {
        return contractTotalPrice;
    }
    
    public void setContractTotalPrice(BigDecimal contractTotalPrice) {
        this.contractTotalPrice = contractTotalPrice;
    }
}
