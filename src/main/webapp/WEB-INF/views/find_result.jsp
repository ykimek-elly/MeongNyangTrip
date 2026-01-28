<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <jsp:include page="include/header.jsp" />
            <link rel="stylesheet" href="<c:url value='/resources/css/style.css' />?v=9">
            <title>멍냥트립 - 찾기 결과</title>
        </head>

        <body class="bg-gray-100">
            <div class="mobile-container min-h-screen flex flex-col justify-center px-6 relative bg-white">

                <div class="text-center mb-8">
                    <c:choose>
                        <c:when test="${success}">
                            <div
                                class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i data-lucide="check" class="w-10 h-10 text-green-600"></i>
                            </div>
                            <h2 class="text-2xl font-bold text-gray-900 mb-2">정보를 찾았습니다! 🎉</h2>
                        </c:when>
                        <c:otherwise>
                            <div
                                class="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i data-lucide="x" class="w-10 h-10 text-red-600"></i>
                            </div>
                            <h2 class="text-2xl font-bold text-gray-900 mb-2">정보가 없습니다 😢</h2>
                        </c:otherwise>
                    </c:choose>

                    <p class="text-gray-600 leading-relaxed">${msg}</p>
                </div>

                <div class="space-y-3">
                    <c:choose>
                        <c:when test="${success}">
                            <a href="<c:url value='/login' />"
                                class="block w-full py-4 bg-primary text-white text-center font-bold rounded-2xl shadow-lg">
                                로그인하러 가기
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button onclick="history.back()"
                                class="block w-full py-4 bg-gray-100 text-gray-700 text-center font-bold rounded-2xl">
                                다시 시도하기
                            </button>
                            <a href="<c:url value='/join' />"
                                class="block w-full py-4 text-primary text-center font-bold rounded-2xl hover:bg-pink-50 transition-colors">
                                회원가입 하기
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
            <script>lucide.createIcons();</script>
        </body>

        </html>