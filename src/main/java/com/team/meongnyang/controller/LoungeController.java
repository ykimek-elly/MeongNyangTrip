package com.team.meongnyang.controller;

import java.io.File;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.team.meongnyang.dto.CommentDTO;
import com.team.meongnyang.dto.FeedDTO;
import com.team.meongnyang.dto.MemberDTO;
import com.team.meongnyang.dto.TalkCommentDTO;
import com.team.meongnyang.dto.TalkDTO;
import com.team.meongnyang.service.FeedService;
import com.team.meongnyang.service.TalkService;

@Controller
@RequestMapping("/lounge")
public class LoungeController {

    @Autowired private FeedService feedService;
    @Autowired private TalkService talkService;

    // 1. 라운지 메인 화면
    @RequestMapping(value = "", method = RequestMethod.GET)
    public String loungeMain(Model model, HttpSession session) {
        // 로그인 정보 확인
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        String nickname = (loginUser != null) ? loginUser.getNickname() : ""; // 비로그인이면 빈 문자열

        // nickname을 넘겨서 isLiked 여부를 함께 조회하도록 서비스 호출 변경 필요
        // (FeedService.getAllFeeds 메서드에도 파라미터 추가 필요)
        model.addAttribute("feedList", feedService.getAllFeeds(nickname)); 
        
        model.addAttribute("talkList", talkService.getRecentTalks());
        model.addAttribute("activeTab", "lounge");
        return "lounge";
    }

    // 2. 피드 작성 페이지 (GET)
    @RequestMapping(value = "/write/feed", method = RequestMethod.GET)
    public String writeFeedPage(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login";
        return "lounge_write_feed";
    }

