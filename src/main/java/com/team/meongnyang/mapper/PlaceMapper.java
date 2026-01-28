package com.team.meongnyang.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.team.meongnyang.dto.PlaceDTO;

@Mapper //  이 어노테이션이 있어야 MyBatis가 인식합니다.
public interface PlaceMapper {

    // 1. 초기 데이터 구축용
    void insertPlace(PlaceDTO place);
    int countByContentId(String contentId);
    int countAll(); 

    // 2. 서비스 기능용 (검색, 리스트, 상세)
    // MyBatis에서 파라미터가 2개 이상일 때는 @Param을 붙여주는 것이 안전합니다.
    List<PlaceDTO> selectPlaceList(@Param("region") String region, @Param("category") String category);

    PlaceDTO selectPlaceById(Long id);
    void updatePlaceDesc(PlaceDTO place);
    
    // 3. 리뷰 관련 기능
    List<Map<String, Object>> selectReviewsByPlaceId(Long placeId);
    int insertReview(Map<String, Object> params); // 리뷰 저장
    void updatePlaceStats(Long placeId);         // 별점/개수 동기화
}