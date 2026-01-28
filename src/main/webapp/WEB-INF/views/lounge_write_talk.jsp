<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="include/header.jsp" />
<link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
<title>실시간 톡 쓰기 - 멍냥트립</title>
</head>

<body class="bg-gray-100">
	<form action="<c:url value='/lounge/write/talk' />" method="POST">
		<div class="mobile-container min-h-screen relative bg-white pb-24">
			
			<header
				class="bg-white px-5 py-4 flex items-center justify-between sticky top-0 z-50 border-b border-gray-50">
				<button type="button" onclick="history.back()" class="flex-shrink-0">
					<i data-lucide="x" class="w-6 h-6 text-gray-800"></i>
				</button>
				<h1 class="text-base font-bold text-gray-900 absolute left-1/2 -translate-x-1/2">실시간 톡</h1>
				<button type="submit" class="text-sm font-bold text-primary">등록</button>
			</header>

			<div class="p-5">
				<div class="bg-primary/5 p-4 rounded-2xl mb-6">
					<div class="flex items-center gap-2 mb-1">
						<i data-lucide="info" class="w-4 h-4 text-primary"></i> <span
							class="text-xs font-bold text-primary">안내</span>
					</div>
					<p class="text-xs text-gray-600 leading-relaxed">
						실시간 톡은 24시간 동안만 유지됩니다.<br> 동네 산책 정보, 반짝 모임 등 지금 상황을 공유해보세요!
					</p>
				</div>

				<textarea name="content"
					class="w-full h-32 resize-none text-[15px] outline-none placeholder-gray-300 mb-6"
					placeholder="지금 무슨 일이 일어나고 있나요?" required></textarea>

				<div class="mb-8">
					<span class="block text-sm font-bold text-gray-700 mb-3">태그 선택</span>
					
					<input type="hidden" name="bgColor" id="bgColorInput" value="yellow">
					
					<div class="flex gap-3">
						<button type="button" onclick="selectColor('yellow', this)"
							class="w-8 h-8 rounded-full bg-yellow-100 border-2 border-yellow-400 ring-2 ring-yellow-200"></button>
						<button type="button" onclick="selectColor('red', this)"
							class="w-8 h-8 rounded-full bg-red-100 border border-gray-200"></button>
						<button type="button" onclick="selectColor('blue', this)"
							class="w-8 h-8 rounded-full bg-blue-100 border border-gray-200"></button>
						<button type="button" onclick="selectColor('green', this)"
							class="w-8 h-8 rounded-full bg-green-100 border border-gray-200"></button>
					</div>
				</div>

				<div onclick="openSearchModal()"
					class="flex items-center gap-2 text-gray-500 bg-gray-50 px-4 py-3 rounded-xl cursor-pointer hover:bg-gray-100 transition-colors">
					<i data-lucide="map-pin" class="w-5 h-5 text-primary"></i> 
					
					<span id="place-label" class="text-sm font-medium text-gray-900">현재 위치 (자동 첨부)</span> 
					<input type="hidden" name="locationName" id="locationName" value="">
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
					<input type="text" id="searchInput" placeholder="장소 이름을 검색해보세요"
						class="bg-transparent text-sm w-full outline-none"
						onkeyup="if(window.event.keyCode==13){searchPlaces()}">
				</div>
				<button onclick="closeSearchModal()" class="text-sm text-gray-500 font-medium">닫기</button>
			</div>

			<div id="searchResultList" class="flex-1 overflow-y-auto p-5 space-y-2">
				<div class="text-center py-20 text-gray-400 text-sm">
					<i data-lucide="map" class="w-10 h-10 mx-auto mb-2 opacity-50"></i>
					어디에 계신가요?<br>장소를 검색해서 태그해보세요!
				</div>
			</div>
			
			<div class="p-4 border-t border-gray-100">
				<button onclick="resetLocation()" class="w-full py-3 bg-primary/10 text-primary rounded-xl font-bold text-sm">
					📍 현재 내 위치 사용하기
				</button>
			</div>
		</div>
	</div>

	<script src="https://unpkg.com/lucide@latest"></script>
	<script>
        if (typeof lucide !== 'undefined') lucide.createIcons();

        function selectColor(color, btnElement) {
            document.getElementById('bgColorInput').value = color;
            const buttons = btnElement.parentElement.children;
            for(let btn of buttons) {
                btn.style.borderWidth = "1px";
                btn.style.borderColor = "#e5e7eb"; 
                btn.style.boxShadow = "none";
            }
            btnElement.style.borderWidth = "2px";
            btnElement.style.borderColor = "#fbbf24"; 
            btnElement.style.boxShadow = "0 0 0 2px #fde68a"; 
        }

        // --- 장소 검색 모달 관련 ---

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

            setTimeout(() => {
                modal.classList.add('hidden');
            }, 300);
        }

        function searchPlaces() {
            const keyword = document.getElementById('searchInput').value.trim();
            if(!keyword) {
                alert("검색어를 입력해주세요.");
                return;
            }

            const resultDiv = document.getElementById('searchResultList');
            resultDiv.innerHTML = '<div class="text-center py-10 text-gray-400">검색 중...</div>';

            fetch('<c:url value="/place/api/search/list" />?keyword=' + encodeURIComponent(keyword))
            .then(response => response.json())
            .then(data => {
                resultDiv.innerHTML = ''; 

                if(data.length === 0) {
                    resultDiv.innerHTML = '<div class="text-center py-10 text-gray-400 text-sm">검색 결과가 없습니다.</div>';
                    return;
                }

                data.forEach(place => {
                    const item = document.createElement('div');
                    item.className = 'p-3 border-b border-gray-50 hover:bg-gray-50 cursor-pointer flex justify-between items-center';
                    item.onclick = function() { selectPlace(place.title); }; 
                    
                    item.innerHTML = `
                        <div>
                            <p class="font-bold text-gray-800 text-sm">` + place.title + `</p>
                            <p class="text-xs text-gray-500 mt-0.5">` + (place.addr || '주소 정보 없음') + `</p>
                        </div>
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-300"></i>
                    `;
                    resultDiv.appendChild(item);
                });
                
                lucide.createIcons();
            })
            .catch(err => {
                console.error(err);
                resultDiv.innerHTML = '<div class="text-center py-10 text-red-400 text-sm">오류가 발생했습니다.</div>';
            });
        }

        function selectPlace(placeName) {
            const label = document.getElementById('place-label');
            label.innerText = "📍 " + placeName;
            label.classList.add('text-primary'); 
            
            document.getElementById('locationName').value = placeName;
            closeSearchModal();
        }

        function resetLocation() {
            const label = document.getElementById('place-label');
            label.innerText = "📍 현재 위치 (자동 첨부)";
            label.classList.remove('text-primary');
            
            document.getElementById('locationName').value = ""; 
            closeSearchModal();
        }
    </script>
</body>
</html>