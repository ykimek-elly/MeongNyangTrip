<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <jsp:include page="include/header.jsp" />
            <title>멍냥트립 - 회원가입</title>

            <link rel="stylesheet" href="<c:url value='/resources/css/style.css' />?v=9">
        </head>

        <body class="bg-gray-100">
            <div class="mobile-container min-h-screen px-6 py-8 relative bg-white pb-24">

                <header class="flex items-center mb-8">
                    <button onclick="history.back()" class="p-2 -ml-2 text-gray-600">
                        <i data-lucide="arrow-left" class="w-6 h-6"></i>
                    </button>
                    <div class="flex-1 flex justify-center gap-2">
                        <div id="bar1" class="h-1.5 w-8 rounded-full bg-primary transition-all duration-300"></div>
                        <div id="bar2" class="h-1.5 w-2 rounded-full bg-gray-200 transition-all duration-300"></div>
                        <div id="bar3" class="h-1.5 w-2 rounded-full bg-gray-200 transition-all duration-300"></div>
                    </div>
                    <div class="w-8"></div>
                </header>

                <form id="joinForm" action="<c:url value='/joinProcess' />" method="post">

                    <section id="step1" class="space-y-6 fade-in-up">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-900 mb-2">반가워요! 👋<br />먼저 보호자님 정보를 알려주세요.</h2>
                            <p class="text-gray-500 text-sm">로그인에 사용할 계정 정보입니다.</p>
                        </div>
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">이메일 (아이디)</label>
                                <input type="email" name="id" required
                                    class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary transition-all"
                                    placeholder="example@email.com">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
                                <input type="password" id="pw1" name="password" required
                                    class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary transition-all"
                                    placeholder="6자리 이상 입력해주세요">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">비밀번호 확인</label>
                                <input type="password" id="pw2" required
                                    class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary transition-all"
                                    placeholder="비밀번호를 한번 더 입력해주세요">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">닉네임</label>
                                <input type="text" name="nickname" required
                                    class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary transition-all"
                                    placeholder="활동할 닉네임을 입력해주세요">
                            </div>
                        </div>
                    </section>

                    <section id="step2" class="hidden space-y-6">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-900 mb-2">우리 아이를 소개해주세요 🐾</h2>
                            <p class="text-gray-500 text-sm">모든 반려동물 친구들을 환영합니다.</p>
                        </div>
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">이름</label>
                                <input type="text" name="dogName"
                                    class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary"
                                    placeholder="아이의 이름">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-3">무게</label>
                                <div class="grid grid-cols-3 gap-3">
                                    <div class="relative">
                                        <input type="radio" name="dogSize" value="SMALL" id="sizeS" class="hidden peer">
                                        <label for="sizeS"
                                            class="flex flex-col items-center justify-center h-32 rounded-2xl border-2 border-gray-100 bg-white text-gray-400 hover:bg-gray-50 peer-checked:border-primary peer-checked:bg-pink-50 peer-checked:text-primary transition-all cursor-pointer">
                                            <div class="flex items-center justify-center h-10 mb-1">
                                                <i data-lucide="cat" class="w-6 h-6"></i>
                                            </div>
                                            <span class="text-sm font-bold">~10kg</span>
                                            <span class="text-[10px] opacity-60">소형</span>
                                        </label>
                                    </div>
                                    <div class="relative">
                                        <input type="radio" name="dogSize" value="MEDIUM" id="sizeM"
                                            class="hidden peer">
                                        <label for="sizeM"
                                            class="flex flex-col items-center justify-center h-32 rounded-2xl border-2 border-gray-100 bg-white text-gray-400 hover:bg-gray-50 peer-checked:border-primary peer-checked:bg-pink-50 peer-checked:text-primary transition-all cursor-pointer">
                                            <div class="flex items-center justify-center h-10 mb-1">
                                                <i data-lucide="dog" class="w-7 h-7"></i>
                                            </div>
                                            <span class="text-sm font-bold">10~25kg</span>
                                            <span class="text-[10px] opacity-60">중형</span>
                                        </label>
                                    </div>
                                    <div class="relative">
                                        <input type="radio" name="dogSize" value="LARGE" id="sizeL" class="hidden peer">
                                        <label for="sizeL"
                                            class="flex flex-col items-center justify-center h-32 rounded-2xl border-2 border-gray-100 bg-white text-gray-400 hover:bg-gray-50 peer-checked:border-primary peer-checked:bg-pink-50 peer-checked:text-primary transition-all cursor-pointer">
                                            <div class="flex items-center justify-center h-10 mb-1">
                                                <i data-lucide="paw-print" class="w-8 h-8"></i>
                                            </div>
                                            <span class="text-sm font-bold">25kg~</span>
                                            <span class="text-[10px] opacity-60">대형</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section id="step3" class="hidden space-y-6">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-900 mb-2">마지막으로 취향을 알려주세요 ✨</h2>
                            <p class="text-gray-500 text-sm">아이에게 딱 맞는 장소를 추천해 드릴게요.</p>
                        </div>
                        <div class="space-y-5">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">품종</label>
                                <div class="relative">
                                    <select id="breedSelect" name="dogBreed" onchange="toggleOtherInput()"
                                        class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary appearance-none transition-all text-gray-900 font-medium">
                                        <option value="" disabled selected>품종을 선택해 주세요</option>
                                        <optgroup label="강아지">
                                            <option value="말티즈">말티즈</option>
                                            <option value="푸들">푸들</option>
                                            <option value="포메라니안">포메라니안</option>
                                            <option value="비숑">비숑</option>
                                            <option value="믹스견">믹스견</option>
                                        </optgroup>
                                        <optgroup label="고양이">
                                            <option value="코리안숏헤어">코리안숏헤어</option>
                                            <option value="러시안블루">러시안블루</option>
                                            <option value="샴">샴</option>
                                            <option value="페르시안">페르시안</option>
                                        </optgroup>
                                        <option value="OTHER">기타 (직접 입력)</option>
                                    </select>
                                    <i data-lucide="chevron-down"
                                        class="w-4 h-4 text-gray-400 absolute right-5 top-1/2 -translate-y-1/2 pointer-events-none"></i>
                                </div>
                            </div>

                            <div id="otherBreedContainer"
                                class="hidden animate-in fade-in slide-in-from-top-1 duration-300">
                                <input type="text" id="otherBreedInput" placeholder="품종을 직접 입력해 주세요"
                                    class="w-full p-4 bg-pink-50/30 border border-primary/20 rounded-2xl outline-none focus:border-primary text-sm">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">우리 아이 성향</label>
                                <select name="personality"
                                    class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary appearance-none text-gray-900">
                                    <option value="ACTIVE">활동적임</option>
                                    <option value="SHY">얌전하고 소심함</option>
                                    <option value="SENSITIVE">사회성이 부족하고 예민함</option>
                                </select>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">선호하는 장소 분위기</label>
                                <select name="preferredPlace"
                                    class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary appearance-none text-gray-900">
                                    <option value="NATURE">🌿 자연/숲 (풀냄새 위주)</option>
                                    <option value="URBAN">🏙️ 도심/카페 (깔끔한 공간)</option>
                                    <option value="PLAYGROUND">🎾 운동장 (뛰어놀기 좋은 곳)</option>
                                </select>
                            </div>
                        </div>
                    </section>

                    <div
                        class="fixed bottom-0 left-0 w-full max-w-[600px] left-1/2 -translate-x-1/2 p-5 bg-white border-t z-50">
                        <button type="button" id="nextBtn" onclick="nextStep()"
                            class="w-full py-4 bg-primary text-white font-bold rounded-2xl shadow-lg active:scale-95 transition-all">
                            다음으로
                        </button>
                    </div>
                </form>
            </div>

            <script src="<c:url value='/resources/js/join.js' />"></script>
        </body>

        </html>