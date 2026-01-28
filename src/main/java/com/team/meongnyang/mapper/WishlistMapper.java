package com.team.meongnyang.mapper;

import com.team.meongnyang.dto.WishlistDTO;
import java.util.List;

public interface WishlistMapper {
    // 1. 찜 추가
    void insertWish(WishlistDTO wish);

    // 2. 찜 취소 (삭제)
    void deleteWish(WishlistDTO wish);

    // 3. 내가 이 장소를 찜했는지 확인 (결과가 1이면 찜한 것, 0이면 안 한 것)
    int checkWish(WishlistDTO wish);
    
    // 4. 내가 찜한 장소 목록 가져오기 (마이페이지용)
    List<Integer> selectMyWishList(String memberId);
    
    // 5. 내가 찜한 장소들의 상세 정보 가져오기 (PlaceDTO 리스트 반환)
    List<com.team.meongnyang.dto.PlaceDTO> selectWishlistPlaces(String memberId);
}