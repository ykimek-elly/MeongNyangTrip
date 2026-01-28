package com.team.meongnyang.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team.meongnyang.dto.MemberDTO;
import com.team.meongnyang.dto.PlaceDTO;
import com.team.meongnyang.service.MemberService;
import com.team.meongnyang.service.PlaceService;
import com.team.meongnyang.service.WishlistService;

@Controller
public class MainController {

    @Autowired
    private PlaceService placeService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private WishlistService wishlistService;

    // 1. 홈 화면
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home(Model model) {
        List<PlaceDTO> allPlaces = placeService.getPlaceList(null, "all");
        if (allPlaces.size() >= 6) {
            model.addAttribute("recommendPlaces", allPlaces.subList(0, 6));
        } else {
            model.addAttribute("recommendPlaces", allPlaces);
        }
        model.addAttribute("allPlaces", allPlaces);
        model.addAttribute("activeTab", "home");
        return "home";
    }

    // 2. 검색 및 리스트
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(@RequestParam(value = "category", defaultValue = "all") String category,
            @RequestParam(value = "region", required = false) String region,
            @RequestParam(value = "sort", defaultValue = "id") String sort,
            Model model) {

        List<PlaceDTO> result = placeService.getPlaceList(region, category);
        if (result != null && !result.isEmpty()) {
            switch (sort) {
                case "rating":
                    result.sort((p1, p2) -> Double.compare(p2.getRating(), p1.getRating()));
                    break;
                case "review":
                    result.sort((p1, p2) -> Integer.compare(p2.getReviewCount(), p1.getReviewCount()));
                    break;
                default:
                    result.sort((p1, p2) -> Integer.compare(p2.getId(), p1.getId()));
                    break;
            }
        }

        if (region != null && !region.isEmpty()) {
            model.addAttribute("searchMsg", "'" + region + "' 검색 결과: " + result.size() + "건");
        }
        model.addAttribute("places", result);
        model.addAttribute("activeCategory", category);
        model.addAttribute("sort", sort);
        model.addAttribute("activeTab", "list");
        return "list";
    }

    // 3. 상세 페이지
    @RequestMapping(value = "/detail/{id}", method = RequestMethod.GET)
    public String detail(@PathVariable("id") Long id, Model model, HttpSession session) {
        PlaceDTO place = placeService.getPlaceById(id);
        model.addAttribute("place", place);

        List<Map<String, Object>> reviews = placeService.getReviews(id);
        model.addAttribute("reviews", reviews);

        model.addAttribute("amenities", Arrays.asList("소형견", "운동장", "주차가능", "와이파이"));

        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser != null) {
            boolean isWished = wishlistService.isWished(loginUser.getId(), id.intValue());
            model.addAttribute("isWished", isWished);
        }

        List<String> hashtags = extractKeywords(place.getDesc());
        model.addAttribute("hashtags", hashtags);

