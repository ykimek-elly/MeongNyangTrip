<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<nav
	class="fixed bottom-0 left-0 right-0 max-w-[600px] mx-auto bg-white border-t border-gray-100 flex justify-between items-center px-2 pb-4 pt-3 z-50 text-[10px] font-medium text-gray-400">

	<a href="<c:url value='/' />"
		class="flex flex-col items-center gap-1 w-full p-1 ${activeTab == 'home' ? 'text-primary font-bold' : 'hover:text-gray-600'}">
		<i data-lucide="home"
		class="w-6 h-6 ${activeTab == 'home' ? 'text-primary fill-primary/10' : ''}"></i>
		<span>홈</span>
	</a> <a href="<c:url value='/list' />"
		class="flex flex-col items-center gap-1 w-full p-1 ${activeTab == 'list' ? 'text-primary font-bold' : 'hover:text-gray-600'}">
		<i data-lucide="list"
		class="w-6 h-6 ${activeTab == 'list' ? 'text-primary' : ''}"></i> <span>목록보기</span>
	</a> <a href="<c:url value='/map' />"
		class="flex flex-col items-center gap-1 w-full p-1 ${activeTab == 'map' ? 'text-primary font-bold' : 'hover:text-gray-600'}">
		<i data-lucide="map"
		class="w-6 h-6 ${activeTab == 'map' ? 'text-primary fill-primary/10' : ''}"></i>
		<span>지도</span>
	</a> <a href="<c:url value='/lounge' />"
		class="flex flex-col items-center gap-1 w-full p-1 ${activeTab == 'lounge' ? 'text-primary font-bold' : 'hover:text-gray-600'}">
		<i data-lucide="message-circle"
		class="w-6 h-6 ${activeTab == 'lounge' ? 'text-primary fill-primary/10' : ''}"></i>
		<span>라운지</span>
	</a> <a
		href="<c:url value='${empty sessionScope.loginUser ? "/login" : "/wish"}' />"
		class="flex flex-col items-center gap-1 w-full p-1 ${activeTab == 'wish' ? 'text-primary font-bold' : 'text-gray-400 hover:text-gray-600'}">
		<i data-lucide="heart"
		class="w-6 h-6 ${activeTab == 'wish' ? 'text-primary fill-primary/10' : ''}"></i>
		<span>찜</span>
	</a> <a
		href="<c:url value='${empty sessionScope.loginUser ? "/login" : "/mypage"}' />"
		class="flex flex-col items-center gap-1 w-full p-1 ${activeTab == 'mypage' ? 'text-primary font-bold' : 'text-gray-400 hover:text-gray-600'}">
		<i data-lucide="user"
		class="w-6 h-6 ${activeTab == 'mypage' ? 'text-primary fill-primary/10' : ''}"></i>
		<span>마이</span>
	</a> 

</nav>

<script>
	if (typeof lucide !== 'undefined') {
		lucide.createIcons();
	}
</script>