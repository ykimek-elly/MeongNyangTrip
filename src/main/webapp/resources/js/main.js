/* [공통] Lucide 아이콘 초기화 */
function initIcons() {
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
}

/* [공통] 이미지 에러 핸들링 */
function handleImgError(image) {
    image.onerror = null;
    image.src = 'https://placehold.co/400x300/f1f5f9/94a3b8?text=No+Image';
}

/* [홈/리스트] 카테고리 검색 및 이동 */
function goCategorySearch(category, baseUrl) {
    var regionInput = document.getElementById('regionInput');
    var dateInput = document.getElementById('dateInput');
    var region = regionInput ? regionInput.value : "";
    var date = dateInput ? dateInput.value : "";

    var url = baseUrl + "?category=" + category;
    if (region) url += "&region=" + encodeURIComponent(region);
    if (date) url += "&date=" + date;
    location.href = url;
}

function changeCategory(category, baseUrl) {
    var urlParams = new URLSearchParams(window.location.search);
    urlParams.set('category', category);
    location.href = baseUrl + "?" + urlParams.toString();
}
/* [홈] 카테고리별 베스트 필터링 로직 */
function filterBest(category, btn, baseUrl) {
    // 1. 버튼 스타일 업데이트
    if (btn) {
        var tabs = document.querySelectorAll('.best-tab');
        tabs.forEach(function (t) {
            t.classList.remove('bg-primary', 'text-white', 'shadow-md');
            t.classList.add('bg-gray-100', 'text-gray-500');
        });
        btn.classList.remove('bg-gray-100', 'text-gray-500');
        btn.classList.add('bg-primary', 'text-white', 'shadow-md');
    }

    // 2. '더보기' 링크 업데이트
    var moreLink = document.getElementById('bestMoreLink');
    if (moreLink && baseUrl) {
        moreLink.href = baseUrl + "?category=" + category;
    }

    // 3. 아이템 필터링 (최대 5개만 노출)
    var items = document.querySelectorAll('.best-item');
    var count = 0;

    items.forEach(function (item) {
        // data-cat 속성값 확인 (소문자 변환하여 비교)
        var itemCat = item.getAttribute('data-cat') ? item.getAttribute('data-cat').toLowerCase() : "";

        if (itemCat === category.toLowerCase()) {
            if (count < 5) {
                item.style.display = 'flex';
                // 순위 뱃지 숫자 재설정 (1~5)
                var badge = item.querySelector('.ranking-badge');
                if (badge) badge.innerText = count + 1;
                count++;
            } else {
                item.style.display = 'none';
            }
        } else {
            item.style.display = 'none';
        }
    });
}

/* [리스트] 정렬 변경 */
function changeSort(sortType, baseUrl) {
    var urlParams = new URLSearchParams(window.location.search);
    urlParams.set('sort', sortType);
    location.href = baseUrl + "?" + urlParams.toString();
}

/* [리스트] 뷰 모드 전환 */
function toggleView() {
    var list = document.getElementById('placeList');
    var icon = document.getElementById('viewIcon');
    if (!list || !icon) return;
    var isGrid = list.classList.toggle('grid-mode');
    icon.setAttribute('data-lucide', isGrid ? 'list' : 'layout-grid');
    initIcons();
}

/* [상세] 별점 설정 로직 */
function setRating(rating) {
    var ratingInput = document.getElementById('selectedRating');
    if (ratingInput) ratingInput.value = rating;

    var stars = document.querySelectorAll('#starSelector i');
    stars.forEach(function (star, index) {
        if (index < rating) {
            star.classList.remove('text-gray-200');
            star.classList.add('text-yellow-400', 'fill-yellow-400');
            star.setAttribute('fill', '#facc15');
        } else {
            star.classList.remove('text-yellow-400', 'fill-yellow-400');
            star.classList.add('text-gray-200');
            star.setAttribute('fill', 'none');
        }
    });
    initIcons();
}

