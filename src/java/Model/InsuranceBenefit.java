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
    private BigDecimal lost_bank_card;
    private BigDecimal kidnap_and_hostage;
    private BigDecimal lost_or_damaged_golf_equipment;
    private Boolean is_deleted;
    private BigDecimal medical_cost;
    private BigDecimal emergency_transport;
    private BigDecimal repatriation_vn;
    private BigDecimal repatriation_abroad;
    private BigDecimal hospital_visit;
    private BigDecimal funeral_arrangement;
    private BigDecimal child_care;
    private BigDecimal hospital_allowance;
    private BigDecimal accident_death_injury;
    private BigDecimal trip_cancellation;
    private BigDecimal companion_support;
    private BigDecimal delayed_baggage;
    private BigDecimal travel_documents;
    private BigDecimal trip_delay;

    public InsuranceBenefit() {
    }

    public InsuranceBenefit(int id, BigDecimal death_or_permanent_disability, BigDecimal death_due_to_illness, BigDecimal third_party_liability, BigDecimal lost_bank_card, BigDecimal kidnap_and_hostage, BigDecimal lost_or_damaged_golf_equipment, Boolean is_deleted) {
        this.id = id;
        this.death_or_permanent_disability = death_or_permanent_disability;
        this.death_due_to_illness = death_due_to_illness;
        this.third_party_liability = third_party_liability;
        this.lost_bank_card = lost_bank_card;
        this.kidnap_and_hostage = kidnap_and_hostage;
        this.lost_or_damaged_golf_equipment = lost_or_damaged_golf_equipment;
        this.is_deleted = is_deleted;
    }
    
    // Full constructor with all fields
    public InsuranceBenefit(int id, BigDecimal death_or_permanent_disability, BigDecimal death_due_to_illness, 
                           BigDecimal third_party_liability, BigDecimal lost_bank_car, BigDecimal kidnap_and_hostage, 
                           BigDecimal lost_or_damaged_golf_equipment, Boolean is_deleted, BigDecimal medical_cost,
                           BigDecimal emergency_transport, BigDecimal repatriation_vn, BigDecimal repatriation_abroad,
                           BigDecimal hospital_visit, BigDecimal funeral_arrangement, BigDecimal child_care,
                           BigDecimal hospital_allowance, BigDecimal accident_death_injury, BigDecimal trip_cancellation,
                           BigDecimal companion_support, BigDecimal delayed_baggage, BigDecimal travel_documents,
                           BigDecimal trip_delay) {
        this.id = id;
        this.death_or_permanent_disability = death_or_permanent_disability;
        this.death_due_to_illness = death_due_to_illness;
        this.third_party_liability = third_party_liability;
        this.lost_bank_card = lost_bank_card;
        this.kidnap_and_hostage = kidnap_and_hostage;
        this.lost_or_damaged_golf_equipment = lost_or_damaged_golf_equipment;
        this.is_deleted = is_deleted;
        this.medical_cost = medical_cost;
        this.emergency_transport = emergency_transport;
        this.repatriation_vn = repatriation_vn;
        this.repatriation_abroad = repatriation_abroad;
        this.hospital_visit = hospital_visit;
        this.funeral_arrangement = funeral_arrangement;
        this.child_care = child_care;
        this.hospital_allowance = hospital_allowance;
        this.accident_death_injury = accident_death_injury;
        this.trip_cancellation = trip_cancellation;
        this.companion_support = companion_support;
        this.delayed_baggage = delayed_baggage;
        this.travel_documents = travel_documents;
        this.trip_delay = trip_delay;
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

    public BigDecimal getLost_bank_card() {
        return lost_bank_card;
    }

    public void setLost_bank_card(BigDecimal lost_bank_card) {
        this.lost_bank_card = lost_bank_card;
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

    // Getter and setter methods for new fields
    public BigDecimal getMedical_cost() {
        return medical_cost;
    }

    public void setMedical_cost(BigDecimal medical_cost) {
        this.medical_cost = medical_cost;
    }

    public BigDecimal getEmergency_transport() {
        return emergency_transport;
    }

    public void setEmergency_transport(BigDecimal emergency_transport) {
        this.emergency_transport = emergency_transport;
    }

    public BigDecimal getRepatriation_vn() {
        return repatriation_vn;
    }

    public void setRepatriation_vn(BigDecimal repatriation_vn) {
        this.repatriation_vn = repatriation_vn;
    }

    public BigDecimal getRepatriation_abroad() {
        return repatriation_abroad;
    }

    public void setRepatriation_abroad(BigDecimal repatriation_abroad) {
        this.repatriation_abroad = repatriation_abroad;
    }

    public BigDecimal getHospital_visit() {
        return hospital_visit;
    }

    public void setHospital_visit(BigDecimal hospital_visit) {
        this.hospital_visit = hospital_visit;
    }

    public BigDecimal getFuneral_arrangement() {
        return funeral_arrangement;
    }

    public void setFuneral_arrangement(BigDecimal funeral_arrangement) {
        this.funeral_arrangement = funeral_arrangement;
    }

    public BigDecimal getChild_care() {
        return child_care;
    }

    public void setChild_care(BigDecimal child_care) {
        this.child_care = child_care;
    }

    public BigDecimal getHospital_allowance() {
        return hospital_allowance;
    }

    public void setHospital_allowance(BigDecimal hospital_allowance) {
        this.hospital_allowance = hospital_allowance;
    }

    public BigDecimal getAccident_death_injury() {
        return accident_death_injury;
    }

    public void setAccident_death_injury(BigDecimal accident_death_injury) {
        this.accident_death_injury = accident_death_injury;
    }

    public BigDecimal getTrip_cancellation() {
        return trip_cancellation;
    }

    public void setTrip_cancellation(BigDecimal trip_cancellation) {
        this.trip_cancellation = trip_cancellation;
    }

    public BigDecimal getCompanion_support() {
        return companion_support;
    }

    public void setCompanion_support(BigDecimal companion_support) {
        this.companion_support = companion_support;
    }

    public BigDecimal getDelayed_baggage() {
        return delayed_baggage;
    }

    public void setDelayed_baggage(BigDecimal delayed_baggage) {
        this.delayed_baggage = delayed_baggage;
    }

    public BigDecimal getTravel_documents() {
        return travel_documents;
    }

    public void setTravel_documents(BigDecimal travel_documents) {
        this.travel_documents = travel_documents;
    }

    public BigDecimal getTrip_delay() {
        return trip_delay;
    }

    public void setTrip_delay(BigDecimal trip_delay) {
        this.trip_delay = trip_delay;
    }
    
}
