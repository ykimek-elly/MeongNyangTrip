<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="include/header.jsp" />
    <link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
    <title>톡 댓글</title>
</head>
<body class="bg-white">
    <div class="mobile-container min-h-screen flex flex-col relative pb-20">
        
        <header class="sticky top-0 z-50 bg-white/95 backdrop-blur-md border-b border-gray-100 px-4 h-14 flex items-center gap-3">
            <button onclick="history.back()" class="p-1"><i data-lucide="chevron-left" class="w-6 h-6"></i></button>
            <h1 class="font-bold text-base">댓글</h1>
        </header>

        <div class="flex-1 p-5 space-y-6 overflow-y-auto">
            <c:choose>
                <c:when test="${not empty commentList}">
                    <c:forEach var="cmt" items="${commentList}">
                        <div class="flex gap-3">
                            <div class="w-8 h-8 rounded-full bg-yellow-100 flex items-center justify-center text-xs font-bold text-yellow-600 flex-shrink-0">
                                ${cmt.nickname.substring(0,1)}
                            </div>
                            <div class="flex-1">
                                <div class="flex items-center justify-between mb-1">
                                    <span class="text-xs font-bold text-gray-900">${cmt.nickname}</span>
                                    
                                    <c:if test="${sessionScope.loginUser.nickname eq cmt.nickname}">
                                        <button onclick="deleteComment(${cmt.id})" class="text-[10px] text-gray-400 underline">삭제</button>
                                    </c:if>
                                </div>
                                <div class="bg-gray-50 px-3 py-2 rounded-r-xl rounded-bl-xl text-sm text-gray-700 leading-relaxed">
                                    ${cmt.content}
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-20 text-gray-300 text-sm">
                        아직 댓글이 없습니다.<br>첫 번째 대화를 시작해보세요!
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 p-3 sm:max-w-[430px] sm:mx-auto">
            <div class="flex gap-2">
                <input type="text" id="cmtInput" class="flex-1 bg-gray-50 rounded-full px-4 text-sm outline-none focus:ring-2 focus:ring-primary/20 transition-all" placeholder="댓글을 입력하세요..." onkeyup="if(window.event.keyCode==13){addComment()}">
                <button onclick="addComment()" class="w-10 h-10 bg-primary text-white rounded-full flex items-center justify-center hover:bg-primary-dark transition-colors">
                    <i data-lucide="send" class="w-4 h-4 ml-0.5"></i>
                </button>
            </div>
        </div>
    </div>

    <script src="https://unpkg.com/lucide@latest"></script>
    <script>
        lucide.createIcons();

        function addComment() {
            const content = document.getElementById('cmtInput').value.trim();
            if(!content) return;

            fetch('<c:url value="/lounge/talk/addComment" />', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'talkId=${talkId}&content=' + encodeURIComponent(content)
            })
            .then(res => res.text())
            .then(data => {
                if(data === "success") location.reload();
                else alert("로그인이 필요합니다.");
            });
        }

        function deleteComment(id) {
            if(!confirm("삭제하시겠습니까?")) return;
            fetch('<c:url value="/lounge/talk/deleteComment" />', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + id
            })
            .then(res => res.text())
            .then(data => {
                if(data === "success") location.reload();
            });
        }
    </script>
</body>
</html>