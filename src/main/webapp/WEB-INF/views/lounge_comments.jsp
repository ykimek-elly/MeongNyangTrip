<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="include/header.jsp" />
<link rel="stylesheet"
	href="<c:url value='/resources/css/style.css' />?v=3">
<title>댓글 - 멍냥트립</title>
</head>
<body class="bg-white">
	<div class="mobile-container min-h-screen flex flex-col bg-white">

		<header
			class="bg-white px-4 py-4 flex items-center border-b border-gray-100 sticky top-0 z-50">
			<button onclick="history.back()"
				class="p-1 mr-3 hover:bg-gray-100 rounded-full transition-colors">
				<i data-lucide="arrow-left" class="w-6 h-6 text-gray-800"></i>
			</button>
			<h1 class="text-lg font-bold text-gray-900">댓글</h1>
		</header>

		<div class="p-5 border-b border-gray-50 flex gap-3 bg-gray-50/30">
			<img
				src="https://api.dicebear.com/7.x/avataaars/svg?seed=${feed.nickname}"
				class="w-10 h-10 rounded-full bg-white shadow-sm border border-gray-100">
			<div class="flex-1">
				<p class="text-sm font-bold text-gray-900">${feed.nickname}</p>
				<p class="text-sm text-gray-700 mt-1 leading-relaxed">${feed.content}</p>
				<p class="text-[11px] text-gray-400 mt-2">${feed.timeAgo}</p>
			</div>
		</div>

		<div id="commentList" class="flex-1 overflow-y-auto p-5 space-y-6">
			<c:choose>
				<c:when test="${not empty commentList}">
					<c:forEach var="comment" items="${commentList}">
						<div class="flex gap-3">
							<img
								src="https://api.dicebear.com/7.x/avataaars/svg?seed=${comment.nickname}"
								class="w-9 h-9 rounded-full">
							<div class="flex-1">
								<div class="flex justify-between">
									<p class="text-xs font-bold">${comment.nickname}</p>
									<div class="flex gap-2 items-center">
										<span class="text-xs text-gray-400">${comment.timeAgo}</span>
										<c:if
											test="${(sessionScope.loginUser.nickname eq comment.nickname) or (comment.nickname eq '익명댕댕이')}">
											<button onclick="deleteComment(${comment.commentId})"
												class="text-red-400">
												<i data-lucide="trash-2" class="w-3 h-3"></i>
											</button>
										</c:if>
									</div>
								</div>
								<p class="text-sm text-gray-700">${comment.content}</p>
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<div class="py-20 text-center">
						<i data-lucide="message-square"
							class="w-12 h-12 text-gray-200 mx-auto mb-3"></i>
						<p class="text-gray-400 text-sm">
							아직 댓글이 없습니다.<br>첫 번째 댓글을 남겨보세요!
						</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>

		<div class="p-4 border-t border-gray-100 bg-white sticky bottom-0">
			<div class="flex gap-3 items-center">
				<div
					class="flex-1 bg-gray-100 rounded-2xl px-4 py-1.5 flex items-center border border-transparent focus-within:border-primary/30 focus-within:bg-white transition-all">
					<input type="text" id="commentInput" placeholder="댓글을 입력하세요..."
						onkeyup="if(window.event.keyCode==13){postComment()}"
						class="flex-1 text-sm py-2 bg-transparent focus:outline-none">
				</div>
				<button onclick="postComment()"
					class="text-primary font-bold text-sm px-2 py-2">게시</button>
			</div>
		</div>
	</div>

	<script>
    document.addEventListener("DOMContentLoaded", function() {
        if (typeof lucide !== 'undefined') lucide.createIcons();
    });

    function postComment() {
        const input = document.getElementById('commentInput');
        const content = input.value.trim();
        const feedId = "${feedId}"; 

        if (!content) {
            alert("댓글 내용을 입력해주세요.");
            return;
        }

        fetch('<c:url value="/lounge/addComment" />', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'feedId=' + feedId + '&content=' + encodeURIComponent(content)
        })
        .then(res => res.text())
        .then(data => {
            if (data === "success") {
                input.value = '';
                location.reload(); 
            } else {
                alert("댓글 등록에 실패했습니다.");
            }
        })
        .catch(err => console.error("전송 에러:", err));
    }

   function deleteComment(commentId) {
    if (!confirm("정말로 이 댓글을 삭제하시겠습니까?")) return;
    const feedId = "${feedId}"; 

    fetch('<c:url value="/lounge/deleteComment" />', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'commentId=' + commentId + '&feedId=' + feedId 
    })
    .then(res => res.text())
    .then(data => {
        if (data === "success") {
            location.reload();
        } else {
            alert("삭제 실패: " + data);
        }
    })
    .catch(err => console.error("삭제 에러:", err));
}
</script>
</body>
</html>