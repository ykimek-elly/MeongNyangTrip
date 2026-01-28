package com.team.meongnyang.dto;

public class WishlistDTO {
    private int no;
    private String memberId;
    private int placeId;
    
    // 기본 생성자
    public WishlistDTO() {}
    
    // 생성자
    public WishlistDTO(String memberId, int placeId) {
        this.memberId = memberId;
        this.placeId = placeId;
    }

    // Getter & Setter
    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }
    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }
    public int getPlaceId() { return placeId; }
    public void setPlaceId(int placeId) { this.placeId = placeId; }
}