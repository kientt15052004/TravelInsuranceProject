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
public class InsuranceBenefit {
    private int id;
    private BigDecimal death_or_permanent_disability;
    private BigDecimal death_due_to_illness;
    private BigDecimal third_party_liability;
    private BigDecimal lost_bank_car;
    private BigDecimal kidnap_and_hostage;
    private BigDecimal lost_or_damaged_golf_equipment;
    private Boolean is_deleted;

    public InsuranceBenefit() {
    }

    public InsuranceBenefit(int id, BigDecimal death_or_permanent_disability, BigDecimal death_due_to_illness, BigDecimal third_party_liability, BigDecimal lost_bank_car, BigDecimal kidnap_and_hostage, BigDecimal lost_or_damaged_golf_equipment, Boolean is_deleted) {
        this.id = id;
        this.death_or_permanent_disability = death_or_permanent_disability;
        this.death_due_to_illness = death_due_to_illness;
        this.third_party_liability = third_party_liability;
        this.lost_bank_car = lost_bank_car;
        this.kidnap_and_hostage = kidnap_and_hostage;
        this.lost_or_damaged_golf_equipment = lost_or_damaged_golf_equipment;
        this.is_deleted = is_deleted;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public BigDecimal getDeath_or_permanent_disability() {
        return death_or_permanent_disability;
    }

    public void setDeath_or_permanent_disability(BigDecimal death_or_permanent_disability) {
        this.death_or_permanent_disability = death_or_permanent_disability;
    }

    public BigDecimal getDeath_due_to_illness() {
        return death_due_to_illness;
    }

    public void setDeath_due_to_illness(BigDecimal death_due_to_illness) {
        this.death_due_to_illness = death_due_to_illness;
    }

    public BigDecimal getThird_party_liability() {
        return third_party_liability;
    }

    public void setThird_party_liability(BigDecimal third_party_liability) {
        this.third_party_liability = third_party_liability;
    }

    public BigDecimal getLost_bank_car() {
        return lost_bank_car;
    }

    public void setLost_bank_car(BigDecimal lost_bank_car) {
        this.lost_bank_car = lost_bank_car;
    }

    public BigDecimal getKidnap_and_hostage() {
        return kidnap_and_hostage;
    }

    public void setKidnap_and_hostage(BigDecimal kidnap_and_hostage) {
        this.kidnap_and_hostage = kidnap_and_hostage;
    }

    public BigDecimal getLost_or_damaged_golf_equipment() {
        return lost_or_damaged_golf_equipment;
    }

    public void setLost_or_damaged_golf_equipment(BigDecimal lost_or_damaged_golf_equipment) {
        this.lost_or_damaged_golf_equipment = lost_or_damaged_golf_equipment;
    }

    public Boolean getIs_deleted() {
        return is_deleted;
    }

    public void setIs_deleted(Boolean is_deleted) {
        this.is_deleted = is_deleted;
    }

}
