<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

			<!DOCTYPE html>
			<html lang="ko">

			<head>
				<jsp:include page="include/header.jsp" />
				<link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
				<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
				<title>멍냥트립 - 홈</title>
				<style>
					.swiper-slide {
						width: auto;
						/* Ensure slides don't stretch */
					}
				</style>

			</head>

			<body class="bg-gray-100">
				<!-- URL Variables for cleaner code and to avoid lint errors with nested quotes -->
				<c:url value="/" var="rootUrl" />
				<c:url value="/login" var="loginUrl" />
				<c:url value="/logout" var="logoutUrl" />
				<c:url value="/list" var="listUrl" />
				<c:url value="/map" var="mapUrl" />
				<c:url value="/lounge" var="loungeUrl" />

				<div class="mobile-container min-h-screen pb-24 relative bg-white">

					<header
						class="bg-white px-5 py-4 flex justify-between items-center sticky top-0 z-50 border-b border-gray-100">
						<div class="flex items-center gap-2" onclick="location.href='${rootUrl}'"
							style="cursor: pointer;">
							<i data-lucide="leaf" class="text-primary w-5 h-5"></i>
							<h1 class="text-base font-bold text-gray-800">멍냥트립</h1>
						</div>

						<c:choose>
							<c:when test="${empty sessionScope.loginUser}">
								<a href="${loginUrl}" class="text-xs font-bold text-gray-600 bg-gray-100 px-3 py-1.5 rounded-full
						hover:bg-gray-200">로그인</a>
							</c:when>
							<c:otherwise>
								<div class="flex items-center gap-2">
									<span
										class="text-xs font-bold text-gray-800">${sessionScope.loginUser.nickname}님</span>
									<a href="${logoutUrl}" class="text-xs text-gray-400 hover:text-red-500 border border-gray-200 px-2 py-1
							rounded-lg">로그아웃</a>
								</div>
							</c:otherwise>
						</c:choose>
					</header>

					<div class="px-5 pt-4 pb-6">
						<div class="relative w-full h-64 rounded-[2rem] overflow-hidden shadow-lg group cursor-pointer">
							<img src="https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?q=80&w=800&auto=format&fit=crop"
								class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105 brightness-90"
								onerror="handleImgError(this)">

							<div class="absolute top-0 left-0 w-full h-full flex flex-col justify-center px-8 z-10">
								<div
									class="bg-yellow-400 text-gray-900 text-[11px] font-bold px-3 py-1 rounded-full w-fit mb-4 flex items-center gap-1 shadow-sm">
									🔥 인기 급상승</div>
								<h2 class="text-2xl font-bold text-white leading-tight drop-shadow-md">
									이번 주말엔 여기 어때?<br> <span class="text-yellow-400">반려견과
										함께하는</span><br>힐링 여행
								</h2>
							</div>

							<div class="absolute inset-0 bg-gradient-to-r from-black/50 via-black/20 to-transparent">
							</div>
						</div>
					</div>

					<div class="px-5 mb-8">
						<div
							class="bg-white rounded-[1.5rem] shadow-[0_8px_30px_rgba(0,0,0,0.04)] p-2.5 flex items-center gap-2 border border-gray-100">

							<div
								class="flex-1 flex items-center bg-gray-50 rounded-2xl px-4 py-3.5 transition-colors hover:bg-gray-100">
								<i data-lucide="search" class="w-4 h-4 text-gray-400 mr-2 shrink-0"></i>
								<input type="text" id="mainRegionInput" placeholder="지역 (예: 제주)"
									class="bg-transparent text-sm w-full outline-none text-gray-700 placeholder-gray-400 font-medium">
							</div>

							<div class="flex-1 flex items-center bg-gray-50 rounded-2xl px-4 py-3.5 cursor-pointer relative transition-colors hover:bg-gray-100"
								onclick="document.getElementById('mainDateInput').showPicker()">

								<i data-lucide="calendar" class="w-4 h-4 text-gray-400 mr-2 shrink-0"></i> <input
									type="text" id="dateDisplay" placeholder="연도. 월. 일."
									class="bg-transparent text-sm w-full outline-none text-gray-700 placeholder-gray-400 font-medium pointer-events-none"
									readonly> <input type="date" id="mainDateInput"
									class="absolute inset-0 opacity-0 w-full h-full cursor-pointer"
									onchange="updateMainDate(this)">
							</div>

							<button onclick="goMainSearch()"
								class="bg-primary w-[3.2rem] h-[3.2rem] rounded-2xl flex items-center justify-center text-white shadow-md active:scale-95 transition-all shrink-0 hover:bg-pink-500">
								<i data-lucide="search" class="w-5 h-5"></i>
							</button>
						</div>
					</div>

					<div class="px-5 mb-10">
						<div class="flex justify-around items-center px-4">
							<div onclick="goCategorySearch('place', '${listUrl}')"
								class="flex flex-col items-center gap-2 group cursor-pointer">
								<div
									class="w-16 h-16 bg-pink-50 rounded-full flex items-center justify-center group-hover:bg-primary group-hover:text-white transition-colors text-primary shadow-sm border border-pink-100">
									<i data-lucide="tree-pine" class="w-7 h-7"></i>
								</div>
								<span class="text-xs font-bold text-gray-600">멍냥플레이스</span>
							</div>
							<div onclick="goCategorySearch('stay', '${listUrl}')"
								class="flex flex-col items-center gap-2 group cursor-pointer">
								<div
									class="w-16 h-16 bg-pink-50 rounded-full flex items-center justify-center group-hover:bg-primary group-hover:text-white transition-colors text-primary shadow-sm border border-pink-100">
									<i data-lucide="bed-double" class="w-7 h-7"></i>
								</div>
								<span class="text-xs font-bold text-gray-600">멍냥스테이</span>
							</div>
							<div onclick="goCategorySearch('dining', '${listUrl}')"
								class="flex flex-col items-center gap-2 group cursor-pointer">
								<div
									class="w-16 h-16 bg-pink-50 rounded-full flex items-center justify-center group-hover:bg-primary group-hover:text-white transition-colors text-primary shadow-sm border border-pink-100">
									<i data-lucide="coffee" class="w-7 h-7"></i>
								</div>
								<span class="text-xs font-bold text-gray-600">멍냥다이닝</span>
							</div>
							<div onclick="location.href='${mapUrl}'"
								class="flex flex-col items-center gap-2 group cursor-pointer flex-shrink-0">
								<div
									class="w-16 h-16 bg-pink-50 rounded-full flex items-center justify-center group-hover:bg-primary group-hover:text-white transition-colors text-primary shadow-sm border border-pink-100">
									<i data-lucide="map" class="w-7 h-7"></i>
								</div>
								<span class="text-xs font-bold text-gray-500">멍냥지도</span>
							</div>
							<div onclick="location.href='${loungeUrl}'"
								class="flex flex-col items-center gap-2 group cursor-pointer flex-shrink-0">
								<div
									class="w-16 h-16 bg-pink-50 rounded-full flex items-center justify-center group-hover:bg-primary group-hover:text-white transition-colors text-primary shadow-sm border border-pink-100">
									<i data-lucide="message-circle" class="w-7 h-7"></i>
								</div>
								<span class="text-xs font-bold text-gray-500">멍냥라운지</span>
							</div>
						</div>
					</div>

					<div class="mb-10 pl-5">
						<div class="flex justify-between items-end mb-4 pr-5">
							<h3 class="text-lg font-bold text-gray-900">이번 주말, 여기 어때요?</h3>
							<a href="${listUrl}" class="text-xs text-gray-400 flex items-center hover:text-primary">더보기
								<i data-lucide="chevron-right" class="w-3 h-3"></i>
							</a>
						</div>
						<!-- Swiper Container -->
						<div class="swiper mySwiper pr-5 !pb-4">
							<div class="swiper-wrapper">
								<c:forEach var="place" items="${recommendPlaces}" varStatus="status">
									<div class="swiper-slide !w-[150px]">
										<!-- detail ID path requires contextPath manually to avoid complex tags in attribute -->
										<a href="${pageContext.request.contextPath}/detail/${place.id}"
											class="block bg-white rounded-2xl overflow-hidden cursor-pointer group shadow-sm border border-gray-100 active:scale-95 transition-transform">
											<div class="h-32 bg-gray-200 relative overflow-hidden mb-2">
												<img src="${place.img}" onerror="handleImgError(this)"
													alt="${place.title}"
													class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
												<span
													class="absolute top-2 left-2 bg-primary text-white w-6 h-6 flex items-center justify-center rounded-lg text-xs font-bold shadow-md">
													${status.count} </span>
											</div>
											<div class="px-3 pb-3">
												<h4 class="text-sm font-bold text-gray-900 truncate mb-0.5">
													${place.title}</h4>
												<div class="flex items-center gap-1 text-xs">
													<i data-lucide="star"
														class="w-3 h-3 text-yellow-400 fill-yellow-400"></i>
													<span class="font-bold text-gray-800">${place.rating}</span> <span
														class="text-gray-400">(${place.reviewCount})</span>
												</div>
											</div>
										</a>
									</div>
								</c:forEach>
							</div>
						</div>
					</div>

					<div class="px-5 mb-10">
						<h3 class="text-lg font-bold text-gray-900 mb-4">카테고리별 베스트 👍</h3>

						<div class="flex items-center justify-between mb-4">
							<div class="flex gap-2 overflow-x-auto scrollbar-hide flex-1">
								<button onclick="filterBest('place', this, '${listUrl}')" class="best-tab px-4 py-2 rounded-full text-xs font-bold whitespace-nowrap bg-primary
							text-white shadow-md transition-all flex-shrink-0">
									멍냥플레이스</button>
								<button onclick="filterBest('stay', this, '${listUrl}')" class="best-tab px-4 py-2 rounded-full text-xs font-bold whitespace-nowrap bg-gray-100
							text-gray-500 hover:bg-gray-200 transition-all flex-shrink-0">
									멍냥스테이</button>
								<button onclick="filterBest('dining', this, '${listUrl}')" class="best-tab px-4 py-2 rounded-full text-xs font-bold whitespace-nowrap bg-gray-100
							text-gray-500 hover:bg-gray-200 transition-all flex-shrink-0">
									멍냥다이닝</button>
							</div>

							<a id="bestMoreLink" href="${listUrl}?category=place"
								class="text-gray-500 text-xs flex items-center hover:text-primary transition-colors cursor-pointer ml-3 flex-shrink-0">더보기
								<i data-lucide="chevron-right" class="w-3 h-3 ml-0.5"></i>
							</a>
						</div>

						<div class="flex flex-col gap-3">
							<c:forEach var="place" items="${allPlaces}" varStatus="status">
								<div class="best-item w-full bg-white p-3 rounded-2xl shadow-sm border border-gray-100 hover:bg-gray-50 transition-colors cursor-pointer flex gap-4"
									data-cat="${place.cat}"
									onclick="location.href='${pageContext.request.contextPath}/detail/${place.id}'">

									<div
										class="w-24 h-24 bg-gray-200 rounded-xl overflow-hidden flex-shrink-0 relative">
										<span
											class="ranking-badge absolute top-1 left-1 bg-primary text-white w-6 h-6 flex items-center justify-center rounded-lg text-xs font-bold shadow-md z-10">
											${status.count} </span> <img src="${place.img}"
											onerror="handleImgError(this)" alt="${place.title}"
											class="w-full h-full object-cover">
									</div>

									<div class="flex-1 py-1 flex flex-col justify-between h-24">
										<div>
											<div class="flex items-center gap-2 mb-1">
												<span
													class="text-[10px] font-bold text-primary bg-pink-50 px-1.5 py-0.5 rounded uppercase border border-pink-100">${place.cat}</span>
												<span class="text-[10px] text-gray-400">후기
													${place.reviewCount}개</span>
											</div>
											<h4 class="text-base font-bold text-gray-900 line-clamp-1 mb-1">
												${place.title}</h4>
										</div>
										<div class="flex items-center justify-between mt-auto">
											<p class="text-xs text-gray-500 truncate flex items-center gap-1">
												<i data-lucide="map-pin" class="w-3 h-3"></i> ${place.loc}
											</p>
											<div class="flex items-center gap-1 text-gray-800 font-bold text-xs">
												<i data-lucide="star"
													class="w-3 h-3 text-yellow-500 fill-yellow-500"></i>
												${place.rating}
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</div>

					<div class="px-5 mb-10">
						<div
							class="bg-pink-50 rounded-3xl p-6 flex items-center justify-between shadow-sm border border-pink-100 cursor-pointer hover:bg-pink-100 transition-colors">
							<div>
								<h6 class="font-bold text-pink-600 mb-1 text-base">첫 리뷰 이벤트 🎁</h6>
								<p class="m-0 text-sm text-gray-600 leading-snug">
									산책 인증샷 올리면<br> <span class="font-bold">간식 쿠폰 100% 증정!</span>
								</p>
							</div>
							<div class="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-sm">
								<i data-lucide="gift" class="text-pink-500 w-6 h-6"></i>
							</div>
						</div>
					</div>

					<div class="h-6"></div>
				</div>

				<jsp:include page="include/nav.jsp" />
				<script src="<c:url value='/resources/js/main.js' />" defer></script>
				<!-- Swiper JS -->
				<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

				<script>
					// Initialize Swiper
					var swiper = new Swiper(".mySwiper", {
						slidesPerView: "auto",
						spaceBetween: 16,
						freeMode: true,
					});

					// 페이지 로드 시 필요한 홈 전용 초기화만 수행
					document.addEventListener("DOMContentLoaded", function () {
						if (typeof filterBest === 'function')
							filterBest('place');
					});

					document.addEventListener("DOMContentLoaded", function () {
						// 페이지 로드 시 'place' 카테고리를 기본으로 첫 5개 필터링 실행
						var firstBtn = document.querySelector('.best-tab');
						if (typeof filterBest === 'function') {
							filterBest('place', firstBtn, '<c:url value="/list" />');
						}
					});
				</script>
				<script>
					function updateMainDate(input) {
						const dateDisplay = document.getElementById('dateDisplay');
						if (input.value) {
							const date = new Date(input.value);
							const year = date.getFullYear();
							const month = String(date.getMonth() + 1).padStart(2, '0');
							const day = String(date.getDate()).padStart(2, '0');
							dateDisplay.value = `\${year}. \${month}. \${day}`;
							dateDisplay.classList.add('text-primary', 'font-bold');
						} else {
							dateDisplay.value = '';
							dateDisplay.classList.remove('text-primary', 'font-bold');
						}
					}

					function goMainSearch() {
						const region = document.getElementById('mainRegionInput').value;
						const date = document.getElementById('mainDateInput').value;

						let url = "${pageContext.request.contextPath}/list?category=all";
						if (region)
							url += "&region=" + encodeURIComponent(region);
						if (date)
							url += "&date=" + date;

						location.href = url;
					}
				</script>
			</body>

			</html>