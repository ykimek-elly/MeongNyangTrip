<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="include/header.jsp" />
    <link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
    <title>피드 수정</title>
</head>
<body class="bg-white">
    <div class="mobile-container min-h-screen pb-20">
        
        <header class="sticky top-0 z-50 bg-white border-b border-gray-100 px-4 h-14 flex items-center justify-between">
            <button onclick="history.back()" class="p-2 -ml-2"><i data-lucide="chevron-left" class="w-6 h-6"></i></button>
            <h1 class="font-bold text-base">게시글 수정</h1>
            <button type="submit" form="editForm" class="text-sm font-bold text-primary px-2">완료</button>
        </header>

        <form id="editForm" action="<c:url value='/lounge/edit/feed' />" method="POST" enctype="multipart/form-data" class="p-5">
            <input type="hidden" name="feedId" value="${feed.feedId}">

            <textarea name="content" class="w-full h-40 resize-none outline-none text-base placeholder-gray-300" 
                      placeholder="어떤 추억이 있었나요?">${feed.content}</textarea>

            <div class="mt-6">
                <label class="block text-sm font-bold text-gray-900 mb-2">사진</label>
                <div class="flex gap-3 overflow-x-auto pb-2">
                    <label class="w-20 h-20 flex-shrink-0 border border-gray-200 rounded-xl flex flex-col items-center justify-center cursor-pointer bg-gray-50">
                        <i data-lucide="camera" class="w-6 h-6 text-gray-400"></i>
                        <span class="text-[10px] text-gray-400 mt-1">변경</span>
                        <input type="file" name="imageFile" class="hidden" accept="image/*" onchange="previewImage(this)">
                    </label>
                    
                    <div class="w-20 h-20 flex-shrink-0 rounded-xl bg-gray-100 overflow-hidden relative" id="preview-box">
                        <c:choose>
                            <c:when test="${not empty feed.imageUrl}">
                                <img id="preview" src="${feed.imageUrl}" class="w-full h-full object-cover">
                            </c:when>
                            <c:otherwise>
                                <img id="preview" class="w-full h-full object-cover hidden">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="mt-8 pt-6 border-t border-gray-100">
                <div class="flex justify-between items-center mb-3">
                    <label class="text-sm font-bold text-gray-900">장소</label>
                    <button type="button" onclick="openPlaceSearch()" class="text-xs text-gray-400 flex items-center">
                        <i data-lucide="map-pin" class="w-3 h-3 mr-1"></i> 장소 변경
                    </button>
                </div>
                <input type="text" name="placeName" value="${feed.placeName}" class="w-full bg-gray-50 rounded-xl px-4 py-3 text-sm outline-none" placeholder="장소를 입력하거나 지도에서 선택하세요">
                <input type="hidden" name="placeId" value="${feed.placeId}">
            </div>
        </form>
    </div>

    <script src="https://unpkg.com/lucide@latest"></script>
    <script>
        lucide.createIcons();

        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    const preview = document.getElementById('preview');
                    preview.src = e.target.result;
                    preview.classList.remove('hidden');
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        function openPlaceSearch() {
            alert('지도 검색 기능은 준비 중입니다.'); 
            // 추후 지도 팝업 연결
        }
    </script>
</body>
</html>