<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="https://cdn.tailwindcss.com"></script>
<script>
	tailwind.config = {
		theme : {
			extend : {
				colors : {
					primary : '#ea4c89',
					dark : '#111111',
					bgGray : '#f8f9fa'
				}
			}
		}
	}
</script>
<script src="https://unpkg.com/lucide@latest"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">
<style>
body {
	font-family: 'Pretendard', sans-serif;
	background-color: #f1f1f1;
}

.mobile-container {
	max-width: 600px;
	margin: 0 auto;
	min-height: 100vh;
	background: white;
	padding-bottom: 80px;
	box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
	position: relative;
}

.scrollbar-hide::-webkit-scrollbar {
	display: none;
}
</style>

<script>
    tailwind.config = {
        theme: {
            extend: {
                colors: {
                    primary: '#E36394', 
                }
            }
        }
    }
</script>