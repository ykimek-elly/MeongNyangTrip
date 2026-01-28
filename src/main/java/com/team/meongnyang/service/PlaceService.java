package com.team.meongnyang.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.team.meongnyang.dto.PlaceDTO;
import com.team.meongnyang.mapper.PlaceMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;

import org.springframework.transaction.annotation.Transactional;

@Service
public class PlaceService {

    @Autowired
    private PlaceMapper placeMapper;

    private final String API_KEY = "dcdb89720c4eaa48b8c86bd53b5eb4fdda5aa8257f70d20b8f2116706ec50322";

    // 1. 목록 조회 (DB가 비어있으면 카테고리별 수집 시작)
    public List<PlaceDTO> getPlaceList(String region, String category) {
        if (placeMapper.countAll() == 0) {
            System.out.println(">>> [최초 수집] 카테고리별 데이터 수집을 시작합니다...");
            fetchAndSaveApiData(); 
        }
        return placeMapper.selectPlaceList(region, category);
    }
    
    // 2. 상세 조회
    public PlaceDTO getPlaceById(Long id) {
        PlaceDTO place = placeMapper.selectPlaceById(id);
        if (place != null) {
            String desc = place.getDesc();
            if (desc == null || desc.trim().isEmpty() || "-".equals(desc.trim())) {
                fetchPlaceDetail(place);
                place = placeMapper.selectPlaceById(id);
            }
        }
        return place;
    }

    // 카테고리별 분할 수집 로직
    public void fetchAndSaveApiData() {
        String[] categories = {"32", "39", "12"};
        int perCategoryLimit = 50; 

        try {
            for (String catCode : categories) {
                StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorPetTourService2/areaBasedList2");
                urlBuilder.append("?serviceKey=" + API_KEY);
                urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + perCategoryLimit);
                urlBuilder.append("&" + URLEncoder.encode("contentTypeId","UTF-8") + "=" + catCode);
                urlBuilder.append("&MobileOS=ETC&MobileApp=MeongNyang&_type=json");

                String jsonString = callApi(urlBuilder.toString());
                parseAndSave(jsonString);
            }
            System.out.println(">>> [완료] 이미지가 포함된 데이터 위주로 수집 성공");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ [수정] 이미지가 없는 데이터는 저장을 건너뜁니다.
    private void parseAndSave(String jsonString) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(jsonString);
            JsonNode items = root.path("response").path("body").path("items").path("item");

            if (items.isArray()) {
                for (JsonNode item : items) {
                    // 1. 이미지 존재 여부 우선 체크
                    String img = item.path("firstimage").asText();
                    
                    // 이미지가 null이거나 빈 문자열이면 저장을 하지 않고 다음 데이터로 넘어감
                    if (img == null || img.trim().isEmpty()) {
                        continue; 
                    }

                    // 2. 중복 체크
                    String contentId = item.path("contentid").asText();
                    if (placeMapper.countByContentId(contentId) > 0) continue; 

                    PlaceDTO place = new PlaceDTO();
                    place.setContentId(contentId);
                    place.setTitle(item.path("title").asText());
                    place.setLoc(item.path("addr1").asText());
                    place.setMapX(item.path("mapx").asDouble(0.0));
                    place.setMapY(item.path("mapy").asDouble(0.0));
                    place.setImg(img); // 이미지가 있는 것이 확인된 값 세팅

                    // 카테고리 코드 변환
                    String typeId = item.path("contenttypeid").asText();
                    if ("32".equals(typeId)) place.setCat("stay");
                    else if ("39".equals(typeId)) place.setCat("dining");
                    else place.setCat("place"); 
                    
                    // 초기 별점 및 리뷰수는 이전과 동일하게 랜덤 세팅 유지
                    place.setRating(Math.round((3.5 + Math.random() * 1.5) * 10) / 10.0);
                    place.setReviewCount((int)(Math.random() * 100));
                    
                    placeMapper.insertPlace(place);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 상세 정보 및 시설 정보 수집 로직 (기존 유지)
    private void fetchPlaceDetail(PlaceDTO place) {
        try {
            StringBuilder urlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorPetTourService2/detailCommon2");
            urlBuilder.append("?serviceKey=" + API_KEY + "&MobileOS=ETC&MobileApp=MeongNyang&_type=json&contentId=" + place.getContentId());
            
            String commonJson = callApi(urlBuilder.toString());
            ObjectMapper mapper = new ObjectMapper();
            JsonNode commonItem = mapper.readTree(commonJson).path("response").path("body").path("items").path("item").get(0);

            if (commonItem != null) {
                String overview = commonItem.path("overview").asText().replaceAll("<[^>]*>", "").trim();
                place.setDesc((overview.isEmpty() || "-".equals(overview)) ? "반려견과 함께하기 좋은 공간입니다." : overview);
                place.setTel(commonItem.path("tel").asText());
                
                String rawHp = commonItem.path("homepage").asText();
                java.util.regex.Pattern p = java.util.regex.Pattern.compile("href=\"(.*?)\"");
                java.util.regex.Matcher m = p.matcher(rawHp);
                place.setHomepage(m.find() ? m.group(1) : rawHp.replaceAll("<[^>]*>", ""));
            }

            StringBuilder petUrlBuilder = new StringBuilder("http://apis.data.go.kr/B551011/KorPetTourService2/detailPetTour2");
            petUrlBuilder.append("?serviceKey=" + API_KEY + "&MobileOS=ETC&MobileApp=MeongNyang&_type=json&contentId=" + place.getContentId());
            String petJson = callApi(petUrlBuilder.toString());
            JsonNode petItem = mapper.readTree(petJson).path("response").path("body").path("items").path("item").get(0);

            if (petItem != null) {
                StringBuilder tags = new StringBuilder();
                String size = petItem.path("acmpyTypeCd").asText();
                String info = petItem.path("relaPosesICmpy").asText();
                if(!size.isEmpty()) tags.append(size).append(",");
                if(!info.isEmpty()) tags.append(info).append(",");
                place.setFacilityInfo(tags.toString());
            }

            placeMapper.updatePlaceDesc(place); 
        } catch (Exception e) { e.printStackTrace(); }
    }

    private String callApi(String urlStr) throws Exception {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(4000);
        conn.setReadTimeout(4000);
        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) sb.append(line);
        rd.close();
        return sb.toString();
    }
    
    public List<Map<String, Object>> getReviews(Long placeId) {
        List<Map<String, Object>> reviews = placeMapper.selectReviewsByPlaceId(placeId);

        if (reviews == null || reviews.isEmpty()) {
            reviews = new ArrayList<>();
            Map<String, Object> fake1 = new HashMap<>();
            fake1.put("userId", "멍냥이맘");
            fake1.put("content", "장소가 정말 깨끗하고 사장님이 친절하세요! 우리 강아지가 너무 좋아했습니다.");
            fake1.put("rating", 5.0);
            fake1.put("regDate", "2026.01.15");
            reviews.add(fake1);

            Map<String, Object> fake2 = new HashMap<>();
            fake2.put("userId", "초코아빠");
            fake2.put("content", "주차 공간이 넓어서 편하게 이용했습니다. 재방문 의사 100%입니다!");
            fake2.put("rating", 4.0);
            fake2.put("regDate", "2026.01.18");
            reviews.add(fake2);
        }
        return reviews;
    }
    
    @Transactional
    public boolean addReview(Map<String, Object> params) {
        try {
            int result = placeMapper.insertReview(params);
            if (result > 0) {
                Long placeId = Long.parseLong(params.get("placeId").toString());
                placeMapper.updatePlaceStats(placeId);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}