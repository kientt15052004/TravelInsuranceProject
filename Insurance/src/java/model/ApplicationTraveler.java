package model;

import java.sql.Date;

public class ApplicationTraveler {
    private int id;
    private int application_id;
    private String name;
    private String gender;
    private int cccd_id;
    private Date dob;
    private int age;
    private String phone;
    private String email;

    public ApplicationTraveler() {
    }

    public ApplicationTraveler(int id, int application_id, String name, String gender, int cccd_id, Date dob, int age, String phone, String email) {
        this.id = id;
        this.application_id = application_id;
        this.name = name;
        this.gender = gender;
        this.cccd_id = cccd_id;
        this.dob = dob;
        this.age = age;
        this.phone = phone;
        this.email = email;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getApplication_id() {
        return application_id;
    }

    public void setApplication_id(int application_id) {
        this.application_id = application_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getCccd_id() {
        return cccd_id;
    }

    public void setCccd_id(int cccd_id) {
        this.cccd_id = cccd_id;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}