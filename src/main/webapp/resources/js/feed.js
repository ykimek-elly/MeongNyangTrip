/**
 * feed.js - 피드 및 라운지 관련 기능 스크립트
 * (수정: 좋아요 즉시 반영, 공유 모달 추가, 메뉴 토글 개선)
 */

document.addEventListener("DOMContentLoaded", function () {
    // 1. 아이콘 로딩
    if (typeof lucide !== 'undefined') lucide.createIcons();
    
    // 2. 탭 초기화 (?tab=talk 파라미터 확인)
    const urlParams = new URLSearchParams(window.location.search);
    if(urlParams.get('tab') === 'talk') {
        if(typeof switchTab === 'function') switchTab('talk');
    }
});

// ==========================================
// 1. 피드(Feed) 관련 기능
// ==========================================

// [수정] 피드 메뉴 토글 (점 세개 버튼) - event 파라미터 추가
function toggleFeedMenu(feedId, event) {
    if(event) event.stopPropagation(); // 클릭 이벤트가 부모로 퍼지는 것 방지
    
    const targetMenu = document.getElementById('feed-menu-' + feedId);
    if(!targetMenu) return; 

    const isHidden = targetMenu.classList.contains('hidden');

    // 다른 열린 메뉴 모두 닫기
    document.querySelectorAll('[id^="feed-menu-"]').forEach(menu => {
        menu.classList.add('hidden');
    });

    // 현재 메뉴 열기
    if (isHidden) {
        targetMenu.classList.remove('hidden');
    }
}

// 화면 아무 곳이나 클릭 시 메뉴 닫기
window.addEventListener('click', function() {
    document.querySelectorAll('[id^="feed-menu-"]').forEach(menu => {
        menu.classList.add('hidden');
    });
});

// 피드 좋아요 (비회원 차단 기능 추가)
function toggleLike(feedId) {
    // 1. [추가] 로그인 여부 먼저 확인
    if (typeof IS_LOGIN !== 'undefined' && !IS_LOGIN) {
        alert("회원가입 후 이용 가능합니다.");
        // (선택사항) 로그인 페이지로 이동시키려면 아래 주석 해제
        // if(confirm("로그인 페이지로 이동하시겠습니까?")) location.href = '/login';
        return; // 여기서 함수 강제 종료 (아래 코드 실행 안 됨)
    }

    // 2. 기존 로직 시작 (요소 가져오기)
    const heartIcon = document.getElementById('heart-icon-' + feedId);
    const likeCountSpan = document.getElementById('like-count-' + feedId);
    
    if(!heartIcon || !likeCountSpan) return;

    const isLiked = heartIcon.classList.contains('fill-pink-500');
    let currentCount = parseInt(likeCountSpan.innerText.replace(/,/g, '')) || 0;

    // 3. 화면 즉시 변경 (낙관적 업데이트)
    if (isLiked) {
        // 좋아요 취소
        heartIcon.classList.remove('text-pink-500', 'fill-pink-500');
        heartIcon.classList.add('text-gray-800');
        likeCountSpan.innerText = Math.max(0, currentCount - 1);
    } else {
        // 좋아요 등록
        heartIcon.classList.remove('text-gray-800');
        heartIcon.classList.add('text-pink-500', 'fill-pink-500');
        likeCountSpan.innerText = currentCount + 1;
    }

    // 4. 서버 전송
    fetch(API_URLS.TOGGLE_LIKE, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'feedId=' + feedId
    })
    .then(res => res.text())
    .then(data => {
        if(data !== "success") {
            console.error("좋아요 처리 실패");
            // 에러 시 원래대로 되돌리는 로직을 넣을 수도 있음
        }
    });
}

// 피드 삭제
function deleteFeed(feedId) {
    if(!confirm("이 피드를 삭제하시겠습니까?")) return;
    
    fetch(API_URLS.DELETE_FEED, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'feedId=' + feedId
    })
    .then(res => res.text())
    .then(data => {
        if(data === "success") location.reload();
        else alert("삭제 실패 (본인 글 아님)");
    });
}

// ==========================================
// 2. 실시간 톡(Talk) 관련 기능
// ==========================================

// 톡 삭제
function deleteTalk(talkId) {
    if(!confirm("삭제하시겠습니까?")) return;
    
    fetch(API_URLS.DELETE_TALK, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'talkId=' + talkId
    })
    .then(res => res.text())
    .then(data => {
        if(data === "success") location.reload();
        else alert("삭제 실패");
    });
}

// ==========================================
// 3. 모달(Modal) 제어 기능
// ==========================================

// [추가] 공유 모달 열기
function openShareModal() {
    const modal = document.getElementById('alertModal');
    const content = document.getElementById('alertContent');
    if(!modal) return;
    
    modal.classList.remove('hidden');
    setTimeout(() => {
        content.classList.remove('scale-95', 'opacity-0');
        content.classList.add('scale-100', 'opacity-100');
    }, 10);
}

// [추가] 공유 모달 닫기
function closeShareModal() {
    const modal = document.getElementById('alertModal');
    const content = document.getElementById('alertContent');
    if(!modal) return;

    content.classList.remove('scale-100', 'opacity-100');
    content.classList.add('scale-95', 'opacity-0');
    setTimeout(() => { modal.classList.add('hidden'); }, 200);
}

// 글쓰기 모달 열기
function openWriteModal() {
    const modal = document.getElementById('writeModal');
    const backdrop = document.getElementById('modalBackdrop');
    const content = document.getElementById('modalContent');
    if(!modal) return;

    modal.classList.remove('hidden');
    setTimeout(() => {
        backdrop.classList.remove('opacity-0');
        if (window.innerWidth < 640) content.classList.remove('translate-y-full');
    }, 10);
}

// 글쓰기 모달 닫기
function closeWriteModal() {
    const modal = document.getElementById('writeModal');
    const backdrop = document.getElementById('modalBackdrop');
    const content = document.getElementById('modalContent');
    if(!modal) return;

    backdrop.classList.add('opacity-0');
    if (window.innerWidth < 640) content.classList.add('translate-y-full');
    setTimeout(() => { modal.classList.add('hidden'); }, 300);
}