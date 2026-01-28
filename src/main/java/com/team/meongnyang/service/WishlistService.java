package com.team.meongnyang.service;

import com.team.meongnyang.dto.PlaceDTO;
import com.team.meongnyang.dto.WishlistDTO;
import com.team.meongnyang.mapper.WishlistMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WishlistService {

    @Autowired
    private WishlistMapper wishlistMapper;

    // 1. 찜 토글 기능
    public String toggleWish(String memberId, int placeId) {
        WishlistDTO dto = new WishlistDTO(memberId, placeId);
        int count = wishlistMapper.checkWish(dto);
        
        if (count > 0) {
            wishlistMapper.deleteWish(dto);
            return "off";
        } else {
            wishlistMapper.insertWish(dto);
            return "on";
        }
    }
    
    // 2. 찜 여부 확인 (상세페이지용)
    public boolean isWished(String memberId, int placeId) {
        return wishlistMapper.checkWish(new WishlistDTO(memberId, placeId)) > 0;
    }

    // 3. [이게 없어서 에러남] 마이페이지용 찜 목록 가져오기
    public List<PlaceDTO> getMyWishlist(String memberId) {
        return wishlistMapper.selectWishlistPlaces(memberId);
    }
}