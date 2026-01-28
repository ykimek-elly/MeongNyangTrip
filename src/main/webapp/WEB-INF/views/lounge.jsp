<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<jsp:include page="include/header.jsp" />
<link rel="stylesheet"
	href="<c:url value='/resources/css/style.css' />?v=3">
<title>멍냥트립 - 라운지</title>
</head>

<body class="bg-gray-100">
	<div class="mobile-container min-h-screen pb-24 relative bg-white">

		<header
			class="bg-white px-5 py-4 flex justify-between items-center sticky top-0 z-50 border-b border-gray-100">
			<div class="flex items-center gap-2 cursor-pointer"
				onclick="location.href='<c:url value='/' />'">
				<i data-lucide="leaf" class="text-primary w-5 h-5"></i>
				<h1 class="text-base font-bold text-gray-800">멍냥트립</h1>
			</div>

			<c:choose>
				<c:when test="${empty sessionScope.loginUser}">
					<a href="<c:url value='/login' />"
						class="text-xs font-bold text-gray-600 bg-gray-100 px-3 py-1.5 rounded-full hover:bg-gray-200">로그인</a>
				</c:when>
				<c:otherwise>
					<div class="flex items-center gap-2">
						<span class="text-xs font-bold text-gray-800">${sessionScope.loginUser.nickname}님</span>
						<a href="<c:url value='/logout' />"
							class="text-xs text-gray-400 hover:text-red-500 border border-gray-200 px-2 py-1 rounded-lg">로그아웃</a>
					</div>
				</c:otherwise>
			</c:choose>
		</header>

		<div class="lounge-tab-container sticky top-[60px] z-40 bg-white">
			<div id="tab-btn-feed" onclick="switchTab('feed')"
				class="tab-btn active">
				<i data-lucide="image" class="w-5 h-5"></i> 피드
			</div>
			<div id="tab-btn-talk" onclick="switchTab('talk')" class="tab-btn">
				<i data-lucide="message-circle" class="w-5 h-5"></i> 실시간 톡
			</div>
		</div>

		<div id="view-feed" style="display: block;" class="px-0">
			<div id="feedContainer" class="flex flex-col gap-4 pb-10">

				<c:choose>
					<c:when test="${not empty feedList}">
						<c:forEach var="feed" items="${feedList}">

							<div
								class="bg-white border-b border-gray-100 pb-6 mb-2 overflow-visible relative">

								<div
									class="px-5 py-3 flex justify-between items-center relative z-20">
									<div class="flex items-center gap-2">
										<img
											src="https://api.dicebear.com/7.x/avataaars/svg?seed=${feed.nickname}"
											class="bg-gray-100 w-9 h-9 rounded-full border border-gray-100">
										<div>
											<p class="font-bold text-sm text-gray-900">${feed.nickname}</p>
											<p class="text-[10px] text-gray-400">${feed.timeAgo}</p>
										</div>
									</div>

									<c:if
										test="${sessionScope.loginUser.nickname eq feed.nickname}">
										<div class="relative z-30">
											<button type="button"
												onclick="toggleFeedMenu('${feed.feedId}', event)"
												class="p-2 text-gray-400 hover:bg-gray-50 rounded-full transition-colors">
												<i data-lucide="more-horizontal" class="w-5 h-5"></i>
											</button>

											<div id="feed-menu-${feed.feedId}"
												class="hidden absolute right-0 top-8 w-32 bg-white rounded-xl shadow-xl border border-gray-100 overflow-hidden flex flex-col z-50">
												<button
													onclick="location.href='<c:url value='/lounge/edit/feed'/>?feedId=${feed.feedId}'"
													class="w-full text-left px-4 py-3 text-xs font-bold text-gray-600 hover:bg-gray-50 hover:text-primary border-b border-gray-50 flex items-center gap-2">
													<i data-lucide="edit-2" class="w-3 h-3"></i> 수정하기
												</button>
												<button onclick="deleteFeed('${feed.feedId}')"
													class="w-full text-left px-4 py-3 text-xs font-bold text-red-500 hover:bg-red-50 flex items-center gap-2">
													<i data-lucide="trash-2" class="w-3 h-3"></i> 삭제하기
												</button>
											</div>
										</div>
									</c:if>
								</div>

								<c:if test="${not empty feed.imageUrl}">
									<div class="w-full aspect-square bg-gray-50 mb-3 relative z-10">
										<img src="${feed.imageUrl}" class="w-full h-full object-cover">
									</div>
								</c:if>

								<div
									class="px-4 flex items-center justify-between mb-3 relative z-20">
									<div class="flex items-center gap-4">
										<button onclick="toggleLike(${feed.feedId})"
											class="flex items-center gap-1.5 transition-transform active:scale-90">
											<i id="heart-icon-${feed.feedId}" data-lucide="heart"
												class="w-7 h-7 ${feed.liked ? 'text-pink-500 fill-pink-500' : 'text-gray-800'} transition-colors duration-200"></i>
										</button>
										<a
											href="<c:url value='/lounge/comments?feedId=${feed.feedId}' />">
											<i data-lucide="message-circle" class="w-7 h-7 text-gray-800"></i>
										</a>
										<button onclick="openShareModal()">
											<i data-lucide="send" class="w-7 h-7 text-gray-800"></i>
										</button>
									</div>
								</div>

								<div class="px-5 space-y-2 relative z-20">
									<div
										class="flex items-center gap-2 text-sm font-bold text-gray-900">
										<span>좋아요 <span id="like-count-${feed.feedId}">${feed.likeCount}</span>개
										</span> <span class="text-gray-300">|</span> <a
											href="<c:url value='/lounge/comments?feedId=${feed.feedId}' />"
											class="hover:underline hover:text-primary"> 댓글 <span>${feed.commentCount}</span>개
										</a>
									</div>

									<p class="text-sm text-gray-800 leading-snug">
										<span class="font-bold mr-1.5">${feed.nickname}</span>${feed.content}
									</p>

									<c:if test="${not empty feed.placeName}">
										<div
											onclick="location.href='<c:url value='/map'/>?target=${feed.placeName}'"
											class="inline-flex items-center gap-1 mt-2 bg-gray-50 px-3 py-1.5 rounded-lg cursor-pointer hover:bg-gray-100 transition-colors border border-gray-100">
											<i data-lucide="map-pin" class="w-3.5 h-3.5 text-primary"></i>
											<span class="text-xs font-bold text-gray-700">${feed.placeName}</span>
											<i data-lucide="chevron-right"
												class="w-3 h-3 text-gray-400 ml-1"></i>
										</div>
									</c:if>
								</div>
							</div>

						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="py-20 text-center w-full">
							<i data-lucide="camera"
								class="w-12 h-12 text-gray-200 mx-auto mb-3"></i>
							<p class="text-gray-400">아직 등록된 피드가 없습니다.</p>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div id="view-talk" class="px-5 pt-5 pb-20" style="display: none;">
			<div
				class="bg-primary/5 p-4 rounded-2xl mb-6 flex justify-between items-center">
				<div>
					<h3 class="text-primary font-bold text-sm flex items-center gap-1">
						실시간 산책 톡 <i data-lucide="message-circle" class="w-3 h-3"></i>
					</h3>
					<p class="text-xs text-gray-600 mt-1">
						지금 동네 산책 상황을 공유해요!<br>(24시간 후 자동 삭제)
					</p>
				</div>
				<i data-lucide="clock" class="w-8 h-8 text-pink-300"></i>
			</div>

			<div class="flex flex-col space-y-4">
				<c:choose>
					<c:when test="${not empty talkList}">
						<c:forEach var="talk" items="${talkList}">

							<c:set var="bgClass" value="bg-yellow-50 border-yellow-100" />
							<c:if test="${talk.bgColor eq 'red'}">
								<c:set var="bgClass" value="bg-red-50 border-red-100" />
							</c:if>
							<c:if test="${talk.bgColor eq 'blue'}">
								<c:set var="bgClass" value="bg-blue-50 border-blue-100" />
							</c:if>
							<c:if test="${talk.bgColor eq 'green'}">
								<c:set var="bgClass" value="bg-green-50 border-green-100" />
							</c:if>

							<c:set var="isMyTalk"
								value="${sessionScope.loginUser.nickname eq talk.nickname}" />

							<div class="p-5 rounded-3xl border ${bgClass} relative mb-4">

								<c:if test="${isMyTalk}">
									<button onclick="deleteTalk(${talk.talkId})"
										class="absolute top-4 right-4 text-gray-400 hover:text-red-500 hover:bg-white/50 rounded-full p-1 z-10 transition-colors">
										<i data-lucide="x" class="w-4 h-4"></i>
									</button>
								</c:if>

								<div class="flex justify-between items-start mb-3">
									<div class="flex items-center gap-2">
										<span class="font-bold text-gray-900 text-[15px]">${talk.nickname}</span>
										<span class="text-xs text-gray-400">${talk.timeAgo}</span>
									</div>

									<c:if test="${not empty talk.locationName}">
										<span
											onclick="location.href='<c:url value='/map'/>?target=${talk.locationName}'"
											class="text-[10px] text-gray-500 flex items-center gap-0.5 bg-white/60 px-2 py-1 rounded-full cursor-pointer hover:bg-white hover:text-primary hover:font-bold transition-all shadow-sm ${isMyTalk ? 'mr-8' : ''}">
											<i data-lucide="map-pin" class="w-3 h-3"></i>
											${talk.locationName}
										</span>
									</c:if>
								</div>

								<p
									class="text-gray-800 text-[15px] leading-relaxed mb-1 font-medium">${talk.content}</p>

								<div
									class="mt-3 pt-3 border-t border-black/5 flex items-center justify-between">
									<a
										href="<c:url value='/lounge/talk/comments?talkId=${talk.talkId}' />"
										class="flex items-center gap-1.5 text-gray-500 hover:text-gray-900 transition-colors">
										<i data-lucide="message-circle" class="w-4 h-4"></i> <span
										class="text-xs font-bold">댓글 달기</span>
									</a>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="text-center py-20 text-gray-400">등록된 톡이 없습니다.</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div id="writeModal" class="fixed inset-0 z-[60] hidden">
			<div
				class="absolute inset-0 bg-black/50 backdrop-blur-sm transition-opacity opacity-0"
				onclick="closeWriteModal()" id="modalBackdrop"></div>
			<div
				class="absolute bottom-0 left-0 right-0 bg-white rounded-t-3xl p-6 transform translate-y-full transition-transform duration-300 ease-out sm:max-w-[430px] sm:mx-auto"
				id="modalContent">
				<div class="w-12 h-1 bg-gray-200 rounded-full mx-auto mb-6"></div>
				<h3 class="text-lg font-bold text-gray-900 mb-6 text-center">게시글
					작성</h3>
				<div class="space-y-3">
					<a href="<c:url value='/lounge/write/feed' />"
						class="flex items-center gap-4 p-4 bg-gray-50 rounded-2xl hover:bg-gray-100 transition-colors">
						<div
							class="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-sm text-primary">
							<i data-lucide="image" class="w-6 h-6"></i>
						</div>
						<div>
							<h4 class="font-bold text-gray-900">피드 쓰기</h4>
							<p class="text-xs text-gray-500">사진과 함께 추억 공유</p>
						</div>
					</a> <a href="<c:url value='/lounge/write/talk' />"
						class="flex items-center gap-4 p-4 bg-gray-50 rounded-2xl hover:bg-gray-100 transition-colors">
						<div
							class="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-sm text-primary">
							<i data-lucide="message-circle" class="w-6 h-6"></i>
						</div>
						<div>
							<h4 class="font-bold text-gray-900">실시간 톡 쓰기</h4>
							<p class="text-xs text-gray-500">지금 상황 빠르게 공유</p>
						</div>
					</a>
				</div>
			</div>
		</div>

		<div id="alertModal"
			class="fixed inset-0 z-[70] hidden flex items-center justify-center px-4">
			<div class="absolute inset-0 bg-black/40 backdrop-blur-sm"
				onclick="closeShareModal()"></div>
			<div
				class="bg-white rounded-2xl p-6 w-full max-w-xs relative transform transition-all scale-95 opacity-0"
				id="alertContent">
				<div class="text-center">
					<div
						class="w-12 h-12 bg-pink-100 rounded-full flex items-center justify-center mx-auto mb-4">
						<i data-lucide="rocket" class="w-6 h-6 text-primary"></i>
					</div>
					<h3 class="text-lg font-bold text-gray-900 mb-2">준비 중인 기능입니다</h3>
					<p class="text-sm text-gray-500 mb-6">
						공유하기 기능은 곧 업데이트될 예정입니다!<br>조금만 기다려주세요 🐾
					</p>
					<button onclick="closeShareModal()"
						class="w-full py-3 bg-primary text-white rounded-xl font-bold hover:bg-primary-dark transition-colors">확인</button>
				</div>
			</div>
		</div>

		<div class="fab-pink" onclick="openWriteModal()">
			<i data-lucide="plus" class="w-7 h-7"></i>
		</div>

	</div>

	<jsp:include page="include/nav.jsp" />

<script src="<c:url value='/resources/js/main.js' />"></script>

<script>
    // API 주소 및 로그인 상태 설정
    const API_URLS = {
        DELETE_FEED: "<c:url value='/lounge/delete/feed' />",
        TOGGLE_LIKE: "<c:url value='/lounge/toggleLike' />",
        DELETE_TALK: "<c:url value='/lounge/delete/talk' />"
    };
    
    // 로그인 여부 (true/false)
    const IS_LOGIN = ${not empty sessionScope.loginUser};
</script>

<script src="<c:url value='/resources/js/feed.js' />?v=5"></script>

</body>
</html>