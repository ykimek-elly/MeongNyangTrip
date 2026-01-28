package com.team.meongnyang.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; 
import org.apache.ibatis.annotations.Param;

import com.team.meongnyang.dto.CommentDTO;
import com.team.meongnyang.dto.FeedDTO;
import com.team.meongnyang.mapper.LoungeMapper;

@Service
public class FeedService {

	@Autowired
	private LoungeMapper loungeMapper;

	// 1. 피드 전체 조회 (DB) - [수정] 닉네임을 받아 좋아요 여부 확인
	public List<FeedDTO> getAllFeeds(String nickname) {
		// Mapper에 nickname을 전달하여 isLiked(좋아요 여부)까지 포함된 데이터를 가져옵니다.
		List<FeedDTO> list = loungeMapper.selectAllFeeds(nickname);
		
		// 시간 계산
		if (list != null) {
			for (FeedDTO feed : list) {
				feed.setTimeAgo(calcTimeAgo(feed.getCreatedAt()));
			}
		}
		return list;
	}

	// 2. 피드 상세 조회
	public FeedDTO getFeedById(int feedId) {
		// 편의상 전체 목록에서 검색 (비로그인 상태("")로 조회)
		List<FeedDTO> all = getAllFeeds(""); 
		for (FeedDTO f : all) {
			// feedId는 long일 수도 있으므로 타입에 맞춰 비교 (여기선 int로 가정)
			if (f.getFeedId() == feedId)
				return f;
		}
		return null;
	}

	// 3. 피드 작성 (DB 저장)
	public void addFeed(FeedDTO dto) {
		if (dto.getCreatedAt() == null) {
			dto.setCreatedAt(LocalDateTime.now());
		}
		loungeMapper.insertFeed(dto);
	}

	// 4. 댓글 관련
	public List<CommentDTO> getCommentsByFeedId(int feedId) {
		// TODO: 실제로는 WHERE feed_id = #{feedId} 쿼리를 사용하는 메서드로 교체하는 것이 좋습니다.
		return loungeMapper.selectAllComments();
	}

	public void addComment(CommentDTO dto) {
		if (dto.getCreatedAt() == null)
			dto.setCreatedAt(LocalDateTime.now());
		loungeMapper.insertComment(dto);
	}

	public boolean deleteComment(int feedId, long commentId, String nickname) {
		// TODO: Mapper에 deleteComment(commentId, nickname) 메서드가 있다면 주석 해제
		// loungeMapper.deleteComment(commentId, nickname);
		return true;
	}

	// 5. [수정] 좋아요 토글 로직 구현
	@Transactional // DB 작업이 여러 개(조회, 등록/삭제, 카운트수정)이므로 트랜잭션 필수
	public void toggleLike(int feedId, String nickname) {
		// 1. 유저가 이미 좋아요를 눌렀는지 확인
		int count = loungeMapper.checkUserLike(feedId, nickname);

		if (count > 0) {
			// 이미 눌렀음 -> 좋아요 취소
			loungeMapper.deleteFeedLike(feedId, nickname); // 기록 삭제
			loungeMapper.minusLikeCount(feedId);           // 카운트 감소
		} else {
			// 안 눌렀음 -> 좋아요 등록
			loungeMapper.insertFeedLike(feedId, nickname); // 기록 추가
			loungeMapper.plusLikeCount(feedId);            // 카운트 증가
		}
	}

	// 시간 계산 유틸
	private String calcTimeAgo(LocalDateTime createdAt) {
		if (createdAt == null)
			return "방금 전";
		Duration duration = Duration.between(createdAt, LocalDateTime.now());
		if (duration.toMinutes() < 1)
			return "방금 전";
		if (duration.toMinutes() < 60)
			return duration.toMinutes() + "분 전";
		long hours = duration.toHours();
		if (hours < 24)
			return hours + "시간 전";
		return (hours / 24) + "일 전";
	}

	// 피드 삭제 메서드
	public boolean deleteFeed(int feedId, String nickname) {
		try {
			loungeMapper.deleteFeed(feedId, nickname);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	// 피드 수정
    public void updateFeed(FeedDTO dto) {
        loungeMapper.updateFeed(dto);
    }
}