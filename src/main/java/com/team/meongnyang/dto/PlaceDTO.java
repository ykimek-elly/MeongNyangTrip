package com.team.meongnyang.dto;

public class PlaceDTO {
    // 1. 기본 정보 (리스트 및 공통 사용)
    private int id;              // DB PK
    private String title;        // 장소명
    private String cat;          // 카테고리 (place, stay, dining)
    private String loc;          // 주소 (위치)
    private String img;          // 대표 이미지
    private double rating;       // 평점
    private int reviewCount;     // 리뷰 개수
    private String contentId;    // 공공 API 고유 ID (중복 검사 및 상세 조회용)
    
    // 2. 상세 정보 (상세 페이지용 - 추가된 필드)
    private String desc;        // 소개글 (개요/설명)
    private String tel;         // 전화번호
    private String homepage;    // 홈페이지 URL
    private String parking;     // 주차 가능 여부
    private String usageTime;   // 이용 시간
    
    // 좌표 정보 (경도, 위도)
    private double mapX; // 경도 (Longitude)
    private double mapY; // 위도 (Latitude)
    
    private String facilityInfo; // 시설 정보 저장용 필드 추가

    // 기본 생성자
    public PlaceDTO() {}

    // 리스트용 생성자 (기존 유지)
    public PlaceDTO(int id, String title, String cat, String loc, String img, double rating, int reviewCount) {
        this.id = id; 
        this.title = title; 
        this.cat = cat; 
        this.loc = loc; 
        this.img = img; 
        this.rating = rating; 
        this.reviewCount = reviewCount;
    }
    
    // ================= Getter & Setter =================

    // 기본 정보 Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getCat() { return cat; }
    public void setCat(String cat) { this.cat = cat; }
    
    public String getLoc() { return loc; }
    public void setLoc(String loc) { this.loc = loc; }
    
    public String getImg() { return img; }
    public void setImg(String img) { this.img = img; }
    
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    
    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    
    public String getContentId() { return contentId; }
    public void setContentId(String contentId) { this.contentId = contentId; }

    public String getDesc() { return desc; }
    public void setDesc(String desc) { this.desc = desc; }
    
    public String getTel() { return tel; }
    public void setTel(String tel) { this.tel = tel; }
    
    public String getHomepage() { return homepage; }
    public void setHomepage(String homepage) { this.homepage = homepage; }
    
    public String getParking() { return parking; }
    public void setParking(String parking) { this.parking = parking; }
    
    public String getUsageTime() { return usageTime; }
    public void setUsageTime(String usageTime) { this.usageTime = usageTime; }
    
    public double getMapX() { return mapX; }
    public void setMapX(double mapX) { this.mapX = mapX; }
    public double getMapY() { return mapY; }
    public void setMapY(double mapY) { this.mapY = mapY; }
    
    public String getFacilityInfo() {
        return facilityInfo;
    }

    public void setFacilityInfo(String facilityInfo) {
        this.facilityInfo = facilityInfo;
    }
}