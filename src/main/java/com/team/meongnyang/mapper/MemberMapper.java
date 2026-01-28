package com.team.meongnyang.mapper;

import com.team.meongnyang.dto.MemberDTO;

public interface MemberMapper {
    // 1. 회원 정보 조회 (로그인 체크용)
    MemberDTO selectMemberById(String id);

    // 2. 회원가입 (선택 사항)
    void insertMember(MemberDTO member);

    // 3. 아이디 찾기
    String findId(MemberDTO member);

    // 4. 비밀번호 찾기
    String findPassword(MemberDTO member);
}