/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;

/**
 *
 * @author FPTSHOP
 */
public class ClaimsRes {
    private int claimRes_id;
    private int claim_id;
    private int user_id;
    private String user_name;
    private String user_fullname;
    private Date createDate;
    private String description;
    private String related_img;
    private String related_file;
    private String action_type; // 'approve', 'reject', or 'review'

    public ClaimsRes() {
    }

    public ClaimsRes(int claimRes_id, int claim_id, int user_id, Date createDate, String description, String related_img, String related_file) {
        this.claimRes_id = claimRes_id;
        this.claim_id = claim_id;
        this.user_id = user_id;
        this.createDate = createDate;
        this.description = description;
        this.related_img = related_img;
        this.related_file = related_file;
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

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getUser_fullname() {
        return user_fullname;
    }

    public void setUser_fullname(String user_fullname) {
        this.user_fullname = user_fullname;
    }

    public String getAction_type() {
        return action_type;
    }

    public void setAction_type(String action_type) {
        this.action_type = action_type;
    }
}
