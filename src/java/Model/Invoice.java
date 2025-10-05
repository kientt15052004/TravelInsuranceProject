/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author FPTSHOP
 */
public class Invoice {
    private int id;
    private int contract_id;
    private BigDecimal base_amount;
    private BigDecimal tax_rate;
    private String payment_method;
    private String payment_code;
    private String notes;
    private Timestamp created_at;

    public Invoice() {
    }

    public Invoice(int id, int contract_id, BigDecimal base_amount, BigDecimal tax_rate, String payment_method, String payment_code, String notes, Timestamp created_at) {
        this.id = id;
        this.contract_id = contract_id;
        this.base_amount = base_amount;
        this.tax_rate = tax_rate;
        this.payment_method = payment_method;
        this.payment_code = payment_code;
        this.notes = notes;
        this.created_at = created_at;
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

    public BigDecimal getBase_amount() {
        return base_amount;
    }

    public void setBase_amount(BigDecimal base_amount) {
        this.base_amount = base_amount;
    }

    public BigDecimal getTax_rate() {
        return tax_rate;
    }

    public void setTax_rate(BigDecimal tax_rate) {
        this.tax_rate = tax_rate;
    }

    public String getPayment_method() {
        return payment_method;
    }

    public void setPayment_method(String payment_method) {
        this.payment_method = payment_method;
    }

    public String getPayment_code() {
        return payment_code;
    }

    public void setPayment_code(String payment_code) {
        this.payment_code = payment_code;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }
}
