package com.team.meongnyang.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team.meongnyang.dto.TalkCommentDTO;
import com.team.meongnyang.dto.TalkDTO;
import com.team.meongnyang.mapper.LoungeMapper;

@Service
public class TalkService {

    @Autowired
    private LoungeMapper loungeMapper;

    // 1. 글쓰기 (DB에 즉시 저장)
    public void addTalk(TalkDTO dto) {
        if (dto.getCreatedAt() == null) {
            dto.setCreatedAt(LocalDateTime.now());
        }
        if(dto.getBgColor() == null || dto.getBgColor().isEmpty()) {
            dto.setBgColor("yellow");
        }
        
        // DB에 저장 (서버 꺼져도 안전함)
        loungeMapper.insertTalk(dto);
    }

    // 2. 삭제 (DB에서 즉시 삭제)
    public boolean deleteTalk(int talkId, String nickname) {
        try {
            // 삭제 시도
            loungeMapper.deleteTalk(talkId, nickname);
            return true; // 에러 안 나면 성공으로 간주
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. 목록 조회 (DB에서 불러옴)
    public List<TalkDTO> getRecentTalks() {
        List<TalkDTO> list = loungeMapper.selectAllTalks();
        
        // 시간 계산 ("방금 전" 등)
        if(list != null) {
            for (TalkDTO talk : list) {
                talk.setTimeAgo(calcTimeAgo(talk.getCreatedAt()));
            }
        }
        return list;
    }

    // 시간 계산 유틸리티
    private String calcTimeAgo(LocalDateTime createdAt) {
        if (createdAt == null) return "방금 전";
        Duration duration = Duration.between(createdAt, LocalDateTime.now());
        if (duration.toMinutes() < 1) return "방금 전";
        if (duration.toMinutes() < 60) return duration.toMinutes() + "분 전";
        long hours = duration.toHours();
        if (hours < 24) return hours + "시간 전";
        return (hours / 24) + "일 전";
    }
    
    // 1. 댓글 목록 조회
    public List<TalkCommentDTO> getComments(int talkId) {
        return loungeMapper.selectTalkComments(talkId);
    }

    // 2. 댓글 작성
    public void addComment(TalkCommentDTO dto) {
        loungeMapper.insertTalkComment(dto);
    }

    // 3. 댓글 삭제
    public boolean deleteComment(int id, String nickname) {
        try {
            loungeMapper.deleteTalkComment(id, nickname);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    
}