package com.team.meongnyang.dto;

import java.time.LocalDateTime;

public class TalkDTO {
	private int talkId;
    private String nickname;
    private String content;
    private String locationName;
    private String bgColor; 
    private LocalDateTime createdAt;
    private String timeAgo;
	
    public TalkDTO() {}
    
    public int getTalkId() { return talkId; }
    public void setTalkId(int talkId) { this.talkId = talkId; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }

	public String getContent() { return content; }
	public void setContent(String content) { this.content = content; }

	public String getLocationName() { return locationName; }
	public void setLocationName(String locationName) { this.locationName = locationName; }
    
    public String getBgColor() { return bgColor; }
    public void setBgColor(String bgColor) { this.bgColor = bgColor; }

	public LocalDateTime getCreatedAt() { return createdAt; }
	public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

	public String getTimeAgo() { return timeAgo; }
	public void setTimeAgo(String timeAgo) { this.timeAgo = timeAgo; }
}