package com.team.meongnyang.dto;

import java.time.LocalDateTime;

public class TalkCommentDTO {
    private int id;           // 댓글 고유 번호
    private int talkId;       // 어떤 톡에 달린 댓글인지
    private String nickname;  // 작성자
    private String content;   // 내용
    private LocalDateTime regDate;
    
    // 생성자 & Getter/Setter
    public TalkCommentDTO() {}
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getTalkId() { return talkId; }
    public void setTalkId(int talkId) { this.talkId = talkId; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public LocalDateTime getRegDate() { return regDate; }
    public void setRegDate(LocalDateTime regDate) { this.regDate = regDate; }
}