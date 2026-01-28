package com.team.meongnyang.service;

import com.team.meongnyang.dto.MemberDTO;
import com.team.meongnyang.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberService {

    @Autowired
    private MemberMapper memberMapper;

    // 로그인 체크 기능
    public MemberDTO login(String id, String password) {
        // 1. DB에서 아이디로 회원 정보 가져오기
        MemberDTO member = memberMapper.selectMemberById(id);

        // 2. 회원이 존재하고, 비밀번호가 일치하는지 확인
        if (member != null && member.getPassword().equals(password)) {
            return member; // 로그인 성공! (회원정보 반환)
        }

        return null; // 로그인 실패
    }

    // 회원가입
    public void join(MemberDTO member) {
        memberMapper.insertMember(member);
    }

    // 아이디 찾기
    public String findId(MemberDTO member) {
        return memberMapper.findId(member);
    }

    // 비밀번호 찾기
    public String findPassword(MemberDTO member) {
        return memberMapper.findPassword(member);
    }

}