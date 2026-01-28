package com.team.meongnyang.service;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.team.meongnyang.dto.MemberDTO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml" })
public class MemberServiceTest {

    @Autowired
    private MemberService memberService;

    @Test
    @Transactional // 테스트 후 DB 롤백 (데이터 안 남음)
    public void testJoinAndLogin() {
        // 1. 회원가입 테스트 데이터 준비
        MemberDTO newMember = new MemberDTO();
        newMember.setId("testuser@test.com");
        newMember.setPassword("123456");
        newMember.setNickname("테스트유저");
        newMember.setDogName("멍멍이");
        newMember.setDogSize("SMALL");
        newMember.setDogBreed("말티즈");
        newMember.setPersonality("ACTIVE");
        newMember.setPreferredPlace("NATURE");

        // 2. 가입 실행
        memberService.join(newMember);

        // 3. 로그인 검증
        MemberDTO loginUser = memberService.login("testuser@test.com", "123456");
        assertNotNull("로그인 성공 시 정보가 반환되어야 함", loginUser);
        assertEquals("닉네임 일치 확인", "테스트유저", loginUser.getNickname());

        // 4. 실패 케이스 검증
        MemberDTO failUser = memberService.login("testuser@test.com", "wrongpw");
        assertNull("비밀번호 틀리면 null 반환", failUser);
    }

    @Test
    @Transactional
    public void testFindIdAndPw() {
        // 1. 데이터 준비 및 가입
        MemberDTO member = new MemberDTO();
        member.setId("findtest@test.com");
        member.setPassword("findpw123");
        member.setNickname("찾기테스트");
        member.setDogName("찾기견");
        memberService.join(member);

        // 2. 아이디 찾기 검증
        MemberDTO searchDto = new MemberDTO();
        searchDto.setNickname("찾기테스트");
        searchDto.setDogName("찾기견");

        String foundId = memberService.findId(searchDto);
        assertEquals("아이디 찾기 결과 일치", "findtest@test.com", foundId);

        // 3. 비밀번호 찾기 검증
        searchDto.setId("findtest@test.com");
        searchDto.setDogName("찾기견");

        String foundPw = memberService.findPassword(searchDto);
        assertEquals("비밀번호 찾기 결과 일치", "findpw123", foundPw);
    }
}
