<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <jsp:include page="include/header.jsp" />
            <link rel="stylesheet" href="<c:url value='/resources/css/style.css' />?v=9">
            <title>멍냥트립 - 아이디 찾기</title>
        </head>

        <body class="bg-gray-100">
            <div class="mobile-container min-h-screen px-6 py-8 relative bg-white">
                <header class="flex items-center mb-10">
                    <button onclick="history.back()" class="p-2 -ml-2 text-gray-600">
                        <i data-lucide="arrow-left" class="w-6 h-6"></i>
                    </button>
                    <h1 class="text-lg font-bold ml-2">아이디 찾기</h1>
                </header>

                <form action="<c:url value='/findIdProcess' />" method="post" class="space-y-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">닉네임</label>
                        <input type="text" name="nickname" required
                            class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary"
                            placeholder="가입시 등록한 닉네임">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">반려동물 이름</label>
                        <input type="text" name="dogName" required
                            class="w-full p-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:border-primary"
                            placeholder="등록한 아이 이름">
                    </div>

                    <button type="submit"
                        class="w-full py-4 bg-primary text-white font-bold rounded-2xl shadow-lg mt-8 active:scale-95 transition-transform">
                        아이디 찾기
                    </button>
                </form>
            </div>
            <script>lucide.createIcons();</script>
        </body>

        </html>