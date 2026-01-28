package com.team.meongnyang.dto;

import java.util.Date;

public class MemberDTO {
    private String id;
    private String password;
    private String nickname;       
    private String dogName;        
    private String dogSize;        
    private String dogBreed;       
    private String personality;    
    private String preferredPlace; 
    private Date regDate;

    public MemberDTO() {}

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getDogName() { return dogName; }
    public void setDogName(String dogName) { this.dogName = dogName; }
    public String getDogSize() { return dogSize; }
    public void setDogSize(String dogSize) { this.dogSize = dogSize; }
    public String getDogBreed() { return dogBreed; }
    public void setDogBreed(String dogBreed) { this.dogBreed = dogBreed; }
    public String getPersonality() { return personality; }
    public void setPersonality(String personality) { this.personality = personality; }
    public String getPreferredPlace() { return preferredPlace; }
    public void setPreferredPlace(String preferredPlace) { this.preferredPlace = preferredPlace; }
    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }
}