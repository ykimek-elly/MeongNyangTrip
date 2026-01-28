<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <jsp:include page="include/header.jsp" />
            <title>멍냥트립 - 마이페이지</title>
            <link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
        </head>

        <body class="bg-gray-100">
            <div class="mobile-container bg-gray-50 min-h-screen pb-24">

                <header
                    class="bg-white px-5 py-4 flex justify-between items-center sticky top-0 z-50 border-b border-gray-100">
                    <div class="flex items-center gap-2">
                        <i data-lucide="leaf" class="text-primary w-5 h-5"></i>
                        <h1 class="text-base font-bold text-gray-800">멍냥트립</h1>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout"
                        class="bg-gray-100 text-xs font-bold px-3 py-1.5 rounded-full text-gray-500 hover:text-red-500 hover:bg-gray-200 transition-colors">
                        로그아웃
                    </a>
                </header>

                <div class="bg-white rounded-b-3xl px-6 pt-2 pb-8 shadow-sm mb-6">
                    <div class="flex items-center gap-4 mb-6">
                        <div
                            class="w-16 h-16 bg-green-50 rounded-full flex items-center justify-center border border-green-100 relative">
                            <i data-lucide="dog" class="w-8 h-8 text-green-600"></i>
                            <span
                                class="absolute bottom-0 right-0 w-4 h-4 bg-primary border-2 border-white rounded-full"></span>
                        </div>
                        <div>
                            <h2 class="text-xl font-bold text-gray-900">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.loginUser}">
                                        ${sessionScope.loginUser.nickname} 님
                                    </c:when>
                                    <c:otherwise>
                                        로그인이 필요합니다
                                    </c:otherwise>
                                </c:choose>
                            </h2>
                            <p class="text-xs text-gray-500 mt-1">오늘도 산책하기 좋은 날이에요! ☀️</p>
                        </div>
                    </div>

                    <div class="flex gap-3">
                        <div
                            class="flex-1 bg-gray-50 rounded-2xl p-4 text-center cursor-pointer hover:bg-pink-50 transition-colors group">
                            <p class="text-xs text-gray-500 mb-1 group-hover:text-primary">나의 찜</p>
                            <span class="text-xl font-bold text-primary">${wishCount}</span>
                        </div>
                        <div
                            class="flex-1 bg-gray-50 rounded-2xl p-4 text-center cursor-pointer hover:bg-pink-50 transition-colors group">
                            <p class="text-xs text-gray-500 mb-1 group-hover:text-primary">다녀온 곳</p>
                            <span class="text-xl font-bold text-gray-800 group-hover:text-primary">0</span>
                        </div>
                    </div>
                </div>

                <div class="px-5">
                    <h3 class="text-sm font-bold text-gray-800 mb-4 ml-1">찜한 장소 목록</h3>

                    <c:if test="${empty myWishlist}">
                        <div class="flex flex-col items-center justify-center py-16 text-center">
                            <i data-lucide="leaf" class="w-12 h-12 text-gray-300 mb-3 stroke-[1.5]"></i>
                            <p class="text-sm text-gray-400">찜한 장소가 비어있습니다.</p>
                        </div>
                    </c:if>

                    <div class="grid grid-cols-2 gap-3">
                        <c:forEach var="place" items="${myWishlist}">
                            <a href="${pageContext.request.contextPath}/detail/${place.id}" class="block bg-white border
                            border-gray-100 rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition-shadow">
                                <div class="relative aspect-[4/3]">
                                    <img src="${place.img}" alt="${place.title}" class="w-full h-full object-cover">
                                    <span
                                        class="absolute top-2 right-2 bg-white/90 backdrop-blur-sm px-1.5 py-0.5 rounded text-[10px] font-bold text-gray-600">
                                        ⭐ ${place.rating}
                                    </span>
                                </div>
                                <div class="p-3">
                                    <div class="flex items-center gap-1 mb-1">
                                        <span
                                            class="text-[10px] font-bold text-primary bg-pink-50 px-1.5 py-0.5 rounded">
                                            ${place.cat}
                                        </span>
                                    </div>
                                    <h4 class="text-sm font-bold text-gray-900 truncate mb-1">${place.title}</h4>
                                    <p class="text-[10px] text-gray-400 truncate">${place.loc}</p>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>

            </div>

            <jsp:include page="include/nav.jsp" />

            <script src="<c:url value='/resources/js/main.js' />" defer></script>
        </body>

        </html>