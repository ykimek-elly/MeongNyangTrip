<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="include/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
<title>피드 쓰기 - 멍냥트립</title>
</head>

<body class="bg-gray-100">
    <form action="<c:url value='/lounge/write/feed' />" method="POST" enctype="multipart/form-data">
		<div class="mobile-container min-h-screen relative bg-white pb-24">
			
			<header class="bg-white px-5 py-4 flex items-center justify-between sticky top-0 z-50 border-b border-gray-50">
				<button type="button" onclick="history.back()" class="flex-shrink-0">
					<i data-lucide="x" class="w-6 h-6 text-gray-800"></i>
				</button>
				<h1 class="text-base font-bold text-gray-900 absolute left-1/2 -translate-x-1/2">새 게시물</h1>
				<button type="submit" class="text-sm font-bold text-primary">공유</button>
			</header>

			<div class="p-5">
				<div class="mb-6">
                    <label for="imageUpload" class="block w-full aspect-square bg-gray-50 rounded-2xl border-2 border-dashed border-gray-200 flex flex-col items-center justify-center cursor-pointer hover:bg-gray-100 transition-colors relative overflow-hidden">
                        <img id="imagePreview" class="absolute inset-0 w-full h-full object-cover hidden">
                        
                        <div id="uploadPlaceholder" class="text-center p-4">
                            <div class="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-3 text-gray-400">
                                <i data-lucide="camera" class="w-6 h-6"></i>
                            </div>
                            <p class="text-sm font-bold text-gray-400">사진을 등록해주세요</p>
                        </div>
                    </label>
                    <input type="file" id="imageUpload" name="imageFile" accept="image/*" class="hidden" onchange="previewImage(this)">
				</div>

				<textarea name="content"
					class="w-full h-32 resize-none text-[15px] outline-none placeholder-gray-300 mb-6"
					placeholder="어떤 추억이 있었나요? 이야기를 들려주세요." required></textarea>

				<div onclick="openSearchModal()"
					class="flex items-center gap-2 text-gray-500 bg-gray-50 px-4 py-3 rounded-xl cursor-pointer hover:bg-gray-100 transition-colors border border-gray-100">
					<i data-lucide="map-pin" class="w-5 h-5 text-primary"></i> 
					<span id="place-label" class="text-sm font-medium text-gray-900">장소 태그하기</span> 
                    
                    <input type="hidden" name="placeName" id="placeName" value="">
                    <input type="hidden" name="placeId" id="placeId" value="">
				</div>
			</div>
		</div>
	</form>

    <div id="searchModal" class="fixed inset-0 z-[60] hidden">
		<div class="absolute inset-0 bg-black/50 backdrop-blur-sm transition-opacity opacity-0"
			id="searchBackdrop" onclick="closeSearchModal()"></div>
		<div class="absolute bottom-0 left-0 right-0 bg-white rounded-t-3xl h-[80vh] flex flex-col transform translate-y-full transition-transform duration-300 ease-out w-full max-w-[430px] mx-auto"
			id="searchContent">
			<div class="p-5 border-b border-gray-100 flex items-center gap-3">
				<div class="flex-1 bg-gray-100 rounded-xl px-3 py-2 flex items-center gap-2">
					<i data-lucide="search" class="w-5 h-5 text-gray-400"></i>
					<input type="text" id="searchInput" placeholder="장소 검색"
						class="bg-transparent text-sm w-full outline-none"
						onkeyup="if(window.event.keyCode==13){searchPlaces()}">
				</div>
				<button onclick="closeSearchModal()" class="text-sm text-gray-500 font-medium">닫기</button>
			</div>
			<div id="searchResultList" class="flex-1 overflow-y-auto p-5 space-y-2">
                <div class="text-center py-20 text-gray-400 text-sm">장소를 검색해보세요!</div>
            </div>
		</div>
	</div>

	<script src="https://unpkg.com/lucide@latest"></script>
	<script>
        if (typeof lucide !== 'undefined') lucide.createIcons();

        // [추가] 이미지 미리보기 함수
        function previewImage(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('imagePreview').src = e.target.result;
                    document.getElementById('imagePreview').classList.remove('hidden');
                    document.getElementById('uploadPlaceholder').classList.add('hidden');
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // --- 장소 검색 관련 (Talk와 동일) ---
        function openSearchModal() {
            const modal = document.getElementById('searchModal');
            const backdrop = document.getElementById('searchBackdrop');
            const content = document.getElementById('searchContent');
            modal.classList.remove('hidden');
            setTimeout(() => {
                backdrop.classList.remove('opacity-0');
                content.classList.remove('translate-y-full');
            }, 10);
            setTimeout(() => document.getElementById('searchInput').focus(), 300);
        }

        function closeSearchModal() {
            const modal = document.getElementById('searchModal');
            const backdrop = document.getElementById('searchBackdrop');
            const content = document.getElementById('searchContent');
            backdrop.classList.add('opacity-0');
            content.classList.add('translate-y-full');
            setTimeout(() => { modal.classList.add('hidden'); }, 300);
        }

        function searchPlaces() {
            const keyword = document.getElementById('searchInput').value.trim();
            if(!keyword) return;
            const resultDiv = document.getElementById('searchResultList');
            resultDiv.innerHTML = '<div class="text-center py-10 text-gray-400">검색 중...</div>';

            fetch('<c:url value="/place/api/search/list" />?keyword=' + encodeURIComponent(keyword))
            .then(res => res.json())
            .then(data => {
                resultDiv.innerHTML = '';
                if(data.length === 0) {
                    resultDiv.innerHTML = '<div class="text-center py-10 text-gray-400">결과가 없습니다.</div>';
                    return;
                }
                data.forEach(place => {
                    const item = document.createElement('div');
                    item.className = 'p-3 border-b border-gray-50 hover:bg-gray-50 cursor-pointer flex justify-between items-center';
                    // place.id도 함께 넘겨줍니다.
                    item.onclick = function() { selectPlace(place.title, place.id); };
                    item.innerHTML = `<div><p class="font-bold text-gray-800 text-sm">` + place.title + `</p><p class="text-xs text-gray-500">` + (place.addr || '') + `</p></div>`;
                    resultDiv.appendChild(item);
                });
            });
        }

        function selectPlace(name, id) {
            document.getElementById('place-label').innerText = "📍 " + name;
            document.getElementById('place-label').classList.add('text-primary');
            document.getElementById('placeName').value = name;
            document.getElementById('placeId').value = id; // ID도 저장
            closeSearchModal();
        }
    </script>
</body>
</html>