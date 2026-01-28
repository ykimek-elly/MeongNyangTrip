package com.team.meongnyang.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param; // [중요] 이 import가 꼭 있어야 합니다!

import com.team.meongnyang.dto.CommentDTO;
import com.team.meongnyang.dto.FeedDTO;
import com.team.meongnyang.dto.TalkCommentDTO;
import com.team.meongnyang.dto.TalkDTO;

@Mapper
public interface LoungeMapper {

    // ==========================================
    // 1. 피드 관련
    // ==========================================
    
    // [수정] 닉네임을 받아서 좋아요 여부(isLiked)까지 조회하도록 변경
    List<FeedDTO> selectAllFeeds(@Param("nickname") String nickname);
    
    void insertFeed(FeedDTO dto);
    
    // 피드 삭제 (본인 확인용 nickname 포함)
    void deleteFeed(@Param("feedId") int feedId, @Param("nickname") String nickname);
    
    // 피드 수정
    void updateFeed(FeedDTO dto);

    // ==========================================
    // ▼ [추가] 좋아요 기능 관련 메서드 (에러 해결 부분)
    // ==========================================
    
    // 좋아요 상태 확인 (1이면 누름, 0이면 안 누름)
    // 파라미터가 2개 이상일 때는 @Param을 꼭 붙여야 XML에서 #{feedId}, #{nickname}으로 인식합니다.
    int checkUserLike(@Param("feedId") int feedId, @Param("nickname") String nickname);

    // 좋아요 기록 추가 (DB: FEED_LIKE 테이블)
    void insertFeedLike(@Param("feedId") int feedId, @Param("nickname") String nickname);

    // 좋아요 기록 삭제 (DB: FEED_LIKE 테이블)
    void deleteFeedLike(@Param("feedId") int feedId, @Param("nickname") String nickname);

    // 피드 테이블의 좋아요 총 개수 증가 (+1)
    void plusLikeCount(int feedId);

    // 피드 테이블의 좋아요 총 개수 감소 (-1)
    void minusLikeCount(int feedId);

    // ==========================================

    // 2. 실시간 톡 관련
    List<TalkDTO> selectAllTalks();
    void insertTalk(TalkDTO dto);
    void deleteTalk(@Param("talkId") int talkId, @Param("nickname") String nickname);

    // 3. 피드 댓글 관련
    List<CommentDTO> selectAllComments();
    void insertComment(CommentDTO dto);
    // (필요 시 피드 댓글 삭제 메서드 추가: deleteComment)

    // 4. 톡 댓글 관련
    List<TalkCommentDTO> selectTalkComments(int talkId);
    void insertTalkComment(TalkCommentDTO dto);
    void deleteTalkComment(@Param("id") int id, @Param("nickname") String nickname);
}