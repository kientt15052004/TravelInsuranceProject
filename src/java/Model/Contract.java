/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

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
}