    // 3. 피드 작성 처리 (POST)
    @RequestMapping(value = "/write/feed", method = RequestMethod.POST)
    public String writeFeedProc(@RequestParam("content") String content,
                                @RequestParam("imageFile") MultipartFile imageFile,
                                @RequestParam(value = "placeId", required = false) Integer placeId,
                                @RequestParam(value = "placeName", required = false) String placeName,
                                HttpSession session, HttpServletRequest request) {
        
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        FeedDTO dto = new FeedDTO();
        dto.setContent(content);
        dto.setNickname(loginUser.getNickname());
        
        if (placeId != null) dto.setPlaceId(placeId);
        if (placeName != null) dto.setPlaceName(placeName);

        // 이미지 파일 처리
        if (!imageFile.isEmpty()) {
            try {
                // 저장 경로 설정
                String path = request.getServletContext().getRealPath("/resources/upload");
                File folder = new File(path);
                if (!folder.exists()) folder.mkdirs();

                String originalName = imageFile.getOriginalFilename();
                String saveName = UUID.randomUUID() + "_" + originalName;
                
                imageFile.transferTo(new File(path, saveName));
                
                // DTO에 웹 접근 경로 저장
                dto.setImageUrl(request.getContextPath() + "/resources/upload/" + saveName);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        feedService.addFeed(dto);
        return "redirect:/lounge";
    }
    
    // 4. 톡 작성 페이지 (GET)
    @RequestMapping(value = "/write/talk", method = RequestMethod.GET)
    public String writeTalkPage(HttpSession session) {
        if (session.getAttribute("loginUser") == null) return "redirect:/login";
        return "lounge_write_talk";
    }
    
    // 5. 톡 작성 처리 (POST)
    @RequestMapping(value = "/write/talk", method = RequestMethod.POST)
    public String writeTalkProc(TalkDTO dto, HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";
        
        dto.setNickname(loginUser.getNickname());
        talkService.addTalk(dto);
        
        return "redirect:/lounge?tab=talk";
    }

    // 6. 댓글 화면 (댓글 리스트)
    @RequestMapping(value = "/comments", method = RequestMethod.GET)
    public String commentsPage(@RequestParam("feedId") int feedId, Model model) {
        model.addAttribute("commentList", feedService.getCommentsByFeedId(feedId));
        model.addAttribute("feed", feedService.getFeedById(feedId));
        model.addAttribute("feedId", feedId);
        return "lounge_comments";
    }

    // 7. 댓글 등록 (AJAX - POST)
    @RequestMapping(value = "/addComment", method = RequestMethod.POST)
    @ResponseBody
    public String addComment(@RequestParam("feedId") long feedId,
                             @RequestParam("content") String content,
                             HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "login_needed";

        CommentDTO comment = new CommentDTO();
        comment.setFeedId(feedId);
        comment.setContent(content);
        comment.setNickname(loginUser.getNickname());

        feedService.addComment(comment);
        return "success";
    }

    // 8. 댓글 삭제 (AJAX - POST)
    @RequestMapping(value = "/deleteComment", method = RequestMethod.POST)
    @ResponseBody
    public String deleteComment(@RequestParam("feedId") int feedId,
                                @RequestParam("commentId") long commentId,
                                HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "fail";

        boolean isDeleted = feedService.deleteComment(feedId, commentId, loginUser.getNickname());
        return isDeleted ? "success" : "fail";
    }
    
    // 9. 좋아요 토글 (AJAX - POST)
    @RequestMapping(value = "/toggleLike", method = RequestMethod.POST)
    @ResponseBody
    public String toggleLike(@RequestParam("feedId") int feedId, HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "fail"; // 비로그인 시 실패 처리

        // 닉네임과 함께 서비스 호출
        feedService.toggleLike(feedId, loginUser.getNickname());
        return "success";
    }
    // 실시간 톡 삭제
    @RequestMapping(value = "/delete/talk", method = RequestMethod.POST)
    @ResponseBody
    public String deleteTalk(@RequestParam("talkId") int talkId, HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "fail";
        
        // 서비스 호출 (성공 시 success 반환)
        boolean success = talkService.deleteTalk(talkId, loginUser.getNickname());
        return success ? "success" : "fail";
    }
    
    // 피드 삭제 API
    @RequestMapping(value = "/delete/feed", method = RequestMethod.POST)
    @ResponseBody
    public String deleteFeed(@RequestParam("feedId") int feedId, HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "fail";
        
        // 서비스 호출 (본인 확인 포함)
        boolean success = feedService.deleteFeed(feedId, loginUser.getNickname());
        return success ? "success" : "fail";
    }
    
    // 10. 피드 수정 페이지 이동 (GET)
    @RequestMapping(value = "/edit/feed", method = RequestMethod.GET)
    public String editFeedPage(@RequestParam("feedId") int feedId, HttpSession session, Model model) {
        // 1. 로그인 체크
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        // 2. 기존 피드 정보 가져오기
        FeedDTO feed = feedService.getFeedById(feedId);

        // 3. 본인 글인지 확인 (다르면 라운지로 튕겨내기)
        if (feed == null || !feed.getNickname().equals(loginUser.getNickname())) {
            return "redirect:/lounge"; 
        }

        model.addAttribute("feed", feed);
        return "lounge_edit_feed"; // 수정용 JSP 페이지 (4단계에서 만듦)
    }

    // 11. 피드 수정 처리 (POST)
    @RequestMapping(value = "/edit/feed", method = RequestMethod.POST)
    public String editFeedProc(FeedDTO dto, 
                               @RequestParam("imageFile") MultipartFile imageFile,
                               HttpSession session, HttpServletRequest request) {
        
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";
        
        // 닉네임 세팅 (본인 확인용)
        dto.setNickname(loginUser.getNickname());

        // 새 이미지가 있으면 업로드 처리
        if (!imageFile.isEmpty()) {
            try {
                String path = request.getServletContext().getRealPath("/resources/upload");
                File folder = new File(path);
                if (!folder.exists()) folder.mkdirs();

                String saveName = UUID.randomUUID() + "_" + imageFile.getOriginalFilename();
                imageFile.transferTo(new File(path, saveName));
                
                dto.setImageUrl(request.getContextPath() + "/resources/upload/" + saveName);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // 새 이미지가 없으면 기존 이미지 유지 (null을 보내면 Mapper의 <if>문 덕분에 수정 안됨)
            dto.setImageUrl(null); 
        }
        
        feedService.updateFeed(dto);
        return "redirect:/lounge";
    }
    
    // [톡 댓글] 페이지 이동
    @RequestMapping(value = "/talk/comments", method = RequestMethod.GET)
    public String talkCommentsPage(@RequestParam("talkId") int talkId, Model model) {
        model.addAttribute("commentList", talkService.getComments(talkId));
        model.addAttribute("talkId", talkId);
        // 원본 글 정보도 필요하면 여기서 talkService.getTalkById(talkId) 호출
        return "lounge_talk_comments"; // 새 JSP 파일
    }

    // [톡 댓글] 등록 (AJAX)
    @RequestMapping(value = "/talk/addComment", method = RequestMethod.POST)
    @ResponseBody
    public String addTalkComment(TalkCommentDTO dto, HttpSession session) {
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
        if(user == null) return "fail";
        
        dto.setNickname(user.getNickname());
        talkService.addComment(dto);
        return "success";
    }

    // [톡 댓글] 삭제 (AJAX)
    @RequestMapping(value = "/talk/deleteComment", method = RequestMethod.POST)
    @ResponseBody
    public String deleteTalkComment(@RequestParam("id") int id, HttpSession session) {
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
        if(user == null) return "fail";
        
        boolean result = talkService.deleteComment(id, user.getNickname());
        return result ? "success" : "fail";
    }
    
    
}