/* [상세] 리뷰 제출 */
function submitReview(isLoggedIn) {
    if (isLoggedIn === 'false' || isLoggedIn === '') {
        alert("로그인이 필요한 서비스입니다.");
        return;
    }
    var reviewContent = document.getElementById('reviewContent');
    var content = reviewContent ? reviewContent.value : "";
    if (!content.trim()) {
        alert("리뷰 내용을 입력해주세요.");
        return;
    }
    // [수정] 실제 서버로 리뷰 데이터 전송
    var ratingInput = document.getElementById('selectedRating');
    var rating = ratingInput ? ratingInput.value : "0";

    var urlParams = new URLSearchParams(window.location.href);
    // URL에서 ID 추출 (예: /detail/5 -> 5)
    var pathSegments = window.location.pathname.split('/');
    var placeId = pathSegments[pathSegments.length - 1];

    fetch('/addReview', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'placeId=' + placeId + '&content=' + encodeURIComponent(content) + '&rating=' + rating
    })
        .then(function (response) { return response.text(); })
        .then(function (result) {
            if (result === 'success') {
                alert("리뷰가 등록되었습니다!");
                location.reload();
            } else if (result === 'login_needed') {
                alert("로그인이 필요합니다.");
                location.href = '/login';
            } else {
                alert("리뷰 등록에 실패했습니다.");
            }
        })
        .catch(function (error) {
            console.error('Error:', error);
            alert("오류가 발생했습니다.");
        });
}

/* [상세] 찜하기 및 공유 */
function toggleWish(placeId, url) {
    fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'placeId=' + placeId
    })
        .then(function (res) { return res.text(); })
        .then(function (result) {
            var icon = document.getElementById('heartIcon');
            if (result === 'on') {
                icon.classList.add('text-primary', 'fill-primary');
            } else {
                icon.classList.remove('text-primary', 'fill-primary');
            }
            initIcons();
        });
}

function shareUrl() {
    var url = window.location.href;
    navigator.clipboard.writeText(url).then(function () {
        alert("주소가 복사되었습니다!");
    });
}

/* [상세] 카카오맵 초기화 */
var isMapInitialized = false;
function toggleMap(mapX, mapY) {
    var container = document.getElementById('mapContainer');
    var btn = document.getElementById('toggleMapBtn');
    if (!container || !btn) return;

    if (!container.classList.contains('hidden')) {
        container.classList.add('hidden');
        btn.innerHTML = '지도보기 <i data-lucide="chevron-right" class="w-4 h-4 ml-0.5"></i>';
        initIcons();
        return;
    }

    container.classList.remove('hidden');
    btn.innerHTML = '지도닫기 <i data-lucide="chevron-up" class="w-4 h-4 ml-0.5"></i>';
    initIcons();

    if (!isMapInitialized && typeof kakao !== 'undefined') {
        kakao.maps.load(function () {
            var mapContainer = document.getElementById('map');
            var mapOption = { center: new kakao.maps.LatLng(mapY, mapX), level: 3 };
            var map = new kakao.maps.Map(mapContainer, mapOption);
            new kakao.maps.Marker({ position: new kakao.maps.LatLng(mapY, mapX), map: map });
            isMapInitialized = true;
        });
    }
}


/* =========================================
   [라운지 & 지도] 기능 (ver 2.0)
========================================= */

/* 1. 탭 전환 기능 */
function switchTab(tabName) {
    // 탭 버튼 스타일 변경
    document.querySelectorAll('.tab-btn').forEach(function (btn) {
        btn.classList.remove('active');
    });
    document.getElementById('tab-btn-' + tabName).classList.add('active');

    // 컨텐츠 영역 전환
    document.getElementById('view-feed').style.display = 'none';
    document.getElementById('view-talk').style.display = 'none';

    document.getElementById('view-' + tabName).style.display = 'block';

    // 뷰 전환 아이콘(그리드/리스트)은 '피드' 탭에서만 보임
    var toggleBtn = document.getElementById('feedToggleBtn');
    if (toggleBtn) {
        toggleBtn.style.display = (tabName === 'feed') ? 'block' : 'none';
    }
}

/* [라운지] 뷰 모드 전환 (1단 피드 <-> 2단 그리드) */
function toggleLoungeView() {
    var container = document.getElementById('feedContainer');
    var icon = document.getElementById('layoutIcon');

    if (!container || !icon) return;

    // grid-mode 클래스를 토글 (기본값: 없음=1단 -> 클릭시: 있음=2단)
    var isGrid = container.classList.toggle('grid-mode');

    // 아이콘 변경 logic
    // isGrid(2단) 상태면 -> 다시 '리스트(list)'로 돌아가는 버튼 보여주기
    // 1단 상태면 -> '그리드(layout-grid)'로 가는 버튼 보여주기
    icon.setAttribute('data-lucide', isGrid ? 'list' : 'layout-grid');

    // 아이콘 새로고침
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
}

/* 3. 지도 태그 필터 (UI용) */
function filterMapTag(btn) {
    // 모든 태그 비활성화
    document.querySelectorAll('.map-pill').forEach(function (el) {
        el.classList.remove('active');
    });
    // 선택한 태그 활성화
    btn.classList.add('active');
}