/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

/**
 *
 * @author FPTSHOP
 */
public class ClaimsRes {
    private int claimRes_id;
    private int claim_id;
    private Date createDate;
    private String description;
    private String related_img;
    private String related_file;
    private String status;

    public ClaimsRes() {
    }

    public ClaimsRes(int claimRes_id, int claim_id, Date createDate, String description, String related_img, String related_file, String status) {
        this.claimRes_id = claimRes_id;
        this.claim_id = claim_id;
        this.createDate = createDate;
        this.description = description;
        this.related_img = related_img;
        this.related_file = related_file;
        this.status = status;
    }

    public int getClaimRes_id() {
        return claimRes_id;
    }

    public void setClaimRes_id(int claimRes_id) {
        this.claimRes_id = claimRes_id;
    }

    public int getClaim_id() {
        return claim_id;
    }

    public void setClaim_id(int claim_id) {
        this.claim_id = claim_id;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
