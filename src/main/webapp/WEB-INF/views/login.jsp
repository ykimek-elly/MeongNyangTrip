<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<!DOCTYPE html>
		<html lang="ko">

		<head>
			<jsp:include page="include/header.jsp" />
			<link rel="stylesheet" href="<c:url value='/resources/css/style.css' />">
			<title>멍냥트립 - 로그인</title>
		</head>

		<body class="bg-gray-100">
			<div
				class="mobile-container flex flex-col justify-center items-center min-h-screen px-8 relative bg-white pb-24">

				<div class="mb-10 text-center">
					<div class="w-20 h-20 bg-pink-50 rounded-full flex items-center justify-center mx-auto mb-4">
						<i data-lucide="leaf" class="w-10 h-10 text-primary stroke-[1.5]"></i>
					</div>
					<h1 class="text-2xl font-bold text-gray-900 mb-2">멍냥트립</h1>
					<p class="text-gray-500 text-sm">반려견과 함께하는 자연 여행</p>
				</div>

				<form action="<c:url value='/loginProcess' />" method="post" class="w-full max-w-xs space-y-3">
					<div>
						<input type="text" name="id" placeholder="아이디" required
							class="w-full px-5 py-3.5 rounded-2xl border border-gray-200 bg-white text-sm outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all placeholder-gray-400">
					</div>
					<div>
						<input type="password" name="password" placeholder="비밀번호" required
							class="w-full px-5 py-3.5 rounded-2xl border border-gray-200 bg-white text-sm outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all placeholder-gray-400">
					</div>

					<c:if test="${param.error eq 'true'}">
						<p class="text-xs text-red-500 text-center font-bold">아이디 또는
							비밀번호가 일치하지 않습니다.</p>
					</c:if>

					<button type="submit"
						class="w-full bg-primary text-white font-bold py-4 rounded-2xl mt-4 hover:bg-pink-600 transition-colors shadow-md active:scale-[0.98]">
						로그인</button>
				</form>

				<div class="flex items-center gap-4 mt-6 text-xs text-gray-500">
					<a href="<c:url value='/join' />" class="hover:text-primary transition-colors font-bold">회원가입</a>
					<span class="w-[1px] h-3 bg-gray-300"></span> <a href="<c:url value='/findId' />"
						class="hover:text-primary transition-colors">아이디 찾기</a> <span
						class="w-[1px] h-3 bg-gray-300"></span> <a href="<c:url value='/findPw' />"
						class="hover:text-primary transition-colors">비밀번호 찾기</a>
				</div>

				<div class="mt-12">
					<a href="<c:url value='/' />"
						class="text-xs text-gray-400 border-b border-gray-300 pb-0.5 hover:text-primary hover:border-primary transition-colors">
						둘러보기 </a>
				</div>

			</div>

			<jsp:include page="include/nav.jsp" />

			<script src="<c:url value='/resources/js/main.js' />" defer></script>
		</body>

		</html>