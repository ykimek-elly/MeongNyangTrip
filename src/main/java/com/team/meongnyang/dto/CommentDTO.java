package com.team.meongnyang.dto;

import java.time.LocalDateTime;

public class CommentDTO {
    private Long commentId;
    private Long feedId;
    private String nickname;
    private String content;
    private LocalDateTime createdAt;
    private String timeAgo;
    
	public CommentDTO() {}

    public Long getCommentId() { return commentId; }
    public void setCommentId(Long commentId) { this.commentId = commentId; }

	public Long getFeedId() { return feedId; }
	public void setFeedId(Long feedId) { this.feedId = feedId; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }

	public String getContent() { return content; }
	public void setContent(String content) { this.content = content; }

	public LocalDateTime getCreatedAt() { return createdAt; }
	public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

	public String getTimeAgo() { return timeAgo; }
	public void setTimeAgo(String timeAgo) { this.timeAgo = timeAgo; }
}