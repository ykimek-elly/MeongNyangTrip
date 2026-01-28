<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
			<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

				<!DOCTYPE html>
				<html lang="ko">

				<head>
					<jsp:include page="include/header.jsp" />
					<title>멍냥트립 - 검색 결과</title>
					<link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
				</head>

				<body class="bg-gray-100">
					<div class="mobile-container min-h-screen bg-gray-50 pb-24">

						<header
							class="bg-white px-4 py-3 sticky top-0 z-50 flex items-center gap-2 shadow-sm border-b border-gray-100">
							<button onclick="location.href='${pageContext.request.contextPath}/'"
								class="text-gray-800 p-1 flex-shrink-0">
								<i data-lucide="arrow-left" class="w-6 h-6"></i>
							</button>

							<form action="${pageContext.request.contextPath}/list" method="get"
								class="flex-1 flex items-center bg-gray-100 rounded-xl p-1">

								<div class="flex-1 flex items-center px-2">
									<i data-lucide="search" class="w-4 h-4 text-gray-400 mr-2 flex-shrink-0"></i> <input
										type="text" name="region" value="${param.region}" placeholder="지역/숙소명"
										class="bg-transparent w-full text-sm outline-none text-gray-800 placeholder-gray-400 min-w-0">
								</div>

								<div class="w-[1px] h-4 bg-gray-300 mx-1"></div>

								<div class="w-[90px] flex items-center justify-center px-1 cursor-pointer relative"
									onclick="document.getElementById('headerDateInput').showPicker()">
									<input type="date" id="headerDateInput" name="date" value="${param.date}"
										class="bg-transparent w-full text-xs outline-none text-gray-600 text-center cursor-pointer font-medium p-0">
								</div>

								<button type="submit"
									class="bg-primary text-white w-9 h-9 rounded-lg flex items-center justify-center ml-1 shadow-sm active:scale-95 transition-transform flex-shrink-0">
									<i data-lucide="search" class="w-4 h-4"></i>
								</button>

								<input type="hidden" name="category" value="${param.category}">
								<input type="hidden" name="sort" value="${param.sort}">
							</form>
						</header>

						<div
							class="sticky top-[64px] z-40 bg-white/95 backdrop-blur-sm px-4 py-3 border-b border-gray-100 flex justify-between items-center shadow-sm">
							<div class="flex gap-2 overflow-x-auto pb-1 scrollbar-hide flex-1 mr-2">
								<button onclick="changeCategory('all', '${pageContext.request.contextPath}/list')"
									class="px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-colors
								border ${(empty param.category or param.category eq 'all') ? 'bg-primary text-white
								border-primary shadow-sm' : 'bg-gray-100 text-gray-500 border-gray-100
								hover:bg-gray-200'}">전체</button>
								<button onclick="changeCategory('place', '${pageContext.request.contextPath}/list')"
									class="px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-colors
								border ${param.category eq 'place' ? 'bg-primary text-white border-primary shadow-sm' :
								'bg-gray-100 text-gray-500 border-gray-100 hover:bg-gray-200'}">멍냥플레이스</button>
								<button onclick="changeCategory('stay', '${pageContext.request.contextPath}/list')"
									class="px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-colors
								border ${param.category eq 'stay' ? 'bg-primary text-white border-primary shadow-sm' :
								'bg-gray-100 text-gray-500 border-gray-100 hover:bg-gray-200'}">멍냥스테이</button>
								<button onclick="changeCategory('dining', '${pageContext.request.contextPath}/list')"
									class="px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-colors
								border ${param.category eq 'dining' ? 'bg-primary text-white border-primary shadow-sm' :
								'bg-gray-100 text-gray-500 border-gray-100 hover:bg-gray-200'}">멍냥다이닝</button>
							</div>
							<button onclick="toggleView()"
								class="bg-gray-100 text-gray-500 p-2 rounded-lg hover:bg-gray-200 transition-colors flex-shrink-0">
								<i id="viewIcon" data-lucide="layout-grid" class="w-5 h-5"></i>
							</button>
						</div>

						<div class="px-4 py-4">
							<c:if test="${not empty searchMsg}">
								<div
									class="w-full text-center py-2 text-sm text-gray-500 bg-gray-50 rounded-xl mb-3 border border-gray-100">
									${searchMsg}</div>
							</c:if>

							<div class="flex justify-between items-center px-1 mb-4">
								<div class="flex items-center gap-1 bg-gray-100 px-3 py-1.5 rounded-xl">
									<select onchange="changeSort(this.value,'${pageContext.request.contextPath}/list')"
										class="text-xs font-bold text-gray-600 bg-transparent outline-none cursor-pointer
									appearance-none border-none p-0">
										<option value="id" ${param.sort=='id' || empty param.sort ? 'selected' : '' }>
											최신순
										</option>
										<option value="rating" ${param.sort=='rating' ? 'selected' : '' }>별점
											높은 순</option>
										<option value="review" ${param.sort=='review' ? 'selected' : '' }>리뷰
											많은 순</option>
									</select> <i data-lucide="chevron-down" class="w-3 h-3 text-gray-400"></i>
								</div>

								<div class="text-[11px] text-gray-400">전체
									${fn:length(places)}건</div>
							</div>

							<div id="placeList">
								<c:if test="${empty places}">
									<div class="flex flex-col items-center justify-center py-20 text-center col-span-2">
										<i data-lucide="search-x" class="w-12 h-12 text-gray-300 mb-3"></i>
										<p class="text-sm text-gray-400">
											검색 결과가 없습니다.<br>다른 키워드로 검색해보세요!
										</p>
									</div>
								</c:if>

								<c:forEach var="place" items="${places}">
									<div onclick="location.href='${pageContext.request.contextPath}/detail/${place.id}'"
										class="place-card bg-white border border-gray-100 p-2.5 rounded-3xl shadow-sm
									hover:shadow-md transition-shadow cursor-pointer flex items-center">

										<img src="${place.img}"
											onerror="this.onerror=null; this.src='https://placehold.co/400x300/f1f5f9/94a3b8?text=No+Image';"
											class="place-img rounded-2xl object-cover bg-gray-100" alt="${place.title}">

										<div class="place-info flex-1 min-w-0 w-full">
											<h6 class="font-bold text-gray-900 mb-1 truncate text-[15px]">${place.title}
											</h6>
											<p class="text-xs text-gray-500 flex items-center gap-1 mb-1">
												<i data-lucide="map-pin" class="w-3 h-3 text-gray-400"></i>
												${place.loc}
											</p>
											<div class="flex items-center justify-between mt-1">
												<span
													class="inline-block bg-pink-50 text-primary border border-pink-100 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">
													${place.cat} </span>
												<div class="flex items-center text-xs text-gray-400 gap-1">
													<i data-lucide="star"
														class="w-3 h-3 text-yellow-400 fill-yellow-400"></i> <span
														class="font-medium text-gray-600">${place.rating}</span>
													<span>(${place.reviewCount})</span>
												</div>
											</div>
										</div>
									</div>
								</c:forEach>
							</div>
						</div>
					</div>

					<jsp:include page="include/nav.jsp" />

					<script src="<c:url value='/resources/js/main.js' />" defer></script>
					<script>
						// 페이지 개별 초기화 로직만 남깁니다.
						document.addEventListener("DOMContentLoaded", function () {
							if (typeof initIcons === 'function')
								initIcons();
						});
					</script>
				</body>

				</html>