/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author FPTSHOP
 */
public class InsuranceProduct {
    private int id;
    private int benefit_id ;
    private String type;
    private String name;
    private String img;
    private String description;
    
    public InsuranceProduct(int id, int benefit_id, String type, String name, String img, String description) {
        this.id = id;
        this.benefit_id = benefit_id;
        this.type = type;
        this.name = name;
        this.img = img;
        this.description = description;
    }

    public InsuranceProduct() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBenefit_id() {
        return benefit_id;
    }

    public void setBenefit_id(int benefit_id) {
        this.benefit_id = benefit_id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
}
