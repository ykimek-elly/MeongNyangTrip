<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="include/header.jsp" />
<link rel="stylesheet"
	href="<c:url value='/resources/css/style.css' />?v=2">
<title>멍냥트립 - 지도</title>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f5be83671ab1fd039f403cdb875c42a3&libraries=services"></script>
<script>
	const contextPath = '<c:url value="/" />';
</script>
<style>
/* [핵심] 스크롤바 제거 및 반응형 높이 설정 */
html, body {
	height: 100%;
	margin: 0;
	overflow: hidden; /* 우측 스크롤 원천 차단 */
}

.mobile-container {
	position: relative;
	width: 100%;
	height: 100%;
	background-color: #ffffff;
}

/* [반응형] 내 위치 버튼: 하단 메뉴 위로 배치 */
#locBtn {
	position: absolute;
	bottom: 80px; /* 하단 메뉴(약 64px)보다 높게 설정 */
	right: 20px;
	z-index: 20;
	transition: transform 0.4s ease-out;
}

/* 팝업이 올라올 때 버튼 이동 */
#locBtn.moved {
	transform: translateY(-160px);
}

/* [반응형] 팝콘 배너: 하단 메뉴 안쪽에서 올라옴 */
#placePopUp {
	position: absolute;
	bottom: 83px; /* 하단 메뉴 바로 위에 위치 */
	left: 16px;
	right: 16px;
	z-index: 40; /* 하단 메뉴(z-index 50 가정)보다 낮게 설정 */
}

.no-shadow {
	box-shadow: none !important;
}
</style>
</head>
<body>
	<div class="mobile-container">

		<div class="map-overlay-top" style="z-index: 60;">
			<div class="map-search-box">
				<i data-lucide="arrow-left"
					class="w-5 h-5 text-gray-500 mr-3 cursor-pointer"
					onclick="history.back()"></i> <input type="text" id="keywordInput"
					placeholder="지역이나 장소를 검색해보세요"
					class="flex-1 text-sm outline-none text-gray-700 bg-transparent placeholder-gray-400 font-bold"
					onkeypress="if(event.keyCode==13) { searchLocation(); }"> <i
					data-lucide="search" class="w-5 h-5 text-primary cursor-pointer"
					onclick="searchLocation()"></i>
			</div>

			<div class="map-tags-wrapper scrollbar-hide">
				<div class="map-pill active" onclick="toggleTag(this)">전체</div>
				<div class="map-pill" onclick="toggleTag(this)">#햇살맛집</div>
				<div class="map-pill" onclick="toggleTag(this)">#조용한산책</div>
				<div class="map-pill" onclick="toggleTag(this)">#뛰뛰가능</div>
				<div class="map-pill" onclick="toggleTag(this)">#노작로</div>
			</div>
		</div>

		<div id="map" style="width: 100%; height: 100%;"></div>

		<button id="locBtn" onclick="getCurrentLocation()"
			class="w-12 h-12 bg-white rounded-full shadow-lg flex items-center justify-center border border-gray-100">
			<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
				viewBox="0 0 24 24" fill="none" stroke="#FF4D8D" stroke-width="2"
				stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6">
				<circle cx="12" cy="12" r="10"></circle>
				<circle cx="12" cy="12" r="3"></circle>
				<line x1="12" y1="2" x2="12" y2="4"></line>
				<line x1="12" y1="20" x2="12" y2="22"></line>
				<line x1="2" y1="12" x2="4" y2="12"></line>
				<line x1="20" y1="12" x2="22" y2="12"></line></svg>
		</button>

		<div id="placePopUp"
			class="transition-all duration-500 translate-y-[160%] opacity-0">
			<div
				class="bg-white rounded-[2rem] p-4 flex gap-4 relative border border-gray-100 no-shadow cursor-pointer"
				id="cardLink">
				<button onclick="closePopUp(event)"
					class="absolute top-4 right-4 p-1 text-gray-400">
					<i data-lucide="x" class="w-5 h-5"></i>
				</button>
				<div
					class="w-24 h-24 rounded-2xl overflow-hidden flex-shrink-0 bg-gray-100">
					<img id="popImg" src="" class="w-full h-full object-cover">
				</div>
				<div class="flex-1 flex flex-col justify-between py-1 min-w-0">
					<div>
						<div class="flex items-center gap-1.5 mb-1.5">
							<span id="popTag"
								class="text-[10px] font-bold text-primary bg-pink-50 px-2 py-0.5 rounded-full border border-pink-100">#태그</span>
						</div>
						<h4 id="popTitle"
							class="text-base font-bold text-gray-900 truncate pr-6">장소명</h4>
						<p id="popDesc"
							class="text-[11px] text-gray-500 line-clamp-1 mt-0.5 font-medium">설명
							문구</p>
					</div>
					<div class="flex items-center gap-3 mt-auto">
						<div class="flex items-center gap-1">
							<i data-lucide="star"
								class="w-3.5 h-3.5 text-yellow-400 fill-yellow-400"></i> <span
								id="popRating" class="text-xs font-bold text-gray-800">0.0</span>
						</div>
						<div
							class="ml-auto bg-primary text-white text-[10px] font-bold px-4 py-2 rounded-full">상세보기</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="include/nav.jsp" />
	<script>
		const SEARCH_API_URL = "<c:url value='/place/api/search/list' />";
	</script>
	<script src="<c:url value='/resources/js/map.js' />"></script>
</body>
</html>