        return "detail";
    }

    private List<String> extractKeywords(String text) {
        if (text == null || text.isEmpty())
            return Arrays.asList("여행", "반려동물");

        String cleaned = text.replaceAll("[^가-힣a-zA-Z0-9\\s]", " ")
                .replaceAll("(은|는|이|가|을|를|의|에|로|으로|하다|합니다|입니다)\\b", "");

        String[] words = cleaned.split("\\s+");

        List<String> keywords = new ArrayList<>();
        for (String word : words) {
            if (word.length() >= 2 && !keywords.contains(word)) {
                keywords.add(word);
            }
        }
        return keywords.size() > 5 ? keywords.subList(0, 5) : keywords;
    }

    // 4. 찜하기 토글
    @RequestMapping(value = "/toggleWish", method = RequestMethod.POST)
    @ResponseBody
    public String toggleWish(@RequestParam("placeId") int placeId, HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null)
            return "login_needed";
        return wishlistService.toggleWish(loginUser.getId(), placeId);
    }

    // 5. 로그인/로그아웃 처리
    @RequestMapping(value = "/loginProcess", method = RequestMethod.POST)
    public String loginProcess(@RequestParam("id") String id, @RequestParam("password") String password,
            HttpSession session) {
        MemberDTO loginUser = memberService.login(id, password);
        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser);
            return "redirect:/";
        } else {
            return "redirect:/login?error=true";
        }
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login() {
        return "login";
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // 6. 회원가입
    @RequestMapping(value = "/join", method = RequestMethod.GET)
    public String join() {
        return "join";
    }

    @RequestMapping(value = "/joinProcess", method = RequestMethod.POST)
    public String joinProcess(MemberDTO dto) {
        memberService.join(dto);
        return "redirect:/login";
    }

    // 7. 마이페이지 & 찜 목록
    @RequestMapping(value = "/wish", method = RequestMethod.GET)
    public String wishPage(Model model, HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser != null) {
            List<PlaceDTO> myWishlist = wishlistService.getMyWishlist(loginUser.getId());
            model.addAttribute("myWishlist", myWishlist);
            model.addAttribute("wishCount", myWishlist.size());
            model.addAttribute("activeTab", "wish");
            return "mypage";
        }
        return "redirect:/login";
    }

    @RequestMapping(value = "/mypage", method = RequestMethod.GET)
    public String mypage(Model model, HttpSession session) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser != null) {
            List<PlaceDTO> myWishlist = wishlistService.getMyWishlist(loginUser.getId());
            model.addAttribute("myWishlist", myWishlist);
            model.addAttribute("wishCount", myWishlist.size());
        }
        model.addAttribute("activeTab", "mypage");
        return "mypage";
    }

    // 8. 리뷰 등록 처리
    @RequestMapping(value = "/addReview", method = RequestMethod.POST)
    @ResponseBody
    public String addReview(
            @RequestParam("placeId") String placeId,
            @RequestParam("content") String content,
            @RequestParam("rating") String rating,
            HttpSession session) {

        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null)
            return "login_needed";

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("placeId", placeId);
            params.put("content", content);
            params.put("rating", rating);
            params.put("userId", loginUser.getId());

            boolean success = placeService.addReview(params);
            return success ? "success" : "fail";

        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    // 9. 멍냥지도
    @RequestMapping(value = "/map", method = RequestMethod.GET)
    public String map(Model model) {
        model.addAttribute("activeTab", "map");
        return "map";
    }

    // 10. 아이디 찾기
    @RequestMapping(value = "/findId", method = RequestMethod.GET)
    public String findIdPage() {
        return "find_id";
    }

    @RequestMapping(value = "/findIdProcess", method = RequestMethod.POST)
    public String findIdProcess(MemberDTO dto, Model model) {
        String foundId = memberService.findId(dto);
        if (foundId != null) {
            model.addAttribute("msg", "회원님의 아이디는 <strong>" + foundId + "</strong> 입니다.");
            model.addAttribute("success", true);
        } else {
            model.addAttribute("msg", "일치하는 회원 정보를 찾을 수 없습니다.");
            model.addAttribute("success", false);
        }
        return "find_result";
    }

    // 11. 비밀번호 찾기
    @RequestMapping(value = "/findPw", method = RequestMethod.GET)
    public String findPwPage() {
        return "find_pw";
    }

    @RequestMapping(value = "/findPwProcess", method = RequestMethod.POST)
    public String findPwProcess(MemberDTO dto, Model model) {
        String foundPw = memberService.findPassword(dto);
        if (foundPw != null) {
            model.addAttribute("msg", "회원님의 비밀번호는 <strong>" + foundPw + "</strong> 입니다.");
            model.addAttribute("success", true);
        } else {
            model.addAttribute("msg", "일치하는 회원 정보를 찾을 수 없습니다.");
            model.addAttribute("success", false);
        }
        return "find_result";
    }
    
    // 12. 지도 API (장소 데이터)
    @RequestMapping(value = "/api/places", method = RequestMethod.GET)
    @ResponseBody
    public List<PlaceDTO> getMapPlaces() {
        return placeService.getPlaceList(null, "all"); 
    }
    
    // 13. 장소 검색 API (피드 작성 시 호출됨)
    @RequestMapping(value = "/place/api/search/list", method = RequestMethod.GET)
    @ResponseBody
    public List<PlaceDTO> searchPlaceList(@RequestParam("keyword") String keyword) {
        // PlaceService에 searchPlaces 메서드가 있어야 합니다.
        // 없다면 placeService.getPlaceList(keyword, "all") 등으로 대체 가능 여부 확인
        return placeService.getPlaceList(keyword, "all"); 
    }
    
	
}