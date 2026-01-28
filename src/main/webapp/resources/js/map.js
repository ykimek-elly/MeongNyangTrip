/**
 * 멍냥트립 map.js - 최종 수정본
 */
let map;

// [안전장치] 화면(HTML)이 다 로드된 후에 지도를 그리기 시작합니다.
document.addEventListener("DOMContentLoaded", function() {
    kakao.maps.load(function() {
        initMap();
        
        // [추가] 외부에서 장소 클릭(target)해서 들어왔을 때 처리하는 로직
        checkExternalRequest();
    });
});

function initMap() {
    const container = document.getElementById('map');
    
    // 지도를 담을 영역이 없으면 중단 (에러 방지)
    if (!container) return;

    const options = {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 4
    };

    map = new kakao.maps.Map(container, options);
    
    if (typeof lucide !== 'undefined') lucide.createIcons();
    fetchNearbyPlaces();
}

function getCurrentLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;
            map.panTo(new kakao.maps.LatLng(lat, lng));
        });
    }
}

function fetchNearbyPlaces() {
    // contextPath가 정의되어 있지 않을 경우를 대비해 빈 문자열 처리
    const path = (typeof contextPath !== 'undefined') ? contextPath : '';
    
    fetch(`${path}api/places`)
        .then(response => response.json())
        .then(places => renderMarkers(places))
        .catch(err => console.error(err));
}

function renderMarkers(places) {
    places.forEach(place => {
        // [중요] DTO 필드명 확인 (mapY=위도, mapX=경도)
        const lat = place.mapY || place.lat; 
        const lng = place.mapX || place.lng;
        
        const position = new kakao.maps.LatLng(lat, lng);
        const content = document.createElement('div');
        content.className = 'flex flex-col items-center cursor-pointer';
        
        content.innerHTML = `
            <div class="bg-white px-2 py-1 rounded shadow-md text-[10px] font-bold mb-1 border border-gray-100 whitespace-nowrap">${place.title}</div>
            <div class="w-9 h-9 bg-white rounded-full flex items-center justify-center shadow-lg border-2 border-primary">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="#FF4D8D" stroke="#FF4D8D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="4" r="2"></circle><circle cx="18" cy="8" r="2"></circle><circle cx="20" cy="16" r="2"></circle>
                    <path d="M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z"></path>
                </svg>
            </div>
        `;
        content.onclick = () => openPlacePopUp(place);
        new kakao.maps.CustomOverlay({ position: position, content: content, yAnchor: 1.2 }).setMap(map);
    });
}

function openPlacePopUp(place) {
    const popUp = document.getElementById('placePopUp');
    const locBtn = document.getElementById('locBtn');
    const cardLink = document.getElementById('cardLink');
    const path = (typeof contextPath !== 'undefined') ? contextPath : '';
    
    // 데이터 안전하게 바인딩
    document.getElementById('popTitle').innerText = place.title || '장소명 없음';
    document.getElementById('popRating').innerText = (place.rating || 0).toFixed(1);
    document.getElementById('popImg').src = place.img || 'https://via.placeholder.com/150';
    document.getElementById('popDesc').innerText = place.loc || place.addr || '주소 정보 없음';
    document.getElementById('popTag').innerText = place.cat === 'stay' ? '#멍냥숙소' : '#맛집추천';

    // 상세 페이지 이동 링크 설정
    cardLink.onclick = () => location.href = `${path}detail/${place.id}`;
    
    popUp.classList.remove('translate-y-[160%]', 'opacity-0');
    popUp.classList.add('translate-y-0', 'opacity-100');
    if(locBtn) locBtn.classList.add('moved');

    const lat = place.mapY || place.lat; 
    const lng = place.mapX || place.lng;
    map.panTo(new kakao.maps.LatLng(lat, lng));
}

function closePopUp(event) {
    if(event) event.stopPropagation();
    const popUp = document.getElementById('placePopUp');
    const locBtn = document.getElementById('locBtn');
    
    popUp.classList.add('translate-y-[160%]', 'opacity-0');
    popUp.classList.remove('translate-y-0', 'opacity-100');
    if(locBtn) locBtn.classList.remove('moved');
}

function toggleTag(element) {
    const allTags = document.querySelectorAll('.map-pill');
    allTags.forEach(tag => {
        tag.classList.remove('active');
    });
    element.classList.add('active');
}

function searchLocation() {
    const keyword = document.getElementById('keywordInput').value;

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('검색어를 입력해주세요!');
        return;
    }

    const ps = new kakao.maps.services.Places(); 
    ps.keywordSearch(keyword, placesSearchCB); 
}

function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
        const target = data[0];
        const moveLatLon = new kakao.maps.LatLng(target.y, target.x);
        map.panTo(moveLatLon); 
    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        alert('검색 결과가 존재하지 않습니다.');
    } else if (status === kakao.maps.services.Status.ERROR) {
        alert('검색 중 오류가 발생했습니다.');
    }
}

// [핵심 기능] 외부(톡 리스트)에서 클릭해서 들어왔을 때 처리
function checkExternalRequest() {
    const urlParams = new URLSearchParams(window.location.search);
    const targetName = urlParams.get('target');

    // SEARCH_API_URL이 map.jsp에서 제대로 넘어왔는지 확인
    if (targetName && typeof SEARCH_API_URL !== 'undefined') {
        console.log("📍 지도 이동 요청 발견:", targetName);

        fetch(SEARCH_API_URL + '?keyword=' + encodeURIComponent(targetName))
        .then(res => res.json())
        .then(data => {
            if (data && data.length > 0) {
                const targetPlace = data[0]; 
                
                // [수정] DTO 필드명 통일 (mapY, mapX 우선 사용)
                const lat = targetPlace.mapY || targetPlace.lat;
                const lng = targetPlace.mapX || targetPlace.lng;
                
                // 지도 이동
                const moveLatLon = new kakao.maps.LatLng(lat, lng);
                map.setCenter(moveLatLon);
                map.setLevel(3); 

                // [수정] showPlaceInfo 대신 존재하는 함수 openPlacePopUp 사용
                openPlacePopUp(targetPlace);
                
            } else {
                // DB에 없으면 카카오 장소 검색으로 시도 (백업 플랜)
                const ps = new kakao.maps.services.Places();
                ps.keywordSearch(targetName, placesSearchCB);
            }
        })
        .catch(err => console.error("장소 찾기 실패:", err));
    }
}