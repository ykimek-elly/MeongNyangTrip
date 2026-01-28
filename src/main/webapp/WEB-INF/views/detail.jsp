<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <jsp:include page="include/header.jsp" />
    <link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
    <title>멍냥트립 - ${place.title}</title>
    <script>
        const contextPath = '<c:url value="/" />';
    </script>
</head>

<body class="bg-gray-100">
    <div class="mobile-container relative bg-white pb-48">
        <header class="sticky top-0 z-50 bg-white/95 backdrop-blur-md px-4 h-[64px] flex items-center  border-gray-50">
            <button onclick="history.back()" class="p-2 flex-shrink-0">
                <i data-lucide="chevron-left" class="w-7 h-7 text-gray-700"></i>
            </button>
            <h1 class="flex-1 text-center font-bold text-[17px] text-gray-900 truncate px-2">${place.title}</h1>
            <div class="flex gap-1 flex-shrink-0">
                <c:url value="/toggleWish" var="toggleWishUrl" />
                <button onclick="toggleWish('${place.id}', '${toggleWishUrl}')" class="p-2">
                    <i id="heartIcon" data-lucide="heart"
                        class="w-7 h-7 ${isWished ? 'text-primary fill-primary' : 'text-gray-700'}"></i>
                </button>
                <button onclick="shareUrl()" class="p-2">
                    <i data-lucide="share-2" class="w-7 h-7 text-gray-700"></i>
                </button>
            </div>
        </header>

        <div class="w-full aspect-[4/3] relative overflow-hidden">
            <img src="${place.img}" onerror="handleImgError(this)" class="w-full h-full object-cover">
            <div class="absolute bottom-4 right-4 bg-black/40 text-white text-[10px] px-2 py-1 rounded-full backdrop-blur-sm">
                1 / 4
            </div>
        </div>

        <div class="px-6 py-10">
            
            <div class="mb-8">
                <h2 class="text-3xl font-extrabold text-gray-900 mb-3 tracking-tight">${place.title}</h2>
                <div class="flex items-center gap-1.5 text-base">
                    <i data-lucide="star" class="w-5 h-5 text-yellow-400 fill-yellow-400"></i>
                    <span class="font-bold text-gray-900">${place.rating}</span>
                    <span class="text-gray-400">(${place.reviewCount}개 리뷰)</span>
                </div>
            </div>

            <div class="mb-14">
                <h3 class="text-xl font-bold text-gray-900 mb-6 tracking-tight">시설 정보</h3>
                <div class="flex flex-wrap gap-2">
                    <c:choose>
                        <c:when test="${not empty place.facilityInfo}">
                            <c:forEach var="info" items="${fn:split(place.facilityInfo, ',')}">
                                <c:if test="${not empty fn:trim(info)}">
                                    <div class="facility-tag">
                                        <i data-lucide="check-circle" class="w-4 h-4 text-rose-400"></i>
                                        ${fn:trim(info)}
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="facility-tag"><i data-lucide="dog" class="w-4 h-4"></i> 반려동물 동반</div>
                            <div class="facility-tag"><i data-lucide="parking-circle" class="w-4 h-4"></i> 주차가능</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="mb-12">
                <h3 class="text-xl font-bold text-gray-900 mb-4 tracking-tight">소개</h3>
                <div class="flex flex-wrap gap-2 mb-3">
                    <c:forEach var="tag" items="${hashtags}">
                        <span class="px-2.5 py-1 bg-gray-100 text-gray-600 rounded-lg text-[13px] font-medium">#${tag}</span>
                    </c:forEach>
                </div>
                <div class="relative">
                    <p id="descText" class="text-gray-600 leading-relaxed text-[17px] text-justify whitespace-pre-line line-clamp-3 overflow-hidden transition-all duration-300">
                        ${place.desc}
                    </p>
                    <button id="moreBtn" onclick="toggleDesc()" class="mt-2 text-sm font-bold text-primary flex items-center gap-1">
                        더보기 <i data-lucide="chevron-down" class="w-4 h-4"></i>
                    </button>
                </div>
            </div>

            <script>
                function toggleDesc() {
                    const desc = document.getElementById('descText');
                    const btn = document.getElementById('moreBtn');
                    if (desc.classList.contains('line-clamp-3')) {
                        desc.classList.remove('line-clamp-3', 'overflow-hidden');
                        btn.innerHTML = '접기 <i data-lucide="chevron-up" class="w-4 h-4"></i>';
                    } else {
                        desc.classList.add('line-clamp-3', 'overflow-hidden');
                        btn.innerHTML = '더보기 <i data-lucide="chevron-down" class="w-4 h-4"></i>';
                    }
                }
            </script>

            <div class="address-container mb-10">
                <div class="flex items-center gap-2.5 text-gray-500 overflow-hidden">
                    <i data-lucide="map-pin" class="w-5 h-5 flex-shrink-0"></i>
                    <span class="text-sm truncate font-medium">${place.loc}</span>
                </div>
                <button id="toggleMapBtn" onclick="toggleMap('${place.mapX}', '${place.mapY}')" class="btn-toggle-map">
                    지도보기 <i data-lucide="chevron-right" class="w-4 h-4 ml-0.5"></i>
                </button>
            </div>
            <div id="mapContainer" class="hidden mb-10 overflow-hidden rounded-2xl border border-gray-100">
                <div id="map" style="width: 100%; height: 300px;"></div>
            </div>

            <div class="action-grid mb-14">
                <c:if test="${not empty place.tel}">
                    <a href="tel:${place.tel}" class="action-icon-btn">
                        <i data-lucide="phone" class="w-6 h-6"></i><span class="font-medium">전화하기</span>
                    </a>
                </c:if>
                <a href="#" class="action-icon-btn">
                    <i data-lucide="instagram" class="w-6 h-6"></i><span class="font-medium">인스타그램</span>
                </a>
                <c:if test="${not empty place.homepage}">
                    <a href="${place.homepage}" target="_blank" class="action-icon-btn">
                        <i data-lucide="globe" class="w-6 h-6"></i><span class="font-medium">홈페이지</span>
                    </a>
                </c:if>
            </div>

            <div class="px-6 py-10 border-gray-100">
                <div class="flex items-center justify-between mb-8">
                    <h3 class="text-xl font-bold text-gray-900 tracking-tight">
                        리뷰 <span class="text-primary">${place.reviewCount}</span>
                    </h3>
                </div>

                <div class="bg-gray-50 p-6 rounded-3xl border border-gray-100 shadow-sm mb-10">
                    <h4 class="font-bold text-gray-800 mb-4 flex items-center gap-2">
                        <i data-lucide="pen-tool" class="w-4 h-4 text-primary"></i> 리뷰 작성하기
                    </h4>
                    <div class="flex items-center justify-between mb-4 bg-white px-4 py-3 rounded-2xl border border-gray-100">
                        <span class="text-sm font-bold text-gray-600">장소는 어떠셨나요?</span>
                        <div class="star-rating" id="starSelector">
                            <i data-lucide="star" class="w-6 h-6 text-gray-200" onclick="setRating(1)"></i>
                            <i data-lucide="star" class="w-6 h-6 text-gray-200" onclick="setRating(2)"></i>
                            <i data-lucide="star" class="w-6 h-6 text-gray-200" onclick="setRating(3)"></i>
                            <i data-lucide="star" class="w-6 h-6 text-gray-200" onclick="setRating(4)"></i>
                            <i data-lucide="star" class="w-6 h-6 text-gray-200" onclick="setRating(5)"></i>
                        </div>
                        <input type="hidden" id="selectedRating" value="0">
                    </div>
                    <textarea id="reviewContent" class="w-full h-32 p-4 bg-white border border-gray-100 rounded-2xl text-[15px] outline-none focus:border-primary transition-all placeholder-gray-300 shadow-inner" placeholder="이곳에 대한 솔직한 후기를 남겨주세요."></textarea>
                    <button onclick="submitReview('${not empty sessionScope.loginUser}')" class="btn-review-custom w-full mt-4 py-4 rounded-2xl text-base font-bold shadow-none">
                        리뷰 등록하기
                    </button>
                </div>

                <div class="space-y-8 mb-12">
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <c:forEach var="rev" items="${reviews}">
                                <div class="border-gray-50 pb-8 last:border-0">
                                    <div class="flex justify-between items-start mb-3">
                                        <div>
                                            <span class="font-bold text-gray-900 text-sm">${rev.userId}</span>
                                            <div class="flex items-center gap-0.5 mt-1">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i data-lucide="star" class="w-3.5 h-3.5 ${i <= rev.rating ? 'text-yellow-400 fill-yellow-400' : 'text-gray-200'}"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <span class="text-[11px] text-gray-400">${rev.regDate}</span>
                                    </div>
                                    <p class="text-sm text-gray-600 leading-relaxed">${rev.content}</p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="py-12 text-center">
                                <i data-lucide="message-square" class="w-12 h-12 text-gray-200 mx-auto mb-3"></i>
                                <p class="text-sm text-gray-400">첫 번째 리뷰를 남겨보세요!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="btn-reservation-container">
            <button class="btn-reservation">예약 / 문의하기</button>
        </div>

        <jsp:include page="include/nav.jsp" />

        <script src="<c:url value='/resources/js/main.js' />" defer></script>
        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f5be83671ab1fd039f403cdb875c42a3&libraries=services"></script>
        
        <script>
            window.addEventListener('DOMContentLoaded', function () {
                if (typeof lucide !== 'undefined') lucide.createIcons();
            });

            window.addEventListener('scroll', function () {
                const scrollPosition = window.scrollY + window.innerHeight;
                const documentHeight = document.documentElement.scrollHeight;
                const btnContainer = document.querySelector('.btn-reservation-container');

                if (scrollPosition >= documentHeight - 150) {
                    btnContainer.classList.add('show');
                } else {
                    btnContainer.classList.remove('show');
                }
            });

            // 찜하기 토글 함수
            function toggleWish(placeId, url) {
                fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                    },
                    body: 'placeId=' + placeId
                })
                .then(response => response.text())
                .then(text => {
                    const result = text.trim(); // 공백 제거

                    if (result === 'login_needed') {
                        if (confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) {
                            location.href = contextPath + 'login';
                        }
                        return;
                    }

                    const icon = document.getElementById('heartIcon');
                    if (result === 'on') {
                        icon.classList.remove('text-gray-700');
                        icon.classList.add('text-primary', 'fill-primary');
                        alert("찜 목록에 추가되었습니다!");
                    } else if (result === 'off') {
                        icon.classList.remove('text-primary', 'fill-primary');
                        icon.classList.add('text-gray-700');
                        alert("찜 목록에서 삭제되었습니다.");
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert("처리 중 오류가 발생했습니다.");
                });
            }
        </script>
    </div>
</body>
</html>