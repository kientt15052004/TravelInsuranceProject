package Model;

import java.io.Serializable;
import java.time.LocalDate;

public class User implements Serializable {
    private int id;
    private String username;
    private String password;
    private String fullname;
    private String mail;
    private LocalDate dob;
    private String address;
    private String phone;
    private String cccd;
    private String avatar;
    private String role;
    private String cccd_img;
    private String status;

    public User() {
    }

    public User(int id, String username, String password, String fullname, String mail, LocalDate dob, String address, String phone, String cccd, String avatar, String role, String cccd_img, String status) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.mail = mail;
        this.dob = dob;
        this.address = address;
        this.phone = phone;
        this.cccd = cccd;
        this.avatar = avatar;
        this.role = role;
        this.cccd_img = cccd_img;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getMail() {
        return mail;
    }

    public void setMail(String mail) {
        this.mail = mail;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getCccd_img() {
        return cccd_img;
    }

    public void setCccd_img(String cccd_img) {
        this.cccd_img = cccd_img;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
