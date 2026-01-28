package com.team.meongnyang.dto;

import java.time.LocalDateTime;

public class FeedDTO {

	private Long feedId;
	private String nickname;
	private String content;
	private String imageUrl;

	private int likeCount;
	private boolean isLiked; 

	private LocalDateTime createdAt;
	private String timeAgo; // "2시간 전" 표시용

	private Integer placeId; // 지도 연동용 ID
	private String placeName; // 장소 이름
	
    private int commentCount; // 댓글 개수

	public FeedDTO() {}

	public Long getFeedId() { return feedId; }
	public void setFeedId(Long feedId) { this.feedId = feedId; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }

	public String getContent() { return content; }
	public void setContent(String content) { this.content = content; }

	public String getImageUrl() { return imageUrl; }
	public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

	public int getLikeCount() { return likeCount; }
	public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

	public boolean isLiked() { return isLiked; }
	public void setLiked(boolean liked) { isLiked = liked; }

	public LocalDateTime getCreatedAt() { return createdAt; }
	public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

	public String getTimeAgo() { return timeAgo; }
	public void setTimeAgo(String timeAgo) { this.timeAgo = timeAgo; }

	public Integer getPlaceId() { return placeId; }
	public void setPlaceId(Integer placeId) { this.placeId = placeId; }

	public String getPlaceName() { return placeName; }
	public void setPlaceName(String placeName) { this.placeName = placeName; }
	
	public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
}